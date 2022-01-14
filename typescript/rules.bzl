load("@bazel_skylib//lib:paths.bzl", "paths")
load("//commonjs:providers.bzl", "CjsEntries", "CjsInfo", "create_dep", "create_global", "create_package", "default_strip_prefix", "gen_manifest", "output_name", "output_root", "package_path")
load("//commonjs:rules.bzl", "cjs_root")
load("//nodejs:rules.bzl", "nodejs_binary")
load("//javascript:providers.bzl", "JsInfo", js_create_deps = "create_deps", js_create_extra_deps = "create_extra_deps", js_target_deps = "target_deps")
load("//util:path.bzl", "output", "runfile_path")
load(":providers.bzl", "SimpleTsCompilerInfo", "TsCompilerInfo", "TsInfo", "TsconfigInfo", "create_deps", "create_extra_deps", "declaration_path", "is_declaration", "is_directory", "is_json", "js_path", "map_path", "target_deps", "target_globals")

def configure_ts_simple_compiler(name, ts, tslib = None, visibility = None):
    nodejs_binary(
        main = "lib/tsc.js",
        name = "%s_bin" % name,
        dep = ts,
        visibility = ["//visibility:private"],
    )

    ts_simple_compiler(
        name = name,
        bin = "%s_bin" % name,
        tslib = tslib,
        visibility = visibility,
    )

def _ts_simple_compiler_impl(ctx):
    tslib_js = ctx.attr.tslib[JsInfo] if ctx.attr.tslib else None
    tslib_ts = ctx.attr.tslib[TsInfo] if ctx.attr.tslib else None

    compiler_info = SimpleTsCompilerInfo(
        bin = ctx.attr.bin[DefaultInfo],
        js_deps = [tslib_js] if tslib_js else [],
        ts_deps = [tslib_ts] if tslib_ts else [],
    )

    return [compiler_info]

ts_simple_compiler = rule(
    attrs = {
        "bin": attr.label(
            executable = True,
            cfg = "exec",
        ),
        "tslib": attr.label(
            providers = [[JsInfo], [TsInfo]],
        ),
    },
    implementation = _ts_simple_compiler_impl,
)

