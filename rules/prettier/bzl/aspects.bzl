load(":providers.bzl", "PrettierConfig")

def _format_impl(target, ctx):
    prettier_config = ctx.attr._prettier[PrettierConfig]

    inputs, input_manifests = ctx.resolve_tools(tools=[prettier_config.bin])

    outputs = []
    for src in ctx.rule.attr.srcs:
        for file in src.files.to_list():
            formatted = ctx.actions.declare_file("%s/%s" % (ctx.label.name, file.path))
            outputs.append(formatted)
            ctx.actions.run_shell(
                command = '"$1" "$2" > "$3"',
                arguments = [prettier_config.bin.files_to_run.executable.path, file.path, formatted.path],
                inputs = depset([file], transitive = [inputs]),
                outputs = [formatted],
                tools = [prettier_config.bin.files_to_run],
            )

    output_groups = OutputGroupInfo(formatted = depset(outputs))
    return [output_groups]

def format_aspect(prettier):
    return aspect(
        implementation = _format_impl,
        attrs = {
            "_prettier": attr.label(
                default = prettier,
                providers = [PrettierConfig],
            ),
        },
        toolchains = ["@better_rules_javascript//rules/nodejs:toolchain_type"],
    )
