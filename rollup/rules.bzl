load("@bazel_skylib//lib:shell.bzl", "shell")
load("//commonjs:providers.bzl", "CjsInfo", "gen_manifest", "package_path")
load("//javascript:providers.bzl", "JsInfo")
load("//javascript:rules.bzl", "js_export")
load("//nodejs:rules.bzl", "nodejs_binary")
load("//util:path.bzl", "output_name", "runfile_path")
load(":providers.bzl", "RollupInfo")

def _rollup_impl(ctx):
    config = ctx.attr.config
    config_dep = ctx.attr.config_dep[CjsInfo]
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
            cfg = "exec",
            doc = "Config dependency.",
            mandatory = True,
            providers = [CjsInfo],
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
    default_dep = ctx.attr.dep[DefaultInfo]
    dep_cjs = ctx.attr.dep[CjsInfo]
    dep_js = ctx.attr.dep[JsInfo]
    fs_linker_cjs = ctx.attr._fs_linker[CjsInfo]
    fs_linker_js = ctx.attr._fs_linker[JsInfo]
    rollup = ctx.attr.rollup[RollupInfo]
    label = ctx.label
    if bool(ctx.outputs.output) == bool(ctx.attr.output_directory):
        fail("Exactly one of output and output must be defined")

    if ctx.outputs.output:
        output = ctx.outputs.output
        map = ctx.actions.declare_file("%s.map" % output_name(file = ctx.outputs.output, label = ctx.label))
    else:
        output = ctx.actions.declare_directory(ctx.attr.output_directory)
        map = output

    package_manifest = actions.declare_file("%s.packages.json" % ctx.attr.name)
    gen_manifest(
        actions = actions,
        deps = dep_cjs.transitive_links,
        manifest = package_manifest,
        manifest_bin = ctx.attr._manifest[DefaultInfo],
        packages = dep_cjs.transitive_packages,
        package_path = package_path,
    )

    args = []
    args.append("--config")
    args.append("./%s.runfiles/%s" % (rollup.bin.executable.path, rollup.config_path))

    actions.run(
        env = {
            "NODE_FS_PACKAGE_MANIFEST": package_manifest.path,
            "NODE_OPTIONS_APPEND": "-r ./%s/dist/bundle.js" % fs_linker_cjs.package.path,
            "ROLLUP_INPUT_ROOT": dep_cjs.package.path,
            ("ROLLUP_OUTPUT_ROOT" if output.is_directory else "ROLLUP_OUTPUT"): output.path,
        },
        executable = rollup.bin.executable,
        tools = [rollup.bin],
        arguments = args,
        inputs = depset(
            [package_manifest],
            transitive = [dep_js.transitive_files, fs_linker_js.transitive_files],
        ),
        outputs = [output, map],
    )

    runfiles = ctx.runfiles(files = [map])
    runfiles = runfiles.merge(default_dep.default_runfiles)
    default_info = DefaultInfo(
        files = depset([output]),
        runfiles = runfiles,
    )

    output_group_info = OutputGroupInfo(
        map = depset([map]),
    )

    return [default_info, output_group_info]

rollup_bundle = rule(
    attrs = {
        "dep": attr.label(
            doc = "JavaScript dependencies",
            providers = [CjsInfo, JsInfo],
        ),
        "rollup": attr.label(
            doc = "Rollup tools",
            mandatory = True,
            providers = [RollupInfo],
        ),
        "output": attr.output(
        ),
        "output_directory": attr.string(
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
    },
    doc = "Rollup bundle",
    implementation = _rollup_bundle_impl,
)
