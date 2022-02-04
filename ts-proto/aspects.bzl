load("@rules_proto//proto:defs.bzl", "ProtoInfo")
load("//commonjs:providers.bzl", "CjsInfo", "create_dep", "create_package", "gen_manifest", "package_path")
load("//javascript:providers.bzl", "JsInfo")
load("//typescript:providers.bzl", "TsInfo", "declaration_path", "js_path", "map_path")
load("//util:path.bzl", "output", "runfile_path")
load(":providers.bzl", "TsProtoInfo", "TsProtobuf", "create_lib")

def _ts_proto_impl(target, ctx):
    actions = ctx.actions
    proto = target[ProtoInfo]
    protoc = ctx.toolchains["@rules_proto_grpc//protobuf:toolchain_type"]
    config = ctx.attr._config[DefaultInfo]
    ts_proto = ctx.attr._ts_protoc[TsProtobuf]
    deps = [dep[TsProtoInfo] for dep in ctx.rule.attr.deps]
    compiler = ts_proto.compiler
    fs_linker = ctx.file._fs_linker
    output_name = "%s/ts_proto" % target.label.name
    output_ = output(ctx.label, actions, output_name)
    declaration_output_name = "%s/%s" % (output_name, ctx.attr._declaration_prefix) if ctx.attr._declaration_prefix != "_" else output_name
    declaration_output_path = "%s/%s" % (output_name, ctx.attr._declaration_prefix) if ctx.attr._declaration_prefix != "_" else output_.path
    js_output_name = "%s/%s" % (output_name, ctx.attr._js_prefix) if ctx.attr._js_prefix != "_" else output_name
    js_output_path = "%s/%s" % (output_.path, ctx.attr._js_prefix) if ctx.attr._js_prefix != "_" else output_.path
    src_output_name = "%s/%s" % (output_name, ctx.attr._src_prefix) if ctx.attr._src_prefix != "_" else output_name
    src_output_path = "%s/%s" % (output_.path, ctx.attr._src_prefix) if ctx.attr._src_prefix != "_" else output_.path
    workspace_name = ctx.workspace_name

    # declare files
    ts = []
    declarations = []
    js = []
    maps = []
    protos = []
    for file in proto.direct_sources:
        path = file.path
        if proto.proto_source_root and proto.proto_source_root != ".":
            path = path[len("%s/" % proto.proto_source_root):]
        protos.append(path)
        name = path.replace(".proto", ".ts")
        ts_ = actions.declare_file("%s/%s" % (src_output_name, name))
        ts.append(ts_)
        declaration = actions.declare_file("%s/%s" % (declaration_output_name, declaration_path(name)))
        declarations.append(declaration)
        js_ = actions.declare_file("%s/%s" % (js_output_name, js_path(name)))
        js.append(js_)
        map = actions.declare_file("%s/%s" % (js_output_name, map_path(js_path(name))))
        maps.append(map)

    # generate TS
    args = actions.args()
    args.add(protoc.protoc_executable)
    args.add(ts_proto.bin.executable)
    args.add(output_.path)
    args.add_joined(
        proto.transitive_descriptor_sets,
        join_with = ctx.configuration.host_path_separator,
        format_joined = "--descriptor_set_in=%s",
    )
    actions.run_shell(
        command = '''
protoc="$1"
shift
plugin="$1"
shift
out="$1"
shift
mkdir -p "$out"
"$protoc" --plugin=protoc-gen-ts_proto="$plugin" --ts_proto_opt=esModuleInterop=true --ts_proto_opt=forceLong=long --ts_proto_out="$out" "$@"
        '''.strip(),
        arguments = [args] + protos,
        tools = [protoc.protoc_executable, ts_proto.bin],
        inputs = depset(
            transitive = [proto.transitive_descriptor_sets, proto.transitive_sources],
        ),
        outputs = ts,
    )

    # create tsconfig
    tsconfig = actions.declare_file("%s/tsconfig.json" % output_name)
    args = actions.args()
    args.add("--config", ctx.file._tsconfig)
    args.add("--declaration-dir", declaration_output_path)
    args.add("--out-dir", js_output_path)
    args.add("--root-dir", src_output_path)
    args.add("--root-dirs", src_output_path)
    args.add_all(ts, before_each = "--file")
    for path in depset(transitive = [dep.transitive_paths for dep in deps]).to_list():
        args.add("--root-dirs", "%s/%s"(path, ctx.attr._declaration_prefix) if ctx.attr.declaration_prefix != "_" else path)
    args.add(tsconfig)
    actions.run(
        arguments = [args],
        executable = config.files_to_run.executable,
        tools = [config.files_to_run],
        outputs = [tsconfig],
    )

    # create package manifest
    package = create_package(
        id = runfile_path(workspace_name, output_),
        name = "",
        label = ctx.label,
        path = output_.path,
        short_path = output_.short_path,
    )
    package_deps = [
        create_dep(
            dep = ts_info.package.id,
            id = package.id,
            label = ctx.label,
            name = ts_info.name,
        )
        for ts_info in ts_proto.ts_deps
    ]
    transitive_deps = depset(package_deps, transitive = [dep.transitive_deps for dep in deps])
    transitive_packages = depset([package], transitive = [dep.transitive_packages for dep in deps])

    package_manifest = actions.declare_file("%s/package-manifest.json" % output_name)
    gen_manifest(
        actions = actions,
        manifest_bin = ctx.attr._manifest,
        manifest = package_manifest,
        packages = depset(
            transitive = [transitive_packages] + [ts_info.transitive_packages for ts_info in ts_proto.ts_deps],
        ),
        deps = depset(
            transitive = [transitive_deps] + [ts_info.transitive_deps for ts_info in ts_proto.ts_deps],
        ),
        globals = [],
        package_path = package_path,
    )

    # compile TS
    actions.run(
        arguments = ["-p", tsconfig.path],
        env = {
            "NODE_OPTIONS_APPEND": "-r ./%s" % fs_linker.path,
            "NODE_FS_PACKAGE_MANIFEST": package_manifest.path,
        },
        executable = compiler.bin.files_to_run.executable,
        inputs = depset(
            ts + [ctx.file._tsconfig, tsconfig, package_manifest, fs_linker],
            transitive =
                [ts_info.transitive_files for ts_info in deps + ts_proto.ts_deps],
        ),
        mnemonic = "TypescriptCompile",
        outputs = declarations + js + maps,
        tools = [compiler.bin.files_to_run],
    )

    # define TsProtoInfo
    lib = create_lib(
        declarations = declarations,
        deps = [dep.label for dep in ctx.rule.attr.deps],
        js = js,
        label = ctx.label,
        path = output_.path,
        runfile_path = runfile_path(workspace_name, output_),
        srcs = maps,
        js_deps = ts_proto.js_deps + compiler.js_deps,
        ts_deps = ts_proto.ts_deps + compiler.ts_deps,
    )
    transitive_libs = depset(
        [lib],
        order = "postorder",
        transitive = [ts_proto_info.transitive_libs for ts_proto_info in deps],
    )
    transitive_paths = depset(
        [lib.path],
        transitive = [ts_proto_info.transitive_paths for ts_proto_info in deps],
    )
    transitive_files = depset(
        declarations,
        transitive = [ts_proto_info.transitive_files for ts_proto_info in deps],
    )
    ts_proto_info = TsProtoInfo(
        transitive_deps = transitive_deps,
        transitive_libs = transitive_libs,
        transitive_paths = transitive_paths,
        transitive_files = transitive_files,
        transitive_packages = transitive_packages,
    )

    return [ts_proto_info]

