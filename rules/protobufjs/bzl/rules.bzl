load(
    "//rules/javascript/bzl:providers.bzl",
    _JsInfo = "JsInfo",
    _create_module = "create_module",
    _create_package = "create_package",
    _create_package_dep = "create_package_dep",
    _merge_js = "merge_js",
)
load("@rules_proto//proto:defs.bzl", _ProtoInfo = "ProtoInfo")
load(":providers.bzl", _JsProtobuf = "JsProtobuf")

def _js_proto_impl(ctx):
    js_protobuf = _JsProtobuf(
        runtime = ctx.attr.runtime[_JsInfo],
        bin = ctx.attr.bin,
    )

    return [js_protobuf]

js_proto = rule(
    implementation = _js_proto_impl,
    attrs = {
        "bin": attr.label(
            executable = True,
            cfg = "host",
            mandatory = True,
        ),
        "runtime": attr.label(
            doc = "Runtime dependencies",
            providers = [_JsInfo],
        ),
    },
)

def _js_proto_library_impl(ctx):
    package_name = ctx.attr.package_name
    if not package_name:
        package_name = "@%s/%s" % (ctx.label.workspace_name or ctx.workspace_name, ctx.label.package) if ctx.label.package else ctx.label.workspace_name

    js_proto = ctx.attr.js_proto[_JsProtobuf]

    args = ctx.actions.args()

    for dep in ctx.attr.deps:
        args.add_all(dep[_ProtoInfo].transitive_proto_path, before_each = "-p")

    output = ctx.actions.declare_file("%s/index.js" % ctx.label.name)
    args.add("-o", output.path)

    ctx.actions.run(
        executable = js_proto.bin.files_to_run,
        arguments = [args],
        inputs = depset(transitive = [dep[_ProtoInfo].transitive_sources for dep in ctx.attr.deps]),
        outputs = [output],
    )

    runtime_package = js_proto.runtime

    package = _create_package(
        ctx.label,
        package_name,
        None,
        tuple([_create_module("index.js", output)]),
        tuple([_create_package_dep(runtime_package.name, runtime_package.id)]),
    )

    default_info = DefaultInfo(files = depset([output]))

    js_info = _merge_js(
        _JsInfo(
            id = package.id,
            name = package.name,
            globals = depset(),
            transitive_files = depset([output]),
            transitive_packages = depset([package]),
            transitive_source_maps = depset(),
        ),
        [runtime_package],
    )

    return [default_info, js_info]

js_proto_library = rule(
    implementation = _js_proto_library_impl,
    attrs = {
        "js_proto": attr.label(
            doc = "Config",
            mandatory = True,
            providers = [_JsProtobuf],
        ),
        "package_name": attr.string(
            doc = "Package name",
        ),
        "deps": attr.label_list(
            doc = "Protobufs",
            mandatory = True,
            providers = [_ProtoInfo],
        ),
    },
)
