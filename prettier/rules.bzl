load("@rules_format//format:providers.bzl", "FormatInfo")
load("//commonjs:rules.bzl", "cjs_root")
load("//javascript:providers.bzl", "JsInfo")
load("//nodejs:rules.bzl", "nodejs_binary")
load("//typescript:rules.bzl", "ts_library", "tsconfig")
load("//util:path.bzl", "runfile_path")

def configure_prettier(name, dep, config_dep, config, plugins = [], visibility = None):
    cjs_root(
        name = "%s.root" % name,
        package_name = "@better_rules_javascript/prettier-format",
        descriptors = ["@better_rules_javascript//prettier/format:descriptors"],
        strip_prefix = "better_rules_javascript/prettier/format",
    )

    tsconfig(
        name = "%s.config" % name,
        root = ":root",
        src = "@better_rules_javascript//prettier/format:tsconfig",
    )

    ts_library(
        name = "%s.lib" % name,
        srcs = ["@better_rules_javascript//prettier/format:src"],
        strip_prefix = "better_rules_javascript/prettier/format/src",
        compiler = "@better_rules_javascript//rules:tsc",
        config = ":%s.config" % name,
        deps = [
            dep,
            "@better_rules_javascript//worker/lib",
            "@better_rules_javascript_npm//@types/argparse:lib",
            "@better_rules_javascript_npm//@types/node:lib",
            "@better_rules_javascript_npm//@types/prettier:lib",
            "@better_rules_javascript_npm//argparse:lib",
        ],
        root = ":%s.root" % name,
    )

    nodejs_binary(
        main = "index.js",
        name = "%s.bin" % name,
        dep = "%s.lib" % name,
        global_deps = plugins,
        other_deps = [config_dep],
        visibility = ["//visibility:private"],
    )

    prettier(
        config = config,
        config_dep = config_dep,
        name = name,
        bin = "%s.bin" % name,
        visibility = visibility,
    )

def _prettier_fn(ctx, name, src, out, bin, config):
    args = ctx.actions.args()
    args.add(src)
    args.add(out)
    args.set_param_file_format("multiline")
    args.use_param_file("@%s", use_always = True)

    ctx.actions.run(
        arguments = ["--config", config, args],
        executable = bin.executable,
        mnemonic = "PrettierFormat",
        inputs = [src],
        progress_message = "Formatting %s" % name,
        outputs = [out],
        tools = [bin],
        execution_requirements = {
            "supports-workers": "1",
        },
    )

def _prettier_impl(ctx):
    bin = ctx.attr.bin[DefaultInfo]

    config_path = "%s/%s" % (runfile_path(ctx, ctx.attr.config_dep[JsInfo].package), ctx.attr.config)

    format_info = FormatInfo(
        fn = _prettier_fn,
        args = [
            bin.files_to_run,
            "./%s.runfiles/%s" % (bin.files_to_run.executable.path, config_path),
        ],
    )

    default_info = DefaultInfo(files = depset(transitive = [bin.files]))

    return [default_info, format_info]

prettier = rule(
    implementation = _prettier_impl,
    attrs = {
        "bin": attr.label(
            doc = "Prettier",
            mandatory = True,
            executable = True,
            cfg = "exec",
        ),
        "config": attr.string(
            doc = "Configuration file path",
            mandatory = True,
        ),
        "config_dep": attr.label(
            cfg = "exec",
            mandatory = True,
            providers = [JsInfo],
        ),
    },
)
