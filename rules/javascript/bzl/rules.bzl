load("//rules/util/bzl:path.bzl", "runfile_path")
load(":providers.bzl", "JsPackage", "create_module", "create_package", "create_package_dep", "merge_packages")

def _js_library_impl(ctx):
    package_name = ctx.attr.package_name
    if not package_name:
        package_name = "@%s/%s" % (ctx.label.workspace_name or ctx.workspace_name, ctx.label.package) if ctx.label.package else ctx.label.workspace_name
    strip_prefix = ctx.attr.strip_prefix
    if not strip_prefix:
        strip_prefix = "%s/%s" % (ctx.label.workspace_name or ctx.workspace_name, ctx.label.package) if ctx.label.package else ctx.label.workspace_name

    modules = []
    for src in ctx.files.srcs:
        path = runfile_path(ctx, src)
        if strip_prefix:
            if not path.startswith(strip_prefix + "/"):
                fail("Source %s does not have prefix %s" % (path, strip_prefix))
            path = path[len(strip_prefix + "/"):]
        if ctx.attr.prefix:
            path = ctx.attr.prefix + "/" + path
        modules.append(create_module(name = path, file = src))

    deps = [
        create_package_dep(name = dep[JsPackage].name, id = dep[JsPackage].id)
        for dep in ctx.attr.deps
    ]

    package = create_package(
        ctx.label,
        package_name,
        ctx.attr.main,
        tuple(modules),
        tuple(deps),
    )

    js_package = merge_packages(
        package,
        [module.file for module in modules],
        [],
        [dep[JsPackage] for dep in ctx.attr.deps],
    )

    return [js_package]

js_library = rule(
    attrs = {
        "main": attr.string(
            doc = "Main module, if not index.js",
        ),
        "deps": attr.label_list(
            doc = "Dependencies",
            providers = [JsPackage],
        ),
        "prefix": attr.string(
            doc = "Add prefix",
        ),
        "strip_prefix": attr.string(
            doc = "Remove prefix. Defaults to repository_name()/package_name().",
        ),
        "package_name": attr.string(
            doc = "Package name. Defaults to repository_name()/package_name().",
        ),
        # TODO: should permit JSON?
        "srcs": attr.label_list(
            allow_files = True,
            doc = "JavaScript files.",
        ),
    },
    implementation = _js_library_impl,
)

def _js_import_impl(ctx):
    js_package = ctx.attr.dep[JsPackage]

    return JsPackage(
        id = js_package.id,
        name = ctx.attr.package_name or js_package.package_name,
        transitive_files = js_package.transitive_files,
        transitive_packages = js_package.transitive_packages,
        transitive_source_maps = js_package.transitive_source_maps,
    )

js_import = rule(
    attrs = {
        "package_name": attr.string(
            doc = "Package name",
        ),
        "dep": attr.label(
            doc = "Package",
            mandatory = True,
            providers = [JsPackage],
        ),
    },
    implementation = _js_import_impl,
)
