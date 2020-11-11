load(":providers.bzl", "PrettierConfig")

def _format_impl(target, ctx):
    prettier_config = ctx.attr._prettier[PrettierConfig]

    inputs, input_manifests = ctx.resolve_tools(tools = [prettier_config.bin])

    script = ""

    outputs = []
    for src in ctx.rule.attr.srcs:
        for file in src.files.to_list():
            formatted = ctx.actions.declare_file("_format/src/%s" % file.path)
            outputs.append(formatted)
            script += "format %s %s \n" % (file.path, formatted.path)
            ctx.actions.run_shell(
                command = '"$1" --config "$2" "$3" > "$4"',
                arguments = [
                    prettier_config.bin.files_to_run.executable.path,
                    prettier_config.config.path or "/dev/null",
                    file.path,
                    formatted.path,
                ],
                inputs = depset([file, prettier_config.config], transitive = [inputs]),
                outputs = [formatted],
                tools = [prettier_config.bin.files_to_run],
            )

    bin = ctx.actions.declare_file("_format/bin")
    ctx.actions.expand_template(
        template = ctx.file._runner,
        output = bin,
        substitutions = {"%{files}": script},
    )

    output_groups = OutputGroupInfo(
        formatted = depset(outputs + [bin]),
    )
    return [output_groups]

def format_aspect(prettier):
    return aspect(
        implementation = _format_impl,
        attrs = {
            "_runner": attr.label(
                default = "@better_rules_javascript//rules/prettier:runner.sh.tpl",
                allow_single_file = True,
            ),
            "_prettier": attr.label(
                default = prettier,
                providers = [PrettierConfig],
            ),
        },
    )
