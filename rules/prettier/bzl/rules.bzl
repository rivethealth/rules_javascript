load("//rules/nodejs/bzl:rules.bzl", "write_packages_manifest")
load("//rules/javascript/bzl:providers.bzl", "JsInfo")
load("//rules/nodejs/bzl:rules.bzl", "create_nodejs_binary")
load(":providers.bzl", "PrettierInfo")

def _prettier_impl(ctx):
    prettier = ctx.attr.prettier[JsInfo]
    packages_manifest = ctx.actions.declare_file("%s/packages-manifest.txt" % ctx.label.name)
    write_packages_manifest(ctx, packages_manifest, prettier)

    prettier_info = PrettierInfo(
        bin = ctx.attr._bin,
        config = ctx.file.config,
        manifest = packages_manifest,
        plugins = [plugin[JsInfo] for plugin in ctx.attr.plugins],
        prettier = prettier,
    )

    return [prettier_info]

prettier = rule(
    implementation = _prettier_impl,
    attrs = {
        "config": attr.label(
            doc = "Configuration file",
            allow_single_file = True,
        ),
        "prettier": attr.label(
            doc = "Prettier library",
            mandatory = True,
        ),
        "plugins": attr.label_list(
            doc = "Plugins to load",
            providers = [JsInfo],
        ),
        "_bin": attr.label(
            doc = "Prettier executable",
            default = "//rules/prettier:bin",
            executable = True,
            cfg = "host",
        ),
    },
)
