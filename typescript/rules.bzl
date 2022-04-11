load("@bazel_skylib//lib:paths.bzl", "paths")
load("@bazel_skylib//rules:common_settings.bzl", "BuildSettingInfo")
load("//commonjs:providers.bzl", "CjsInfo", "create_cjs_info", "gen_manifest", "package_path", "source_root")
load("//commonjs:rules.bzl", "cjs_root")
load("//javascript:providers.bzl", "JsInfo", "create_js_info")
load("//javascript:rules.bzl", "js_export")
load("//nodejs:rules.bzl", "nodejs_binary")
load("//util:path.bzl", "output", "output_name", "runfile_path")
load(":providers.bzl", "TsCompilerInfo", "TsInfo", "create_ts_info", "declaration_path", "is_declaration", "is_directory", "is_json", "js_path", "map_path", "module", "target")

def configure_ts_compiler(name, ts, tslib = None, visibility = None):
    """Configure TypeScript compiler.

    Args:
        name: Name to use for targets.
        ts: Typescript library.
        tslib: Tslib library.
        descriptors: List of package descriptors.
        visibility: Visibility.
    """

    nodejs_binary(
        main = "lib/tsc.js",
        name = "%s.bin" % name,
        node = "@better_rules_javascript//rules:nodejs",
        dep = ts,
        visibility = ["//visibility:private"],
    )

    js_export(
        name = "%s.lib" % name,
        dep = "@better_rules_javascript//typescript/js-compiler:dist_lib",
        deps = [
            ts,
            "@better_rules_javascript_npm//argparse:lib",
            "@better_rules_javascript_npm//long:lib",
            "@better_rules_javascript_npm//protobufjs:lib",
            "@better_rules_javascript_npm//tslib:lib",
        ],
    )

    nodejs_binary(
        name = "%s.js_bin" % name,
        main = "dist/bundle.js",
        node = "@better_rules_javascript//rules:nodejs",
        dep = ":%s.lib" % name,
        visibility = ["//visibility:private"],
    )

    ts_compiler(
        name = name,
        bin = "%s.bin" % name,
        runtime = tslib,
        transpile_bin = "%s.js_bin" % name,
        visibility = visibility,
    )

def _ts_compiler_impl(ctx):
    bin = ctx.attr.bin[DefaultInfo]
    cjs_runtime = ctx.attr.runtime and ctx.attr.runtime[CjsInfo]
    js_runtime = ctx.attr.runtime and ctx.attr.runtime[JsInfo]
    transpile_bin = ctx.attr.transpile_bin[DefaultInfo]

    ts_compiler_info = TsCompilerInfo(
        bin = bin,
        runtime_cjs = [cjs_runtime] if cjs_runtime else [],
        runtime_js = [js_runtime] if js_runtime else [],
        transpile_bin = transpile_bin,
    )

    return [ts_compiler_info]

ts_compiler = rule(
    implementation = _ts_compiler_impl,
    attrs = {
        "bin": attr.label(
            cfg = "exec",
            doc = "Declaration compiler executable.",
            executable = True,
            mandatory = True,
        ),
        "transpile_bin": attr.label(
            cfg = "exec",
            doc = "JS compiler executable.",
            executable = True,
            mandatory = True,
        ),
        "runtime": attr.label(
            doc = "Runtime library.",
            providers = [CjsInfo, JsInfo],
        ),
    },
)

