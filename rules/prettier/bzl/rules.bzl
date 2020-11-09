load("//rules/module/bzl:providers.bzl", "PackageInfo")
load(":providers.bzl", "PrettierConfig")

def _prettier_impl(ctx):
    prettier_config = PrettierConfig(
        config = ctx.file.config,
        bin = ctx.attr.bin,
        plugins = [plugin[PackageInfo] for plugin in ctx.attr.plugins],
    )

    return prettier_config

prettier = rule(
    implementation = _prettier_impl,
    attrs = {
        "config": attr.label(
            doc = "Configuration file",
            allow_single_file = [".json"],
        ),
        "bin": attr.label(
            doc = "Library",
            mandatory = True,
            executable = True,
            cfg = "host",
        ),
        "plugins": attr.label_list(
            doc = "Plugins to load",
            providers = [PackageInfo],
        ),
    },
)
