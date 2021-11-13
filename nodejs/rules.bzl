load("@bazel_skylib//lib:shell.bzl", "shell")
load("//commonjs:providers.bzl", "cjs_path")
load("//javascript:providers.bzl", "JsInfo")
load("//util:path.bzl", "runfile_path")
load(":providers.bzl", "js_info_gen_fs")

_VFS_ROOT = "bazel-nodejs"

def _nodejs_simple_binary_implementation(ctx):
    nodejs_toolchain = ctx.toolchains["@better_rules_javascript//nodejs:toolchain_type"]

    bin = ctx.actions.declare_file("%s/bin" % ctx.label.name)
    ctx.actions.expand_template(
        template = ctx.file._runner,
        output = bin,
        substitutions = {
            "%{module}": shell.quote(runfile_path(ctx, ctx.file.src)),
            "%{node}": shell.quote(runfile_path(ctx, nodejs_toolchain.nodejs.bin)),
        },
        is_executable = True,
    )

    runfiles = ctx.files._bash_runfiles + [ctx.file.src, nodejs_toolchain.nodejs.bin]
    default_info = DefaultInfo(executable = bin, runfiles = ctx.runfiles(runfiles))

    return default_info

nodejs_simple_binary = rule(
    attrs = {
        "src": attr.label(mandatory = True, allow_single_file = [".js"], doc = "Source file"),
        "_bash_runfiles": attr.label(
            allow_files = True,
            default = "@bazel_tools//tools/bash/runfiles",
        ),
        "_runner": attr.label(
            allow_single_file = True,
            default = "//nodejs:simple_runner.sh.tpl",
        ),
    },
    doc = "Node.js executable, from a single bundled file",
    executable = True,
    implementation = _nodejs_simple_binary_implementation,
    toolchains = ["@better_rules_javascript//nodejs:toolchain_type"],
)

def _nodejs_binary_implementation(ctx):
    env = ctx.attr.env
    js_info = ctx.attr.dep[JsInfo]
    main = ctx.attr.main

    nodejs_toolchain = ctx.toolchains["@better_rules_javascript//nodejs:toolchain_type"]

    files = [js_info.transitive_descriptors, js_info.js_entry_set.transitive_files]
    if ctx.attr.include_sources:
        files.append(js_info.src_entry_set.transitive_files)

    fs_manifest = ctx.actions.declare_file("%s/vfs.js" % ctx.label.name)
    js_info_gen_fs(
        ctx.actions,
        ctx.attr._gen_fs[DefaultInfo],
        fs_manifest,
        _VFS_ROOT,
        js_info,
        ctx.attr.include_sources,
        True,
    )

    main_module = "./%s/%s" % (_VFS_ROOT, cjs_path(js_info.root))
    if ctx.attr.main:
        main_module += "/%s" % ctx.attr.main

    bin = ctx.actions.declare_file("%s/bin" % ctx.label.name)
    ctx.actions.expand_template(
        template = ctx.file._runner,
        output = bin,
        substitutions = {
            "%{env}": " ".join(["%s=%s" % (name, shell.quote(value)) for name, value in env.items()]),
            "%{main_module}": shell.quote(main_module),
            "%{node}": shell.quote(runfile_path(ctx, nodejs_toolchain.nodejs.bin)),
            "%{node_options}": " ".join([shell.quote(option) for option in ctx.attr.node_options]),
            "%{fs_manifest}": shell.quote(runfile_path(ctx, fs_manifest)),
            "%{shim}": shell.quote(runfile_path(ctx, ctx.file._shim)),
            "%{workspace}": shell.quote(ctx.workspace_name),
        },
        is_executable = True,
    )

    for dep in ctx.attr.data:
        if DefaultInfo not in dep:
            continue
        if dep[DefaultInfo].default_runfiles != None:
            files.append(dep[DefaultInfo].default_runfiles.files)

    default_info = DefaultInfo(
        executable = bin,
        runfiles = ctx.runfiles(files = ctx.files._bash_runfiles + [nodejs_toolchain.nodejs.bin, ctx.file._shim, fs_manifest] + ctx.files.data, transitive_files = depset(transitive = files)),
    )

    return [default_info]

nodejs_binary = rule(
    attrs = {
        "data": attr.label_list(
            allow_files = True,
            providers = [DefaultInfo],
            doc = "Runtime data",
        ),
        "dep": attr.label(mandatory = True, providers = [JsInfo]),
        "env": attr.string_dict(
            doc = "Environment variables",
        ),
        "main": attr.string(
            default = "",
        ),
        "node_options": attr.string_list(
        ),
        "include_sources": attr.bool(
            default = True,
        ),
        "_bash_runfiles": attr.label(
            allow_files = True,
            default = "@bazel_tools//tools/bash/runfiles",
        ),
        "_runner": attr.label(
            allow_single_file = True,
            default = "//nodejs:runner.sh.tpl",
        ),
        "_shim": attr.label(
            allow_single_file = True,
            default = "//nodejs/shim:js",
        ),
        "_gen_fs": attr.label(
            cfg = "exec",
            executable = True,
            default = "//nodejs/fs-gen:bin",
        ),
    },
    doc = "Node.js binary",
    executable = True,
    implementation = _nodejs_binary_implementation,
    toolchains = ["@better_rules_javascript//nodejs:toolchain_type"],
)
