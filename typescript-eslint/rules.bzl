load("@rules_file//generate:runner.bzl", "create_runner")
load("//commonjs:providers.bzl", "CjsInfo")
load("//javascript:rules.bzl", "js_export")
load("//javascript:providers.bzl", "JsInfo")
load("//nodejs:rules.bzl", "nodejs_binary")
load("//typescript:providers.bzl", "TsCompileInfo")
load("//util:path.bzl", "runfile_path")
load(":providers.bzl", "TsEslintInfo")

def configure_ts_eslint(name, config, config_dep, dep = "@better_rules_javascript//eslint:eslint_lib", plugins = [], visibility = None):
    js_export(
        name = "%s.main" % name,
        dep = "@better_rules_javascript//typescript-eslint/linter:lib",
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

    ts_eslint(
        name = name,
        config = config,
        config_dep = config_dep,
        bin = ":%s.bin" % name,
        visibility = visibility,
    )


def _ts_eslint_impl(ctx):
    bin_default = ctx.attr.bin[DefaultInfo]
    config = ctx.attr.config
    config_js = ctx.attr.config_dep[JsInfo]
    config_cjs = ctx.attr.config_dep[CjsInfo]
    workspace_name = ctx.workspace_name

    config_path = "%s/%s" % (runfile_path(workspace_name, config_cjs.package), config)
    config = "./%s.runfiles/%s" % (bin_default.files_to_run.executable.path, config_path)

    ts_eslint_info = TsEslintInfo(
        bin = bin_default.files_to_run,
        config_path = config,
    )

    return [ts_eslint_info]

ts_eslint = rule(
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
    implementation = _ts_eslint_impl,
    provides = [TsEslintInfo]
)

def _ts_eslint_format(ctx, name, src, out, outputs):
    if src.path not in outputs:
        fail("%s not formatted" % src.path)
    return outputs[src.path]

def _ts_eslint_format_impl(ctx):
    all_srcs = ctx.attr.all_srcs
    actions = ctx.actions
    args_default = ctx.attr._args[DefaultInfo]
    bash_runfiles = ctx.files._bash_runfiles
    diff_default = ctx.attr._diff[DefaultInfo]
    label = ctx.label
    name = ctx.attr.name
    run_default = ctx.attr._run[DefaultInfo]
    runner = ctx.file._runner
    srcs = depset(ctx.files.srcs)
    ts_eslint = ctx.attr.ts_eslint[TsEslintInfo]
    ts_compile = ctx.attr.ts[TsCompileInfo]
    workspace = ctx.workspace_name

    executable = actions.declare_file(name)

    if all_srcs:
        srcs = ts_compile.srcs

    file_defs = {
        src.short_path.replace("../", ""): struct(
            generated = actions.declare_file("%s.out/%x.%s" % (name, index, src.extension)),
            src = src,
        )
        for index, src in enumerate(srcs.to_list())
    }

    args = actions.args()
    args.add("--confi", ts_eslint.config_path)
    args.add("--manifest", ts_compile.manifest)
    for file_def in file_defs.values():
        args.add("%s=%s" % (file_def.src.path, file_def.generated.path))
    actions.run(
        arguments = [args],
        env = {"TSESTREE_SINGLE_RUN": "true", "TS_CONFIG": ts_compile.config_path},
        executable = ts_eslint.bin.executable,
        inputs = depset(
            [ts_compile.manifest],
            transitive = [srcs, ts_compile.declarations, ts_compile.configs, ts_compile.runtime_js, ts_compile.srcs],
        ),
        mnemonic = "TypeScriptCompile",
        progress_message = "Linting TypeScript %{label}",
        outputs = [file_def.generated for file_def in file_defs.values()],
        tools = [ts_eslint.bin],
    )

    default_info = create_runner(
        actions = actions,
        args_bin = args_default,
        bash_runfiles = bash_runfiles,
        bin = executable,
        diff_bin = diff_default,
        dir_mode = "775",
        file_defs = file_defs,
        file_mode = "664",
        label = label,
        name = name,
        run_bin = run_default,
        runfiles_fn = ctx.runfiles,
        runner_template = runner,
        workspace_name = workspace,
    )

    return [default_info]

ts_eslint_format = rule(
    attrs = {
        "ts_eslint": attr.label(
            providers = [TsEslintInfo],
        ),
        "all_srcs": attr.bool(
            default = True,
            doc = "Use all compiled srcs",
        ),
        "srcs": attr.label(
            doc = "Sources",
            allow_files = True,
        ),
        "ts": attr.label(
            doc = "TypeScript compilation",
            mandatory = True,
            providers = [TsCompileInfo],
        ),
        "_args": attr.label(
            cfg = "exec",
            default = "@rules_file//generate/args:bin",
            executable = True,
        ),
        "_bash_runfiles": attr.label(
            allow_files = True,
            default = "@bazel_tools//tools/bash/runfiles",
        ),
        "_diff": attr.label(
            cfg = "exec",
            default = "@rules_file//generate/diff:bin",
            executable = True,
        ),
        "_run": attr.label(
            default = "@rules_file//generate/run:bin",
            cfg = "target",
            executable = True,
        ),
        "_runner": attr.label(
            allow_single_file = True,
            default = "@rules_file//generate:runner.sh.tpl",
        ),
    },
    doc = "TypeScript ESLint",
    executable = True,
    implementation = _ts_eslint_format_impl,
)
