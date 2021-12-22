load("//util:path.bzl", "output")
load(":providers.bzl", "CjsEntries", "CjsInfo", "create_entries", "create_package", "default_strip_prefix")

def _default_package_name(ctx):
    workspace = "@%s" % (ctx.label.workspace_name or ctx.workspace_name)
    parts = [workspace]
    if ctx.label.package:
        parts.append(ctx.label.package)
    return "/".join(parts)

def _cjs_descriptors_impl_(ctx):
    fail("TODO")

cjs_descriptors = rule(
    attrs = {
        "srcs": attr.label_list(
            allow_files = [".json"],
            mandatory = True,
        ),
        "prefix": attr.string(),
        "strip_prefix": attr.string(),
    },
    implementation = _cjs_descriptors_impl_,
)

def _cjs_root_impl(ctx):
    name = ctx.attr.package_name or _default_package_name(ctx)
    prefix = ctx.label.name if not ctx.attr.subpackages else ""
    strip_prefix = ctx.attr.strip_prefix or default_strip_prefix(ctx)
    output_ = output(ctx.label, ctx.actions)

    path = output_.path
    short_path = output_.short_path
    if not ctx.attr.subpackages:
        prefix = ctx.label.name
        path = "%s/%s" % (path, ctx.label.name) if path else ctx.label.name
        short_path = "%s/%s" % (short_path, ctx.label.name) if short_path else ctx.label.name
    else:
        prefix = ""

    descriptors = create_entries(ctx, ctx.actions, ctx.files.descriptors, prefix, strip_prefix)

    package = create_package(
        id = str(ctx.label),
        label = ctx.label,
        path = path,
        short_path = short_path,
    )
    cjs_info = CjsInfo(
        descriptors = descriptors,
        package = package,
        name = name,
    )

    cjs_entries = CjsEntries(
        name = name,
        package = package,
        transitive_files = depset(descriptors),
        transitive_packages = depset([package]),
        transitive_deps = depset([]),
    )

    return [cjs_entries, cjs_info]

cjs_root = rule(
    doc = "CommonJS-style root",
    implementation = _cjs_root_impl,
    attrs = {
        "deps": attr.label_list(
            doc = "Dependencies",
        ),
        "descriptors": attr.label_list(
            allow_files = [".json"],
            doc = "package.json descriptors",
        ),
        "package_name": attr.string(
            doc = "Package name",
            mandatory = True,
        ),
        "subpackages": attr.bool(
            doc = "Whether to allow Bazel subpackages",
        ),
        "strip_prefix": attr.string(),
    },
)
