load("@bazel_skylib//lib:shell.bzl", "shell")
load("@bazel_skylib//rules:common_settings.bzl", "BuildSettingInfo")
load("@rivet_bazel_util//bazel:providers.bzl", "create_digest")
load("//commonjs:providers.bzl", "CjsInfo", "create_cjs_info", "gen_manifest", "package_path")
load("//javascript:providers.bzl", "JsInfo", "create_js_info")
load("//javascript:rules.bzl", "js_export")
load("//nodejs:providers.bzl", "NODE_MODULES_PREFIX", "modules_links", "package_path_name")
load("//nodejs:rules.bzl", "nodejs_binary")
load("//util:path.bzl", "runfile_path")
load(":providers.bzl", "WebpackInfo")

WEBPACK_MODULES_PREFIX = "_webpack_modules"

def _webpack_tool_transition_impl(settings, attrs):
    return {
        "browser": {"//javascript:language": attrs.language, "//javascript:module": attrs.module},
        "tool": {
            "//javascript:language": settings["//javascript:language"],
            "//javascript:module": settings["//javascript:module"],
        },
    }

_webpack_tool_transition = transition(
    implementation = _webpack_tool_transition_impl,
    inputs = ["//javascript:language", "//javascript:module"],
    outputs = ["//javascript:language", "//javascript:module"],
)

def _webpack_transition_impl(settings, attrs):
    return {"//javascript:language": "es2020", "//javascript:module": "esnext"}

_webpack_transition = transition(
    implementation = _webpack_transition_impl,
    inputs = [],
    outputs = ["//javascript:language", "//javascript:module"],
)

def _webpack_impl(ctx):
    bin = ctx.attr.bin[DefaultInfo]
    client_cjs = [target[CjsInfo] for target in ctx.attr.client]
    client_js = [target[JsInfo] for target in ctx.attr.client]
    config = ctx.attr.config
    config_dep = ctx.attr.config_dep[CjsInfo]
    server = ctx.attr.server[DefaultInfo]
    workspace_name = ctx.workspace_name

    webpack_info = WebpackInfo(
        bin = bin,
        client_cjs = client_cjs,
        client_js = client_js,
        config_path = "%s/%s" % (package_path_name(workspace_name, config_dep.package.short_path), config),
        server = server,
    )

    return [webpack_info]

webpack = rule(
    attrs = {
        "bin": attr.label(
            doc = "Webpack executable",
            executable = True,
            mandatory = True,
            cfg = "exec",
        ),
        "config": attr.string(
            mandatory = True,
        ),
        "config_dep": attr.label(
            cfg = "exec",
            mandatory = True,
            providers = [CjsInfo],
        ),
        "language": attr.string(
            default = "es2020",
        ),
        "module": attr.string(
            default = "esnext",
        ),
        "server": attr.label(
            cfg = "exec",
            executable = True,
            mandatory = True,
        ),
        "client": attr.label_list(
            mandatory = True,
            providers = [CjsInfo, JsInfo],
        ),
    },
    doc = "Webpack tools",
    implementation = _webpack_impl,
)

_webpack = webpack

def configure_webpack(name, cli, webpack, dev_server, config, config_dep, node_options = [], visibility = None):
    """Set up webpack tools.

    Args:
        name: Name
        cli: Webpack CLI library
        webpack: Webpack library
        dev_server: Webpack dev server library
        config: Configuration path
        config_dep: Configuration library
        node_options: Node.js options
        visibility: Visibility
    """

    nodejs_binary(
        main = "bin/cli.js",
        name = "%s.bin" % name,
        dep = ":%s.main" % name,
        node_options = node_options,
        visibility = ["//visibility:private"],
    )

    js_export(
        name = "%s.main" % name,
        dep = cli,
        extra_deps = [config_dep, "@better_rules_javascript//webpack/load-config:lib"],
    )

    nodejs_binary(
        name = "%s.server_bin" % name,
        node_options = node_options,
        main = "src/main.js",
        dep = ":%s.server_main" % name,
        visibility = ["//visibility:private"],
    )

    js_export(
        name = "%s.server_main" % name,
        dep = "@better_rules_javascript//webpack/server:lib",
        deps = [webpack, dev_server],
        extra_deps = [config_dep],
        visibility = ["//visibility:private"],
    )

    _webpack(
        name = name,
        config = config,
        config_dep = config_dep,
        bin = ":%s.bin" % name,
        server = ":%s.server_bin" % name,
        client = [dev_server],
        visibility = visibility,
    )

