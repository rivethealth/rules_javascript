load("//commonjs:providers.bzl", "CjsEntries", "CjsInfo")
load("//javascript:providers.bzl", "JsInfo", js_create_deps = "create_deps")
load("//nodejs:rules.bzl", "nodejs_binary")
load("//typescript:providers.bzl", "TsCompilerInfo", "TsInfo", "create_deps")
load("//util:path.bzl", "output_name", "runfile_path")
load(":aspects.bzl", _ts_proto_aspect = "ts_proto_aspect")
load(":providers.bzl", "TsProtoInfo", "TsProtobuf", "TsProtosInfo")

def _ts_protoc_impl(ctx):
    ts_protobuf = TsProtobuf(
        bin = ctx.attr.bin[DefaultInfo].files_to_run,
        compiler = ctx.attr.compiler[TsCompilerInfo],
        js_deps = [dep[JsInfo] for dep in ctx.attr.deps if JsInfo in dep],
        ts_deps = [dep[TsInfo] for dep in ctx.attr.deps if TsInfo in dep],
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
        node_options = ["--no-deprecation"],  # https://github.com/protobufjs/protobuf.js/issues/1411
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
    cjs_info = ctx.attr.root[CjsInfo]
    label = ctx.label
    workspace_name = ctx.workspace_name

    libs = depset(
        order = "postorder",
        transitive = [dep[TsProtoInfo].transitive_libs for dep in ctx.attr.deps],
    )

    js_infos = {}
    ts_infos = {}
    default_infos = {}
    for lib in libs.to_list():
        lib_path = "/" + "/".join(lib.runfile_path.split("/")[1:])
        js = []
        for file in lib.js:
            path = output_name(
                file = file,
                strip_prefix = lib_path,
                label = label,
            )
            js_ = actions.declare_file(path)
            actions.symlink(
                output = js_,
                target_file = file,
            )
            js.append(js_)
        declarations = []
        for file in lib.declarations:
            path = output_name(
                file = file,
                label = label,
                strip_prefix = lib_path,
            )
            declaration = actions.declare_file(path)
            actions.symlink(
                output = declaration,
                target_file = file,
            )
            declarations.append(declaration)
        srcs = []
        for src in lib.srcs:
            path = output_name(
                file = file,
                label = label,
                strip_prefix = lib_path,
            )
            src = actions.declare_file(path)
            actions.symlink(
                output = src,
                target_file = file,
            )
            srcs.append(src)

        js_deps = list(lib.js_deps) + [js_infos[label] for label in lib.deps]
        ts_deps = list(lib.ts_deps) + [ts_infos[label] for label in lib.deps]

        transitive_deps = depset(
            js_create_deps(cjs_info.package, lib.label, js_deps),
            transitive = [js_info.transitive_deps for js_info in js_deps],
        )
        transitive_packages = depset(
            [cjs_info.package],
            transitive = [js_info.transitive_packages for js_info in js_deps],
        )
        transitive_files = depset(
            cjs_info.descriptors + js,
            transitive = [js_info.transitive_files for js_info in js_deps],
        )
        transitive_srcs = depset(
            srcs,
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

        transitive_deps = depset(
            create_deps(cjs_info.package, lib.label, ts_deps),
            transitive = [ts_info.transitive_deps for ts_info in ts_deps],
        )
        transitive_files = depset(
            cjs_info.descriptors + declarations,
            transitive = [ts_info.transitive_files for ts_info in ts_deps],
        )
        transitive_packages = depset(
            [cjs_info.package],
            transitive = [ts_info.transitive_packages for ts_info in ts_deps],
        )
        ts_infos[lib.label] = TsInfo(
            name = cjs_info.name,
            package = cjs_info.package,
            transitive_deps = transitive_deps,
            transitive_files = transitive_files,
            transitive_packages = transitive_packages,
            transitive_srcs = depset(),
        )

        default_infos[lib.label] = DefaultInfo(
            files = depset(js + declarations + srcs),
        )

    ts_protos_info = TsProtosInfo(
        js = {dep.label: js_infos[dep.label] for dep in ctx.attr.deps},
        ts = {dep.label: ts_infos[dep.label] for dep in ctx.attr.deps},
        default = {dep.label: default_infos[dep.label] for dep in ctx.attr.deps},
    )

    return [ts_protos_info]

def ts_proto_libraries_rule(aspect):
    return rule(
        implementation = _ts_proto_libraries_impl,
        attrs = {
            "deps": attr.label_list(
                providers = [ProtoInfo],
                aspects = [aspect],
            ),
            "root": attr.label(
                providers = [CjsInfo],
            ),
        },
    )

def _ts_proto_export_impl(ctx):
    ts_protos_info = ctx.attr.lib[TsProtosInfo]
    dep = ctx.attr.dep.label

    if not dep in ts_protos_info.js:
        fail('Dep "%s" not in "%s"' % (dep, ctx.attr.lib.label))

    js_info = ts_protos_info.js[dep]
    ts_info = ts_protos_info.ts[dep]
    default_info = ts_protos_info.default[dep]

    cjs_entries = CjsEntries(
        name = ts_info.name,
        package = ts_info.package,
        transitive_packages = depset(transitive = [js_info.transitive_packages, ts_info.transitive_packages]),
        transitive_deps = depset(transitive = [js_info.transitive_deps, ts_info.transitive_deps]),
        transitive_files = depset(
            transitive = [ts_info.transitive_files, js_info.transitive_files, js_info.transitive_srcs],
        ),
    )

    return [cjs_entries, default_info, js_info, ts_info]

ts_proto_export = rule(
    doc = "TypeScript protobuf library",
    implementation = _ts_proto_export_impl,
    attrs = {
        "dep": attr.label(
            providers = [ProtoInfo],
        ),
        "lib": attr.label(
            providers = [TsProtosInfo],
        ),
    },
)
