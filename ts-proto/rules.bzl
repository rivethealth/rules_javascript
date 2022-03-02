load("@bazel_skylib//rules:common_settings.bzl", "BuildSettingInfo")
load("//commonjs:providers.bzl", "CjsInfo", "CjsRootInfo", "create_cjs_info", "gen_manifest", "package_path")
load("//javascript:providers.bzl", "JsInfo", "create_js_info")
load("//nodejs:rules.bzl", "nodejs_binary")
load("//typescript:providers.bzl", "TsCompilerInfo", "TsInfo", "create_ts_info", "declaration_path", "js_path", "map_path", "module", "target")
load("//util:path.bzl", "output", "output_name", "runfile_path")
load(":aspects.bzl", _ts_proto_aspect = "ts_proto_aspect")
load(":providers.bzl", "TsProtoInfo", "TsProtobuf", "TsProtosInfo")

def _ts_protoc_impl(ctx):
    bin = ctx.attr.bin[DefaultInfo]
    tsc = ctx.attr.tsc[TsCompilerInfo]
    deps_cjs = [target[CjsInfo] for target in ctx.attr.deps]
    deps_js = [dep[JsInfo] for dep in ctx.attr.deps if JsInfo in dep]
    deps_ts = [dep[TsInfo] for dep in ctx.attr.deps if TsInfo in dep]
    options = ctx.attr.options

    ts_protobuf = TsProtobuf(
        bin = bin.files_to_run,
        tsc = tsc,
        deps_cjs = deps_cjs,
        deps_js = deps_js,
        deps_ts = deps_ts,
        options = options,
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
        "tsc": attr.label(
            doc = "TypeScript compiler",
            mandatory = True,
            providers = [TsCompilerInfo],
        ),
        "deps": attr.label_list(
            doc = "Dependencies",
            mandatory = True,
            providers = [[CjsInfo, JsInfo], [CjsInfo, TsInfo]],
        ),
        "options": attr.string_list(),
    },
)

def configure_ts_protoc(name, tsc, ts_proto, deps, options = [], visibility = None):
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
        tsc = tsc,
        deps = deps,
        name = name,
        options = options,
        visibility = visibility,
    )

