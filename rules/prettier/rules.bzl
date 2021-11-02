load("@better_rules_typescript//rules/typescript:rules.bzl", "ts_library")
load("@rules_format//rules/format:providers.bzl", "FormatInfo")
load("//rules/nodejs:rules.bzl", "nodejs_binary")

def configure_prettier(name, config, dep, plugins = [], visibility = None):
    ts_library(
        name = "%s_lib" % name,
        srcs = ["@better_rules_javascript//rules/prettier/format:src"],
        strip_prefix = "better_rules_javascript/rules/prettier/format/src",
        compiler = "@better_rules_javascript//rules:tsc",
        compiler_options = ["--esModuleInterop"],
        deps = [
            dep,
            "@better_rules_javascript//rules/worker:lib",
            "@better_rules_javascript_npm//argparse:lib",
            "@better_rules_javascript_npm//types_argparse:lib",
            "@better_rules_javascript_npm//types_prettier:lib",
        ],
        global_deps = [
            "@better_rules_javascript_npm//types_node:lib",
        ] + plugins,
        root = "@better_rules_javascript//rules/prettier/format:root",
    )

    nodejs_binary(
        name = "%s_bin" % name,
        dep = "%s_lib" % name,
        visibility = ["//visibility:private"],
    )

    prettier(
        config = config,
        name = name,
        bin = "%s_bin" % name,
        visibility = visibility,
    )

def _prettier_fn(ctx, name, src, out, bin, config):
    args = ctx.actions.args()
    args.add(src.path)
    args.add(out.path)
    args.set_param_file_format("multiline")
    args.use_param_file("@%s", use_always = True)

    ctx.actions.run(
        arguments = ["--config", config.path, args],
        executable = bin.executable,
        mnemonic = "PrettierFormat",
        inputs = [config, src],
        progress_message = "Formatting %s" % name,
        outputs = [out],
        tools = [bin],
        execution_requirements = {
            "supports-workers": "1",
        },
    )

def _prettier_impl(ctx):
    bin = ctx.attr.bin[DefaultInfo]
    config = ctx.file.config

    format_info = FormatInfo(
        fn = _prettier_fn,
        args = [bin.files_to_run, config],
    )

    default_info = DefaultInfo(files = depset([config], transitive = [bin.files]))

    return [default_info, format_info]

prettier = rule(
    implementation = _prettier_impl,
    attrs = {
        "config": attr.label(
            doc = "Configuration file",
            allow_single_file = True,
            mandatory = True,
        ),
        "bin": attr.label(
            doc = "Prettier",
            mandatory = True,
            executable = True,
            cfg = "exec",
        ),
    },
)
