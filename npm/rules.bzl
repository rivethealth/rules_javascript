load("@bazel_skylib//lib:paths.bzl", "paths")
load("@bazel_skylib//lib:shell.bzl", "shell")
load("@rules_file//util:path.bzl", "runfile_path")

def _yarn_audit_test_impl(ctx):
    actions = ctx.actions
    lock = ctx.file.lock
    manifest = ctx.file.manifest
    name = ctx.attr.name
    runner = ctx.file._runner
    workspace_name = ctx.workspace_name
    yarn = ctx.attr._yarn[DefaultInfo]

    executable = actions.declare_file(name)
    dir = paths.dirname(runfile_path(workspace_name, lock))
    actions.expand_template(
        is_executable = True,
        substitutions = {"%{dir}": shell.quote(dir)},
        template = runner,
        output = executable,
    )

    runfiles = ctx.runfiles(files = [lock] + ([manifest] if manifest else []))
    runfiles = runfiles.merge(yarn.default_runfiles)
    default_info = DefaultInfo(executable = executable, runfiles = runfiles)

    return [default_info]

yarn_audit_test = rule(
    attrs = {
        "lock": attr.label(
            allow_single_file = ["yarn.lock"],
            mandatory = True,
        ),
        "manifest": attr.label(
            allow_single_file = ["package.json"],
        ),
        "_runner": attr.label(
            allow_single_file = True,
            default = ":yarn-audit-runner.sh.tpl",
        ),
        "_yarn": attr.label(
            default = ":yarn",
        ),
    },
    implementation = _yarn_audit_test_impl,
    test = True,
)

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
            "%{directory}": shell.quote(directory_path or "."),
            "%{options}": "--refresh" if refresh else "",
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
