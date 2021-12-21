load("@bazel_skylib//lib:shell.bzl", "shell")
load("//commonjs:providers.bzl", "cjs_path")
load("//commonjs:rules.bzl", "gen_manifest", "package_path")
load("//javascript:providers.bzl", "JsFile", "JsInfo")
load("//nodejs:rules.bzl", "nodejs_binary")
load("//util:path.bzl", "runfile_path")
load(":providers.bzl", "WebpackInfo")

def _webpack_impl(ctx):
    config = ctx.attr.config[JsFile]
    config_dep = ctx.attr.config[JsInfo]

    webpack_info = WebpackInfo(
        bin = ctx.attr.bin[DefaultInfo].files_to_run,
        config_path = "%s/%s" % (runfile_path(ctx.workspace_name, config_dep.package), config.path),
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
    },
    doc = "Webpack tools",
    implementation = _webpack_impl,
)

def configure_webpack(name, dep, config, other_deps = [], visibility = None):
    """Set up webpack tools.

    Args:
        name: Name
        dep: Webpack library
        config: Configuration
        other_deps: Other deps (helps with Webpack package cycles)
    """

    nodejs_binary(
        main = "bin/cli.js",
        name = "%s_bin" % name,
        dep = dep,
        other_deps = other_deps + [config],
        visibility = visibility,
    )

    webpack(
        name = name,
        config = config,
        bin = "%s_bin" % name,
        visibility = visibility,
    )

def _webpack_bundle_impl(ctx):
    dep = ctx.attr.dep[JsInfo]
    webpack = ctx.attr.webpack[WebpackInfo]

    package_manifest = ctx.actions.declare_file("%s/packages.json" % ctx.label.name)
    gen_manifest(
        actions = ctx.actions,
        deps = dep.transitive_deps,
        globals = [],
        manifest = package_manifest,
        manifest_bin = ctx.attr._manifest[DefaultInfo],
        packages = dep.transitive_packages,
        package_path = package_path,
    )

    bundle = ctx.actions.declare_file("%s/bundle.js" % ctx.label.name)

    args = []
    args.append("--config")
    args.append("./%s.runfiles/%s" % (webpack.bin.executable.path, webpack.config_path))

    ctx.actions.run(
        env = {
            "NODE_FS_PACKAGE_MANIFEST": package_manifest.path,
            "NODE_OPTIONS_APPEND": "-r ./%s -r ./%s" % (ctx.file._fs_linker.path, ctx.file._skip_package_check.path),
            "WEBPACK_INPUT_ROOT": dep.package.path,
            "WEBPACK_OUTPUT": bundle.path,
        },
        executable = webpack.bin.executable,
        tools = [webpack.bin],
        arguments = args,
        inputs = depset(
            [package_manifest, ctx.file._fs_linker, ctx.file._skip_package_check],
            transitive = [
                dep.transitive_descriptors,
                dep.transitive_js,
                dep.transitive_srcs,
            ],
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
            default = "//webpack:skip-package-check.js",
        ),
    },
    doc = "Webpack bundle",
    implementation = _webpack_bundle_impl,
)