def _ts_library_impl(ctx):
    actions = ctx.actions
    config = ctx.attr._config[DefaultInfo]
    compiler = ctx.attr.compiler[TsCompilerInfo]
    cjs_deps = compiler.runtime_cjs + [target[CjsInfo] for target in ctx.attr.deps]
    cjs_root = ctx.attr.root[CjsInfo]
    declaration_prefix = ctx.attr.declaration_prefix
    fs_linker_cjs = ctx.attr._fs_linker[CjsInfo]
    fs_linker_js = ctx.attr._fs_linker[JsInfo]
    js_deps = compiler.runtime_js + [dep[JsInfo] for dep in ctx.attr.deps if JsInfo in dep]
    js_prefix = ctx.attr.js_prefix
    label = ctx.label
    module_ = ctx.attr.module or module(ctx.attr._module[BuildSettingInfo].value)
    output_ = output(ctx.label, actions)
    source_map = ctx.attr._source_map[BuildSettingInfo].value
    src_prefix = ctx.attr.src_prefix
    srcs = ctx.files.srcs
    strip_prefix = ctx.attr.strip_prefix
    target_ = ctx.attr.target or target(ctx.attr._language[BuildSettingInfo].value)
    ts_deps = [target[TsInfo] for target in ctx.attr.compile_deps + ctx.attr.deps if TsInfo in target]
    tsconfig_js = ctx.attr.config_dep and ctx.attr.config_dep[JsInfo]
    tsconfig_path = ctx.attr.config
    tsconfig_dep = ctx.attr.config_dep[CjsInfo] if ctx.attr.config_dep else None
    workspace_name = ctx.workspace_name

    if tsconfig_path and not tsconfig_dep:
        fail("tsconfig attribute requires non-empty tsconfig_dep attribute")

    transpile_tsconfig = actions.declare_file("%s.js-tsconfig.json" % ctx.attr.name)
    args = actions.args()
    if tsconfig_path:
        args.add("--config", "%s/%s" % (tsconfig_dep.package.path, tsconfig_path))
    args.add("--empty", "true")
    args.add("--module", module_)
    args.add("--out-dir", "%s/%s" % (output_.path, js_prefix) if js_prefix else output_.path)
    args.add("--root-dir", "%s/%s" % (output_.path, src_prefix) if src_prefix else output_.path)
    args.add("--source-map", json.encode(source_map))
    args.add("--source-root", source_root(workspace_name, label))
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
        deps = ([tsconfig_dep] if tsconfig_dep else []) + compiler.runtime_cjs,
    )
    gen_manifest(
        actions = actions,
        deps = transpile_cjs_info.transitive_links,
        manifest = transpile_package_manifest,
        manifest_bin = ctx.attr._manifest[DefaultInfo],
        package_path = package_path,
        packages = transpile_cjs_info.transitive_packages,
    )

    declarations = []
    inputs = []
    js = []
    outputs = []
    for file in srcs:
        path = output_name(
            file = file,
            prefix = src_prefix,
            strip_prefix = strip_prefix,
            label = label,
        )
        if file.path == "%s/%s" % (output_.path, path):
            ts_ = file
        else:
            ts_ = actions.declare_file(path)
            actions.symlink(target_file = file, output = ts_)
        inputs.append(ts_)

        if is_declaration(path):
            continue

        js_path_ = output_name(
            file = file,
            label = label,
            prefix = js_prefix,
            strip_prefix = strip_prefix,
        )
        declaration_path_ = output_name(
            file = file,
            label = label,
            prefix = declaration_prefix,
            strip_prefix = strip_prefix,
        )
        if is_json(path):
            if path == js_path_:
                js_ = ts_
            else:
                js_ = actions.declare_file(js_path_)
                outputs.append(js_)
            js.append(js_)
            declarations.append(js_)
        else:
            js_outputs = []
            if is_directory(file.path):
                js_ = actions.declare_directory(js_path_)
                js.append(js_)
                js_outputs.append(js_)
                declaration = actions.declare_directory(declaration_path_)
                declarations.append(declaration)
                outputs.append(declaration)
            else:
                js_ = actions.declare_file(js_path(js_path_))
                js.append(js_)
                js_outputs.append(js_)
                if source_map:
                    map = actions.declare_file(map_path(js_path(js_path_)))
                    js.append(map)
                    js_outputs.append(map)
                declaration = actions.declare_file(declaration_path(declaration_path_))
                declarations.append(declaration)
                outputs.append(declaration)

            args = actions.args()
            args.add("--config", transpile_tsconfig)
            args.add("--manifest", transpile_package_manifest)
            args.add(ts_.path)
            args.set_param_file_format("multiline")
            args.use_param_file("@%s", use_always = True)
            actions.run(
                arguments = [args],
                executable = compiler.transpile_bin.files_to_run.executable,
                execution_requirements = {"supports-workers": "1"},
                inputs = depset(
                    [ts_, transpile_package_manifest, transpile_tsconfig],
                    transitive = [js_info.transitive_files for js_info in compiler.runtime_js] + [tsconfig_js.transitive_files] if tsconfig_js else [],
                ),
                progress_message = "Transpiling %s to JavaScript" % file.path,
                mnemonic = "TypeScriptTranspile",
                outputs = js_outputs,
                tools = [compiler.transpile_bin.files_to_run],
            )

    # compile declarations
    if outputs:
        # create tsconfig
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
            deps = ([tsconfig_dep] if tsconfig_dep else []) + compiler.runtime_cjs + cjs_deps,
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

        actions.run(
            arguments = ["-p", tsconfig.path],
            env = {
                "NODE_OPTIONS_APPEND": "-r ./%s/dist/bundle.js" % fs_linker_cjs.package.path,
                "NODE_FS_PACKAGE_MANIFEST": package_manifest.path,
            },
            executable = compiler.bin.files_to_run.executable,
            inputs = depset(
                [package_manifest, tsconfig] + inputs,
                transitive =
                    [cjs_root.transitive_files, fs_linker_js.transitive_files] +
                    ([tsconfig_js.transitive_files] if tsconfig_js else []) +
                    [js_info.transitive_files for js_info in compiler.runtime_js] +
                    [dep.transitive_files for dep in ts_deps],
            ),
            mnemonic = "TypeScriptCompile",
            progress_message = "Compiling %{label} TypeScript declarations",
            outputs = outputs,
            tools = [compiler.bin.files_to_run],
        )

    default_info = DefaultInfo(
        files = depset(js),
    )

    output_group_info = OutputGroupInfo(
        dts = depset(declarations),
        _validation = depset(declarations),
    )

    cjs_info = create_cjs_info(
        files = declarations + js,
        label = label,
        cjs_root = cjs_root,
        deps = cjs_deps,
    )

    js_info = create_js_info(
        cjs_root = cjs_root,
        deps = js_deps + compiler.runtime_js,
        files = js,
    )

    ts_info = create_ts_info(
        cjs_root = cjs_root,
        deps = ts_deps,
        files = declarations,
    )

    return [cjs_info, default_info, js_info, output_group_info, ts_info]

