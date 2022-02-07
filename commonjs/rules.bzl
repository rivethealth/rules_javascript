load("@rules_file//util:path.bzl", "runfile_path")
load("//util:path.bzl", "output", "output_name")
load(":providers.bzl", "CjsEntries", "CjsInfo", "create_package")

def _default_package_name(ctx):
    workspace = ctx.label.workspace_name or ctx.workspace_name
    name = ctx.label.package.replace("/", "-") or "root"
    return "@%s/%s" % (workspace, name)

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
    actions = ctx.actions
    label = ctx.label
    name = ctx.attr.package_name or _default_package_name(ctx)
    prefix = ctx.attr.prefix
    strip_prefix = ctx.attr.strip_prefix
    output_ = output(ctx.label, actions)
    workspace_name = ctx.workspace_name

    if ctx.attr.path:
        root = struct(
            path = "%s/%s" % (output_.path, ctx.attr.path),
            short_path = "%s/%s" % (output_.short_path, ctx.attr.path) if output_.short_path else ctx.attr.path,
        )
    else:
        root = output_

    id = ctx.attr.id or runfile_path(workspace_name, root)

    descriptors = []
    for file in ctx.files.descriptors:
        path = output_name(
            file = file,
            label = label,
            prefix = prefix,
            strip_prefix = strip_prefix,
        )
        if file.path == "%s/%s" % (output_.path, path):
            descriptor = file
        else:
            descriptor = actions.declare_file(path)
            actions.symlink(
                target_file = file,
                output = descriptor,
            )
        descriptors.append(descriptor)

    package = create_package(
        id = id,
        name = name,
        label = ctx.label,
        path = root.path,
        short_path = root.short_path,
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

    default_info = DefaultInfo(
        files = depset(descriptors),
    )

    return [cjs_entries, cjs_info, default_info]

cjs_root = rule(
    doc = "CommonJS-style root",
    implementation = _cjs_root_impl,
    attrs = {
        "deps": attr.label_list(
            doc = "Dependencies",
        ),
        "descriptors": attr.label_list(
            allow_files = True,
            doc = "package.json descriptors",
        ),
        "id": attr.string(),
        "package_name": attr.string(
            doc = "Package name",
        ),
        "path": attr.string(
        ),
        "prefix": attr.string(),
        "strip_prefix": attr.string(),
    },
)
