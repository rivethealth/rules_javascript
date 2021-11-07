def lint_repo(name, build_file):
    native.new_local_repository(
        name = name,
        path = ".",
        build_file = build_file,
    )

def _format_impl(ctx):
    ctx.file("WORKSPACE.bazel", executable = False)
    content = ctx.read(ctx.attr.build)
    ctx.file("BUILD.bazel", content = content, executable = False)
    path = ctx.path(ctx.attr.workspace).dirname
    ctx.symlink(path, "files")

format = repository_rule(
    implementation = _format_impl,
    attrs = {
        "build": attr.label(
            allow_single_file = True,
        ),
        "workspace": attr.label(
            doc = "A file in the workspace",
        ),
    },
    local = True,
)