def _ts_simple_library_impl(ctx):
    actions = ctx.actions
    cjs_info = ctx.attr.root[CjsInfo]
    compiler = ctx.attr.compiler[SimpleTsCompilerInfo]
    declaration_prefix = ctx.attr.declaration_prefix
    fs_linker = ctx.file._fs_linker
    js_deps = compiler.js_deps + [dep[JsInfo] for dep in ctx.attr.deps if JsInfo in dep]
    js_prefix = ctx.attr.js_prefix
    output_ = output(ctx.label, actions)
    src_prefix = ctx.attr.src_prefix
    srcs = ctx.files.srcs
    strip_prefix = ctx.attr.strip_prefix or default_strip_prefix(ctx)
    ts_deps = compiler.ts_deps + [dep[TsInfo] for dep in ctx.attr.deps if TsInfo in dep]
    workspace_name = ctx.workspace_name

    declarations = []
    inputs = []
    js = []
    outputs = []
    js_srcs = []
    for file in ctx.files.srcs:
        path = output_name(
            file = file,
            package_output = output_,
            prefix = src_prefix,
            root = cjs_info.package,
            strip_prefix = strip_prefix,
            workspace_name = workspace_name,
        )
        if file.path == "%s/%s" % (output_.path, path):
            ts_ = file
        else:
            ts_ = actions.declare_file(path)
            actions.symlink(
                target_file = file,
                output = ts_,
            )
        inputs.append(ts_)
        js_srcs.append(ts_)
        if not is_declaration(path):
            js_path_ = output_name(
                file = file,
                package_output = output_,
                prefix = js_prefix,
                root = cjs_info.package,
                strip_prefix = strip_prefix,
                workspace_name = workspace_name,
            )
            declaration_path_ = output_name(
                file = file,
                package_output = output_,
                prefix = declaration_prefix,
                root = cjs_info.package,
                strip_prefix = strip_prefix,
                workspace_name = workspace_name,
            )
            if is_directory(path):
                js_ = actions.declare_directory(js_path_)
                js.append(js_)
                outputs.append(js_)
                declaration = actions.declare_directory(declaration_path_)
                declarations.append(declaration)
                outputs.append(declaration)
            elif is_json(path):
                if path == js_path_:
                    js_ = ts_
                else:
                    js_ = actions.declare_file(js_path_)
                    outputs.append(js_)
                js.append(js_)
                declarations.append(js_)
            else:
                js_ = actions.declare_file(js_path(js_path_))
                js.append(js_)
                outputs.append(js_)
                map = actions.declare_file(map_path(js_path(js_path_)))
                js_srcs.append(map)
                outputs.append(map)
                declaration = actions.declare_file(declaration_path(declaration_path_))
                declarations.append(declaration)
                outputs.append(declaration)

    transitive_deps = depset(
        target_deps(cjs_info.package, ctx.attr.deps),
        transitive = [ts_info.transitive_deps for ts_info in ts_deps],
    )
    transitive_packages = depset(
        [cjs_info.package],
        transitive =
            [ts_info.transitive_packages for ts_info in ts_deps],
    )

    package_manifest = actions.declare_file("%s/package-manifest.json" % ctx.attr.name)
    gen_manifest(
        actions = actions,
        manifest_bin = ctx.attr._manifest[DefaultInfo],
        manifest = package_manifest,
        packages = transitive_packages,
        deps = transitive_deps,
        globals = [],
        package_path = package_path,
    )

    if outputs:
        js_root = output_root(
            root = cjs_info.package,
            package_output = output_,
            prefix = js_prefix,
        )
        src_root = output_root(
            root = cjs_info.package,
            package_output = output_,
            prefix = src_prefix,
        )
        declaration_root = output_root(
            root = cjs_info.package,
            package_output = output_,
            prefix = declaration_prefix,
        )

        args = actions.args()
        args.add("--pretty")
        args.add("--declaration", "true")
        args.add("--declarationDir", declaration_root)
        args.add("--rootDir", src_root)
        args.add("--sourceMap", "true")
        args.add("--typeRoots", "%s/node_modules/@types" % cjs_info.package.path)
        args.add("--outDir", js_root)
        args.add_all(ctx.attr.compiler_options)
        args.add_all(inputs)

        actions.run(
            arguments = [args],
            env = {
                "NODE_OPTIONS_APPEND": "-r ./%s" % fs_linker.path,
                "NODE_FS_PACKAGE_MANIFEST": package_manifest.path,
            },
            executable = compiler.bin.files_to_run.executable,
            inputs = depset(
                [package_manifest, fs_linker] + cjs_info.descriptors + inputs,
                transitive = [ts_info.transitive_files for ts_info in ts_deps],
            ),
            mnemonic = "TypescriptCompile",
            outputs = outputs,
            tools = [compiler.bin.files_to_run],
        )

    ts_info = TsInfo(
        name = cjs_info.name,
        package = cjs_info.package,
        transitive_deps = transitive_deps,
        transitive_files = depset(
            cjs_info.descriptors + declarations,
            transitive = [dep.transitive_files for dep in ts_deps],
        ),
        transitive_packages = transitive_packages,
        transitive_srcs = depset(
            transitive = [dep.transitive_srcs for dep in ts_deps],
        ),
    )

    js_info = JsInfo(
        name = cjs_info.name,
        package = cjs_info.package,
        transitive_deps = depset(
            js_target_deps(cjs_info.package, ctx.attr.deps) + js_create_deps(cjs_info.package, ctx.attr.compiler.label, compiler.js_deps),
            transitive = [js_info.transitive_deps for js_info in js_deps],
        ),
        transitive_files = depset(
            cjs_info.descriptors + js,
            transitive = [js_info.transitive_files for js_info in js_deps],
        ),
        transitive_packages = depset(
            [cjs_info.package],
            transitive =
                [js_info.transitive_packages for js_info in js_deps],
        ),
        transitive_srcs = depset(
            js_srcs,
            transitive = [js_info.transitive_srcs for js_info in js_deps],
        ),
    )

    default_info = DefaultInfo(
        files = depset(declarations + js),
    )

    cjs_entries = CjsEntries(
        name = cjs_info.name,
        package = cjs_info.package,
        transitive_deps = depset(transitive = [js_info.transitive_deps, ts_info.transitive_deps]),
        transitive_packages = depset(transitive = [js_info.transitive_packages, ts_info.transitive_packages]),
        transitive_files = depset(transitive = [js_info.transitive_files, ts_info.transitive_files]),
    )

    return [default_info, cjs_entries, js_info, ts_info]

