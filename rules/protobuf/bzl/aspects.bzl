load("@better_rules_javascript//rules/javascript/bzl:providers.bzl", "JsInfo", "create_js", "create_module", "create_package", "create_package_dep")
load("@rules_proto//proto:defs.bzl", "ProtoInfo")
load(":providers.bzl", "JsProtobuf")

def _path(file):
    return file.path

def _js_proto_impl(target, ctx):
    protoc = ctx.toolchains["@rules_proto_grpc//protobuf:toolchain_type"]
    proto = target[ProtoInfo]

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

    modules = []
    outputs = []
    for file in proto.direct_sources:
        path = file.path
        if proto.proto_source_root and proto.proto_source_root != ".":
            path = path[len("%s/" % proto.proto_source_root):]
        args.add(path)
        name = path.replace(".proto", "_pb.js")
        output = ctx.actions.declare_file("js_proto/%s" % name)
        outputs.append(output)
        modules.append(create_module(name, output))

    ctx.actions.run_shell(
        command = 'protoc="$1"; shift; out="$1"; shift; mkdir -p "$out" && "$protoc" --js_out=import_style=commonjs,binary:"$out" "$@"',
        arguments = [args],
        inputs = depset(
            [protoc.protoc_executable],
            transitive = [proto.transitive_sources, proto.transitive_descriptor_sets],
        ),
        outputs = outputs,
    )

    deps = [dep[JsInfo] for dep in ctx.rule.attr.deps]
    package_deps = [create_package_dep(dep[JsInfo].name, id) for dep in ctx.rule.attr.deps for id in dep[JsInfo].ids]

    runtime_package = ctx.attr._js_protoc[JsProtobuf].runtime
    deps.append(runtime_package)
    for id in runtime_package.ids:
        package_deps.append(create_package_dep(runtime_package.name, id))

    package = create_package(
        id = str(ctx.label),
        name = ctx.attr._js_name,
        modules = tuple(modules),
        deps = tuple(package_deps),
    )

    js_info = create_js(
        package = package,
        files = outputs,
        deps = deps,
    )

    return [js_info]

def js_proto_aspect(js_protoc, js_name = "proto"):
    """
    Create js_proto aspect

    :param str|Label js_protoc: JsProtobuf label
    :param str js_name: Package name
    """
    return aspect(
        implementation = _js_proto_impl,
        attr_aspects = ["deps"],
        attrs = {
            "_js_protoc": attr.label(
                providers = [JsProtobuf],
                default = js_protoc,
            ),
            "_js_name": attr.string(
                default = js_name,
            ),
        },
        toolchains = ["@rules_proto_grpc//protobuf:toolchain_type"],
    )
