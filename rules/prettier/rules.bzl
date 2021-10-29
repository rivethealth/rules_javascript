load("@better_rules_typescript//rules/typescript:rules.bzl", "ts_library")
load("//rules/nodejs:rules.bzl", "nodejs_binary")
load("//rules/javascript:providers.bzl", "JsInfo")
load(":providers.bzl", "PrettierInfo")

def configure_prettier(name, config, dep, visibility = None):
    ts_library(
        name = "%s_lib" % name,
        srcs = ["@better_rules_javascript//rules/prettier/format:src"],
        strip_prefix = "better_rules_javascript/rules/prettier/format/src",
        compiler = "@better_rules_javascript//rules:tsc",
        deps = [
            dep,
            "@better_rules_javascript_npm//argparse:lib",
            "@better_rules_javascript_npm//types_argparse:lib",
        ],
        root = "@better_rules_javascript//rules/prettier/format:root",
    )

    nodejs_binary(
        name = "%s_bin" % name,
        dep = "%s_lib" % name,
        visibility = ["//visibility:private"],
    )

    prettier(
        name = name,
        bin = "%s_bin" % name,
        config = config,
        visibility = visibility,
    )

def _prettier_impl(ctx):
    prettier_info = PrettierInfo(
        config = ctx.file.config,
        bin = ctx.attr.bin[DefaultInfo].files_to_run,
    )

    return [prettier_info]

prettier = rule(
    implementation = _prettier_impl,
    attrs = {
        "config": attr.label(
            doc = "Configuration file",
            allow_single_file = True,
        ),
        "bin": attr.label(
            doc = "Prettier",
            mandatory = True,
            executable = True,
            cfg = "exec",
        ),
        # "plugins": attr.label_list(
        #     doc = "Plugins to load",
        #     providers = [JsInfo],
        # ),
    },
)

def prettier_format_impl_(ctx):
    prettier_info = ctx.attr.prettier[PrettierInfo]

    script = ""

    outputs = []

    output_prefix = ctx.label.name

    for src in ctx.files.srcs:
        inputs = []
        args = ctx.actions.args()

        formatted = ctx.actions.declare_file("%s/src/%s" % (output_prefix, src.path))
        outputs.append(formatted)
        script += "format %s %s \n" % (src.path, formatted.path)

        if prettier_info.config:
            args.add("--config", prettier_info.config.path)
            inputs.append(prettier_info.config)

        args.add(src.path)
        inputs.append(src)

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

    default_info = DefaultInfo(
        files = depset(outputs + [bin]),
    )
    return [default_info]

prettier_format = rule(
    implementation = prettier_format_impl_,
    attrs = {
        "prettier": attr.label(
            mandatory = True,
            providers = [PrettierInfo],
        ),
        "srcs": attr.label_list(
            allow_files = True,
            mandatory = True,
        ),
        "_runner": attr.label(
            default = "@better_rules_javascript//rules/prettier:runner.sh.tpl",
            allow_single_file = True,
        ),
    },
)
