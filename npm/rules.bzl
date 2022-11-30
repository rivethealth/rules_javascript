load("@bazel_skylib//lib:paths.bzl", "paths")
load("@bazel_skylib//lib:shell.bzl", "shell")
load("@rules_file//util:path.bzl", "runfile_path")

def _yarn_audit_test_impl(ctx):
    actions = ctx.actions
    data = ctx.files.data
    label = ctx.label
    name = ctx.attr.name
    path = ctx.attr.path
    runner = ctx.file._runner
    workspace = ctx.workspace_name
    yarn = ctx.executable._yarn
    yarn_default = ctx.attr._yarn[DefaultInfo]

    path = path[len("/"):] if path.startswith("/") else "/".join([part for part in [workspace, label.package, path]])

    executable = actions.declare_file(name)
    actions.expand_template(
        is_executable = True,
        substitutions = {
            "%{path}": shell.quote(path),
            "%{yarn}": shell.quote(runfile_path(workspace, yarn)),
        },
        template = runner,
        output = executable,
    )

    runfiles = ctx.runfiles(files = data)
    runfiles = runfiles.merge(yarn_default.default_runfiles)
    default_info = DefaultInfo(executable = executable, runfiles = runfiles)

    return [default_info]

yarn_audit_test = rule(
    attrs = {
        "data": attr.label_list(allow_files = True),
        "path": attr.string(doc = "Package relative path"),
        "_runner": attr.label(
            allow_single_file = True,
            default = ":yarn-audit-runner.sh.tpl",
        ),
        "_yarn": attr.label(
            cfg = "target",
            default = ":yarn",
            executable = True,
        ),
    },
    implementation = _yarn_audit_test_impl,
    test = True,
)

def _yarn_resolve_impl(ctx):
    actions = ctx.actions
    label = ctx.label
    name = ctx.attr.name
    path = ctx.attr.path
    refresh = ctx.attr.refresh
    runner = ctx.file._runner
    output = ctx.attr.output
    workspace = ctx.workspace_name
    yarn = ctx.executable._yarn
    yarn_default = ctx.attr._yarn[DefaultInfo]
    yarn_resolve = ctx.executable._yarn_resolve
    yarn_resolve_default = ctx.attr._yarn_resolve[DefaultInfo]

    bin = actions.declare_file(name)
    output = output[len("/"):] if output.startswith("/") else "/".join([part for part in [label.package, output]])
    path = path[len("/"):] if path.startswith("/") else "/".join([part for part in [label.package, path]])

    actions.expand_template(
        template = runner,
        output = bin,
        substitutions = {
            "%{refresh}": shell.quote("true" if refresh else "false"),
            "%{path}": shell.quote(path),
            "%{output}": shell.quote(output),
            "%{yarn}": shell.quote(runfile_path(workspace, yarn)),
            "%{yarn_resolve}": shell.quote(runfile_path(workspace, yarn_resolve)),
        },
        is_executable = True,
    )

    runfiles = ctx.runfiles()
    runfiles = runfiles.merge(yarn_default.default_runfiles)
    runfiles = runfiles.merge(yarn_resolve_default.default_runfiles)
    default_info = DefaultInfo(executable = bin, runfiles = runfiles)

    return [default_info]

yarn_resolve = rule(
    attrs = {
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
        "_runner": attr.label(
            allow_single_file = True,
            default = ":yarn-resolve.sh.tpl",
        ),
        "_yarn": attr.label(
            cfg = "target",
            default = "//npm:yarn",
            executable = True,
        ),
        "_yarn_resolve": attr.label(
            cfg = "target",
            default = "//npm/yarn-resolve:bin",
            executable = True,
        ),
    },
    executable = True,
    implementation = _yarn_resolve_impl,
)
