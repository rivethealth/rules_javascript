load("@better_rules_typescript//typescript:rules.bzl", "ts_library")
load("@bazel_skylib//lib:shell.bzl", "shell")
load("@rules_format//format:providers.bzl", "FormatInfo")
load("//commonjs:providers.bzl", "cjs_path")
load("//commonjs:rules.bzl", "cjs_root")
load("//javascript:providers.bzl", "JsInfo")
load("//nodejs:rules.bzl", "nodejs_binary")
load("//util:path.bzl", "runfile_path")

def configure_eslint(name, config, config_path, dep, plugins = [], visibility = None):
    cjs_root(
        name = "%s_root" % name,
        package_name = "@better_rules_javascript/eslint-format",
        descriptors = ["@better_rules_javascript//eslint/linter:descriptors"],
    )

    ts_library(
        name = "%s_lib" % name,
        config = "@better_rules_javascript//eslint/linter:tsconfig",
        srcs = ["@better_rules_javascript//eslint/linter:src"],
        strip_prefix = "better_rules_javascript/eslint/linter/src",
        compiler = "@better_rules_javascript//rules:tsc",
        deps = [
            dep,
            "@better_rules_javascript//worker:lib",
            "@better_rules_javascript_npm//argparse:lib",
            "@better_rules_javascript_npm//types_argparse:lib",
            "@better_rules_javascript_npm//types_node:lib",
            config,
        ],
        global_deps = [
            "@better_rules_javascript_npm//types_eslint:lib",
        ],
        root = "%s_root" % name,
    )

    nodejs_binary(
        name = "%s_bin" % name,
        dep = "%s_lib" % name,
        global_deps = plugins,
        main = "index.js",
        visibility = ["//visibility:private"],
    )

    eslint_linter(
        bin = "%s_bin" % name,
        name = "%s_linter" % name,
        visibility = ["//visibility:private"],
        config = config,
        config_path = config_path,
    )

    eslint(
        name = name,
        bin = "%s_linter" % name,
        visibility = visibility,
    )

def _eslint_linter_impl(ctx):
    eslint_bin = ctx.attr.bin[DefaultInfo]
    config_js_info = ctx.attr.config[JsInfo]
    config_path = "bazel-nodejs/%s/%s" % (cjs_path(config_js_info.root), ctx.attr.config_path)

    bin = ctx.actions.declare_file("%s/bin" % ctx.label.name)

    ctx.actions.expand_template(
        template = ctx.file._runner,
        output = bin,
        substitutions = {
            "%{bin}": shell.quote(runfile_path(ctx, eslint_bin.files_to_run.executable)),
            "%{config}": shell.quote(config_path),
        },
        is_executable = True,
    )

    default_info = DefaultInfo(
        executable = bin,
        runfiles = ctx.runfiles(files = ctx.files._bash_runfiles, transitive_files = depset(transitive = [
            config_js_info.js_entry_set.transitive_files,
            config_js_info.transitive_descriptors,
            eslint_bin.default_runfiles.files,
        ])),
    )

    return [default_info]

eslint_linter = rule(
    attrs = {
        "bin": attr.label(
            mandatory = True,
            executable = True,
            cfg = "exec",
        ),
        "config": attr.label(
            providers = [JsInfo],
            mandatory = True,
        ),
        "config_path": attr.string(
            mandatory = True,
        ),
        "_bash_runfiles": attr.label(
            allow_files = True,
            default = "@bazel_tools//tools/bash/runfiles",
        ),
        "_runner": attr.label(
            allow_single_file = True,
            default = "@better_rules_javascript//eslint:runner.sh.tpl",
        ),
    },
    executable = True,
    implementation = _eslint_linter_impl,
)

def _eslint_fn(ctx, name, src, out, bin):
    args = ctx.actions.args()
    args.add(src.path)
    args.add(out.path)
    args.set_param_file_format("multiline")
    args.use_param_file("@%s", use_always = True)

    ctx.actions.run(
        arguments = [args],
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

    format_info = FormatInfo(
        fn = _eslint_fn,
        args = [bin.files_to_run],
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
    },
)
