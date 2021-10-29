load("@bazel_skylib//lib:shell.bzl", "shell")
load("//rules/commonjs:providers.bzl", "cjs_path", "entry_json", "entry_runfile_json", "extra_link_json", "root_json", "root_runfile_json")
load("//rules/javascript:providers.bzl", "JsInfo")
load("//rules/util:path.bzl", "runfile_path")
load("//rules/util:json.bzl", "json")

_VFS_ROOT = "bazel-nodejs"

def _entry_arg(entry):
    return json.encode(entry_json(entry))

def _entry_runfile_arg(entry):
    return json.encode(entry_runfile_json(entry))

def _extra_link_arg(extra_link):
    return json.encode(extra_link_json(extra_link))

def _root_arg(root):
    return json.encode(root_json(root))

def _root_runfile_arg(root):
    return json.encode(root_runfile_json(root))

def _nodejs_simple_binary_implementation(ctx):
    nodejs_toolchain = ctx.toolchains["@better_rules_javascript//rules/nodejs:toolchain_type"]

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
            default = "//rules/nodejs:simple_runner.sh.tpl",
        ),
    },
    doc = "Node.js executable, from a single bundled file",
    executable = True,
    implementation = _nodejs_simple_binary_implementation,
    toolchains = ["@better_rules_javascript//rules/nodejs:toolchain_type"],
)

def gen_fs(actions, gen, file, mount, entries, extra_links, roots, is_runfiles):
    args = actions.args()
    args.set_param_file_format("multiline")
    args.add("gen")
    args.add(mount)
    if is_runfiles:
        args.add("--runfiles")
        args.add("true")
        args.add_all(entries, before_each = "--entry", map_each = _entry_runfile_arg)
        args.add_all(roots, before_each = "--root", map_each = _root_runfile_arg)
    else:
        args.add_all(entries, before_each = "--entry", map_each = _entry_arg)
        args.add_all(roots, before_each = "--root", map_each = _root_arg)
    args.add_all(extra_links, before_each = "--extra-link", map_each = _extra_link_arg)
    args.add(file)

    actions.run(
        executable = gen.files_to_run.executable,
        tools = [gen.files_to_run],
        arguments = [args],
        mnemonic = "GenFs",
        outputs = [file],
    )

def js_info_gen_fs(actions, gen, file, mount, js_info, include_sources, is_runfiles):
    entries = [js_info.js_entry_set.transitive_entries]
    if include_sources:
        entries.append(js_info.src_entry_set.transitive_entries)
    gen_fs(
        actions,
        gen,
        file,
        mount,
        depset([], transitive = entries),
        js_info.transitive_extra_links,
        js_info.transitive_roots,
        is_runfiles,
    )

def _nodejs_binary_implementation(ctx):
    js_info = ctx.attr.dep[JsInfo]
    main = ctx.attr.main

    nodejs_toolchain = ctx.toolchains["@better_rules_javascript//rules/nodejs:toolchain_type"]

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
            "%{main_module}": shell.quote(main_module),
            "%{node}": shell.quote(runfile_path(ctx, nodejs_toolchain.nodejs.bin)),
            "%{fs_manifest}": shell.quote(runfile_path(ctx, fs_manifest)),
            "%{shim}": shell.quote(runfile_path(ctx, ctx.file._shim)),
            "%{workspace}": shell.quote(ctx.workspace_name),
        },
        is_executable = True,
    )

    runfiles = depset(
        ctx.files._bash_runfiles + [nodejs_toolchain.nodejs.bin, ctx.file._shim, fs_manifest],
        transitive = files,
    )

    default_info = DefaultInfo(executable = bin, runfiles = ctx.runfiles(transitive_files = runfiles))
    return default_info

nodejs_binary = rule(
    attrs = {
        "dep": attr.label(mandatory = True, providers = [JsInfo]),
        "main": attr.string(
            default = "",
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
            default = "//rules/nodejs:runner.sh.tpl",
        ),
        "_shim": attr.label(
            allow_single_file = True,
            default = "//rules/nodejs/shim:js",
        ),
        "_gen_fs": attr.label(
            cfg = "exec",
            executable = True,
            default = "//rules/nodejs/fs-gen:bin",
        ),
    },
    doc = "Node.js binary",
    executable = True,
    implementation = _nodejs_binary_implementation,
    toolchains = ["@better_rules_javascript//rules/nodejs:toolchain_type"],
)
