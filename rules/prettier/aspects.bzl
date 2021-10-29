load(":providers.bzl", "PrettierInfo")

def _format_impl(target, ctx):
    prettier_info = ctx.attr._prettier[PrettierInfo]

    script = ""

    outputs = []

    output_prefix = "%s/_prettier_format" % ctx.label.name

    for src in ctx.rule.attr.srcs:
        for file in src.files.to_list():
            inputs = []
            args = ctx.actions.args()

            formatted = ctx.actions.declare_file("%s/src/%s" % (output_prefix, file.path))
            outputs.append(formatted)
            script += "format %s %s \n" % (file.path, formatted.path)

            if prettier_info.config:
                args.add("--config", prettier_info.config.path)
                inputs.append(prettier_info.config)

            args.add(file.path)
            inputs.append(file)

            args.add(formatted.path)
            outputs.append(formatted)

            ctx.actions.run(
                arguments = [args],
                executable = prettier_info.bin.executable,
                inputs = inputs,
                outputs = [formatted],
                tools = [prettier_info.bin],
            )

    bin = ctx.actions.declare_file("%s/bin" % output_prefix)
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
                providers = [PrettierInfo],
            ),
        },
    )
