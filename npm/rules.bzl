load("@bazel_skylib//lib:shell.bzl", "shell")

def _yarn_resolve_impl(ctx):
    actions = ctx.actions
    directory_path = ctx.attr.path[len("/"):] if ctx.attr.path.startswith("/") else ctx.attr.path if not ctx.label.package else ctx.label.package if not ctx.attr.path else "%s/%s" % (ctx.label.package, ctx.attr.path)
    name = ctx.attr.name
    refresh = ctx.attr.refresh
    output_path = ctx.attr.output[len("/"):] if ctx.attr.output.startswith("/") else ctx.attr.output if not ctx.label.package else ctx.label.package if not ctx.attr.output else "%s/%s" % (ctx.label.package, ctx.attr.output)
    yarn_gen = ctx.attr._yarn_gen[DefaultInfo]
    yarn_resolve_template = ctx.file._yarn_resolve_template

    bin = actions.declare_file(name)

    actions.expand_template(
        template = yarn_resolve_template,
        output = bin,
        substitutions = {
            "%{refresh_flag}": "--refresh" if refresh else "",
            "%{directory}": shell.quote(directory_path or "."),
            "%{output}": shell.quote(output_path),
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
            doc = "Package-relative path to package.json and yarn.lock directory",
            default = "",
        ),
        "output": attr.string(
            doc = "Package-relative output path",
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