def _webpack_bundle_impl(ctx):
    actions = ctx.actions
    config = ctx.attr._config[CjsInfo]
    compilation_mode = ctx.var["COMPILATION_MODE"]
    source_map = ctx.attr._source_map[BuildSettingInfo].value
    dep_js = ctx.attr.dep[0][JsInfo]
    dep_cjs = ctx.attr.dep[0][CjsInfo]
    cjs_root = ctx.attr.root[CjsInfo]
    fs_linker_cjs = ctx.attr._fs_linker[CjsInfo]
    fs_linker_js = ctx.attr._fs_linker[JsInfo]
    label = ctx.label
    webpack = ctx.attr.webpack[WebpackInfo]
    output_name = ctx.attr.output or ctx.attr.name
    workspace_name = ctx.workspace_name

    package_manifest = actions.declare_file("%s.packages.json" % ctx.label.name)
    gen_manifest(
        actions = actions,
        deps = dep_cjs.transitive_links,
        manifest = package_manifest,
        manifest_bin = ctx.attr._manifest[DefaultInfo],
        packages = dep_cjs.transitive_packages,
        package_path = package_path,
    )

    output = actions.declare_directory(output_name)

    args = []
    args.append("--config")
    args.append("./%s.runfiles/%s/%s/src/index.mjs" % (webpack.bin.files_to_run.executable.path, NODE_MODULES_PREFIX, package_path_name(workspace_name, config.package.short_path)))

    actions.run(
        env = {
            "COMPILATION_MODE": compilation_mode,
            "JS_SOURCE_MAP": json.encode(source_map),
            "NODE_FS_PACKAGE_MANIFEST": package_manifest.path,
            "NODE_OPTIONS_APPEND": "-r ./%s/dist/bundle.js -r ./%s" % (fs_linker_cjs.package.path, ctx.file._skip_package_check.path),
            "WEBPACK_CONFIG": "%s/%s" % (NODE_MODULES_PREFIX, webpack.config_path),
            "WEBPACK_INPUT_ROOT": dep_cjs.package.path,
            "WEBPACK_OUTPUT": output.path,
        },
        executable = webpack.bin.files_to_run.executable,
        tools = [webpack.bin.files_to_run],
        arguments = args,
        inputs = depset(
            [package_manifest, ctx.file._skip_package_check],
            transitive = [dep_js.transitive_files, fs_linker_js.transitive_files],
        ),
        outputs = [output],
    )

    default_info = DefaultInfo(files = depset([output]))

    cjs_info = create_cjs_info(cjs_root = cjs_root, files = [output], label = label)

    js_info = create_js_info(cjs_root = cjs_root, files = [output])

    return [cjs_info, default_info, js_info]

webpack_bundle = rule(
    attrs = {
        "_allowlist_function_transition": attr.label(
            default = "@bazel_tools//tools/allowlists/function_transition_allowlist",
        ),
        "_config": attr.label(
            default = "//webpack/load-config:lib",
            providers = [CjsInfo],
        ),
        "_manifest": attr.label(
            cfg = "exec",
            executable = True,
            default = "//commonjs/manifest:bin",
        ),
        "_fs_linker": attr.label(
            default = "//nodejs/fs-linker:dist_lib",
            providers = [CjsInfo, JsInfo],
        ),
        "_skip_package_check": attr.label(
            allow_single_file = True,
            default = "//webpack:skip_package_check",
        ),
        "_source_map": attr.label(
            default = "//javascript:source_map",
            providers = [BuildSettingInfo],
        ),
        "dep": attr.label(
            cfg = _webpack_transition,
            doc = "JavaScript dependencies",
            providers = [JsInfo],
            mandatory = True,
        ),
        "output": attr.string(
            doc = "Output directory. Defaults to the name of the rule",
        ),
        "root": attr.label(
            doc = "CommonJS package root",
            providers = [CjsInfo],
            mandatory = True,
        ),
        "webpack": attr.label(
            doc = "Webpack tools",
            mandatory = True,
            providers = [WebpackInfo],
        ),
    },
    doc = "Webpack bundle",
    implementation = _webpack_bundle_impl,
    provides = [CjsInfo, JsInfo],
)

