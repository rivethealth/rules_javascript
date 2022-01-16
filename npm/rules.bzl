def _yarn_resolve_impl(ctx):
    actions = ctx.actions
    directory_path = ctx.attr.path
    name = ctx.attr.name
    refresh = ctx.attr.refresh
    output_path = ctx.attr.output
    yarn_gen = ctx.attr._yarn_gen[DefaultInfo]
    yarn_resolve_template = ctx.file._yarn_resolve_template

    bin = actions.declare_file(name)

    actions.expand_template(
        template = yarn_resolve_template,
        output = bin,
        substitutions = {
            "%{refresh_flag}": "--refresh" if refresh else "",
            "%{directory}": directory_path,
            "%{output}": output_path,
        },
        is_executable = True,
    )

    default_info = DefaultInfo(
        executable = bin,
        runfiles = yarn_gen.default_runfiles,
    )

    return [default_info]

yarn_resolve = rule(
    attrs = {
        "_yarn_resolve_template": attr.label(
            allow_single_file = [".tpl"],
            default = ":yarn_resolve_template",
        ),
        "_yarn_gen": attr.label(
            cfg = "target",
            default = "//npm/yarn-resolve:bin",
            executable = True,
        ),
        "path": attr.string(
            doc = "Path to package.json and yarn.lock directory, relative to repository root",
            default = ".",
        ),
        "output": attr.string(
            doc = "Starlark output path, relative to repository root",
            default = "npm_data.bzl",
        ),
        "refresh": attr.bool(
            default = True,
            doc = "Whether to refresh",
        ),
    },
    executable = True,
    implementation = _yarn_resolve_impl,
)
