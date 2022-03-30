load("@bazel_skylib//lib:shell.bzl", "shell")
load("//commonjs:providers.bzl", "CjsInfo", "create_link", "create_package", "gen_manifest")
load("//nodejs:providers.bzl", "NODE_MODULES_PREFIX", "NodejsInfo", "modules_links", "package_path_name")
load("//nodejs:rules.bzl", "nodejs_binary")
load("//javascript:providers.bzl", "JsInfo")
load("//javascript:rules.bzl", "js_export")
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
    nodejs = ctx.attr.nodejs[NodejsInfo]
    node_options = nodejs.options + ctx.attr.node_options
    cjs_info = ctx.attr.jest[0][CjsInfo]
    js_info = ctx.attr.jest[0][JsInfo]
    cjs_dep = ctx.attr.dep[0][CjsInfo]
    cjs_deps = [config_loader_cjs, config_cjs, cjs_info] + [ctx.attr.dep[0][CjsInfo]]
    js_deps = [config_loader_js, config_js, js_info] + [ctx.attr.dep[0][JsInfo]]
    output_ = output(label = ctx.label, actions = actions)
    workspace_name = ctx.workspace_name

    transitive_packages = depset(transitive = [dep.transitive_packages for dep in cjs_deps])

    def package_path(package):
        if package.path == cjs_dep.package.path:
            return runfile_path(workspace_name, cjs_dep.package)
        return "%s/%s" % (NODE_MODULES_PREFIX, package_path_name(workspace_name, package.short_path))

    package_manifest = actions.declare_file("%s/packages.json" % ctx.label.name)
    gen_manifest(
        actions = actions,
        deps = depset(transitive = [dep.transitive_links for dep in cjs_deps]),
        manifest = package_manifest,
        manifest_bin = manifest_bin,
        packages = transitive_packages,
        package_path = package_path,
    )

    main_module = "%s/%s/bin/jest.js" % (NODE_MODULES_PREFIX, package_path_name(workspace_name, cjs_info.package.short_path))

    bin = actions.declare_file("%s/bin" % ctx.label.name)
    actions.expand_template(
        output = bin,
        is_executable = True,
        substitutions = {
            "%{config}": shell.quote("%s/%s" % (runfile_path(workspace_name, config_cjs.package), config)),
            "%{config_loader}": shell.quote("%s/%s/src/index.js" % (NODE_MODULES_PREFIX, package_path_name(workspace_name, config_loader_cjs.package.short_path))),
            "%{env}": " ".join(["%s=%s" % (name, shell.quote(value)) for name, value in env.items()]),
            "%{fs_linker}": shell.quote("%s/dist/bundle.js" % runfile_path(workspace_name, fs_linker_cjs.package)),
            "%{main_module}": shell.quote(main_module),
            "%{node}": shell.quote(runfile_path(workspace_name, nodejs.bin)),
            "%{node_options}": " ".join([shell.quote(option) for option in node_options]),
            "%{package_manifest}": shell.quote(runfile_path(ctx.workspace_name, package_manifest)),
            "%{module_linker}": shell.quote("%s/dist/bundle.js" % runfile_path(workspace_name, module_linker_cjs.package)),
            "%{root}": shell.quote(runfile_path(workspace_name, cjs_dep.package)),
            "%{workspace}": shell.quote(workspace_name),
        },
        template = ctx.file._runner,
    )

    runfiles = ctx.runfiles(
        files = [nodejs_toolchain.nodejs.bin, package_manifest] + data,
        transitive_files = depset(transitive = [fs_linker_js.transitive_files, module_linker_js.transitive_files]),
        root_symlinks = modules_links(
            files = depset(transitive = [js_info_.transitive_files for js_info_ in js_deps]).to_list(),
            packages = [package for package in transitive_packages.to_list() if package.path != cjs_dep.package.path],
            prefix = NODE_MODULES_PREFIX,
            workspace_name = workspace_name,
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
            mandatory = True,
            providers = [NodejsInfo],
        ),
        "node_options": attr.string_list(
            doc = "Node.js options.",
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
            default = "//jest:runner",
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
