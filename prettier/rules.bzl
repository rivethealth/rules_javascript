load("@rules_file//generate:providers.bzl", "FormatterInfo")
load("//commonjs:providers.bzl", "CjsInfo")
load("//javascript:providers.bzl", "JsInfo")
load("//javascript:rules.bzl", "js_export")
load("//nodejs:rules.bzl", "nodejs_binary")
load("//util:path.bzl", "runfile_path")

def configure_prettier(name, config, config_dep, dep = "@better_rules_javascript//prettier:prettier_lib", plugins = [], visibility = None):
    js_export(
        name = "%s.main" % name,
        dep = "@better_rules_javascript//prettier/format:lib",
        deps = [dep] + plugins,
        extra_deps = [config_dep],
        visibility = ["//visibility:private"],
    )

    nodejs_binary(
        main = "src/index.js",
        name = "%s.bin" % name,
        node = "@better_rules_javascript//tools/nodejs",
        node_options = ["--experimental-import-meta-resolve", "--title=prettier"],
        dep = ":%s.main" % name,
        visibility = ["//visibility:private"],
    )

    prettier(
        name = name,
        config = config,
        config_dep = config_dep,
        bin = "%s.bin" % name,
        visibility = visibility,
    )

def _prettier_format(ctx, name, src, out, bin, config):
    actions = ctx.actions

    args = actions.args()
    args.add(src)
    args.add(out)
    args.set_param_file_format("multiline")
    args.use_param_file("@%s", use_always = True)

    actions.run(
        arguments = ["--config", config, args],
        executable = bin.executable,
        mnemonic = "PrettierFormat",
        inputs = [src],
        progress_message = "Formatting %s" % name,
        outputs = [out],
        tools = [bin],
        execution_requirements = {
            "requires-worker-protocol": "json",
            "supports-workers": "1",
        },
    )

def _prettier_impl(ctx):
    bin = ctx.attr.bin[DefaultInfo]
    config = ctx.attr.config
    config_cjs = ctx.attr.config_dep[CjsInfo]
    config_js = ctx.attr.config_dep[JsInfo]
    workspace_name = ctx.workspace_name

    config_path = "%s/%s" % (runfile_path(workspace_name, config_cjs.package), config)
    config = "./%s.runfiles/%s" % (bin.files_to_run.executable.path, config_path)

    def format(ctx, name, src, out):
        return _prettier_format(
            ctx,
            name,
            src,
            out,
            bin.files_to_run,
            config,
        )

    format_info = FormatterInfo(fn = format)

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
            mandatory = True,
        ),
        "config_dep": attr.label(
            doc = "Configuration file",
            mandatory = True,
            providers = [JsInfo],
        ),
    },
)