def _ts_proto_libraries_impl(ctx):
    actions = ctx.actions
    cjs_root = ctx.attr.root[CjsRootInfo]
    declaration_prefix = ctx.attr.declaration_prefix
    fs_linker_cjs = ctx.attr._fs_linker[CjsInfo]
    fs_linker_js = ctx.attr._fs_linker[JsInfo]
    js_prefix = ctx.attr.js_prefix
    config = ctx.attr._config[DefaultInfo]
    label = ctx.label
    manifest_bin = ctx.attr._manifest[DefaultInfo]
    module_ = ctx.attr.module or module(ctx.attr._module[BuildSettingInfo].value)
    output_ = output(ctx.label, actions)
    prefix = ctx.attr.prefix
    src_prefix = ctx.attr.src_prefix
    ts_proto = ctx.attr._ts_protoc[TsProtobuf]
    tsconfig_dep = ctx.attr.config_dep[CjsInfo] if ctx.attr.config_dep else None
    tsconfig_js = ctx.attr.config_dep and ctx.attr.config_dep[JsInfo]
    tsconfig_path = ctx.attr.config
    workspace_name = ctx.workspace_name
    target_ = ctx.attr.target or target(ctx.attr._language[BuildSettingInfo].value)

    if tsconfig_path and not tsconfig_dep:
        fail("tsconfig attribute requires non-empty tsconfig_dep attribute")

    # transpile to JS
    transpile_tsconfig = actions.declare_file("%s.js-tsconfig.json" % ctx.attr.name)
    args = actions.args()
    if tsconfig_path:
        args.add("--config", "%s/%s" % (tsconfig_dep.package.path, tsconfig_path))
    args.add("--module", module_)
    args.add("--out-dir", "%s/%s" % (output_.path, js_prefix) if js_prefix else output_.path)
    args.add("--root-dir", "%s/%s" % (output_.path, src_prefix) if src_prefix else output_.path)
    args.add("--target", target_)
    args.add(transpile_tsconfig)
    actions.run(
        arguments = [args],
        executable = config.files_to_run.executable,
        tools = [config.files_to_run],
        outputs = [transpile_tsconfig],
    )

    transpile_package_manifest = actions.declare_file("%s.js-package-manifest.json" % ctx.attr.name)
    transpile_cjs_info = create_cjs_info(
        cjs_root = cjs_root,
        label = label,
        deps = ([tsconfig_dep] if tsconfig_dep else []) + ts_proto.tsc.runtime_cjs,
    )
    gen_manifest(
        actions = actions,
        deps = transpile_cjs_info.transitive_links,
        manifest = transpile_package_manifest,
        manifest_bin = manifest_bin,
        package_path = package_path,
        packages = transpile_cjs_info.transitive_packages,
    )

    # compile to DTS
    tsconfig = actions.declare_file("%s.tsconfig.json" % ctx.attr.name)
    args = actions.args()
    if tsconfig_path:
        args.add("--config", "%s/%s" % (tsconfig_dep.package.path, tsconfig_path))
    args.add("--declaration-dir", "%s/%s" % (output_.path, declaration_prefix) if declaration_prefix else output_.path)
    args.add("--module", module_)
    args.add("--root-dir", "%s/%s" % (output_.path, src_prefix) if src_prefix else output_.path)
    args.add("--target", target_)
    args.add("--type-root", "%s/node_modules/@types" % cjs_root.package.path)
    args.add(tsconfig)
    actions.run(
        arguments = [args],
        executable = config.files_to_run.executable,
        tools = [config.files_to_run],
        outputs = [tsconfig],
    )

    package_manifest = actions.declare_file("%s.package-manifest.json" % ctx.attr.name)
    compile_cjs_info = create_cjs_info(
        cjs_root = cjs_root,
        deps = ([tsconfig_dep] if tsconfig_dep else []) + ts_proto.tsc.runtime_cjs + ts_proto.deps_cjs,
        label = label,
    )
    gen_manifest(
        actions = actions,
        deps = compile_cjs_info.transitive_links,
        manifest = package_manifest,
        manifest_bin = ctx.attr._manifest[DefaultInfo],
        package_path = package_path,
        packages = compile_cjs_info.transitive_packages,
    )

    libs = depset(
        order = "postorder",
        transitive = [dep[TsProtoInfo].transitive_libs for dep in ctx.attr.deps],
    )

    js_infos = {}
    ts_infos = {}
    default_infos = {}
    for lib in libs.to_list():
        js = []
        ts = []
        declarations = []
        for file in lib.files:
            path = file.path[len(lib.path + "/"):]
            if src_prefix:
                path = "%s/%s" % (src_prefix, path)
            ts_ = actions.declare_file(path)
            actions.symlink(target_file = file, output = ts_)
            ts.append(ts_)

            path = file.path[len(lib.path + "/"):]
            if js_prefix:
                path = "%s/%s" % (js_prefix, path)
            js_ = actions.declare_file(js_path(path))
            js.append(js_)
            map = actions.declare_file(map_path(js_path(path)))
            js.append(map)

            path = file.path[len(lib.path + "/"):]
            if declaration_prefix:
                path = "%s/%s" % (declaration_prefix, path)
            declaration = actions.declare_file(declaration_path(path))
            declarations.append(declaration)

            args = actions.args()
            args.add("--config", transpile_tsconfig)
            args.add("--manifest", transpile_package_manifest)
            args.add(ts_.path)
            args.set_param_file_format("multiline")
            args.use_param_file("@%s", use_always = True)
            actions.run(
                arguments = [args],
                executable = ts_proto.tsc.transpile_bin.files_to_run.executable,
                execution_requirements = {"supports-workers": "1"},
                inputs = depset(
                    [ts_, transpile_package_manifest, transpile_tsconfig],
                    transitive = [tsconfig_js.transitive_files] if tsconfig_js else [],
                ),
                progress_message = "Transpiling %s to JavaScript" % file.path,
                mnemonic = "TypeScriptTranspile",
                outputs = [js_, map],
                tools = [ts_proto.tsc.transpile_bin.files_to_run],
            )

            actions.run(
                arguments = ["-p", tsconfig.path],
                env = {
                    "NODE_OPTIONS_APPEND": "-r ./%s/dist/bundle.js" % fs_linker_cjs.package.path,
                    "NODE_FS_PACKAGE_MANIFEST": package_manifest.path,
                },
                executable = ts_proto.tsc.bin.files_to_run.executable,
                inputs = depset(
                    [package_manifest, tsconfig] + cjs_root.descriptors + ts,
                    transitive =
                        [fs_linker_js.transitive_files] +
                        ([tsconfig_js.transitive_files] if tsconfig_js else []) +
                        [dep.transitive_files for dep in ts_proto.deps_ts],
                ),
                mnemonic = "TypeScriptCompile",
                progress_message = "Compiling %{label} TypeScript declarations",
                outputs = declarations,
                tools = [ts_proto.tsc.bin.files_to_run],
            )

        js_infos[lib.label] = create_js_info(
            files = js,
            deps = ts_proto.deps_js + [js_infos[label] for label in lib.deps],
        )

        ts_infos[lib.label] = create_ts_info(
            files = declarations,
            deps = ts_proto.deps_ts + [ts_infos[label] for label in lib.deps],
        )

        default_infos[lib.label] = DefaultInfo(
            files = depset(js),
        )

    default_info = DefaultInfo(files = depset(transitive = [default_info.files for default_info in default_infos.values()]))

    cjs_info = create_cjs_info(
        cjs_root = cjs_root,
        label = label,
        deps = ts_proto.deps_cjs + ts_proto.tsc.runtime_cjs,
    )

    ts_protos_info = TsProtosInfo(
        cjs = cjs_info,
        default = default_infos,
        js = js_infos,
        ts = ts_infos,
    )

    return [cjs_info, default_info, ts_protos_info]

