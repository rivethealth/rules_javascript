load("@better_rules_javascript//commonjs:rules.bzl", "output_prefix")
load("@rules_proto//proto:defs.bzl", "ProtoInfo")
load("//commonjs:providers.bzl", "CjsInfo", "create_dep", "create_package")
load("//javascript:providers.bzl", "JsInfo")
load("//nodejs:rules.bzl", "nodejs_binary")
load(":providers.bzl", "JsProtobuf")

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
    runtime_package = js_proto.runtime
    prefix = output_prefix(cjs_info.package.path, ctx.label, ctx.actions)

    output = ctx.actions.declare_file("%s/%s" % (prefix, ctx.attr.output) if prefix else output)

    args = ctx.actions.args()
    for dep in ctx.attr.deps:
        args.add_all(dep[ProtoInfo].transitive_proto_path, before_each = "-p")
    args.add("-o", output.path)
    args.add("-t", "static-module")
    args.add("-w", "commonjs")

    # args.add("--es6")
    args.add_all(dep[ProtoInfo].transitive_sources)
    ctx.actions.run(
        executable = js_proto.bin.executable,
        tools = [js_proto.bin],
        arguments = [args],
        inputs = depset(transitive = [dep[ProtoInfo].transitive_sources for dep in ctx.attr.deps]),
        outputs = [output],
    )

    js_deps = [js_proto.runtime]

    transitive_descriptors = depset(
        cjs_info.descriptors,
        transitive = [js_info.transitive_descriptors for js_info in js_deps],
    )
    transitive_deps = depset(
        [
            create_dep(id = cjs_info.package.id, dep = js_proto.runtime.package.id, name = js_proto.runtime.name, label = ctx.attr.js_proto.label),
        ],
        transitive = [js_info.transitive_deps for js_info in js_deps],
    )
    transitive_packages = depset(
        [cjs_info.package],
        transitive = [js_info.transitive_packages for js_info in js_deps],
    )
    transitive_js = depset(
        [output],
        transitive = [js_info.transitive_js for js_info in js_deps],
    )
    transitive_srcs = depset(
        [],
        transitive = [js_info.transitive_srcs for js_info in js_deps],
    )

    js_info = JsInfo(
        transitive_js = transitive_js,
        package = cjs_info.package,
        transitive_deps = transitive_deps,
        transitive_descriptors = transitive_descriptors,
        transitive_packages = transitive_packages,
        transitive_srcs = transitive_srcs,
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
        "output": attr.string(
            mandatory = True,
        ),
    },
)
