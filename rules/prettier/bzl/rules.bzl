load("//rules/nodejs/bzl:rules.bzl", "write_packages_manifest")
load("//rules/javascript/bzl:providers.bzl", "JsInfo", "add_globals", "merge_js")
load("//rules/nodejs/bzl:rules.bzl", "create_nodejs_binary")
load(":providers.bzl", "PrettierInfo")

def _prettier_impl(ctx):
    prettier = ctx.attr.prettier[JsInfo]
    dep = ctx.attr._dep[JsInfo]
    dep = merge_js(dep, [prettier])
    dep = add_globals(dep, [prettier.id])

    packages_manifest = ctx.actions.declare_file("%s/packages-manifest.txt" % ctx.label.name)
    write_packages_manifest(ctx, packages_manifest, dep)

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
        "prettier": attr.label(
            doc = "Prettier library",
            mandatory = True,
        ),
        "plugins": attr.label_list(
            doc = "Plugins to load",
            providers = [JsInfo],
        ),
        "_dep": attr.label(
            doc = "Main JS",
            default = "//rules/prettier:js",
            providers = [JsInfo],
        ),
    },
)