def ts_proto_libraries_rule(aspect, compiler):
    return rule(
        implementation = _ts_proto_libraries_impl,
        attrs = {
            "_ts_protoc": attr.label(
                default = compiler,
                providers = [TsProtobuf],
            ),
            "config": attr.string(
                doc = "Tsconfig path.",
            ),
            "config_dep": attr.label(
                doc = "Tsconfig dependency.",
                providers = [[CjsInfo, JsInfo]],
            ),
            "deps": attr.label_list(
                providers = [ProtoInfo],
                aspects = [aspect],
            ),
            "module": attr.string(
            ),
            "prefix": attr.string(
                doc = "Prefix to add.",
            ),
            "src_prefix": attr.string(),
            "declaration_prefix": attr.string(),
            "js_prefix": attr.string(),
            "root": attr.label(
                providers = [CjsRootInfo],
            ),
            "target": attr.string(),
            "_config": attr.label(
                cfg = "exec",
                default = "//typescript/config:bin",
                executable = True,
            ),
            "_fs_linker": attr.label(
                cfg = "exec",
                default = "//nodejs/fs-linker:dist_lib",
                providers = [CjsInfo, JsInfo],
            ),
            "_language": attr.label(
                default = "//javascript:language",
                providers = [BuildSettingInfo],
            ),
            "_manifest": attr.label(
                cfg = "exec",
                default = "//commonjs/manifest:bin",
                executable = True,
            ),
            "_module": attr.label(
                default = "//javascript:module",
                providers = [BuildSettingInfo],
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
