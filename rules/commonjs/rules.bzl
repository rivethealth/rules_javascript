load(":providers.bzl", "CjsInfo", "create_root", "create_link")

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

def _cjs_root_impl(ctx):
    name = ctx.attr.package_name or default_package_name(ctx)

    links = tuple([
        create_link(dep = dep[CjsInfo].root.id, name = dep[CjsInfo].root.name, label = dep.label)
        for dep
        in ctx.attr.deps
    ])
    root = create_root(
        id = str(ctx.label),
        name = name,
        descriptor = ctx.file.descriptor,
        links = links
    )
    cjs = CjsInfo(
        descriptor = ctx.file.descriptor,
        id = str(ctx.label),
        prefix = default_strip_prefix(ctx),
        root = root,
    )

    return [cjs]

cjs_root = rule(
    doc = "CommonJS-style root",
    implementation = _cjs_root_impl,
    attrs = {
        "package_name": attr.string(
            doc = "Package name",
            mandatory = True,
        ),
        "deps": attr.label_list(
            doc = "Dependencies"
        ),
        "descriptor": attr.label(
            allow_single_file = [".json"],
            doc = "package.json descriptor",
            mandatory = True,
        ),
    },
)

def _cjs_import_impl(ctx):
    cjs_root = ctx.attr.dep[CjsInfo]

    cjs_root = CjsInfo(
        id = cjs_root.id,
        name = ctx.attr.package_name,
        prefix = cjs_root.prefix,
        transitive_roots = cjs_root.transitive_roots,
    )

    return [cjs_root]

cjs_import = rule(
    doc = "CommonJS alias",
    implementation = _cjs_import_impl,
    attrs = {
        "dep": attr.label(
            doc = "CommonJS root",
            mandatory = True,
            providers = [CjsInfo],
        ),
        "package_name": attr.string(
            doc = "Import alias",
            mandatory = True,
        ),
    }
)
