load(":providers.bzl", "PrettierInfo")

def _format_impl(target, ctx):
    prettier_info = ctx.attr._prettier[PrettierInfo]

    script = ""

    outputs = []

    for src in ctx.rule.attr.srcs:
        for file in src.files.to_list():
            inputs = []
            args = ctx.actions.args()

            formatted = ctx.actions.declare_file("_format/src/%s" % file.path)
            outputs.append(formatted)
            script += "format %s %s \n" % (file.path, formatted.path)

            args.add(prettier_info.manifest.path)
            inputs.append(prettier_info.manifest)

            args.add(prettier_info.dep.name)

            if prettier_info.config:
                args.add("--config", prettier_info.config.path)
                inputs.append(prettier_info.config)

            args.add(file.path)
            inputs.append(file)

            args.add(formatted.path)
            outputs.append(formatted)

            ctx.actions.run(
                executable = ctx.attr._runner.files_to_run,
                arguments = [args],
                inputs = depset(inputs, transitive = [prettier_info.dep.transitive_files]),
                outputs = [formatted],
            )

    bin = ctx.actions.declare_file("_format/bin")
    ctx.actions.expand_template(
        template = ctx.file._write,
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
            "_write": attr.label(
                default = "@better_rules_javascript//rules/prettier:runner.sh.tpl",
                allow_single_file = True,
            ),
            "_prettier": attr.label(
                default = prettier,
                providers = [PrettierInfo],
            ),
        },
    )