ts_simple_library = rule(
    implementation = _ts_simple_library_impl,
    attrs = {
        "srcs": attr.label_list(
            allow_files = True,
            doc = "TypeScript sources",
        ),
        "compiler_options": attr.string_list(
            doc = "Compiler CLI options",
        ),
        "deps": attr.label_list(
            doc = "Dependencies",
            providers = [[JsInfo], [TsInfo]],
        ),
        "root": attr.label(
            doc = "CommonJS root.",
            mandatory = True,
            providers = [CjsInfo],
        ),
        "strip_prefix": attr.string(
            doc = "Strip prefix",
        ),
        "declaration_prefix": attr.string(),
        "src_prefix": attr.string(),
        "js_prefix": attr.string(
            doc = "Prefix",
        ),
        "compiler": attr.label(
            mandatory = True,
            providers = [SimpleTsCompilerInfo],
        ),
        "_fs_linker": attr.label(
            allow_single_file = True,
            default = "@better_rules_javascript//nodejs/fs-linker:file",
        ),
        "_manifest": attr.label(
            cfg = "exec",
            executable = True,
            default = "@better_rules_javascript//commonjs/manifest:bin",
        ),
    },
)

def configure_ts_compiler(name, ts, tslib = None, visibility = None):
    """Configure TypeScript compiler.

    Args:
        name: Name to use for targets.
        ts: Typescript library.
        tslib: Tslib library. If set, importHelpers is true.
        descriptors: List of package descriptors.
        visibility: Visibility.
    """

    cjs_root(
        name = "%s.root" % name,
        package_name = "@better-rules-javascript/typescript",
        descriptors = ["@better_rules_javascript//typescript/js-compiler:descriptors"],
        sealed = True,
        strip_prefix = "better_rules_javascript/typescript/js-compiler",
        visibility = ["//visibility:private"],
    )

    ts_simple_library(
        name = "%s.js_lib" % name,
        srcs = ["@better_rules_javascript//typescript/js-compiler:src"],
        compiler = "@better_rules_javascript//rules:simple_tsc",
        root = ":%s.root" % name,
        compiler_options = ["--esModuleInterop", "--lib", "dom,es2019", "--module", "commonjs", "--target", "es2019", "--types", "node"],
        strip_prefix = "better_rules_javascript/typescript/js-compiler",
        deps = [
            ts,
            "@better_rules_javascript//commonjs/package:lib",
            "@better_rules_javascript//nodejs/fs-linker:lib",
            "@better_rules_javascript//bazel/worker:lib",
            "@better_rules_javascript_npm//argparse:lib",
            "@better_rules_javascript_npm//@types/argparse:lib",
            "@better_rules_javascript_npm//@types/node:lib",
        ],
        visibility = ["//visibility:private"],
    )

    nodejs_binary(
        main = "lib/tsc.js",
        name = "%s.bin" % name,
        dep = ts,
        visibility = ["//visibility:private"],
    )

    nodejs_binary(
        main = "src/main.js",
        name = "%s.js_bin" % name,
        dep = ":%s.js_lib" % name,
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
    ts_compiler_info = TsCompilerInfo(
        bin = ctx.attr.bin[DefaultInfo],
        transpile_bin = ctx.attr.transpile_bin[DefaultInfo],
        js_deps = [ctx.attr.runtime[JsInfo]] if ctx.attr.runtime else [],
        ts_deps = [ctx.attr.runtime[TsInfo]] if ctx.attr.runtime else [],
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
            doc = "Runtime library. If set, importHelpers will be used.",
            providers = [JsInfo],
        ),
    },
)

