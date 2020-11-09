load("//rules/javascript/bzl:providers.bzl", "JavaScriptInfo")

def _rollup_bundle_impl(ctx):
    transitive_js = depset([], transitive = [dep[JavaScriptInfo].transitive_js for dep in ctx.attr.deps])
    ctx.actions.expand_template(
        template = ctx.file._launcher,
        output = ctx.outputs.bin,
        substitutions = {
            # "%{javascript}": ' '.join(
            #     [f.file.short_path for f in transitive_js.to_list()]
            # ),
            "%{main}": ctx.attr.main,
            "%{node}": nodejs_toolchain.nodejs.bin.short_path,
        },
        is_executable = True,
    )
    runfiles = ctx.runfiles(
        files = ctx.files._bash_runfiles + [nodejs_toolchain.nodejs.bin] + [js.file for js in transitive_js.to_list()],
    )
    return DefaultInfo(
        executable = ctx.outputs.bin,
        runfiles = runfiles,
    )

rollup_bundle = rule(
    attrs = {
        "deps": attr.label_list(providers = [JavaScriptInfo]),
        "main": attr.string(mandatory = True),
        "_bash_runfiles": attr.label(
            allow_files = True,
            default = "@bazel_tools//tools/bash/runfiles",
        ),
        "_launcher": attr.label(
            allow_single_file = True,
            default = "node_launcher.sh.tpl",
        ),
    },
    implementation = _rollup_bundle_impl,
    outputs = {"bundle": "%{name}/bundle.js"},
)
