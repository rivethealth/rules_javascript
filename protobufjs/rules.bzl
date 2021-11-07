load("@rules_proto//proto:defs.bzl", "ProtoInfo")
load("//commonjs:providers.bzl", "CjsInfo", "create_entry", "create_entry_set", "create_extra_link")
load("//javascript:providers.bzl", "JsInfo")
load("//nodejs:rules.bzl", "nodejs_binary")
load(":providers.bzl", "JsProtobuf")

def _path(file):
    return file.path

def _js_proto_impl(ctx):
    js_protobuf = JsProtobuf(
        runtime = ctx.attr.runtime[JsInfo],
        bin = ctx.attr.bin[DefaultInfo].files_to_run,
    )

    return [js_protobuf]

js_proto = rule(
    attrs = {
        "bin": attr.label(
            cfg = "exec",
            executable = True,
            mandatory = True,
        ),
        "runtime": attr.label(
            mandatory = True,
            providers = [JsInfo],
        ),
    },
    implementation = _js_proto_impl,
)

def configure_js_proto(name, dep, visibility = None):
    nodejs_binary(
        name = "%s_bin" % name,
        dep = dep,
        main = "bin/pbjs",
        visibility = ["//visibility:private"],
    )

    js_proto(
        name = name,
        bin = "%s_bin" % name,
        runtime = dep,
        visibility = visibility,
    )

def _js_proto_library_impl(ctx):
    cjs_info = ctx.attr.root[CjsInfo]

    js_proto = ctx.attr.js_proto[JsProtobuf]

    args = ctx.actions.args()

    for dep in ctx.attr.deps:
        args.add_all(dep[ProtoInfo].transitive_proto_path, before_each = "-p")

    output = ctx.actions.declare_file("%s/pb.js" % ctx.label.name)
    args.add("-o", output.path)
    args.add("-t", "static-module")
    args.add("-w", "commonjs")
    # args.add("--es6")

    args.add_all(dep[ProtoInfo].transitive_sources, map_each = _path)

    ctx.actions.run(
        executable = js_proto.bin.executable,
        tools = [js_proto.bin],
        arguments = [args],
        inputs = depset(transitive = [dep[ProtoInfo].transitive_sources for dep in ctx.attr.deps]),
        outputs = [output],
    )

    runtime_package = js_proto.runtime

    entries = [create_entry(root = cjs_info.id, name = ctx.attr.module_name, file = output, label = ctx.label)]

    js_deps = [js_proto.runtime]

    transitive_descriptors = depset(
        [cjs_info.descriptor],
        transitive = [js_info.transitive_descriptors for js_info in js_deps],
    )
    transitive_extra_links = depset(
        [
            create_extra_link(root = cjs_info.id, dep = js_proto.runtime.root, label = ctx.attr.js_proto.label),
        ],
        transitive = [js_info.transitive_extra_links for js_info in js_deps],
    )
    transitive_roots = depset(
        [cjs_info.root],
        transitive = [js_info.transitive_roots for js_info in js_deps],
    )
    js_entry_set = create_entry_set(
        entries = entries,
        entry_sets = [js_info.js_entry_set for js_info in js_deps],
    )
    src_entry_set = create_entry_set(
        # TODO: entries,
        entry_sets = [js_info.src_entry_set for js_info in js_deps],
    )

    js_info = JsInfo(
        js_entry_set = js_entry_set,
        root = cjs_info.id,
        src_entry_set = src_entry_set,
        transitive_descriptors = transitive_descriptors,
        transitive_extra_links = transitive_extra_links,
        transitive_roots = transitive_roots,
    )

    default_info = DefaultInfo(files = depset([output]))

    return [default_info, js_info]

js_proto_library = rule(
    implementation = _js_proto_library_impl,
    attrs = {
        "root": attr.label(
            doc = "CommonJS root",
            mandatory = True,
            providers = [CjsInfo],
        ),
        "js_proto": attr.label(
            doc = "Config",
            mandatory = True,
            providers = [JsProtobuf],
        ),
        "deps": attr.label_list(
            doc = "Protobufs",
            mandatory = True,
            providers = [ProtoInfo],
        ),
        "module_name": attr.string(
            mandatory = True,
        ),
    },
)