def _tsconfig_impl(ctx):
    actions = ctx.actions
    cjs_info = ctx.attr.root[CjsInfo]
    deps = [ctx.attr.dep[TsconfigInfo]] if ctx.attr.dep else []
    src = ctx.file.src
    output_ = output(label = ctx.label, actions = actions)
    if ctx.attr.path:
        strip_prefix = runfile_path(ctx.workspace_name, ctx.file.src)
        prefix = ctx.attr.path
    else:
        strip_prefix = default_strip_prefix(ctx)
        prefix = ""
    workspace_name = ctx.workspace_name

    tsconfig_name = output_name(
        file = src,
        package_output = output_,
        prefix = prefix,
        root = cjs_info.package,
        strip_prefix = strip_prefix,
        workspace_name = workspace_name,
    )

    if src.path == "%s/%s" % (output_.path, tsconfig_name):
        tsconfig = src
    else:
        tsconfig = actions.declare_file(tsconfig_name)
        actions.symlink(target_file = src, output = tsconfig)

    tsconfig_info = TsconfigInfo(
        file = tsconfig,
        name = cjs_info.name,
        package = cjs_info.package,
        transitive_files = depset(
            [tsconfig] + cjs_info.descriptors,
            transitive = [tsconfig_info.transitive_files for tsconfig_info in deps],
        ),
        transitive_packages = depset(
            [cjs_info.package],
            transitive = [tsconfig_info.transitive_packages for tsconfig_info in deps],
        ),
        transitive_deps = depset(
            [create_dep(id = cjs_info.package.id, name = ctx.attr.dep[TsconfigInfo].name, dep = ctx.attr.dep[TsconfigInfo].package.id, label = ctx.attr.dep.label)] if ctx.attr.dep else [],
            transitive = [tsconfig_info.transitive_deps for tsconfig_info in deps],
        ),
    )

    cjs_entries = CjsEntries(
        name = cjs_info.name,
        package = cjs_info.package,
        transitive_packages = tsconfig_info.transitive_packages,
        transitive_deps = tsconfig_info.transitive_deps,
        transitive_files = tsconfig_info.transitive_files,
    )

    default_info = DefaultInfo(
        files = depset([tsconfig]),
    )

    return [cjs_info, default_info, tsconfig_info]

tsconfig = rule(
    attrs = {
        "dep": attr.label(
            providers = [TsconfigInfo],
        ),
        "root": attr.label(
            mandatory = True,
            providers = [CjsInfo],
        ),
        "path": attr.string(
            doc = "Strip prefix",
        ),
        "src": attr.label(
            mandatory = True,
            allow_single_file = [".json"],
        ),
    },
    implementation = _tsconfig_impl,
)

