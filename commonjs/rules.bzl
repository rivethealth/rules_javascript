load("@rules_file//util:path.bzl", "runfile_path")
load("//util:path.bzl", "output", "output_name")
load(":providers.bzl", "CjsRootInfo", "create_package")

def _default_package_name(ctx):
    workspace = ctx.label.workspace_name or ctx.workspace_name
    name = ctx.label.package.replace("/", "-") or "root"
    return "@%s/%s" % (workspace, name)

def _cjs_descriptors_impl_(ctx):
    actions = ctx.actions
    label = ctx.label
    output_ = output(label, actions)
    prefix = ctx.attr.prefix
    srcs = ctx.files.srcs
    strip_prefix = ctx.attr.strip_prefix

    descriptors = []
    for file in srcs:
        path = output_name(
            file = file,
            label = label,
            prefix = prefix,
            strip_prefix = strip_prefix,
        )
        if file.path == "%s/%s" % (output_.path, path):
            descriptors.append(file)
        else:
            descriptor = actions.declare_file(path)
            actions.symlink(
                output = descriptor,
                target_file = file,
            )

    default_info = DefaultInfo(files = depset(descriptors))

    return [default_info]

cjs_descriptors = rule(
    attrs = {
        "srcs": attr.label_list(
            allow_files = [".json"],
            doc = "Descriptors.",
            mandatory = True,
        ),
        "prefix": attr.string(
            doc = "Prefix to add.",
        ),
        "strip_prefix": attr.string(
            doc = "Package-relative prefix to remove.",
        ),
    },
    doc = "CommonJS descriptors.",
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
        name = name,
        label = ctx.label,
        path = root.path,
        short_path = root.short_path,
    )

    cjs_root_info = CjsRootInfo(
        descriptors = descriptors,
        package = package,
        name = name,
    )

    default_info = DefaultInfo(
        files = depset(descriptors),
    )

    return [cjs_root_info, default_info]

cjs_root = rule(
    doc = "CommonJS-style package root.",
    implementation = _cjs_root_impl,
    attrs = {
        "descriptors": attr.label_list(
            allow_files = True,
            doc = "package.json descriptors.",
        ),
        "package_name": attr.string(
            doc = "Package name. By default, @workspace_name/path-to-directory",
        ),
        "path": attr.string(
            doc = "Root path, relative to package",
        ),
        "prefix": attr.string(),
        "strip_prefix": attr.string(),
    },
)
