load("@bazel_skylib//rules:common_settings.bzl", "BuildSettingInfo")
load("@rules_proto//proto:defs.bzl", "ProtoInfo")
load("//commonjs:providers.bzl", "CjsInfo", "create_cjs_info", "create_package", "gen_manifest", "package_path")
load("//javascript:providers.bzl", "JsInfo")
load("//typescript:providers.bzl", "TsInfo", "declaration_path", "js_path", "map_path", "module")
load("//util:path.bzl", "output")
load(":providers.bzl", "TsProtoInfo", "TsProtobuf", "create_lib")

def _ts_proto_impl(target, ctx):
    actions = ctx.actions
    proto = target[ProtoInfo]
    protoc = ctx.toolchains["@rules_proto_grpc//protobuf:toolchain_type"]
    config = ctx.attr._config[DefaultInfo]
    ts_proto = ctx.attr._ts_protoc[TsProtobuf]
    label = ctx.label
    deps = [dep[TsProtoInfo] for dep in ctx.rule.attr.deps]
    module_ = module(ctx.attr._module[BuildSettingInfo].value)
    compiler = ts_proto.compiler
    fs_linker = ctx.file._fs_linker
    output_name = "%s.ts_proto" % target.label.name
    output_ = output(ctx.label, actions, output_name)
    workspace_name = ctx.workspace_name
    root = "%s/root" % output_.path

    # declare files
    ts = []
    declarations = []
    js = []
    protos = []
    for file in proto.direct_sources:
        path = file.path
        if proto.proto_source_root and proto.proto_source_root != ".":
            path = path[len("%s/" % proto.proto_source_root):]
        protos.append(path)
        name = path.replace(".proto", ".ts")
        ts_ = actions.declare_file("%s/root/%s" % (output_name, name))
        ts.append(ts_)
        declaration = actions.declare_file("%s/root/%s" % (output_name, declaration_path(name)))
        declarations.append(declaration)
        js_ = actions.declare_file("%s/root/%s" % (output_name, js_path(name)))
        js.append(js_)
        map = actions.declare_file("%s/root/%s" % (output_name, map_path(js_path(name))))
        js.append(map)

    # generate TS
    args = actions.args()
    args.add(protoc.protoc_executable)
    args.add(ts_proto.bin.executable)
    args.add("%s/root" % output_.path)
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

    transitive_paths = depset([root], transitive = [dep.transitive_paths for dep in deps])

    # create tsconfig
    tsconfig = actions.declare_file("%s/tsconfig.json" % output_name)
    args = actions.args()
    args.add("--config", ctx.file._tsconfig)
    args.add("--declaration-dir", root)
    args.add("--module", module_)
    args.add("--out-dir", root)
    args.add("--root-dir", root)
    args.add_all(transitive_paths, before_each = "--root-dirs")
    args.add(tsconfig)
    actions.run(
        arguments = [args],
        executable = config.files_to_run.executable,
        tools = [config.files_to_run],
        outputs = [tsconfig],
    )

    # create package manifest
    package = create_package(
        name = "_",
        path = root,
        short_path = "",
        label = label,
    )
    cjs_info = create_cjs_info(
        cjs_root = struct(package = package, name = package.name),
        label = ctx.label,
        deps = ts_proto.cjs_deps + compiler.runtime_cjs,
    )
    package_manifest = actions.declare_file("%s/package-manifest.json" % output_name)
    gen_manifest(
        actions = actions,
        manifest_bin = ctx.attr._manifest,
        manifest = package_manifest,
        packages = cjs_info.transitive_packages,
        deps = cjs_info.transitive_links,
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
        outputs = declarations + js,
        tools = [compiler.bin.files_to_run],
    )

    # providers
    lib = create_lib(
        declarations = declarations,
        deps = [dep.label for dep in ctx.rule.attr.deps],
        js = js,
        label = ctx.label,
        path = "%s/root" % output_.path,
    )
    transitive_files = depset(
        declarations + js,
        transitive = [ts_proto_info.transitive_paths for ts_proto_info in deps],
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
    ts_proto_info = TsProtoInfo(
        transitive_files = transitive_files,
        transitive_libs = transitive_libs,
        transitive_paths = transitive_paths,
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
            "_module": attr.label(
                default = "//javascript:module",
                providers = [BuildSettingInfo],
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
        provides = [TsProtoInfo],
        toolchains = ["@rules_proto_grpc//protobuf:toolchain_type"],
    )