def _ts_library_impl(ctx):
    actions = ctx.actions
    config = ctx.attr._config[DefaultInfo]
    cjs_info = ctx.attr.root[CjsInfo]
    compiler = ctx.attr.compiler[TsCompilerInfo]
    declaration_prefix = ctx.attr.declaration_prefix
    fs_linker = ctx.file._fs_linker
    js_deps = compiler.js_deps + [dep[JsInfo] for dep in ctx.attr.deps if JsInfo in dep]
    js_prefix = ctx.attr.js_prefix
    label = ctx.label
    output_ = output(ctx.label, actions)
    src_prefix = ctx.attr.src_prefix
    srcs = ctx.files.srcs
    strip_prefix = ctx.attr.strip_prefix or default_strip_prefix(ctx)
    ts_deps = compiler.ts_deps + [dep[TsInfo] for dep in ctx.attr.deps if TsInfo in dep]
    tsconfig_info = ctx.attr.config[TsconfigInfo] if ctx.attr.config else None
    workspace_name = ctx.workspace_name

    transpile_tsconfig = actions.declare_file("%s/js-tsconfig.json" % ctx.attr.name)
    args = actions.args()
    if tsconfig_info:
        args.add("--config", tsconfig_info.file)
    args.add("--out-dir", "/dummy")  # force source maps
    args.add(transpile_tsconfig)
    actions.run(
        arguments = [args],
        executable = config.files_to_run.executable,
        tools = [config.files_to_run],
        outputs = [transpile_tsconfig],
    )

    transpile_package_manifest = actions.declare_file("%s/js-package-manifest.json" % ctx.attr.name)
    gen_manifest(
        actions = actions,
        manifest_bin = ctx.attr._manifest[DefaultInfo],
        manifest = transpile_package_manifest,
        deps = depset(
            create_deps(cjs_info.package, label, compiler.ts_deps),
            transitive = ([tsconfig_info.transitive_deps] if tsconfig_info else []) + [ts_info.transitive_deps for ts_info in compiler.ts_deps],
        ),
        globals = [],
        packages = depset(
            [cjs_info.package],
            transitive = ([tsconfig_info.transitive_packages] if tsconfig_info else []) + [ts_info.transitive_packages for ts_info in compiler.ts_deps],
        ),
        package_path = package_path,
    )

    declarations = []
    inputs = []
    js = []
    outputs = []
    js_srcs = []
    for file in ctx.files.srcs:
        path = output_name(
            file = file,
            package_output = output_,
            prefix = src_prefix,
            root = cjs_info.package,
            strip_prefix = strip_prefix,
            workspace_name = workspace_name,
        )
        if file.path == "%s/%s" % (output_.path, path):
            ts_ = file
        else:
            ts_ = actions.declare_file(path)
            actions.symlink(
                target_file = file,
                output = ts_,
            )
        inputs.append(ts_)
        js_srcs.append(ts_)
        if not is_declaration(path):
            js_path_ = output_name(
                file = file,
                package_output = output_,
                prefix = js_prefix,
                root = cjs_info.package,
                strip_prefix = strip_prefix,
                workspace_name = workspace_name,
            )
            declaration_path_ = output_name(
                file = file,
                package_output = output_,
                prefix = declaration_prefix,
                root = cjs_info.package,
                strip_prefix = strip_prefix,
                workspace_name = workspace_name,
            )
            if is_directory(file.path):
                js_ = actions.declare_directory(js_path_)
                js.append(js_)
                declaration = actions.declare_directory(declaration_path_)
                declarations.append(declaration)
                outputs.append(declaration)
            elif is_json(path):
                if path == js_path_:
                    js_ = ts_
                else:
                    js_ = actions.declare_file(js_path_)
                    outputs.append(js_)
                js.append(js_)
                declarations.append(js_)
            else:
                js_ = actions.declare_file(js_path(js_path_))
                js.append(js_)
                map = actions.declare_file(map_path(js_path(js_path_)))
                js_srcs.append(map)
                declaration = actions.declare_file(declaration_path(declaration_path_))
                declarations.append(declaration)
                outputs.append(declaration)

                args = actions.args()
                args.add("--config", transpile_tsconfig)
                args.add("--manifest", transpile_package_manifest)
                args.add("--js", js_)
                args.add("--map", map)
                args.add(file)
                args.set_param_file_format("multiline")
                args.use_param_file("@%s", use_always = True)
                actions.run(
                    arguments = [args],
                    executable = compiler.transpile_bin.files_to_run.executable,
                    execution_requirements = {"supports-workers": "1"},
                    inputs = depset(
                        [file, transpile_package_manifest, transpile_tsconfig],
                        transitive = [tsconfig_info.transitive_files] if tsconfig_info else [],
                    ),
                    mnemonic = "TypeScriptTranspile",
                    outputs = [js_, map],
                    tools = [compiler.transpile_bin.files_to_run],
                )

    transitive_deps = depset(
        target_deps(cjs_info.package, ctx.attr.deps) + create_deps(cjs_info.package, label, compiler.ts_deps),
        transitive = [ts_info.transitive_deps for ts_info in ts_deps],
    )
    transitive_packages = depset(
        [cjs_info.package],
        transitive =
            [ts_info.transitive_packages for ts_info in ts_deps],
    )

    # compile
    if outputs:
        # create tsconfig
        tsconfig = actions.declare_file("%s/tsconfig.json" % ctx.attr.name)
        args = actions.args()
        if tsconfig_info:
            args.add("--config", tsconfig_info.file)
        declaration_root = output_root(root = cjs_info.package, package_output = output_, prefix = declaration_prefix)
        src_root = output_root(root = cjs_info.package, package_output = output_, prefix = src_prefix)
        args.add("--declaration-dir", declaration_root)
        args.add("--root-dir", src_root)
        args.add("--type-root", ("%s/node_modules/@types") % cjs_info.package.path)
        args.add(tsconfig)
        actions.run(
            arguments = [args],
            executable = config.files_to_run.executable,
            tools = [config.files_to_run],
            outputs = [tsconfig],
        )

        package_manifest = actions.declare_file("%s/package-manifest.json" % ctx.attr.name)
        gen_manifest(
            actions = actions,
            manifest_bin = ctx.attr._manifest[DefaultInfo],
            manifest = package_manifest,
            deps = depset(
                transitive = [transitive_deps] + ([tsconfig_info.transitive_deps] if tsconfig_info else []),
            ),
            globals = target_globals(ctx.attr.global_deps),
            packages = depset(
                transitive = [transitive_packages] + ([tsconfig_info.transitive_packages] if tsconfig_info else []),
            ),
            package_path = package_path,
        )

        actions.run(
            arguments = ["-p", tsconfig.path],
            env = {
                "NODE_OPTIONS_APPEND": "-r ./%s" % fs_linker.path,
                "NODE_FS_PACKAGE_MANIFEST": package_manifest.path,
            },
            executable = compiler.bin.files_to_run.executable,
            inputs = depset(
                [package_manifest, fs_linker, tsconfig] + cjs_info.descriptors + inputs,
                transitive = ([tsconfig_info.transitive_files] if tsconfig_info else []) + [dep.transitive_files for dep in ts_deps],
            ),
            mnemonic = "TypeScriptCompile",
            outputs = outputs,
            tools = [compiler.bin.files_to_run],
        )

    ts_info = TsInfo(
        name = cjs_info.name,
        package = cjs_info.package,
        transitive_deps = transitive_deps,
        transitive_files = depset(
            cjs_info.descriptors + declarations,
            transitive = [dep.transitive_files for dep in ts_deps],
        ),
        transitive_packages = transitive_packages,
        transitive_srcs = depset(
            transitive = [dep.transitive_srcs for dep in ts_deps],
        ),
    )

    js_info = JsInfo(
        name = cjs_info.name,
        package = cjs_info.package,
        transitive_deps = depset(
            js_target_deps(cjs_info.package, ctx.attr.deps),
            transitive = [js_info.transitive_deps for js_info in js_deps],
        ),
        transitive_files = depset(
            cjs_info.descriptors + js,
            transitive = [js_info.transitive_files for js_info in js_deps],
        ),
        transitive_packages = depset(
            [cjs_info.package],
            transitive =
                [js_info.transitive_packages for js_info in js_deps],
        ),
        transitive_srcs = depset(
            js_srcs,
            transitive = [js_info.transitive_srcs for js_info in js_deps],
        ),
    )

    default_info = DefaultInfo(
        files = depset(declarations + js),
    )

    cjs_entries = CjsEntries(
        name = cjs_info.name,
        package = cjs_info.package,
        transitive_deps = depset(transitive = [js_info.transitive_deps, ts_info.transitive_deps]),
        transitive_packages = depset(transitive = [js_info.transitive_packages, ts_info.transitive_packages]),
        transitive_files = depset(transitive = [js_info.transitive_files, ts_info.transitive_files]),
    )

    return [default_info, cjs_entries, js_info, ts_info]

