load("@bazel_skylib//lib:shell.bzl", "shell")

def _lint_impl(ctx):
    bin = ctx.actions.declare_file("%s/bin" % ctx.label.name)
    ctx.actions.expand_template(template = ctx.file._all, output = bin, substitutions = {
        "%{query}": shell.quote(ctx.attr.query),
        "%{path}": shell.quote(ctx.attr.path),
    }, is_executable = True)

    default_info = DefaultInfo(executable = bin)
    return [default_info]

lint = rule(
    attrs = {
        "query": attr.string(
            mandatory = True,
        ),
        "path": attr.string(
            mandatory = True,
        ),
        "_all": attr.label(
            allow_single_file = True,
            default = "all.sh.tpl",
        ),
    },
    executable = True,
    implementation = _lint_impl,
)

def _lint_aspect_impl(ctx):
    bin = ctx.actions.declare_file("%s/bin" % ctx.label.name)
    ctx.actions.expand_template(template = ctx.file._all, output = bin, substitutions = {
        "%{aspect}": shell.quote(ctx.attr.aspect),
        "%{query}": shell.quote(ctx.attr.query),
        "%{path}": shell.quote(ctx.attr.path),
    }, is_executable = True)

    default_info = DefaultInfo(executable = bin)
    return [default_info]

lint_aspect = rule(
    attrs = {
        "aspect": attr.string(
            mandatory = True,
        ),
        "query": attr.string(
            mandatory = True,
        ),
        "path": attr.string(
            mandatory = True,
        ),
        "_all": attr.label(
            allow_single_file = True,
            default = "aspect-all.sh.tpl",
        ),
    },
    executable = True,
    implementation = _lint_aspect_impl,
)