def ts_proto_aspect(ts_protoc, src_prefix = "_", declaration_prefix = "_", js_prefix = "_"):
    """
    Create ts_proto aspect

    :param str|Label ts_protoc: TsProtobuf label
    :param str package_name: Package name
    """
    return aspect(
        implementation = _ts_proto_impl,
        attr_aspects = ["deps"],
        attrs = {
            "_config": attr.label(
                cfg = "exec",
                default = "@better_rules_javascript//typescript/config:bin",
                executable = True,
            ),
            "_manifest": attr.label(
                cfg = "exec",
                default = "@better_rules_javascript//commonjs/manifest:bin",
                executable = True,
            ),
            "_fs_linker": attr.label(
                allow_single_file = [".js"],
                default = "@better_rules_javascript//nodejs/fs-linker:file",
            ),
            "_src_prefix": attr.string(default = src_prefix),
            "_declaration_prefix": attr.string(default = declaration_prefix),
            "_js_prefix": attr.string(default = js_prefix),
            "_ts_protoc": attr.label(
                providers = [TsProtobuf],
                default = ts_protoc,
            ),
            "_tsconfig": attr.label(
                allow_single_file = [".json"],
                default = "@better_rules_javascript//ts-proto:tsconfig",
            ),
        },
        toolchains = ["@rules_proto_grpc//protobuf:toolchain_type"],
    )