def _webpack_server_impl(ctx):
    actions = ctx.actions
    compilation_mode = ctx.var["COMPILATION_MODE"]
    hash = ctx.attr._hash[DefaultInfo]
    label = ctx.label
    skip_package_check = ctx.file._skip_package_check
    source_map = ctx.attr._source_map[BuildSettingInfo].value
    webpack = ctx.split_attr.webpack["tool"][WebpackInfo]
    webpack_client = ctx.split_attr.webpack["browser"][WebpackInfo]
    dep_js = ctx.attr.dep[0][JsInfo]
    dep_cjs = ctx.attr.dep[0][CjsInfo]
    name = ctx.attr.name
    workspace_name = ctx.workspace_name

    transitive_links = depset(
        # create_globals(label, webpack_client.client_cjs),
        transitive = [dep_cjs.transitive_links] + [cjs_info.transitive_links for cjs_info in webpack_client.client_cjs],
    )
    transitive_packages = depset(transitive = [dep_cjs.transitive_packages] + [cjs_info.transitive_packages for cjs_info in webpack_client.client_cjs])

    def package_path(package):
        return "%s/%s" % (WEBPACK_MODULES_PREFIX, package_path_name(workspace_name, package.short_path))

    package_manifest = actions.declare_file("%s-packages.json" % name)
    gen_manifest(
        actions = actions,
        manifest_bin = ctx.attr._manifest[DefaultInfo],
        manifest = package_manifest,
        packages = transitive_packages,
        deps = transitive_links,
        package_path = package_path,
    )

    bin = actions.declare_file(name)
    actions.expand_template(
        template = ctx.file._runner,
        output = bin,
        substitutions = {
            "%{bin}": shell.quote(runfile_path(ctx.workspace_name, webpack.server.files_to_run.executable)),
            "%{compilation_mode}": shell.quote(compilation_mode),
            "%{config}": "%s/%s" % (NODE_MODULES_PREFIX, webpack.config_path),
            "%{input_root}": shell.quote("%s/%s" % (WEBPACK_MODULES_PREFIX, package_path_name(workspace_name, dep_cjs.package.short_path))),
            "%{output}": "/tmp/bundle.js",
            "%{js_source_map}": shell.quote(json.encode(source_map)),
            "%{skip_package_check}": runfile_path(ctx.workspace_name, skip_package_check),
            "%{package_manifest}": shell.quote(runfile_path(ctx.workspace_name, package_manifest)),
        },
        is_executable = True,
    )

    digest = actions.declare_file("%s.digest" % name)
    create_digest(
        actions = actions,
        runfiles = webpack.server.default_runfiles,
        hash = hash,
        output = digest,
    )

    js_info = JsInfo(
        transitive_files = depset(transitive = [js_info.transitive_files for js_info in [dep_js] + webpack_client.client_js]),
    )

    symlinks = modules_links(
        prefix = WEBPACK_MODULES_PREFIX,
        packages = transitive_packages.to_list(),
        files = js_info.transitive_files.to_list(),
        workspace_name = workspace_name,
    )

    runfiles = ctx.runfiles(
        files = [
            skip_package_check,
            package_manifest,
        ],
        root_symlinks = symlinks,
    )
    runfiles = runfiles.merge(webpack.server.default_runfiles)

    default_info = DefaultInfo(
        executable = bin,
        runfiles = runfiles,
    )

    output_group_info = OutputGroupInfo(
        digest = depset([digest]),
    )

    return [default_info, output_group_info]

webpack_server = rule(
    attrs = {
        "dep": attr.label(
            cfg = _webpack_transition,
            doc = "JavaScript dependencies",
            mandatory = True,
            providers = [JsInfo],
        ),
        "language": attr.string(),
        "module": attr.string(),
        "webpack": attr.label(
            cfg = _webpack_tool_transition,
            doc = "Webpack tools",
            mandatory = True,
            providers = [WebpackInfo],
        ),
        "_allowlist_function_transition": attr.label(
            default = "@bazel_tools//tools/allowlists/function_transition_allowlist",
        ),
        "_hash": attr.label(
            cfg = "exec",
            default = "@rivet_bazel_util//util/hash:bin",
            executable = True,
        ),
        "_manifest": attr.label(
            cfg = "exec",
            executable = True,
            default = "//commonjs/manifest:bin",
        ),
        "_skip_package_check": attr.label(
            allow_single_file = True,
            default = "//webpack:skip_package_check",
        ),
        "_runner": attr.label(
            allow_single_file = True,
            default = "//webpack:server_runner",
        ),
        "_source_map": attr.label(
            default = "//javascript:source_map",
            providers = [BuildSettingInfo],
        ),
    },
    executable = True,
    doc = "Run a webpack server",
    implementation = _webpack_server_impl,
)
