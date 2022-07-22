load("@rules_file//generate:providers.bzl", "FormatterInfo")
load("//commonjs:providers.bzl", "CjsInfo")
load("//commonjs:rules.bzl", "cjs_root")
load("//javascript:rules.bzl", "js_export", "js_library")
load("//javascript:providers.bzl", "JsInfo")
load("//nodejs:rules.bzl", "nodejs_binary")
load("//typescript:rules.bzl", "ts_library")
load("//util:path.bzl", "runfile_path")

def configure_eslint(name, dep, config, config_dep, plugins = [], visibility = None):
    cjs_root(
        name = "%s.root" % name,
        package_name = "@better-rules-javascript/eslint-format",
        descriptors = ["@better_rules_javascript//eslint/linter:descriptors"],
        path = "%s.root" % name,
        prefix = "%s.root" % name,
        strip_prefix = "/eslint/linter",
        visibility = ["//visibility:private"],
    )

    js_library(
        name = "%s.config" % name,
        root = ":%s.root" % name,
        srcs = ["@better_rules_javascript//eslint/linter:tsconfig"],
        deps = ["@better_rules_javascript//rules:tsconfig"],
        strip_prefix = "/eslint/linter",
        prefix = "%s.root" % name,
        visibility = ["//visibility:private"],
    )

    ts_library(
        name = "%s.lib" % name,
        srcs = ["@better_rules_javascript//eslint/linter:src"],
        strip_prefix = "/eslint/linter",
        compiler = "@better_rules_javascript//rules:tsc",
        config = "tsconfig.json",
        config_dep = ":%s.config" % name,
        deps = [
            dep,
            "@better_rules_javascript//bazel/worker:lib",
            "@better_rules_javascript_npm//argparse:lib",
            "@better_rules_javascript_npm//@types/argparse:lib",
            "@better_rules_javascript_npm//@types/eslint:lib",
            "@better_rules_javascript_npm//@types/node:lib",
        ],
        declaration_prefix = "%s.root" % name,
        js_prefix = "%s.root" % name,
        src_prefix = "%s.root" % name,
        root = "%s.root" % name,
        visibility = ["//visibility:private"],
    )

    js_export(
        name = "%s.main" % name,
        dep = ":%s.lib" % name,
        extra_deps = [config_dep],
        global_deps = plugins,
        visibility = ["//visibility:private"],
    )

    nodejs_binary(
        name = "%s.bin" % name,
        dep = ":%s.main" % name,
        main = "src/main.js",
        node = "@better_rules_javascript//rules:nodejs",
        visibility = ["//visibility:private"],
    )

    eslint(
        name = name,
        config = config,
        config_dep = config_dep,
        bin = ":%s.bin" % name,
        visibility = visibility,
    )

def _eslint_format(ctx, name, src, out, bin, config):
    actions = ctx.actions

    args = actions.args()
    args.add(src)
    args.add(out)
    args.set_param_file_format("multiline")
    args.use_param_file("@%s", use_always = True)

    actions.run(
        arguments = ["--config", config, args],
        executable = bin.executable,
        mnemonic = "EslintLint",
        inputs = [src],
        progress_message = "Linting %{input}",
        outputs = [out],
        tools = [bin],
        execution_requirements = {
            "requires-worker-protocol": "json",
            "supports-workers": "1",
        },
    )

def _eslint_impl(ctx):
    bin = ctx.attr.bin[DefaultInfo]
    config = ctx.attr.config
    config_js = ctx.attr.config_dep[JsInfo]
    config_cjs = ctx.attr.config_dep[CjsInfo]
    workspace_name = ctx.workspace_name

    config_path = "%s/%s" % (runfile_path(workspace_name, config_cjs.package), config)
    config = "./%s.runfiles/%s" % (bin.files_to_run.executable.path, config_path)

    def format(ctx, name, src, out):
        _eslint_format(ctx, name, src, out, bin.files_to_run, config)

    format_info = FormatterInfo(fn = format)

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
        "config": attr.string(
            mandatory = True,
        ),
        "config_dep": attr.label(
            doc = "Configuration file",
            mandatory = True,
            providers = [CjsInfo, JsInfo],
        ),
    },
    provides = [FormatterInfo],
)