ts_library = rule(
    implementation = _ts_library_impl,
    attrs = {
        "compile_deps": attr.label_list(
            doc = "Dependecies provided only at compile-time",
            providers = [TsInfo],
        ),
        "compiler": attr.label(
            mandatory = True,
            providers = [TsCompilerInfo],
        ),
        "config": attr.string(
            doc = "Tsconfig path.",
        ),
        "config_dep": attr.label(
            doc = "Tsconfig dependency.",
            providers = [[CjsInfo, JsInfo]],
        ),
        "data": attr.label_list(
            allow_files = True,
            doc = "Runfile files. These are added to normal runfiles tree, not CommonJS packages.",
        ),
        "declaration_prefix": attr.string(
            doc = "Prefix to add to declaration files.",
        ),
        "deps": attr.label_list(
            doc = "JS and TS dependencies",
            providers = [[JsInfo], [TsInfo]],
        ),
        "module": attr.string(
            doc = "Module type. By default, uses //javascript:module.",
        ),
        "js_prefix": attr.string(
            doc = "Prefix to add to JavaScript files.",
        ),
        "root": attr.label(
            doc = "CommonJS package root.",
            mandatory = True,
            providers = [CjsInfo],
        ),
        "src_prefix": attr.string(
            doc = "Prefix to add to sources.",
        ),
        "srcs": attr.label_list(
            allow_files = True,
            doc = "TypeScript sources. If providing directories, the *_prefix attributes must be used to separate the outputs.",
        ),
        "strip_prefix": attr.string(
            doc = "Package-relative prefix to remove.",
        ),
        "target": attr.string(
            doc = "Target language. By default, uses //javascript:language.",
        ),
        "_config": attr.label(
            cfg = "exec",
            default = "//typescript/config:bin",
            executable = True,
        ),
        "_fs_linker": attr.label(
            providers = [JsInfo],
            cfg = "exec",
            default = "//nodejs/fs-linker:dist_lib",
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
        "_source_map": attr.label(
            default = "//javascript:source_map",
            providers = [BuildSettingInfo],
        ),
    },
    doc = "TypeScript library.",
)

def _ts_import_impl(ctx):
    actions = ctx.actions
    cjs_root = ctx.attr.root[CjsInfo]
    declaration_prefix = ctx.attr.declaration_prefix
    cjs_deps = [dep[CjsInfo] for dep in ctx.attr.deps]
    js_deps = [dep[JsInfo] for dep in ctx.attr.deps if JsInfo in dep]
    js_prefix = ctx.attr.js_prefix
    label = ctx.label
    output_ = output(label = ctx.label, actions = actions)
    strip_prefix = ctx.attr.strip_prefix
    ts_deps = [dep[TsInfo] for dep in ctx.attr.deps if TsInfo in dep]
    workspace_name = ctx.workspace_name

    declarations = []
    for file in ctx.files.declarations:
        path = output_name(
            file = file,
            prefix = declaration_prefix,
            strip_prefix = strip_prefix,
            label = label,
        )
        if file.path == "%s/%s" % (output_.path, path):
            declaration = file
        else:
            declaration = actions.declare_file(path)
            actions.symlink(
                target_file = file,
                output = declaration,
            )
        declarations.append(declaration)

    js = []
    for file in ctx.files.js:
        path = output_name(
            file = file,
            label = label,
            prefix = js_prefix,
            strip_prefix = strip_prefix,
        )
        if file.path == "%s/%s" % (output_.path, path):
            js_ = file
        else:
            js_ = actions.declare_file(path)
            actions.symlink(
                target_file = file,
                output = js_,
            )
        js.append(js_)

    default_info = DefaultInfo(
        files = depset(js),
    )

    cjs_info = create_cjs_info(
        cjs_root = cjs_root,
        deps = cjs_deps,
        files = declarations,
        label = label,
    )

    js_info = create_js_info(
        cjs_root = cjs_root,
        files = js,
        deps = js_deps,
    )

    ts_info = create_ts_info(
        cjs_root = cjs_root,
        files = declarations,
        deps = ts_deps,
    )

    return [cjs_info, default_info, js_info, ts_info]

ts_import = rule(
    implementation = _ts_import_impl,
    attrs = {
        "declaration_prefix": attr.string(
            doc = "Prefix to add to declaration files.",
        ),
        "declarations": attr.label_list(
            doc = "Typescript declarations",
            allow_files = True,
        ),
        "deps": attr.label_list(
            doc = "Dependencies",
            providers = [[CjsInfo, JsInfo], [CjsInfo, TsInfo]],
        ),
        "js": attr.label_list(
            doc = "JavaScript",
            allow_files = True,
        ),
        "js_prefix": attr.string(
            doc = "Prefix to add to JavaScript files.",
        ),
        "root": attr.label(
            doc = "CommonJS root",
            mandatory = True,
            providers = [CjsInfo],
        ),
        "strip_prefix": attr.string(
            doc = "Package-relative prefix to remove from files.",
        ),
    },
    doc = "TypeScript library with pre-existing declaration files.",
    provides = [CjsInfo, JsInfo, TsInfo],
)

def _ts_export_impl(ctx):
    cjs_dep = ctx.attr.dep[CjsInfo]
    cjs_deps = [target[CjsInfo] for target in ctx.attr.deps]
    cjs_extra = [target[CjsInfo] for target in ctx.attr.extra_deps]
    cjs_globals = [target[CjsInfo] for target in ctx.attr.global_deps]
    default_dep = ctx.attr.dep[DefaultInfo]
    package_name = ctx.attr.package_name
    js_dep = ctx.attr.dep[JsInfo] if JsInfo in ctx.attr.dep else None
    js_deps = [target[JsInfo] for target in ctx.attr.global_deps + ctx.attr.deps + ctx.attr.extra_deps if JsInfo in target]
    label = ctx.label
    ts_dep = ctx.attr.dep[TsInfo] if TsInfo in ctx.attr.dep else None
    ts_deps = [target[TsInfo] for target in ctx.attr.global_deps + ctx.attr.deps + ctx.attr.extra_deps if TsInfo in target]

    default_info = default_dep
    cjs_root = CjsInfo(
        name = package_name,
        package = cjs_dep.package,
        transitive_files = depset(),
        transitive_links = depset(),
        transitive_packages = depset(),
    )

    cjs_info = create_cjs_info(
        cjs_root = cjs_root,
        deps = cjs_deps,
        globals = cjs_globals,
        label = label,
    )
    cjs_info = CjsInfo(
        name = cjs_dep.name,
        package = cjs_info.package,
        transitive_files = depset(transitive = [c.transitive_files for c in [cjs_dep, cjs_info] + cjs_extra]),
        transitive_links = depset(transitive = [c.transitive_links for c in [cjs_dep, cjs_info] + cjs_extra]),
        transitive_packages = depset(transitive = [c.transitive_packages for c in [cjs_dep, cjs_info] + cjs_extra]),
    )

    js_info = create_js_info(
        cjs_root = cjs_root,
        deps = ([js_dep] if js_dep else []) + js_deps,
    )

    ts_info = create_ts_info(
        cjs_root = cjs_root,
        deps = ([ts_dep] if ts_dep else []) + ts_deps,
    )

    return [cjs_info, default_info, js_info, ts_info]

ts_export = rule(
    attrs = {
        "deps": attr.label_list(
            doc = "Dependencies to add.",
            providers = [[CjsInfo, JsInfo], [CjsInfo, TsInfo]],
        ),
        "extra_deps": attr.label_list(
            doc = "Extra dependencies to add.",
            providers = [[CjsInfo, JsInfo], [CjsInfo, TsInfo]],
        ),
        "global_deps": attr.label_list(
            doc = "Global dependencies to add.",
            providers = [[CjsInfo, JsInfo], [CjsInfo, TsInfo]],
        ),
        "package_name": attr.string(
            doc = "Dependency name. Defaults to root's name.",
        ),
        "dep": attr.label(
            doc = "JavaScript library.",
            mandatory = True,
            providers = [[CjsInfo, JsInfo], [CjsInfo, TsInfo]],
        ),
    },
    doc = "Add dependencies, or use alias.",
    implementation = _ts_export_impl,
    provides = [CjsInfo, JsInfo, TsInfo],
)