ts_library = rule(
    implementation = _ts_library_impl,
    attrs = {
        "_config": attr.label(
            cfg = "exec",
            executable = True,
            default = "@better_rules_javascript//typescript/config:bin",
        ),
        "_fs_linker": attr.label(
            allow_single_file = [".js"],
            default = "@better_rules_javascript//nodejs/fs-linker:file",
        ),
        "_manifest": attr.label(
            cfg = "exec",
            executable = True,
            default = "@better_rules_javascript//commonjs/manifest:bin",
        ),
        "extra_deps": attr.string_dict(
            doc = "Extra dependencies.",
        ),
        "global_deps": attr.label_list(
            doc = "Types",
            providers = [[TsInfo]],
        ),
        "srcs": attr.label_list(
            allow_files = True,
            doc = "TypeScript sources",
        ),
        "deps": attr.label_list(
            doc = "Dependencies",
            providers = [[JsInfo], [TsInfo]],
        ),
        "root": attr.label(
            mandatory = True,
            providers = [CjsInfo],
        ),
        "strip_prefix": attr.string(
            doc = "Strip prefix",
        ),
        "config": attr.label(
            providers = [TsconfigInfo],
        ),
        "declaration_prefix": attr.string(
            doc = "Prefix",
        ),
        "src_prefix": attr.string(),
        "js_prefix": attr.string(),
        "compiler": attr.label(
            mandatory = True,
            providers = [TsCompilerInfo],
        ),
    },
)

