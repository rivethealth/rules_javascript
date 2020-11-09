load("//rules/module/bzl:providers.bzl", "PackageInfo", "create_module", "create_package", "create_package_dep", "merge_packages")
load("//rules/util/bzl:path.bzl", "runfile_path")

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
        create_package_dep(name = dep[PackageInfo].name, id = dep[PackageInfo].id)
        for dep in ctx.attr.deps
    ]

    package = create_package(
        ctx.label,
        package_name,
        ctx.attr.main,
        tuple(modules),
        tuple(deps),
    )

    package_info = merge_packages(
        package,
        [module.file for module in modules],
        [],
        [dep[PackageInfo] for dep in ctx.attr.deps],
    )

    return [package_info]

js_library = rule(
    attrs = {
        "main": attr.string(
            doc = "Main module, if not index.js",
        ),
        "deps": attr.label_list(
            doc = "Dependencies",
            providers = [PackageInfo],
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
    package_info = ctx.attr.dep[PackageInfo]

    return PackageInfo(
        id = package_info.id,
        name = ctx.attr.package_name or package_info.package_name,
        transitive_files = package_info.transitive_files,
        transitive_packages = package_info.transitive_packages,
        transitive_source_maps = package_info.transitive_source_maps,
    )

js_import = rule(
    attrs = {
        "package_name": attr.string(
            doc = "Package name",
        ),
        "dep": attr.label(
            doc = "Package",
            mandatory = True,
            providers = [PackageInfo],
        ),
    },
    implementation = _js_import_impl,
)
