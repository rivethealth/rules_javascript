load("//rules/nodejs:rules.bzl", "nodejs_binary")
load("//rules/javascript:providers.bzl", "JsInfo", "create_js", "create_package", "create_package_dep")
load("//rules/typescript:rules.bzl", "ts_library")
load(":providers.bzl", "PrettierInfo")

def configure_prettier(name, config, dep, visibility = None):
    ts_library(
        name = "%s_lib" % name,
        srcs = ["@better_rules_javascript//rules/prettier/format:src"],
        compiler = "@better_rules_javascript//rules:tsc",
        deps = [
            dep,
            "@better_rules_javascript_npm//argparse:lib",
            "@better_rules_javascript_npm//types_argparse:lib"
        ],
        root = "@better_rules_javascript//rules/prettier/format:root",
    )

    nodejs_binary(
        name = "%s_bin" % name,
        dep = "%s_lib" % lib,
    )

    prettier(
        name = name,
        bin = "%s_bin" % name,
        config = config,
        visibility = visibility,
    )

def _prettier_impl(ctx):
    prettier_info = PrettierInfo(
        config = ctx.file.config,
        dep = dep,
        manifest = packages_manifest,
        plugins = [plugin[JsInfo] for plugin in ctx.attr.plugins],
    )

    return [prettier_info]

prettier = rule(
    implementation = _prettier_impl,
    attrs = {
        "config": attr.label(
            doc = "Configuration file",
            allow_single_file = True,
        ),
        "bin": attr.label(
            doc = "Prettier",
            mandatory = True,
            executable = True,
            cfg = "exec",
        ),
        # "plugins": attr.label_list(
        #     doc = "Plugins to load",
        #     providers = [JsInfo],
        # ),
    },
)
