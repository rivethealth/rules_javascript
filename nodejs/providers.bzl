load("//util:path.bzl", "runfile_path")

NodejsRuntimeInfo = provider(
    doc = "Node.js runtime.",
    fields = {
        "bin": "Node.js executable",
    },
)

NodejsInfo = provider(
    doc = "Node.js executable information.",
    fields = {
        "bin": "Node.js executable",
        "options": "Node.js options",
    },
)

def nodejs_runtime_rule(name):
    def nodejs_runtime_impl(ctx):
        nodejs_toolchain = ctx.toolchains["%s.toolchain_type" % name]

        nodejs_runtime_info = NodejsRuntimeInfo(bin = nodejs_toolchain.bin)

        return [nodejs_runtime_info]

    nodejs_runtime = rule(
        implementation = nodejs_runtime_impl,
        provides = [NodejsRuntimeInfo],
        toolchains = ["%s.toolchain_type" % name],
    )

    return nodejs_runtime
