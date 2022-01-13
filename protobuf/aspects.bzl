load("//commonjs:providers.bzl", "CjsInfo")
load("//javascript:providers.bzl", "JsInfo")
load("//util:path.bzl", "output")
load("@rules_proto//proto:defs.bzl", "ProtoInfo")
load(":providers.bzl", "JsProtoInfo", "JsProtobuf", "create_lib")

def _js_proto_impl(target, ctx):
    protoc = ctx.toolchains["@rules_proto_grpc//protobuf:toolchain_type"]
    proto = target[ProtoInfo]
    js_proto = ctx.attr._js_protoc[JsProtobuf]
    deps = [dep[JsProtoInfo] for dep in ctx.rule.attr.deps]
    cjs_info = js_proto.root

    output_name = "%s/js_proto" % target.label.name
    output_ = output(ctx.label, actions, output_name)

    # declare files
    js = []
    protos = []
    for file in proto.direct_sources:
        path = file.path
        if proto.proto_source_root and proto.proto_source_root != ".":
            path = path[len("%s/" % proto.proto_source_root):]
        protos.append(path)
        js_ = actions.declare_file("%s/%s" % (output_name, path.replace(".proto", "_pb.js")))
        js.append(js_)

    args = actions.args()
    args.add(protoc.protoc_executable.path)
    args.add_joined(
        proto.transitive_descriptor_sets,
        join_with = ctx.configuration.host_path_separator,
        format_joined = "--descriptor_set_in=%s",
    )

    actions.run_shell(
        command = '''
protoc="$1"
shift
out="$1"
shift
mkdir -p "$out"
"$protoc" --js_out=import_style=commonjs,binary:"$out" "$@"
''',
        arguments = [args] + protos,
        inputs = depset(
            [protoc.protoc_executable],
            transitive = [proto.transitive_sources, proto.transitive_descriptor_sets],
        ),
        outputs = js,
    )

    js_deps = [dep[JsInfo] for dep in ctx.rule.attr.deps] + [js_proto.runtime]

    # define JsProtoInfo
    lib = create_lib(
        deps = [dep.label for dep in ctx.rule.attr.deps],
        js = js,
        label = ctx.label,
        path = output_.path,
        js_deps = js_proto.runtime,
    )
    transitive_libs = depset(
        [lib],
        order = "postorder",
        transitive = [js_proto_info.transitive_libs for js_proto_info in deps],
    )
    js_proto_info = JsProtoInfo(
        transitive_libs = transitive_libs,
    )

    return [js_proto_info]

def js_proto_aspect(js_protoc):
    """Create js_proto aspect.

    Args:
        js_protoc: JsProtobuf label
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
