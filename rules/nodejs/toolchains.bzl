NodeJsInfo = provider(
    doc = "Information about how to invoke the node executable.",
    fields = {
        "bin": "Node.js executable",
    },
)

def _nodejs_toolchain_impl(ctx):
    toolchain_info = platform_common.ToolchainInfo(
        nodejs = NodeJsInfo(
            bin = ctx.file.nodejs,
        ),
    )
    return [toolchain_info]

nodejs_toolchain = rule(
    implementation = _nodejs_toolchain_impl,
    attrs = {
        "nodejs": attr.label(
            doc = "Node.JS toolchain",
            allow_single_file = True,
            mandatory = True,
        ),
    },
)
