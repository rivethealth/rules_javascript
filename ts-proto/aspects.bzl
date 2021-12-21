load("@better_rules_javascript//commonjs:providers.bzl", "CjsInfo", "create_dep", "create_package", "gen_manifest", "package_path")
load("@better_rules_javascript//javascript:providers.bzl", "JsInfo")
load("@better_rules_javascript//util:path.bzl", "output")
load("@rules_proto//proto:defs.bzl", "ProtoInfo")
load("//typescript:providers.bzl", "TsInfo")
load("//typescript:rules.bzl", "compiled_path", "declaration_path", "map_path")
load(":providers.bzl", "TsProtoInfo", "TsProtobuf", "create_lib")

def _ts_proto_impl(target, ctx):
    proto = target[ProtoInfo]
    protoc = ctx.toolchains["@rules_proto_grpc//protobuf:toolchain_type"]
    config = ctx.attr._config[DefaultInfo]
    ts_proto = ctx.attr._ts_protoc[TsProtobuf]
    deps = [dep[TsProtoInfo] for dep in ctx.rule.attr.deps]
    compiler = ts_proto.compiler

    output_name = "%s/ts_proto" % target.label.name
    output_ = output(ctx.label, ctx.actions, output_name)

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
        ts_ = ctx.actions.declare_file("%s/ts/%s" % (output_name, name))
        ts.append(ts_)
        declaration = ctx.actions.declare_file("%s/js/%s" % (output_name, declaration_path(name)))
        declarations.append(declaration)
        js_ = ctx.actions.declare_file("%s/js/%s" % (output_name, compiled_path(name)))
        js.append(js_)
        map = ctx.actions.declare_file("%s/js/%s" % (output_name, map_path(compiled_path(name))))
        maps.append(map)

    # generate TS
    args = ctx.actions.args()
    args.add(protoc.protoc_executable)
    args.add(ts_proto.bin.executable)
    args.add("%s/ts" % output_.path)
    args.add_joined(
        proto.transitive_descriptor_sets,
        join_with = ctx.configuration.host_path_separator,
        format_joined = "--descriptor_set_in=%s",
    )
    ctx.actions.run_shell(
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

    # create package manifest
    package_id = str(ctx.label)
    package = create_package(
        id = package_id,
        label = ctx.label,
        path = output_.path,
        short_path = output_.short_path,
    )
    package_deps = [
        create_dep(
            dep = ts_info.package.id,
            id = package_id,
            label = ctx.label,
            name = ts_info.name,
        )
        for ts_info in ts_proto.ts_deps
    ]
    transitive_deps = depset(package_deps, transitive = [dep.transitive_deps for dep in deps])
    transitive_packages = depset([package], transitive = [dep.transitive_packages for dep in deps])

    package_manifest = ctx.actions.declare_file("%s/package-manifest.json" % output_name)
    gen_manifest(
        actions = ctx.actions,
        manifest_bin = ctx.attr._manifest,
        manifest = package_manifest,
        packages = depset(
            transitive = [transitive_packages] + [ts_info.transitive_packages for ts_info in ts_proto.ts_deps],
        ),
        deps = transitive_deps,
        globals = [],
        package_path = package_path,
    )

    # create tsconfig
    tsconfig = ctx.actions.declare_file("%s/tsconfig.json" % output_name)
    args = ctx.actions.args()
    args.add("--config", ctx.file._tsconfig)
    args.add("--import-helpers", "false")
    args.add("--out-dir", "%s/js" % output_.path)
    args.add("--root-dir", "%s/ts" % output_.path)
    args.add_all(
        depset(["%s/ts" % output_.path], transitive = [dep.transitive_paths for dep in deps]),
        before_each = "--root-dirs",
    )
    args.add(tsconfig)
    args.add_all(ts)
    ctx.actions.run(
        arguments = [args],
        inputs = [ctx.file._tsconfig],
        executable = config.files_to_run.executable,
        tools = [config.files_to_run],
        outputs = [tsconfig],
    )

    # compile TS
    ctx.actions.run(
        arguments = ["-p", tsconfig.path],
        env = {
            "NODE_OPTIONS_APPEND": "-r ./%s" % ctx.file._fs_linker.path,
            "NODE_FS_PACKAGE_MANIFEST": package_manifest.path,
        },
        executable = compiler.bin.files_to_run.executable,
        inputs = depset(
            ts + [ctx.file._tsconfig, tsconfig, package_manifest, ctx.file._fs_linker],
            transitive =
                [ts_info.transitive_descriptors for ts_info in ts_proto.ts_deps] +
                [ts_info.transitive_declarations for ts_info in deps + ts_proto.ts_deps],
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
        path = "%s/js" % output_.path,
        srcs = maps,
        js_deps = ts_proto.js_deps,
        ts_deps = ts_proto.ts_deps,
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
    transitive_declarations = depset(
        declarations,
        transitive = [ts_proto_info.transitive_declarations for ts_proto_info in deps],
    )
    ts_proto_info = TsProtoInfo(
        transitive_deps = transitive_deps,
        transitive_libs = transitive_libs,
        transitive_paths = transitive_paths,
        transitive_declarations = transitive_declarations,
        transitive_packages = transitive_packages,
    )

    return [ts_proto_info]

def ts_proto_aspect(ts_protoc):
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
