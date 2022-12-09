load("@rules_file//generate:providers.bzl", "FormatterInfo")
load("//commonjs:providers.bzl", "CjsInfo")
load("//javascript:rules.bzl", "js_export")
load("//javascript:providers.bzl", "JsInfo")
load("//nodejs:rules.bzl", "nodejs_binary")
load("//util:path.bzl", "runfile_path")

def configure_eslint(name, config, config_dep, dep = "@better_rules_javascript//eslint:eslint_lib", plugins = [], visibility = None):
    js_export(
        name = "%s.main" % name,
        dep = "@better_rules_javascript//eslint/linter:lib",
        deps = [dep],
        extra_deps = [config_dep],
        global_deps = plugins,
        visibility = ["//visibility:private"],
    )

    nodejs_binary(
        name = "%s.bin" % name,
        dep = ":%s.main" % name,
        main = "src/main.js",
        node = "@better_rules_javascript//nodejs",
        node_options = ["--title=eslint"],
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
