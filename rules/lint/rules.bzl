load("@bazel_skylib//lib:shell.bzl", "shell")
load(":providers.bzl", "LintInfo")

def _lint_impl(ctx):
    linter = ctx.attr.linter[LintInfo]

    script = ""

    outputs = []

    prefix = "external/%s/files/" % ctx.label.workspace_name
    for src in ctx.files.srcs:
        if not src.path.startswith(prefix):
            fail("File %s not in %s" % (src.path, prefix))
        formatted = ctx.actions.declare_file("%s/src/%s" % (ctx.label.name, src.path))
        outputs.append(formatted)

        ctx.actions.run(
            arguments = [src.path, formatted.path],
            executable = linter.bin.executable,
            inputs = [src],
            outputs = [formatted],
            tools = [linter.bin],
        )

        script += "format %s %s \n" % (src.path[len(prefix):], formatted.path)

    bin = ctx.actions.declare_file("%s/bin" % ctx.label.name)
    ctx.actions.expand_template(
        template = ctx.file._runner,
        output = bin,
        substitutions = {"%{files}": script},
    )

    default_info = DefaultInfo(
        executable = bin,
        runfiles = ctx.runfiles(files = outputs),
    )
    return [default_info]

lint = rule(
    attrs = {
        "linter": attr.label(
            mandatory = True,
            providers = [LintInfo],
        ),
        "srcs": attr.label_list(
            allow_files = True,
            mandatory = True,
        ),
        "_runner": attr.label(
            allow_single_file = True,
            default = "runner.sh.tpl",
        ),
    },
    executable = True,
    implementation = _lint_impl,
)

def _linter_impl(ctx):
    linter_info = LintInfo(
        bin = ctx.attr.bin[DefaultInfo].files_to_run,
    )

    return [linter_info]

linter = rule(
    attrs = {
        "bin": attr.label(
            executable = True,
            cfg = "exec",
            mandatory = True,
        ),
    },
    implementation = _linter_impl,
)
