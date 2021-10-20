load("//rules/commonjs:providers.bzl", "cjs_path")
load("//rules/javascript:providers.bzl", "JsInfo")
load("//rules/nodejs:rules.bzl", "nodejs_binary", "js_info_gen_fs")
load(":providers.bzl", "RollupInfo")

_VFS_ROOT = "bazel-rollup"

_VFS_CONFIG_ROOT = "bazel-rollup-config"

def _rollup_impl(ctx):
    rollup_info = RollupInfo(
        bin = ctx.attr.bin[DefaultInfo].files_to_run,
    )

    return [rollup_info]

rollup = rule(
    attrs = {
        "bin": attr.label(
            executable = True,
            mandatory = True,
            cfg = "exec",
        ),
    },
    implementation = _rollup_impl,
)

def configure_rollup(name, dep):
    nodejs_binary(
        main = "dist/bin/rollup",
        name = "%s_bin" % name,
        dep = dep,
    )

    rollup(
        name = name,
        bin = "%s_bin" % name
    )

def _rollup_bundle_impl(ctx):
    config_dep = ctx.attr.config_dep[JsInfo]
    dep = ctx.attr.dep[JsInfo]
    rollup = ctx.attr.rollup[RollupInfo]

    config_vfs = ctx.actions.declare_file("%s/config-vfs.js" % ctx.label.name)
    js_info_gen_fs(
        ctx.actions,
        ctx.attr._gen_fs[DefaultInfo],
        config_vfs,
        _VFS_CONFIG_ROOT,
        config_dep,
        False,
        False,
    )

    vfs = ctx.actions.declare_file("%s/vfs.js" % ctx.label.name)
    js_info_gen_fs(
        ctx.actions,
        ctx.attr._gen_fs[DefaultInfo],
        vfs,
        _VFS_ROOT,
        dep,
        True,
        False,
    )

    bundle = ctx.actions.declare_file("%s/bundle.js" % ctx.label.name)

    config = "%s/%s/%s" % (_VFS_CONFIG_ROOT, cjs_path(config_dep.root), ctx.attr.config_path)

    args = []
    args.append("--config")
    args.append("./%s" % config)

    ctx.actions.run(
        env = {
            # "NODE_TRACE_FS": "true",
            "NODE_OPTIONS_APPEND": '-r ./%s -r ./%s' % (config_vfs.path, vfs.path),
            "ROLLUP_INPUT_ROOT": "%s/%s" % (_VFS_ROOT, cjs_path(dep.root)),
            "ROLLUP_OUTPUT": bundle.path,
        },
        executable = rollup.bin.executable,
        tools = [rollup.bin],
        arguments = args,
        inputs = depset(
            [config_vfs, vfs],
            transitive = [
                config_dep.js_entry_set.transitive_files,
                config_dep.transitive_descriptors,
                dep.js_entry_set.transitive_files,
                dep.src_entry_set.transitive_files,
                dep.transitive_descriptors,
            ]
        ),
        outputs = [bundle],
    )

    default_info = DefaultInfo(files = depset([bundle]))

    return [default_info]

rollup_bundle = rule(
    attrs = {
        "config_path": attr.string(
            mandatory = True,
        ),
        "config_dep": attr.label(
            providers = [JsInfo],
            doc = "Config file",
            mandatory = True,
        ),
        "dep": attr.label(providers = [JsInfo]),
        "rollup": attr.label(
            mandatory = True,
            providers = [RollupInfo],
        ),
        "_gen_fs": attr.label(
            cfg = "exec",
            executable = True,
            default = "//rules/nodejs/fs-gen:bin",
        ),
    },
    implementation = _rollup_bundle_impl,
)
