load("@better_rules_javascript//commonjs:providers.bzl", "CjsEntries", "CjsInfo", "create_dep", "output_prefix")
load("@better_rules_javascript//javascript:providers.bzl", "JsInfo")
load("@better_rules_javascript//nodejs:rules.bzl", "nodejs_binary")
load("@better_rules_javascript//util:path.bzl", "runfile_path")
load("//typescript:providers.bzl", "SimpleTsCompilerInfo", "TsInfo")
load(":aspects.bzl", _ts_proto_aspect = "ts_proto_aspect")
load(":providers.bzl", "TsProtoInfo", "TsProtobuf", "TsProtosInfo")

def _ts_protoc_impl(ctx):
    ts_protobuf = TsProtobuf(
        bin = ctx.attr.bin[DefaultInfo].files_to_run,
        compiler = ctx.attr.compiler[SimpleTsCompilerInfo],
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
            providers = [SimpleTsCompilerInfo],
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
        name = "%s_bin" % name,
        node_options = ["--no-deprecation"],  # https://github.com/protobufjs/protobuf.js/issues/1411
        dep = ts_proto,
        main = "build/plugin.js",
        visibility = ["//visibility:private"],
    )

    ts_protoc(
        bin = "%s_bin" % name,
        compiler = compiler,
        deps = deps,
        name = name,
        visibility = visibility,
    )

def _ts_proto_libraries_impl(ctx):
    cjs_info = ctx.attr.root[CjsInfo]
    prefix = output_prefix(cjs_info.package.path, ctx.label, ctx.actions)

    libs = depset(
        order = "postorder",
        transitive = [dep[TsProtoInfo].transitive_libs for dep in ctx.attr.deps],
    )

    js_infos = {}
    ts_infos = {}
    for lib in libs.to_list():
        js = []
        for js_ in lib.js:
            path = js_.path[len(lib.path + "/"):]
            if prefix:
                path = "%s/%s" % (prefix, path)
            file = ctx.actions.declare_file(path)
            ctx.actions.run(
                arguments = [js_.path, file.path],
                executable = "cp",
                inputs = [js_],
                mnemonic = "CopyFile",
                outputs = [file],
                progress_message = "Copying file to %{output}",
            )
            js.append(file)
        declarations = []
        for declaration in lib.declarations:
            path = declaration.path[len(lib.path + "/"):]
            if prefix:
                path = "%s/%s" % (prefix, path)
            file = ctx.actions.declare_file(path)
            ctx.actions.run(
                arguments = [declaration.path, file.path],
                executable = "cp",
                inputs = [declaration],
                mnemonic = "CopyFile",
                outputs = [file],
                progress_message = "Copying file to %{output}",
            )
            declarations.append(file)
        srcs = []
        for src in lib.srcs:
            path = src.path[len(lib.path + "/"):]
            if prefix:
                path = "%s/%s" % (prefix, path)
            file = ctx.actions.declare_file(path)
            ctx.actions.run(
                arguments = [src.path, file.path],
                executable = "cp",
                inputs = [src],
                mnemonic = "CopyFile",
                outputs = [file],
                progress_message = "Copying file to %{output}",
            )
            srcs.append(file)

        js_deps = list(lib.js_deps) + [js_infos[label] for label in lib.deps]
        ts_deps = list(lib.ts_deps) + [ts_infos[label] for label in lib.deps]

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
            srcs,
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

        transitive_deps = depset(
            [create_dep(id = cjs_info.package.id, name = ts_info.name, dep = ts_info.package.id, label = lib.label) for ts_info in ts_deps],
            transitive = [ts_info.transitive_deps for ts_info in ts_deps],
        )
        transitive_declarations = depset(
            declarations,
            transitive = [ts_info.transitive_declarations for ts_info in ts_deps],
        )
        transitive_descriptors = depset(
            cjs_info.descriptors,
            transitive = [ts_info.transitive_descriptors for ts_info in ts_deps],
        )
        transitive_packages = depset(
            [cjs_info.package],
            transitive = [ts_info.transitive_packages for ts_info in ts_deps],
        )
        ts_infos[lib.label] = TsInfo(
            name = cjs_info.name,
            package = cjs_info.package,
            transitive_deps = transitive_deps,
            transitive_declarations = transitive_declarations,
            transitive_descriptors = transitive_descriptors,
            transitive_packages = transitive_packages,
        )

    ts_protos_info = TsProtosInfo(
        js = {dep.label: js_infos[dep.label] for dep in ctx.attr.deps},
        ts = {dep.label: ts_infos[dep.label] for dep in ctx.attr.deps},
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

    cjs_entries = CjsEntries(
        name = ts_info.name,
        package = ts_info.package,
        transitive_packages = depset(transitive = [js_info.transitive_packages, ts_info.transitive_packages]),
        transitive_deps = depset(transitive = [js_info.transitive_deps, ts_info.transitive_deps]),
        transitive_files = depset(
            transitive = [js_info.transitive_descriptors, ts_info.transitive_descriptors, ts_info.transitive_declarations, js_info.transitive_js, js_info.transitive_srcs],
        ),
    )

    return [cjs_entries, js_info, ts_info]

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
