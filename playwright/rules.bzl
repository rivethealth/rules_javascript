load("@bazel_skylib//lib:shell.bzl", "shell")
load("//commonjs:providers.bzl", "CjsInfo", "CjsPath", "gen_manifest", "create_globals")
load("//javascript:providers.bzl", "JsInfo")
load("//nodejs:providers.bzl", "NodejsInfo")
load("//util:path.bzl", "output", "runfile_path")

def _playwright_transition_impl(settings, attrs):
    return {"//javascript:module": "node"}

_playwright_transition = transition(
    implementation = _playwright_transition_impl,
    inputs = [],
    outputs = ["//javascript:module"],
)

def _playwright_test_impl(ctx):
    actions = ctx.actions
    bash_preamble = ctx.attr.bash_preamble
    data = ctx.files.data
    data_default = [target[DefaultInfo] for target in ctx.attr.data]
    env = ctx.attr.env
    manifest_bin = ctx.attr._manifest[DefaultInfo]
    config_js = ctx.attr.config_dep[0][JsInfo]
    config_cjs = ctx.attr.config_dep[0][CjsInfo]
    config = ctx.attr.config
    esm_linker_cjs = ctx.attr._esm_linker[CjsInfo]
    esm_linker_js = ctx.attr._esm_linker[JsInfo]
    label = ctx.label
    module_linker_cjs = ctx.attr._module_linker[CjsInfo]
    module_linker_js = ctx.attr._module_linker[JsInfo]
    name = ctx.attr.name    
    node = ctx.attr.node[NodejsInfo]
    node_options = node.options + ctx.attr.node_options
    runtime = ctx.file._runtime
    preload_cjs = [target[CjsInfo] for target in ctx.attr.preload]
    preload_js = [target[JsInfo] for target in ctx.attr.preload]
    playwright_cjs = ctx.attr.playwright[0][CjsInfo]
    playwright_js = ctx.attr.playwright[0][JsInfo]
    extra_deps_cjs = [target[CjsInfo] for target in ctx.attr.extra_deps]
    extra_deps_js = [target[JsInfo] for target in ctx.attr.extra_deps]
    cjs_dep = ctx.attr.dep[0][CjsInfo]
    cjs_deps = [config_cjs, playwright_cjs, esm_linker_cjs, module_linker_cjs] + [ctx.attr.dep[0][CjsInfo]] + preload_cjs + extra_deps_cjs
    js_deps = [config_js, playwright_js, esm_linker_js, module_linker_js] + [ctx.attr.dep[0][JsInfo]] + preload_js + extra_deps_js
    output_ = output(label = ctx.label, actions = actions)
    workspace = ctx.workspace_name

    preload_modules = [
        "%s/%s" % (runfile_path(workspace, target[CjsInfo].package), target[CjsPath].path)
        for target in ctx.attr.preload
    ]

    def package_path(package):
        return runfile_path(workspace, package)

    package_manifest = actions.declare_file("%s.packages.json" % name)
    gen_manifest(
        actions = actions,
        deps = depset(
            create_globals(label, [playwright_cjs]),
            transitive = [cjs_info.transitive_links for cjs_info in cjs_deps],
        ),
        manifest = package_manifest,
        manifest_bin = manifest_bin,
        packages = depset(
            transitive = [cjs_info.transitive_packages for cjs_info in cjs_deps],
        ),
        package_path = package_path,
    )

    main_module = "%s/cli.js" % runfile_path(workspace, playwright_cjs.package)

    bin = actions.declare_file(name)
    actions.expand_template(
        output = bin,
        is_executable = True,
        substitutions = {
            "%{config}": shell.quote("%s/%s" % (runfile_path(workspace, config_cjs.package), config)),
            "%{env}": " ".join(["%s=%s" % (name, shell.quote(value)) for name, value in env.items()]),
            "%{esm_loader}": shell.quote("%s/dist/bundle.js" % runfile_path(workspace, esm_linker_cjs.package)),
            "%{main_module}": shell.quote(main_module),
            "%{module_linker}": shell.quote("%s/dist/bundle.js" % runfile_path(workspace, module_linker_cjs.package)),
            "%{node_options}": " ".join(
                [shell.quote(option) for option in node_options] +
                [option for module in preload_modules for option in ["-r", '"$(abspath "$RUNFILES_DIR"/%s)"' % module]],
            ),
            "%{node}": shell.quote(runfile_path(workspace, node.bin)),
            "%{package_manifest}": shell.quote(runfile_path(workspace, package_manifest)),
            "%{preamble}": bash_preamble,
            "%{root}": shell.quote(runfile_path(workspace, cjs_dep.package)),
            "%{runtime}": shell.quote(runfile_path(workspace, runtime)),
            "%{workspace}": shell.quote(workspace),
        },
        template = ctx.file._runner,
    )

    runfiles = ctx.runfiles(
        files = [node.bin, package_manifest, runtime] + data,
        transitive_files = depset(
            transitive = [js_info.transitive_files for js_info in js_deps],
        ),
    )
    runfiles = runfiles.merge_all([default_info.default_runfiles for default_info in data_default if default_info.default_runfiles != None])

    default_info = DefaultInfo(
        executable = bin,
        runfiles = runfiles,
    )

    return [default_info]

playwright_test = rule(
    attrs = {
        "config": attr.string(
            doc = "Path to config file, relative to config_dep root.",
            mandatory = True,
        ),
        "config_dep": attr.label(
            cfg = _playwright_transition,
            doc = "Playwright config dependency.",
            mandatory = True,
            providers = [CjsInfo, JsInfo],
        ),
        "bash_preamble": attr.string(),
        "data": attr.label_list(
            allow_files = True,
            doc = "Runtime data.",
        ),
        "dep": attr.label(
            cfg = _playwright_transition,
            doc = "Test dependency.",
            mandatory = True,
            providers = [JsInfo],
        ),
        "env": attr.string_dict(
            doc = "Environment variables.",
        ),
        "extra_deps": attr.label_list(
            doc = "Additional runtime dependencies.",
            providers = [CjsInfo, JsInfo],
        ),
        "playwright": attr.label(
            cfg = _playwright_transition,
            doc = "Playwright dependency.",
            mandatory = True,
            providers = [CjsInfo, JsInfo],
        ),
        "node": attr.label(
            default = "//nodejs",
            providers = [NodejsInfo],
        ),
        "node_options": attr.string_list(
            doc = "Node.js options.",
        ),
        "preload": attr.label_list(
            doc = "Preloaded modules",
            providers = [CjsInfo, CjsPath, JsInfo],
        ),
        "_allowlist_function_transition": attr.label(
            default = "@bazel_tools//tools/allowlists/function_transition_allowlist",
        ),
        "_config": attr.label(
            cfg = _playwright_transition,
            default = "//playwright/config:lib",
            providers = [CjsInfo, JsInfo],
        ),
        "_esm_linker": attr.label(
            default = "//nodejs/esm-linker:dist_lib",
            providers = [CjsInfo, JsInfo],
        ),
        "_runner": attr.label(
            allow_single_file = True,
            default = "//playwright:runner.sh.tpl",
        ),
        "_manifest": attr.label(
            cfg = "exec",
            executable = True,
            default = "//commonjs/manifest:bin",
        ),
        "_module_linker": attr.label(
            default = "//nodejs/module-linker:dist_lib",
            providers = [CjsInfo, JsInfo],
        ),
        "_runtime": attr.label(
            allow_single_file = True,
            default = "runtime.js",
        ),
    },
    implementation = _playwright_test_impl,
    test = True,
)
