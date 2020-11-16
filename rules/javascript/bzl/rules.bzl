load("//rules/util/bzl:path.bzl", "runfile_path")
load(":providers.bzl", "JsInfo", "create_js", "create_module", "create_package", "create_package_dep", "merge_js")

def default_package_name(ctx):
    workspace = "@%s" % (ctx.label.workspace_name or ctx.workspace_name)
    parts = [workspace]
    if ctx.label.package:
        parts.append(ctx.label.package)
    return "/".join(parts)

def default_strip_prefix(ctx):
    workspace = ctx.label.workspace_name or ctx.workspace_name
    parts = [workspace]
    if ctx.label.package:
        parts.append(ctx.label.package)
    return "/".join(parts)

def _js_library_impl(ctx):
    package_name = ctx.attr.js_name or default_package_name(ctx)
    strip_prefix = ctx.attr.strip_prefix or default_strip_prefix(ctx)

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
        create_package_dep(name = dep[JsInfo].name, id = id)
        for dep in ctx.attr.deps
        for id in dep[JsInfo].ids
    ]

    package = create_package(
        id = str(ctx.label),
        name = package_name,
        main = ctx.attr.main,
        modules = tuple(modules),
        deps = tuple(deps),
    )

    js_info = create_js(
        package = package,
        global_package_ids = [dep[JsInfo].id for dep in ctx.attr.global_deps for id in deps.ids],
        files = [module.file for module in modules],
        deps = [dep[JsInfo] for dep in ctx.attr.deps] + [dep[JsInfo] for dep in ctx.attr.global_deps],
    )

    return [js_info]

js_library = rule(
    attrs = {
        "main": attr.string(
            doc = "Main module, if not index.js.",
        ),
        "deps": attr.label_list(
            doc = "Dependencies.",
            providers = [JsInfo],
        ),
        "global_deps": attr.label_list(
            doc = "Global depenedencies",
            providers = [JsInfo],
        ),
        "js_name": attr.string(
            doc = "Package name. Defaults to @repository_name/js_name.",
        ),
        "prefix": attr.string(
            doc = "Prefix to add. Defaults to empty.",
        ),
        "srcs": attr.label_list(
            allow_files = True,
            doc = "JavaScript files.",
            mandatory = True,
        ),
        "strip_prefix": attr.string(
            doc = "Remove prefix. Defaults to repository_name/js_name.",
        ),
    },
    doc = "JavaScript library",
    implementation = _js_library_impl,
)

def _js_import_impl(ctx):
    package_name = ctx.attr.js_name or default_package_name(ctx)

    js_info = merge_js(
        package_name,
        [dep[JsInfo] for dep in ctx.attr.deps],
        [dep[JsInfo] for dep in ctx.attr.global_deps],
    )

    return [js_info]

js_import = rule(
    attrs = {
        "deps": attr.label_list(
            doc = "Dependencies.",
            providers = [JsInfo],
        ),
        "global_deps": attr.label_list(
            doc = "Global dependencies",
        ),
        "js_name": attr.string(
            doc = "Package name.",
        ),
    },
    doc = "Collect imports.",
    implementation = _js_import_impl,
)
