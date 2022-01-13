load("//util:path.bzl", "output")
load(":providers.bzl", "CjsEntries", "CjsInfo", "create_package", "default_strip_prefix", "output_name")

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
    name = ctx.attr.package_name or _default_package_name(ctx)
    label = ctx.label
    strip_prefix = ctx.attr.strip_prefix or default_strip_prefix(ctx)
    output_ = output(ctx.label, actions)
    workspace_name = ctx.workspace_name

    if ctx.attr.sealed:
        root = struct(
            path = "%s/%s" % (output_.path, label.name),
            short_path = "%s/%s" % (output_.short_path, label.name) if output_.short_path else label.name,
        )
    else:
        root = output_

    descriptors = []
    for file in ctx.files.descriptors:
        path = output_name(
            workspace_name = workspace_name,
            file = file,
            root = root,
            package_output = output_,
            prefix = "",
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
        id = str(ctx.label),
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
        "package_name": attr.string(
            doc = "Package name",
        ),
        "sealed": attr.bool(
            doc = "Whether to add prefix",
        ),
        "strip_prefix": attr.string(),
    },
)
