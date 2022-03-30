load("@rules_proto//proto:defs.bzl", "ProtoInfo")
load("//commonjs:providers.bzl", "CjsInfo", "create_link")
load("//javascript:providers.bzl", "JsInfo")
load("//nodejs:rules.bzl", "nodejs_binary")
load("//util:path.bzl", "output", "output_name")
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
        node = "@better_rules_javascript//rules:nodejs",
        visibility = ["//visibility:private"],
    )

    js_proto(
        name = name,
        bin = "%s_bin" % name,
        runtime = dep,
        visibility = visibility,
    )

def _js_proto_library_impl(ctx):
    actions = ctx.actions
    cjs_info = ctx.attr.root[CjsInfo]
    js_proto = ctx.attr.js_proto[JsProtobuf]
    output_ = output(ctx.label, ctx.actions)
    runtime_package = js_proto.runtime
    workspace_name = ctx.workspace_name

    output = ctx.outputs.output

    args = actions.args()
    for dep in ctx.attr.deps:
        args.add_all(dep[ProtoInfo].transitive_proto_path, before_each = "-p")
    args.add("-o", output.path)
    args.add("-t", "static-module")
    args.add("-w", "commonjs")

    # args.add("--es6")
    args.add_all(dep[ProtoInfo].transitive_sources)
    actions.run(
        executable = js_proto.bin.executable,
        tools = [js_proto.bin],
        arguments = [args],
        inputs = depset(transitive = [dep[ProtoInfo].transitive_sources for dep in ctx.attr.deps]),
        outputs = [output],
    )

    js_deps = [js_proto.runtime]

    transitive_links = depset(
        [
            create_link(id = cjs_info.package.id, dep = js_proto.runtime.package.id, name = js_proto.runtime.name, label = ctx.attr.js_proto.label),
        ],
        transitive = [js_info.transitive_links for js_info in js_deps],
    )
    transitive_packages = depset(
        [cjs_info.package],
        transitive = [js_info.transitive_packages for js_info in js_deps],
    )
    transitive_files = depset(
        [output],
        transitive = [js_info.transitive_files for js_info in js_deps],
    )
    transitive_srcs = depset(
        [],
        transitive = [js_info.transitive_srcs for js_info in js_deps],
    )

    js_info = JsInfo(
        transitive_files = transitive_files,
        package = cjs_info.package,
        transitive_links = transitive_links,
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
        "output": attr.output(
            mandatory = True,
        ),
    },
)
