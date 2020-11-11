load("//rules/javascript/bzl:providers.bzl", "JsPackage")
load("//rules/nodejs/bzl:rules.bzl", "create_nodejs_binary")
load(":providers.bzl", "PrettierConfig")

def _prettier_binary_impl(ctx):
    js_package = ctx.attr.dep[JsPackage]

    bin, runfiles = create_nodejs_binary(
        ctx,
        js_package,
        "bin-prettier.js",
        struct(
            bash_runfiles = ctx.files._bash_runfiles,
            launcher = ctx.file._launcher,
            resolver = ctx.file._resolver,
            shim = ctx.file._shim,
        ),
    )

    default_info = DefaultInfo(
        executable = bin,
        runfiles = ctx.runfiles(transitive_files = runfiles),
    )

    return [default_info]

prettier_binary = rule(
    implementation = _prettier_binary_impl,
    attrs = {
        "dep": attr.label(
            doc = "Prettier library",
            mandatory = True,
            providers = [JsPackage],
        ),
        "_bash_runfiles": attr.label(
            allow_files = True,
            default = "@bazel_tools//tools/bash/runfiles",
        ),
        "_launcher": attr.label(
            allow_single_file = True,
            default = "//rules/nodejs:node_launcher.sh.tpl",
        ),
        "_resolver": attr.label(
            allow_single_file = True,
            default = "//rules/javascript:resolver.js",
        ),
        "_shim": attr.label(
            allow_single_file = True,
            default = "//rules/nodejs:shim.js",
        ),
    },
    executable = True,
    toolchains = ["@better_rules_javascript//rules/nodejs:toolchain_type"],
)

def _prettier_impl(ctx):
    prettier_config = PrettierConfig(
        config = ctx.file.config,
        bin = ctx.attr.bin,
        plugins = [plugin[JsPackage] for plugin in ctx.attr.plugins],
    )

    return [prettier_config]

prettier = rule(
    implementation = _prettier_impl,
    attrs = {
        "config": attr.label(
            doc = "Configuration file",
            allow_single_file = True,
        ),
        "bin": attr.label(
            doc = "Prettier binary",
            mandatory = True,
        ),
        "plugins": attr.label_list(
            doc = "Plugins to load",
            providers = [JsPackage],
        ),
    },
)
