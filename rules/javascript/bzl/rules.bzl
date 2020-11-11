load("//rules/util/bzl:path.bzl", "runfile_path")
load(":providers.bzl", "JsInfo", "create_module", "create_package", "create_package_dep", "merge_js")

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
        create_package_dep(name = dep[JsInfo].name, id = dep[JsInfo].id)
        for dep in ctx.attr.deps
    ]

    package = create_package(
        ctx.label,
        package_name,
        ctx.attr.main,
        tuple(modules),
        tuple(deps),
    )

    js_info = JsInfo(
        id = package.id,
        name = package.name,
        globals = depset(),
        transitive_files = depset([module.file for module in modules]),
        transitive_packages = depset([package]),
        transitive_source_maps = depset(),
    )

    js_info = merge_js(
        js_info,
        [dep[JsInfo] for dep in ctx.attr.deps],
    )

    return [js_info]

js_library = rule(
    attrs = {
        "main": attr.string(
            doc = "Main module, if not index.js",
        ),
        "deps": attr.label_list(
            doc = "Dependencies",
            providers = [JsInfo],
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
            mandatory = True,
        ),
    },
    implementation = _js_library_impl,
)

def _js_import_impl(ctx):
    js_info = ctx.attr.dep[JsInfo]

    js_info = JsInfo(
        id = js_info.id,
        name = ctx.attr.package_name or js_info.package_name,
        globals = depset([dep[JsInfo].id for dep in ctx.attr.global_deps]),
        transitive_files = js_info.transitive_files,
        transitive_packages = js_info.transitive_packages,
        transitive_source_maps = js_info.transitive_source_maps,
    )

    js_info = merge_js(
        js_info,
        [dep[JsInfo] for dep in ctx.attr.global_deps],
    )

    return [js_info]

js_import = rule(
    attrs = {
        "package_name": attr.string(
            doc = "Package name",
        ),
        "dep": attr.label(
            doc = "Package",
            mandatory = True,
            providers = [JsInfo],
        ),
        "global_deps": attr.label_list(
            doc = "Global dependencies",
            providers = [JsInfo],
        ),
    },
    implementation = _js_import_impl,
)
