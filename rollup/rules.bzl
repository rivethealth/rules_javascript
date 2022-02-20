load("@bazel_skylib//lib:shell.bzl", "shell")
load("//commonjs:providers.bzl", "CjsInfo", "gen_manifest", "package_path")
load("//javascript:providers.bzl", "JsInfo")
load("//nodejs:rules.bzl", "nodejs_binary")
load("//nodejs:providers.bzl", "NODE_MODULES_PREFIX", "package_path_name")
load("//util:path.bzl", "runfile_path")
load(":providers.bzl", "RollupInfo")

def _rollup_impl(ctx):
    config = ctx.attr.config
    config_dep = ctx.attr.config_dep[CjsInfo]
    workspace_name = ctx.workspace_name

    rollup_info = RollupInfo(
        bin = ctx.attr.bin[DefaultInfo].files_to_run,
        config_path = "%s/%s" % (package_path_name(workspace_name, config_dep.package.short_path), config),
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

    nodejs_binary(
        main = "dist/bin/rollup",
        name = "%s_bin" % name,
        dep = dep,
        other_deps = [config_dep],
        visibility = ["//visibility:private"],
    )

    rollup(
        name = name,
        config = config,
        config_dep = config_dep,
        bin = "%s_bin" % name,
        visibility = visibility,
    )

def _rollup_bundle_impl(ctx):
    actions = ctx.actions
    cjs_dep = ctx.attr.dep[CjsInfo]
    fs_linker = ctx.file._fs_linker
    js_dep = ctx.attr.dep[JsInfo]
    default_dep = ctx.attr.dep[DefaultInfo]
    rollup = ctx.attr.rollup[RollupInfo]

    package_manifest = actions.declare_file("%s/packages.json" % ctx.label.name)
    gen_manifest(
        actions = actions,
        deps = cjs_dep.transitive_links,
        manifest = package_manifest,
        manifest_bin = ctx.attr._manifest[DefaultInfo],
        packages = cjs_dep.transitive_packages,
        package_path = package_path,
    )

    bundle = actions.declare_file("%s/bundle.js" % ctx.label.name)

    args = []
    args.append("--config")
    args.append("./%s.runfiles/%s/%s" % (rollup.bin.executable.path, NODE_MODULES_PREFIX, rollup.config_path))

    actions.run(
        env = {
            "NODE_FS_PACKAGE_MANIFEST": package_manifest.path,
            "NODE_OPTIONS_APPEND": "-r ./%s" % fs_linker.path,
            "ROLLUP_INPUT_ROOT": cjs_dep.package.path,
            "ROLLUP_OUTPUT": bundle.path,
        },
        executable = rollup.bin.executable,
        tools = [rollup.bin],
        arguments = args,
        inputs = depset(
            [package_manifest, ctx.file._fs_linker],
            transitive = [js_dep.transitive_files],
        ),
        outputs = [bundle],
    )

    default_info = DefaultInfo(
        files = depset([bundle]),
        runfiles = default_dep.default_runfiles,
    )

    return [default_info]

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
        "_manifest": attr.label(
            cfg = "exec",
            executable = True,
            default = "//commonjs/manifest:bin",
        ),
        "_fs_linker": attr.label(
            allow_single_file = True,
            default = "//nodejs/fs-linker:file",
        ),
    },
    doc = "Rollup bundle",
    implementation = _rollup_bundle_impl,
)
