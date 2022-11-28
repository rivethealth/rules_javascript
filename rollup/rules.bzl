load("@bazel_skylib//lib:shell.bzl", "shell")
load("@bazel_skylib//rules:common_settings.bzl", "BuildSettingInfo")
load("//commonjs:providers.bzl", "CjsInfo", "gen_manifest", "package_path")
load("//javascript:providers.bzl", "JsInfo")
load("//javascript:rules.bzl", "js_export")
load("//nodejs:rules.bzl", "nodejs_binary")
load("//util:path.bzl", "output_name", "runfile_path")
load(":providers.bzl", "RollupInfo")

def _rollup_transition_impl(settings, attrs):
    return {"//javascript:language": "es2020", "//javascript:module": "esnext"}

_rollup_transition = transition(
    implementation = _rollup_transition_impl,
    inputs = [],
    outputs = ["//javascript:language", "//javascript:module"],
)

def _rollup_config_transition_impl(settings, attrs):
    return {"//javascript:module": "commonjs"}

_rollup_config_transition = transition(
    implementation = _rollup_config_transition_impl,
    inputs = [],
    outputs = ["//javascript:module"],
)

def _rollup_impl(ctx):
    config = ctx.attr.config
    config_dep = ctx.attr.config_dep[0][CjsInfo]
    workspace_name = ctx.workspace_name

    rollup_info = RollupInfo(
        bin = ctx.attr.bin[DefaultInfo].files_to_run,
        config_path = "%s/%s" % (runfile_path(workspace_name, config_dep.package), config),
    )

    return [rollup_info]

rollup = rule(
    attrs = {
        "bin": attr.label(
            doc = "Rollup executable",
            executable = True,
            mandatory = True,
            cfg = "exec",
        ),
        "config": attr.string(
            doc = "Config.",
            mandatory = True,
        ),
        "config_dep": attr.label(
            cfg = _rollup_config_transition,
            doc = "Config dependency.",
            mandatory = True,
            providers = [CjsInfo],
        ),
        "_allowlist_function_transition": attr.label(
            default = "@bazel_tools//tools/allowlists/function_transition_allowlist",
        ),
    },
    doc = "Rollup tools.",
    implementation = _rollup_impl,
)

def configure_rollup(name, dep, config, config_dep, visibility = None):
    """Set up rollup tools.

    Args:
        name: Name
        dep: Rollup library
        config: Configuration
    """

    js_export(
        name = "%s.main" % name,
        dep = dep,
        extra_deps = [config_dep],
        visibility = ["//visibility:private"],
    )

    nodejs_binary(
        name = "%s.bin" % name,
        main = "dist/bin/rollup",
        node = "@better_rules_javascript//rules:nodejs",
        node_options = ["--title=rollup"],
        dep = ":%s.main" % name,
        visibility = ["//visibility:private"],
    )

    rollup(
        name = name,
        config = config,
        config_dep = config_dep,
        bin = ":%s.bin" % name,
        visibility = visibility,
    )

def _rollup_bundle_impl(ctx):
    actions = ctx.actions
    compilation_mode = ctx.var["COMPILATION_MODE"]
    default_dep = ctx.attr.dep[0][DefaultInfo]
    dep_cjs = ctx.attr.dep[0][CjsInfo]
    dep_js = ctx.attr.dep[0][JsInfo]
    fs_linker_cjs = ctx.attr._fs_linker[CjsInfo]
    fs_linker_js = ctx.attr._fs_linker[JsInfo]
    js_module = ctx.attr._js_module[BuildSettingInfo].value
    js_source_map = ctx.attr._js_source_map[BuildSettingInfo].value
    name = ctx.attr.name
    rollup = ctx.attr.rollup[RollupInfo]
    rollup_config_cjs = ctx.attr._rollup_config[0][CjsInfo]
    rollup_config_js = ctx.attr._rollup_config[0][JsInfo]
    label = ctx.label

    output = ctx.actions.declare_directory(ctx.attr.output or name)

    package_manifest = actions.declare_file("%s.packages.json" % ctx.attr.name)
    gen_manifest(
        actions = actions,
        deps = dep_cjs.transitive_links,
        manifest = package_manifest,
        manifest_bin = ctx.attr._manifest[DefaultInfo],
        packages = dep_cjs.transitive_packages,
        package_path = package_path,
    )

    args = [
        "--config",
        "%s/src/index.cjs" % rollup_config_cjs.package.path,
    ]

    actions.run(
        env = {
            "COMPILATION_MODE": compilation_mode,
            "JS_MODULE": js_module,
            "JS_SOURCE_MAP": "true" if js_source_map else "false",
            "NODE_FS_PACKAGE_MANIFEST": package_manifest.path,
            "NODE_OPTIONS_APPEND": "-r ./%s/dist/bundle.js" % fs_linker_cjs.package.path,
            "ROLLUP_CONFIG": "./%s.runfiles/%s" % (rollup.bin.executable.path, rollup.config_path),
            "ROLLUP_INPUT_ROOT": dep_cjs.package.path,
            "ROLLUP_OUTPUT_ROOT": output.path,
        },
        executable = rollup.bin.executable,
        tools = [rollup.bin],
        arguments = args,
        inputs = depset(
            [package_manifest],
            transitive = [dep_js.transitive_files, fs_linker_js.transitive_files, rollup_config_js.transitive_files],
        ),
        outputs = [output],
    )

    default_info = DefaultInfo(files = depset([output]))

    return [default_info]

rollup_bundle = rule(
    attrs = {
        "dep": attr.label(
            cfg = _rollup_transition,
            doc = "JavaScript dependencies",
            providers = [CjsInfo, JsInfo],
        ),
        "rollup": attr.label(
            doc = "Rollup tools",
            mandatory = True,
            providers = [RollupInfo],
        ),
        "output": attr.string(
            doc = "Output directory. Defaults to the name as the target.",
        ),
        "_allowlist_function_transition": attr.label(
            default = "@bazel_tools//tools/allowlists/function_transition_allowlist",
        ),
        "_manifest": attr.label(
            cfg = "exec",
            executable = True,
            default = "//commonjs/manifest:bin",
        ),
        "_fs_linker": attr.label(
            providers = [CjsInfo, JsInfo],
            default = "//nodejs/fs-linker:dist_lib",
        ),
        "_js_module": attr.label(
            providers = [BuildSettingInfo],
            default = "//javascript:module",
        ),
        "_js_source_map": attr.label(
            providers = [BuildSettingInfo],
            default = "//javascript:source_map",
        ),
        "_rollup_config": attr.label(
            cfg = _rollup_config_transition,
            default = "//rollup/config:lib",
        ),
    },
    doc = "Rollup bundle",
    implementation = _rollup_bundle_impl,
)