def _ts_import_impl(ctx):
    actions = ctx.actions
    cjs_info = ctx.attr.root[CjsInfo]
    declaration_prefix = ctx.attr.declaration_prefix
    extra_deps = ctx.attr.extra_deps
    js_deps = [dep[JsInfo] for dep in ctx.attr.deps if JsInfo in dep]
    js_prefix = ctx.attr.js_prefix
    label = ctx.label
    output_ = output(label = ctx.label, actions = actions)
    strip_prefix = ctx.attr.strip_prefix or default_strip_prefix(ctx)
    ts_deps = [dep[TsInfo] for dep in ctx.attr.deps if TsInfo in dep]
    workspace_name = ctx.workspace_name

    declarations = []
    for file in ctx.files.declarations:
        path = output_name(
            file = file,
            package_output = output_,
            prefix = declaration_prefix,
            root = cjs_info.package,
            strip_prefix = strip_prefix,
            workspace_name = workspace_name,
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
            package_output = output_,
            prefix = js_prefix,
            root = cjs_info.package,
            strip_prefix = strip_prefix,
            workspace_name = workspace_name,
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

    ts_info = TsInfo(
        name = cjs_info.name,
        package = cjs_info.package,
        transitive_files = depset(
            cjs_info.descriptors + declarations,
            transitive = [ts_info.transitive_files for ts_info in ts_deps],
        ),
        transitive_deps = depset(
            target_deps(cjs_info.package, ctx.attr.deps) + create_extra_deps(cjs_info.package, label, extra_deps),
            transitive = [ts_info.transitive_deps for ts_info in ts_deps],
        ),
        transitive_srcs = depset(),  # TODO
        transitive_packages = depset(
            [cjs_info.package],
            transitive = [ts_info.transitive_packages for ts_info in ts_deps],
        ),
    )

    js_info = JsInfo(
        name = cjs_info.name,
        package = cjs_info.package,
        transitive_deps = depset(
            js_target_deps(cjs_info.package, ctx.attr.deps) + create_extra_deps(cjs_info.package, label, extra_deps),
            transitive = [js_info.transitive_deps for js_info in js_deps],
        ),
        transitive_files = depset(
            cjs_info.descriptors + js,
            transitive = [js_info.transitive_files for js_info in js_deps],
        ),
        transitive_packages = depset(
            [cjs_info.package],
            transitive = [js_info.transitive_packages for js_info in js_deps],
        ),
        transitive_srcs = depset(
            transitive = [js_info.transitive_srcs for js_info in js_deps],
        ),
    )

    cjs_entries = CjsEntries(
        name = cjs_info.name,
        package = cjs_info.package,
        transitive_packages = depset(transitive = [js_info.transitive_packages, ts_info.transitive_packages]),
        transitive_deps = depset(transitive = [js_info.transitive_deps, ts_info.transitive_deps]),
        transitive_files = depset(
            transitive = [js_info.transitive_files, ts_info.transitive_files, js_info.transitive_srcs, ts_info.transitive_srcs],
        ),
    )

    default_info = DefaultInfo(
        files = depset(declarations + js),
    )

    return [cjs_entries, js_info, ts_info]

ts_import = rule(
    implementation = _ts_import_impl,
    attrs = {
        "declarations": attr.label_list(
            doc = "Typescript declarations",
            allow_files = True,
        ),
        "deps": attr.label_list(
            doc = "Dependencies",
            providers = [[JsInfo], [TsInfo]],
        ),
        "extra_deps": attr.string_dict(
            doc = "Extra dependencies.",
        ),
        "js": attr.label_list(
            doc = "JavaScript",
            allow_files = True,
        ),
        "root": attr.label(
            doc = "CommonJS root",
            mandatory = True,
            providers = [CjsInfo],
        ),
        "strip_prefix": attr.string(
            doc = "Strip prefix, defaults to CjsRoot prefix",
        ),
        "declaration_prefix": attr.string(),
        "js_prefix": attr.string(
            doc = "Prefix",
        ),
    },
    doc = "Import existing files",
)
