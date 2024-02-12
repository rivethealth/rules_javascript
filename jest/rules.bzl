load("@bazel_skylib//lib:shell.bzl", "shell")
load("//commonjs:providers.bzl", "CjsInfo", "CjsPath", "gen_manifest")
load("//nodejs:providers.bzl", "NodejsInfo")
load("//javascript:providers.bzl", "JsInfo")
load("//util:path.bzl", "output", "runfile_path")

def _jest_transition_impl(settings, attrs):
    return {"//javascript:module": "node"}

_jest_transition = transition(
    implementation = _jest_transition_impl,
    inputs = [],
    outputs = ["//javascript:module"],
)

def _jest_test_impl(ctx):
    actions = ctx.actions
    bash_preamble = ctx.attr.bash_preamble
    data = ctx.files.data
    data_default = [target[DefaultInfo] for target in ctx.attr.data]
    env = ctx.attr.env
    manifest_bin = ctx.attr._manifest[DefaultInfo]
    config_loader_cjs = ctx.attr._config[0][CjsInfo]
    config_loader_js = ctx.attr._config[0][JsInfo]
    config_js = ctx.attr.config_dep[0][JsInfo]
    config_cjs = ctx.attr.config_dep[0][CjsInfo]
    config = ctx.attr.config
    fs_linker_cjs = ctx.attr._fs_linker[CjsInfo]
    fs_linker_js = ctx.attr._fs_linker[JsInfo]
    label = ctx.label
    module_linker_cjs = ctx.attr._module_linker[CjsInfo]
    module_linker_js = ctx.attr._module_linker[JsInfo]
    name = ctx.attr.name
    node = ctx.attr.node[NodejsInfo]
    node_options = node.options + ctx.attr.node_options
    preload_cjs = [target[CjsInfo] for target in ctx.attr.preload]
    preload_js = [target[JsInfo] for target in ctx.attr.preload]
    cjs_info = ctx.attr.jest[0][CjsInfo]
    js_info = ctx.attr.jest[0][JsInfo]
    cjs_dep = ctx.attr.dep[0][CjsInfo]
    cjs_deps = [config_loader_cjs, config_cjs, cjs_info, fs_linker_cjs, module_linker_cjs] + [ctx.attr.dep[0][CjsInfo]] + preload_cjs
    js_deps = [config_loader_js, config_js, js_info, fs_linker_js, module_linker_js] + [ctx.attr.dep[0][JsInfo]] + preload_js
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
            transitive = [cjs_info.transitive_links for cjs_info in cjs_deps],
        ),
        manifest = package_manifest,
        manifest_bin = manifest_bin,
        packages = depset(
            transitive = [cjs_info.transitive_packages for cjs_info in cjs_deps],
        ),
        package_path = package_path,
    )

    main_module = "%s/bin/jest.js" % runfile_path(workspace, cjs_info.package)

    bin = actions.declare_file(name)
    actions.expand_template(
        output = bin,
        is_executable = True,
        substitutions = {
            "%{config_loader}": shell.quote("%s/src/index.js" % runfile_path(workspace, config_loader_cjs.package)),
            "%{config}": shell.quote("%s/%s" % (runfile_path(workspace, config_cjs.package), config)),
            "%{env}": " ".join(["%s=%s" % (name, shell.quote(value)) for name, value in env.items()]),
            "%{fs_linker}": shell.quote("%s/dist/bundle.js" % runfile_path(workspace, fs_linker_cjs.package)),
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
            "%{workspace}": shell.quote(workspace),
        },
        template = ctx.file._runner,
    )

    runfiles = ctx.runfiles(
        files = [node.bin, package_manifest] + data,
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

jest_test = rule(
    attrs = {
        "config": attr.string(
            doc = "Path to config file, relative to config_dep root.",
            mandatory = True,
        ),
        "config_dep": attr.label(
            cfg = _jest_transition,
            doc = "Jest config dependency.",
            mandatory = True,
            providers = [CjsInfo, JsInfo],
        ),
        "bash_preamble": attr.string(),
        "data": attr.label_list(
            allow_files = True,
            doc = "Runtime data.",
        ),
        "dep": attr.label(
            cfg = _jest_transition,
            doc = "Test dependency.",
            mandatory = True,
            providers = [JsInfo],
        ),
        "env": attr.string_dict(
            doc = "Environment variables.",
        ),
        "jest": attr.label(
            cfg = _jest_transition,
            doc = "Jest dependency.",
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
            cfg = _jest_transition,
            default = "//jest/config:lib",
            providers = [CjsInfo, JsInfo],
        ),
        "_runner": attr.label(
            allow_single_file = True,
            default = "//jest:runner.sh.tpl",
        ),
        "_fs_linker": attr.label(
            default = "//nodejs/fs-linker:dist_lib",
            providers = [CjsInfo, JsInfo],
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
    },
    implementation = _jest_test_impl,
    test = True,
)
