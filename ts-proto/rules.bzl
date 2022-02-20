load("//commonjs:providers.bzl", "CjsInfo", "CjsRootInfo", "create_cjs_info")
load("//javascript:providers.bzl", "JsInfo", "create_js_info")
load("//nodejs:rules.bzl", "nodejs_binary")
load("//typescript:providers.bzl", "TsCompilerInfo", "TsInfo", "create_ts_info")
load("//util:path.bzl", "output_name", "runfile_path")
load(":aspects.bzl", _ts_proto_aspect = "ts_proto_aspect")
load(":providers.bzl", "TsProtoInfo", "TsProtobuf", "TsProtosInfo")

def _ts_protoc_impl(ctx):
    bin = ctx.attr.bin[DefaultInfo]
    compiler = ctx.attr.compiler[TsCompilerInfo]
    cjs_deps = [target[CjsInfo] for target in ctx.attr.deps]
    js_deps = [dep[JsInfo] for dep in ctx.attr.deps if JsInfo in dep]
    ts_deps = [dep[TsInfo] for dep in ctx.attr.deps if TsInfo in dep]

    ts_protobuf = TsProtobuf(
        bin = bin.files_to_run,
        compiler = compiler,
        cjs_deps = cjs_deps,
        js_deps = js_deps,
        ts_deps = ts_deps,
    )

    return [ts_protobuf]

ts_protoc = rule(
    implementation = _ts_protoc_impl,
    attrs = {
        "bin": attr.label(
            doc = "Protoc plugin",
            executable = True,
            cfg = "exec",
            mandatory = True,
        ),
        "compiler": attr.label(
            doc = "TypeScript compiler",
            mandatory = True,
            providers = [TsCompilerInfo],
        ),
        "deps": attr.label_list(
            doc = "Declarations",
            mandatory = True,
            providers = [[JsInfo], [TsInfo]],
        ),
    },
)

def configure_ts_protoc(name, compiler, ts_proto, deps, visibility = None):
    nodejs_binary(
        name = "%s.bin" % name,
        node_options = [
            "--no-deprecation",  # https://github.com/protobufjs/protobuf.js/issues/1411
        ],
        dep = ts_proto,
        main = "build/plugin.js",
        visibility = ["//visibility:private"],
    )

    ts_protoc(
        bin = "%s.bin" % name,
        compiler = compiler,
        deps = deps,
        name = name,
        visibility = visibility,
    )

def _ts_proto_libraries_impl(ctx):
    actions = ctx.actions
    ts_proto = ctx.attr._ts_protoc[TsProtobuf]
    cjs_root = ctx.attr.root[CjsRootInfo]
    prefix = ctx.attr.prefix
    label = ctx.label
    workspace_name = ctx.workspace_name

    libs = depset(
        order = "postorder",
        transitive = [dep[TsProtoInfo].transitive_libs for dep in ctx.attr.deps],
    )

    cjs_infos = {}
    js_infos = {}
    ts_infos = {}
    default_infos = {}
    for lib in libs.to_list():
        js = []
        for file in lib.js:
            path = file.path[len(lib.path + "/"):]
            if prefix:
                path = "%s/%s" % (prefix, path)
            js_ = actions.declare_file(path)
            actions.symlink(
                output = js_,
                target_file = file,
            )
            js.append(js_)
        declarations = []
        for file in lib.declarations:
            path = file.path[len(lib.path + "/"):]
            if prefix:
                path = "%s/%s" % (prefix, path)
            declaration = actions.declare_file(path)
            actions.symlink(
                output = declaration,
                target_file = file,
            )
            declarations.append(declaration)

        js_deps = [js_infos[label] for label in lib.deps]
        js_infos[lib.label] = create_js_info(
            files = js,
            deps = js_deps,
        )

        ts_deps = [ts_infos[label] for label in lib.deps]
        ts_infos[lib.label] = create_ts_info(
            files = declarations,
            deps = ts_deps,
        )

        default_infos[lib.label] = DefaultInfo(
            files = depset(js),
        )

    cjs_info = create_cjs_info(
        cjs_root = cjs_root,
        label = label,
        deps = ts_proto.cjs_deps + ts_proto.compiler.runtime_cjs,
    )

    ts_protos_info = TsProtosInfo(
        cjs = cjs_info,
        js = {dep.label: js_infos[dep.label] for dep in ctx.attr.deps},
        ts = {dep.label: ts_infos[dep.label] for dep in ctx.attr.deps},
        default = {dep.label: default_infos[dep.label] for dep in ctx.attr.deps},
    )

    return [cjs_info, ts_protos_info]

def ts_proto_libraries_rule(aspect, compiler):
    return rule(
        implementation = _ts_proto_libraries_impl,
        attrs = {
            "_ts_protoc": attr.label(
                default = compiler,
                providers = [TsProtobuf],
            ),
            "deps": attr.label_list(
                providers = [ProtoInfo],
                aspects = [aspect],
            ),
            "prefix": attr.string(
                doc = "Prefix to add.",
            ),
            "root": attr.label(
                providers = [CjsRootInfo],
            ),
        },
        provides = [CjsInfo, TsProtosInfo],
    )

def _ts_proto_export_impl(ctx):
    dep = ctx.attr.dep.label
    ts_protos = ctx.attr.lib[TsProtosInfo]

    if dep not in ts_protos.js:
        fail('Dep "%s" not in "%s"' % (dep, ctx.attr.lib.label))

    default_info = ts_protos.default[dep]

    cjs_info = ts_protos.cjs

    js_info = ts_protos.js[dep]

    ts_info = ts_protos.ts[dep]

    return [cjs_info, default_info, js_info, ts_info]

ts_proto_export = rule(
    doc = "TypeScript protobuf library",
    implementation = _ts_proto_export_impl,
    attrs = {
        "dep": attr.label(
            providers = [ProtoInfo],
        ),
        "lib": attr.label(
            providers = [CjsInfo, TsProtosInfo],
        ),
    },
    provides = [CjsInfo, JsInfo, TsInfo],
)
