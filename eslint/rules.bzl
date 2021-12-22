load("@bazel_skylib//lib:shell.bzl", "shell")
load("@rules_format//format:providers.bzl", "FormatInfo")
load("//commonjs:rules.bzl", "cjs_root")
load("//javascript:providers.bzl", "JsFile", "JsInfo")
load("//nodejs:rules.bzl", "nodejs_binary")
load("//nodejs:providers.bzl", "NODE_MODULES_PREFIX", "package_path_name")
load("//typescript:rules.bzl", "ts_library", "tsconfig")
load("//util:path.bzl", "runfile_path")

def configure_eslint(name, dep, config, plugins = [], visibility = None):
    cjs_root(
        name = "%s.root" % name,
        package_name = "@better-rules-javascript/eslint-format",
        descriptors = ["@better_rules_javascript//eslint/linter:descriptors"],
        strip_prefix = "better_rules_javascript/eslint/linter",
    )

    tsconfig(
        name = "%s.config" % name,
        root = ":root",
        src = "@better_rules_javascript//eslint/linter:tsconfig",
        dep = "@better_rules_javascript//rules:tsconfig",
        path = "tsconfig.json",
    )

    ts_library(
        name = "%s.lib" % name,
        srcs = ["@better_rules_javascript//eslint/linter:src"],
        strip_prefix = "better_rules_javascript/eslint/linter",
        compiler = "@better_rules_javascript//rules:tsc",
        config = ":%s.config" % name,
        deps = [
            dep,
            "@better_rules_javascript//worker/lib",
            "@better_rules_javascript_npm//argparse:lib",
            "@better_rules_javascript_npm//@types/argparse:lib",
            "@better_rules_javascript_npm//@types/node:lib",
        ],
        global_deps = [
            "@better_rules_javascript_npm//@types/eslint:lib",
        ],
        root = "%s.root" % name,
    )

    nodejs_binary(
        name = "%s.bin" % name,
        dep = ":%s.lib" % name,
        global_deps = plugins,
        other_deps = [config],
        main = "src/main.js",
        visibility = ["//visibility:private"],
    )

    eslint(
        name = name,
        config = config,
        bin = ":%s.bin" % name,
        visibility = visibility,
    )

def _eslint_fn(ctx, name, src, out, bin, config):
    args = ctx.actions.args()
    args.add(src)
    args.add(out)
    args.set_param_file_format("multiline")
    args.use_param_file("@%s", use_always = True)

    ctx.actions.run(
        arguments = ["--config", config, args],
        executable = bin.executable,
        mnemonic = "EslintLint",
        inputs = [src],
        progress_message = "Linting %s" % name,
        outputs = [out],
        tools = [bin],
        execution_requirements = {
            "supports-workers": "1",
        },
    )

def _eslint_impl(ctx):
    bin = ctx.attr.bin[DefaultInfo]
    config = ctx.attr.config[JsFile]
    config_dep = ctx.attr.config[JsInfo]

    config_path = "%s/%s" % (package_path_name(config_dep.package.id), config.path)

    format_info = FormatInfo(
        fn = _eslint_fn,
        args = [
            bin.files_to_run,
            "./%s.runfiles/%s/%s" % (bin.files_to_run.executable.path, NODE_MODULES_PREFIX, config_path),
        ],
    )

    default_info = DefaultInfo(files = depset(transitive = [bin.files]))

    return [default_info, format_info]

eslint = rule(
    implementation = _eslint_impl,
    attrs = {
        "bin": attr.label(
            doc = "eslint",
            mandatory = True,
            executable = True,
            cfg = "exec",
        ),
        "config": attr.label(
            doc = "Configuration file",
            mandatory = True,
            providers = [[JsFile, JsInfo]],
        ),
    },
)
