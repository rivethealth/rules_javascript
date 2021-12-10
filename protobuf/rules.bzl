load("@better_rules_javascript//commonjs:rules.bzl", "output_prefix")
load("@better_rules_javascript//commonjs:providers.bzl", "create_dep")
load("//commonjs:providers.bzl", "CjsInfo")
load("//javascript:providers.bzl", "JsInfo")
load(":aspects.bzl", "js_proto_aspect")
load(":providers.bzl", "JsProtoInfo", "JsProtobuf")

def _js_protoc_impl(ctx):
    js_protobuf = JsProtobuf(
        runtime = ctx.attr.runtime[JsInfo],
    )

    return [js_protobuf]

js_protoc = rule(
    implementation = _js_protoc_impl,
    attrs = {
        "runtime": attr.label(
            doc = "Runtime dependencies",
            providers = [JsInfo],
        ),
    },
    doc = "JavaScript protobuf tools",
)

def _js_proto_libraries_impl(ctx):
    cjs_info = ctx.attr.root[CjsInfo]
    prefix = output_prefix(cjs_info.package.path, ctx.label, ctx.actions)

    libs = depset(
        order = "postorder",
        transitive = [dep[JsProtoInfo].transitive_libs for dep in ctx.attr.deps],
    )

    js_infos = {}
    for lib in libs.to_list():
        js = []
        for js_ in lib.js:
            path = js_.path[len(lib.path + "/"):]
            if prefix:
                path = "%s/%s" % (prefix, path)
            file = ctx.actions.declare_file(path)
            ctx.actions.symlink(
                output = file,
                target_file = js_,
                progress_message = "Copying file to %{output}",
            )
            js.append(file)

        js_deps = list(lib.js_deps) + [js_infos[label] for label in lib.deps]

        transitive_deps = depset(
            [create_dep(id = cjs_info.package.id, name = js_info.name, dep = js_info.package.id, label = lib.label) for js_info in js_deps],
            transitive = [js_info.transitive_deps for js_info in js_deps],
        )
        transitive_descriptors = depset(
            cjs_info.descriptors,
            transitive = [js_info.transitive_descriptors for js_info in js_deps],
        )
        transitive_packages = depset(
            [cjs_info.package],
            transitive = [js_info.transitive_packages for js_info in js_deps],
        )
        transitive_js = depset(
            js,
            transitive = [js_info.transitive_js for js_info in js_deps],
        )
        transitive_srcs = depset(
            [],
            transitive = [js_info.transitive_srcs for js_info in js_deps],
        )
        js_infos[lib.label] = JsInfo(
            name = cjs_info.name,
            package = cjs_info.package,
            transitive_deps = transitive_deps,
            transitive_descriptors = transitive_descriptors,
            transitive_js = transitive_js,
            transitive_srcs = transitive_srcs,
            transitive_packages = transitive_packages,
        )

    js_protos_info = JsProtoInfo(
        js = {dep.label: js_infos[dep.label] for dep in ctx.attr.deps},
    )

    return [js_protos_info]

def js_proto_libraries_rule(js_proto):
    """
    Create js_proto_library rule.

    Args:
        js_proto: Aspect
    """

    return rule(
        implementation = _js_proto_libraries_impl,
        attrs = {
            "deps": attr.label_list(
                providers = [ProtoInfo],
                aspects = [js_proto],
            ),
            "root": attr.label(
                providers = [CjsInfo],
            ),
        },
    )

def _js_proto_export_impl(ctx):
    ts_protos_info = ctx.attr.lib[JsProtoInfo]
    dep = ctx.attr.dep.label

    if not dep in ts_protos_info.js:
        fail('Dep "%s" not in "%s"' % (dep, ctx.attr.lib.label))

    js_info = ts_protos_info.js[dep]

    return [js_info]

js_proto_export = rule(
    doc = "TypeScript protobuf library",
    implementation = _js_proto_export_impl,
    attrs = {
        "dep": attr.label(
            providers = [ProtoInfo],
        ),
        "lib": attr.label(
            providers = [JsProtoInfo],
        ),
    },
)
