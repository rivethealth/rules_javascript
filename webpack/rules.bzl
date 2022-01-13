load("@bazel_skylib//lib:shell.bzl", "shell")
load("//commonjs:rules.bzl", "cjs_root")
load("//commonjs:providers.bzl", "gen_manifest", "package_path")
load("//javascript:providers.bzl", "JsFile", "JsInfo")
load("//nodejs:providers.bzl", "NODE_MODULES_PREFIX", "modules_links", "package_path_name")
load("//typescript:rules.bzl", "ts_library", "tsconfig")
load("//nodejs:rules.bzl", "nodejs_binary")
load("//util:path.bzl", "runfile_path")
load(":providers.bzl", "WebpackInfo")

WEBPACK_MODULES_PREFIX = "_webpack_modules"

def _webpack_impl(ctx):
    bin = ctx.attr.bin[DefaultInfo]
    client = ctx.attr.client[JsInfo]
    config = ctx.attr.config[JsFile]
    config_dep = ctx.attr.config[JsInfo]
    server = ctx.attr.server[DefaultInfo]

    webpack_info = WebpackInfo(
        bin = bin,
        server = server,
        config_path = "%s/%s" % (package_path_name(config_dep.package.id), config.path),
        client = client,
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
        "config": attr.label(
            cfg = "exec",
            mandatory = True,
            providers = [[JsFile, JsInfo]],
        ),
        "server": attr.label(
            cfg = "exec",
            executable = True,
            mandatory = True,
        ),
        "client": attr.label(
            mandatory = True,
            providers = [JsInfo],
        ),
    },
    doc = "Webpack tools",
    implementation = _webpack_impl,
)

_webpack = webpack

def configure_webpack(name, cli, webpack, dev_server, config, global_deps = [], other_deps = [], visibility = None):
    """Set up webpack tools.

    Args:
        name: Name
        dep: Webpack library
        config: Configuration
        other_deps: Other deps (helps with Webpack package cycles)
    """

    nodejs_binary(
        main = "bin/cli.js",
        name = "%s.bin" % name,
        dep = cli,
        global_deps = global_deps,
        other_deps = other_deps + [config, "@better_rules_javascript//webpack/load-config:lib"],
        visibility = ["//visibility:private"],
    )

    nodejs_binary(
        name = "%s.server_bin" % name,
        dep = ":%s.server_lib" % name,
        global_deps = global_deps,
        other_deps = other_deps + [config],
        main = "src/main.js",
    )

    cjs_root(
        name = "%s.server_root" % name,
        package_name = "@better-rules-javascript//webpack-server",
        descriptors = ["@better_rules_javascript//webpack/server:descriptors"],
        strip_prefix = "better_rules_javascript/webpack/server",
        sealed = True,
    )

    ts_library(
        name = "%s.server_lib" % name,
        srcs = ["@better_rules_javascript//webpack/server:src"],
        strip_prefix = "better_rules_javascript/webpack/server",
        compiler = "@better_rules_javascript//rules:tsc",
        config = ":%s.server_tsconfig" % name,
        root = ":%s.server_root" % name,
        visibility = ["//visibility:public"],
        deps = [
            "@better_rules_javascript//commonjs/package:lib",
            "@better_rules_javascript//ibazel/notification:lib",
            "@better_rules_javascript//nodejs/fs-linker:lib",
            "@better_rules_javascript//webpack/config:lib",
            "@better_rules_javascript_npm//enhanced-resolve:lib",
            "@better_rules_javascript_npm//@types/argparse:lib",
            "@better_rules_javascript_npm//@types/node:lib",
            "@better_rules_javascript_npm//argparse:lib",
            webpack,
            dev_server,
        ],
    )

    tsconfig(
        name = "%s.server_tsconfig" % name,
        src = "@better_rules_javascript//webpack/server:tsconfig",
        dep = "@better_rules_javascript//rules:tsconfig",
        root = ":%s.server_root" % name,
        path = "tsconfig.json",
    )

    _webpack(
        name = name,
        config = config,
        bin = ":%s.bin" % name,
        server = ":%s.server_bin" % name,
        client = dev_server,
        visibility = visibility,
    )

def _webpack_bundle_impl(ctx):
    actions = ctx.actions
    config = ctx.attr._config[JsInfo]
    compilation_mode = ctx.var["COMPILATION_MODE"]
    dep = ctx.attr.dep[JsInfo]
    webpack = ctx.attr.webpack[WebpackInfo]

    package_manifest = actions.declare_file("%s/packages.json" % ctx.label.name)
    gen_manifest(
        actions = actions,
        deps = dep.transitive_deps,
        globals = [],
        manifest = package_manifest,
        manifest_bin = ctx.attr._manifest[DefaultInfo],
        packages = dep.transitive_packages,
        package_path = package_path,
    )

    bundle = actions.declare_file("%s/bundle.js" % ctx.label.name)

    args = []
    args.append("--config")
    args.append("./%s.runfiles/%s/%s/src/index.mjs" % (webpack.bin.files_to_run.executable.path, NODE_MODULES_PREFIX, package_path_name(config.package.id)))

    actions.run(
        env = {
            "COMPILATION_MODE": compilation_mode,
            "NODE_FS_PACKAGE_MANIFEST": package_manifest.path,
            "NODE_OPTIONS_APPEND": "-r ./%s -r ./%s" % (ctx.file._fs_linker.path, ctx.file._skip_package_check.path),
            "WEBPACK_CONFIG": "%s/%s" % (NODE_MODULES_PREFIX, webpack.config_path),
            "WEBPACK_INPUT_ROOT": dep.package.path,
            "WEBPACK_OUTPUT": bundle.path,
        },
        executable = webpack.bin.files_to_run.executable,
        tools = [webpack.bin.files_to_run],
        arguments = args,
        inputs = depset(
            [package_manifest, ctx.file._fs_linker, ctx.file._skip_package_check],
            transitive = [dep.transitive_files, dep.transitive_srcs],
        ),
        outputs = [bundle],
    )

    default_info = DefaultInfo(files = depset([bundle]))

    return [default_info]

