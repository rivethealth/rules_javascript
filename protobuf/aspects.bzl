load("//commonjs:providers.bzl", "create_entry", "create_entry_set", "create_extra_link")
load("//javascript:providers.bzl", "JsInfo")
load("@rules_proto//proto:defs.bzl", "ProtoInfo")
load(":providers.bzl", "JsProtobuf")

def _path(file):
    return file.path

def _js_proto_impl(target, ctx):
    protoc = ctx.toolchains["@rules_proto_grpc//protobuf:toolchain_type"]
    proto = target[ProtoInfo]
    js_proto = ctx.attr._js_protoc[JsProtobuf]

    cjs_info = js_proto.root

    dummy = ctx.actions.declare_file("js_proto/_dummy")
    ctx.actions.run_shell(command = "", outputs = [dummy])

    args = ctx.actions.args()
    args.add(protoc.protoc_executable.path)
    args.add(dummy.dirname)

    args.add_joined(
        proto.transitive_descriptor_sets,
        join_with = ctx.configuration.host_path_separator,
        map_each = _path,
        format_joined = "--descriptor_set_in=%s",
    )

    entries = []
    for file in proto.direct_sources:
        path = file.path
        if proto.proto_source_root and proto.proto_source_root != ".":
            path = path[len("%s/" % proto.proto_source_root):]
        args.add(path)
        name = path.replace(".proto", "_pb.js")
        output = ctx.actions.declare_file("js_proto/%s" % name)
        entries.append(create_entry(root = cjs_info.id, name = name, file = output, label = target.label))

    ctx.actions.run_shell(
        command = 'protoc="$1"; shift; out="$1"; shift; mkdir -p "$out" && "$protoc" --js_out=import_style=commonjs,binary:"$out" "$@"',
        arguments = [args],
        inputs = depset(
            [protoc.protoc_executable],
            transitive = [proto.transitive_sources, proto.transitive_descriptor_sets],
        ),
        outputs = [entry.file for entry in entries],
    )

    js_deps = [dep[JsInfo] for dep in ctx.rule.attr.deps] + [js_proto.runtime]

    transitive_descriptors = depset(
        [cjs_info.descriptor],
        transitive = [js_info.transitive_descriptors for js_info in js_deps],
    )
    transitive_extra_links = depset(
        [
            create_extra_link(root = cjs_info.id, dep = dep[JsInfo].root, label = dep.label)
            for dep in ctx.rule.attr.deps
        ] + [
            create_extra_link(root = cjs_info.id, dep = js_proto.runtime.root, label = ctx.attr._js_protoc.label),
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

    return [js_info]

def js_proto_aspect(js_protoc):
    """
    Create js_proto aspect

    :param str|Label js_protoc: JsProtobuf label
    :param str package_name: Package name
    """
    return aspect(
        implementation = _js_proto_impl,
        attr_aspects = ["deps"],
        attrs = {
            "_js_protoc": attr.label(
                providers = [JsProtobuf],
                default = js_protoc,
            ),
        },
        toolchains = ["@rules_proto_grpc//protobuf:toolchain_type"],
    )
