load("//commonjs:providers.bzl", "CjsInfo", "create_dep")
load("//javascript:providers.bzl", "JsInfo")
load("//util:path.bzl", "output_name")
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
    actions = ctx.actions
    cjs_info = ctx.attr.root[CjsInfo]
    label = ctx.label
    prefix = ctx.attr.prefix
    workspace_name = ctx.workspace_name

    libs = depset(
        order = "postorder",
        transitive = [dep[JsProtoInfo].transitive_libs for dep in ctx.attr.deps],
    )

    js_infos = {}
    for lib in libs.to_list():
        js = []
        for file in lib.js:
            path = output_name(
                file = js_,
                prefix = prefix,
                strip_prefix = lib.path,
                label = label,
            )
            js_ = actions.declare_file(path)
            actions.symlink(
                output = js_,
                target_file = file,
            )
            js.append(js_)

        js_deps = list(lib.js_deps) + [js_infos[label] for label in lib.deps]

        transitive_deps = depset(
            [create_dep(id = cjs_info.package.id, name = js_info.name, dep = js_info.package.id, label = lib.label) for js_info in js_deps],
            transitive = [js_info.transitive_deps for js_info in js_deps],
        )
        transitive_packages = depset(
            [cjs_info.package],
            transitive = [js_info.transitive_packages for js_info in js_deps],
        )
        transitive_files = depset(
            js,
            transitive = [js_info.transitive_files for js_info in js_deps],
        )
        transitive_srcs = depset(
            [],
            transitive = [js_info.transitive_srcs for js_info in js_deps],
        )
        js_infos[lib.label] = JsInfo(
            name = cjs_info.name,
            package = cjs_info.package,
            transitive_deps = transitive_deps,
            transitive_files = transitive_files,
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
                mandatory = True,
                providers = [CjsInfo],
            ),
            "prefix": attr.string(),
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
    doc = "JavaScript protobuf library",
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
