load("@bazel_skylib//rules:common_settings.bzl", "BuildSettingInfo")
load("@rules_proto//proto:defs.bzl", "ProtoInfo")
load("//util:path.bzl", "output")
load(":providers.bzl", "TsProtoInfo", "TsProtobuf", "create_lib")

def _ts_proto_impl(target, ctx):
    actions = ctx.actions
    configuration = ctx.configuration
    proto = target[ProtoInfo]
    protoc = ctx.toolchains["@rules_proto_grpc//protobuf:toolchain_type"]
    ts_proto = ctx.attr._ts_protoc[TsProtobuf]
    label = ctx.label
    deps = [dep[TsProtoInfo] for dep in ctx.rule.attr.deps]
    output_name = "%s.ts_proto" % target.label.name
    output_ = output(ctx.label, actions, output_name)
    workspace_name = ctx.workspace_name

    # generate TS
    ts = []
    for file in proto.direct_sources:
        path = file.path
        if proto.proto_source_root and proto.proto_source_root != ".":
            path = path[len("%s/" % proto.proto_source_root):]
        name = path.replace(".proto", ".ts")
        ts_ = actions.declare_file("%s/%s" % (output_name, name))
        ts.append(ts_)

    args = actions.args()
    args.add(ts_proto.bin.executable, format = "--plugin=protoc-gen-ts_proto=%s")
    args.add_all(proto.transitive_proto_path, format_each = "-I%s")
    args.add(output_.path, format = "--ts_proto_out=%s")
    args.add_joined(
        proto.transitive_descriptor_sets,
        join_with = configuration.host_path_separator,
        format_joined = "--descriptor_set_in=%s",
    )
    args.add_all(ts_proto.options, format_each = "--ts_proto_opt=%s")
    args.add_all(proto.direct_sources)
    actions.run(
        executable = protoc.protoc_executable,
        arguments = [args],
        tools = [protoc.protoc_executable, ts_proto.bin],
        inputs = depset(
            transitive = [proto.transitive_descriptor_sets, proto.transitive_sources],
        ),
        outputs = ts,
    )

    lib = create_lib(
        deps = [dep.label for dep in ctx.rule.attr.deps],
        files = ts,
        label = ctx.label,
        path = output_.path,
    )

    # providers

    transitive_libs = depset(
        [lib],
        transitive = [ts_proto_info.transitive_libs for ts_proto_info in deps],
    )
    ts_proto_info = TsProtoInfo(
        transitive_libs = transitive_libs,
    )

    return [ts_proto_info]

def ts_proto_aspect(ts_protoc):
    """
    Create ts_proto aspect

    :param str ts_protoc: TsProtobuf label
    :param list options: List of options
    """
    return aspect(
        implementation = _ts_proto_impl,
        attr_aspects = ["deps"],
        attrs = {
            "_ts_protoc": attr.label(
                providers = [TsProtobuf],
                default = ts_protoc,
            ),
        },
        provides = [TsProtoInfo],
        toolchains = ["@rules_proto_grpc//protobuf:toolchain_type"],
    )
