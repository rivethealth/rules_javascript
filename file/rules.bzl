load("//util:path.bzl", "runfile_path")

def _default_strip_prefix(ctx):
    workspace = ctx.label.workspace_name or ctx.workspace_name
    parts = [workspace]
    if ctx.label.package:
        parts.append(ctx.label.package)
    return "/".join(parts)

def _directory_impl(ctx):
    actions = ctx.actions
    directory = ctx.attr._directory[DefaultInfo]
    srcs = ctx.files.srcs
    output_name = ctx.attr.output or ctx.label.name
    strip_prefix = ctx.attr.strip_prefix or _default_strip_prefix(ctx)
    workspace_name = ctx.workspace_name

    output = actions.declare_directory(output_name)
    args = actions.args()
    for src in srcs:
        path = runfile_path(workspace_name, src)
        if strip_prefix:
            if not path.startswith(strip_prefix + "/"):
                fail("%s does not have prefix %s" % (path, strip_prefix))
            path = path[len(strip_prefix + "/"):]
        args.add(src)
        args.add("%s/%s" % (output.path, path))

    actions.run(
        arguments = [args],
        executable = directory.files_to_run.executable,
        inputs = srcs,
        outputs = [output],
        tools = [directory.files_to_run],
    )

    default_info = DefaultInfo(files = depset([output]))

    return [default_info]

directory = rule(
    attrs = {
        "_directory": attr.label(
            cfg = "exec",
            default = ":directory",
            executable = True,
        ),
        "srcs": attr.label_list(
            allow_files = True,
        ),
        "strip_prefix": attr.string(),
        "output": attr.string(),
    },
    implementation = _directory_impl,
)