webpack_bundle = rule(
    attrs = {
        "dep": attr.label(
            doc = "JavaScript dependencies",
            providers = [JsInfo],
        ),
        "webpack": attr.label(
            doc = "Webpack tools",
            mandatory = True,
            providers = [WebpackInfo],
        ),
        "_config": attr.label(
            cfg = "exec",
            default = "//webpack/load-config:lib",
        ),
        "_manifest": attr.label(
            cfg = "exec",
            executable = True,
            default = "//commonjs/manifest:bin",
        ),
        "_fs_linker": attr.label(
            allow_single_file = True,
            default = "//nodejs/fs-linker:file",
        ),
        "_skip_package_check": attr.label(
            allow_single_file = True,
            default = "//webpack:skip_package_check",
        ),
    },
    doc = "Webpack bundle",
    implementation = _webpack_bundle_impl,
)

def _webpack_server_impl(ctx):
    actions = ctx.actions
    compilation_mode = ctx.var["COMPILATION_MODE"]
    dep = ctx.attr.dep[JsInfo]
    webpack = ctx.attr.webpack[WebpackInfo]
    skip_package_check = ctx.file._skip_package_check

    js_info = ctx.attr.dep[JsInfo]
    js_deps = [js_info] + [dep[JsInfo] for dep in ctx.attr.global_deps]
    js_globals = [dep[JsInfo] for dep in ctx.attr.global_deps]

    transitive_packages = depset(transitive = [dep.transitive_packages for dep in js_deps])

    def package_path(package):
        return "%s/%s" % (NODE_MODULES_PREFIX, package_path_name(package.id))

    package_manifest = actions.declare_file("%s/packages.json" % ctx.label.name)
    gen_manifest(
        actions = actions,
        manifest_bin = ctx.attr._manifest[DefaultInfo],
        manifest = package_manifest,
        packages = webpack.client.transitive_packages,
        deps = webpack.client.transitive_deps,
        globals = [],
        package_path = package_path,
    )

    def webpack_package_path(package):
        return "%s/%s" % (WEBPACK_MODULES_PREFIX, package_path_name(package.id))

    webpack_package_manifest = actions.declare_file("%s/webpack-packages.json" % ctx.label.name)
    gen_manifest(
        actions = actions,
        manifest_bin = ctx.attr._manifest[DefaultInfo],
        manifest = webpack_package_manifest,
        packages = transitive_packages,
        deps = depset(transitive = [dep.transitive_deps for dep in js_deps]),
        globals = [],  # TODO
        package_path = webpack_package_path,
    )

    bin = actions.declare_file("%s/bin" % ctx.label.name)

    actions.expand_template(
        template = ctx.file._runner,
        output = bin,
        substitutions = {
            "%{bin}": shell.quote(runfile_path(ctx.workspace_name, webpack.server.files_to_run.executable)),
            "%{client_root}": shell.quote("%s/%s" % (WEBPACK_MODULES_PREFIX, package_path_name(webpack.client.package.id))),
            "%{compilation_mode}": shell.quote(compilation_mode),
            "%{config}": "%s/%s" % (NODE_MODULES_PREFIX, webpack.config_path),
            "%{input_root}": shell.quote("%s/%s" % (WEBPACK_MODULES_PREFIX, package_path_name(dep.package.id))),
            "%{output}": "/tmp/bundle.js",
            "%{package_manifest}": shell.quote(runfile_path(ctx.workspace_name, package_manifest)),
            "%{skip_package_check}": runfile_path(ctx.workspace_name, skip_package_check),
            "%{webpack_package_manifest}": shell.quote(runfile_path(ctx.workspace_name, webpack_package_manifest)),
        },
        is_executable = True,
    )

    symlinks = modules_links(
        prefix = WEBPACK_MODULES_PREFIX,
        packages = transitive_packages.to_list(),
        files = depset(
            transitive =
                [js_info_.transitive_files for js_info_ in js_deps] +
                [js_info_.transitive_srcs for js_info_ in js_deps],
        ).to_list(),
    )

    runfiles = ctx.runfiles(
        files = [
            package_manifest,
            skip_package_check,
            webpack_package_manifest,
        ],
        root_symlinks = symlinks,
    )
    runfiles = runfiles.merge(webpack.server.default_runfiles)

    default_info = DefaultInfo(
        executable = bin,
        runfiles = runfiles,
    )

    return [default_info]

webpack_server = rule(
    attrs = {
        "dep": attr.label(
            doc = "JavaScript dependencies",
            providers = [JsInfo],
        ),
        "global_deps": attr.label_list(
            providers = [JsInfo],
        ),
        "webpack": attr.label(
            doc = "Webpack tools",
            mandatory = True,
            providers = [WebpackInfo],
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
    },
    executable = True,
    doc = "Run a webpack server",
    implementation = _webpack_server_impl,
)
