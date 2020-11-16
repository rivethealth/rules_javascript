load(
    "//rules/javascript/bzl:providers.bzl",
    "JsInfo",
    "create_js",
    "create_module",
    "create_package",
    "create_package_dep",
)
load("//rules/javascript/bzl:rules.bzl", "default_package_name")
load("@rules_proto//proto:defs.bzl", "ProtoInfo")
load(":providers.bzl", "JsProtobuf")

def _path(file):
    return file.path

def _js_proto_impl(ctx):
    js_protobuf = JsProtobuf(
        runtime = ctx.attr.runtime[JsInfo],
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
            providers = [JsInfo],
        ),
    },
)

def _js_proto_library_impl(ctx):
    package_name = ctx.attr.js_name or default_package_name(ctx)

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
        executable = js_proto.bin.files_to_run,
        arguments = [args],
        inputs = depset(transitive = [dep[ProtoInfo].transitive_sources for dep in ctx.attr.deps]),
        outputs = [output],
    )

    runtime_package = js_proto.runtime

    package = create_package(
        id = str(ctx.label),
        name = package_name,
        modules = (create_module("pb.js", output),),
        deps = tuple([create_package_dep(runtime_package.name, id) for id in runtime_package.ids]),
    )

    default_info = DefaultInfo(files = depset([output]))

    js_info = create_js(
        package = package,
        files = [output],
        deps = [runtime_package],
    )

    return [default_info, js_info]

js_proto_library = rule(
    implementation = _js_proto_library_impl,
    attrs = {
        "js_name": attr.string(
            doc = "Package name",
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
    },
)
