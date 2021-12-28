load("@bazel_skylib//lib:paths.bzl", "paths")
load("@better_rules_javascript//commonjs:providers.bzl", "CjsEntries", "CjsInfo", "create_dep", "create_entries", "create_global", "create_package", "default_strip_prefix", "gen_manifest", "output_prefix", "package_path")
load("@better_rules_javascript//commonjs:rules.bzl", "cjs_root")
load("@better_rules_javascript//nodejs:rules.bzl", "nodejs_binary")
load("@better_rules_javascript//javascript:providers.bzl", "JsInfo")
load("@better_rules_javascript//util:path.bzl", "output", "runfile_path")
load(":providers.bzl", "SimpleTsCompilerInfo", "TsCompilerInfo", "TsInfo", "TsconfigInfo")

def configure_ts_simple_compiler(name, ts, visibility = None):
    nodejs_binary(
        main = "lib/tsc.js",
        name = "%s_bin" % name,
        dep = ts,
        visibility = ["//visibility:private"],
    )

    ts_simple_compiler(
        name = name,
        bin = "%s_bin" % name,
        visibility = visibility,
    )

def _ts_simple_compiler_impl(ctx):
    compiler_info = SimpleTsCompilerInfo(
        bin = ctx.attr.bin[DefaultInfo],
    )

    return [compiler_info]

ts_simple_compiler = rule(
    attrs = {
        "bin": attr.label(
            executable = True,
            cfg = "exec",
        ),
    },
    implementation = _ts_simple_compiler_impl,
)

def declaration_path(input):
    if input.endswith(".js"):
        return input.replace(".js", ".d.ts")
    if input.endswith(".ts"):
        return input.replace(".ts", ".d.ts")

def compiled_path(input):
    return input.replace(".ts", ".js")

def map_path(input):
    return input + ".map"

def _ts_simple_library_impl(ctx):
    cjs_info = ctx.attr.root[CjsInfo]
    js_deps = [dep[JsInfo] for dep in ctx.attr.deps if JsInfo in dep]
    ts_deps = [dep[TsInfo] for dep in ctx.attr.deps if TsInfo in dep]
    compiler = ctx.attr.compiler[SimpleTsCompilerInfo]
    output_ = output(ctx.label, ctx.actions)
    prefix = output_prefix(cjs_info.package.path, ctx.label, ctx.actions)
    strip_prefix = ctx.attr.strip_prefix or default_strip_prefix(ctx)
    if ctx.attr.prefix:
        prefix = "%s/%s" % (prefix, ctx.attr.prefix)

    ts = []
    declarations = []
    js = []
    maps = []
    for src in ctx.files.srcs:
        path = runfile_path(ctx.workspace_name, src)
        if strip_prefix:
            if not path.startswith(strip_prefix + "/"):
                fail("Source %s does not have prefix %s" % (path, strip_prefix))
            path = path[len(strip_prefix + "/"):]
        path2 = path if not ctx.attr.prefix else ctx.attr.prefix + "/" + path
        if prefix:
            path = "%s/%s" % (prefix, path)
        ts_ = ctx.actions.declare_file(
            "%s.ts/%s" % (
                ctx.attr.name,
                (path2 if output_.path.startswith(cjs_info.package.path) else output_.path[len(cjs_info.package.path) + 1:] + "/" + path2),
            ),
        )
        ts.append(ts_)
        ctx.actions.run(
            arguments = [src.path, ts_.path],
            executable = "cp",
            inputs = [src],
            mnemonic = "CopyFile",
            outputs = [ts_],
            progress_message = "Copying file to %{output}",
        )
        if not path.endswith(".d.ts"):
            declaration = ctx.actions.declare_file(declaration_path(path))
            declarations.append(declaration)
        if path.endswith(".js") or path.endswith(".ts"):
            js_ = ctx.actions.declare_file(compiled_path(path))
            js.append(js_)
            map = ctx.actions.declare_file(map_path(compiled_path(path)))
            maps.append(map)
        else:
            js_ = ctx.actions.declare_file(path)
            declarations.append(js_)
            js.append(js_)

    transitive_descriptors = depset(
        cjs_info.descriptors,
        transitive = [ts_info.transitive_descriptors for ts_info in ts_deps],
    )
    transitive_deps = depset(
        [
            create_dep(id = cjs_info.package.id, dep = dep[TsInfo].package.id, name = dep[TsInfo].name, label = dep.label)
            for dep in ctx.attr.deps
            if TsInfo in dep
        ],
        transitive = [ts_info.transitive_deps for ts_info in ts_deps],
    )
    transitive_packages = depset(
        [cjs_info.package],
        transitive =
            [ts_info.transitive_packages for ts_info in ts_deps],
    )

    package_manifest = ctx.actions.declare_file("%s/package-manifest.json" % ctx.attr.name)
    gen_manifest(
        actions = ctx.actions,
        manifest_bin = ctx.attr._manifest[DefaultInfo],
        manifest = package_manifest,
        packages = depset(
            [
                create_package(
                    id = "",
                    path = "%s/%s.ts" % (output_.path, ctx.attr.name),
                    short_path = "%s/%s.ts" % (output_.short_path, ctx.attr.name),
                    label = cjs_info.package.label,
                ),
            ],
            transitive = [transitive_packages],
        ),
        deps = depset(
            [
                create_dep(id = "", dep = dep[TsInfo].package.id, name = dep[TsInfo].name, label = dep.label)
                for dep in ctx.attr.deps
                if TsInfo in dep
            ],
            transitive = [transitive_deps],
        ),
        globals = [],
        package_path = package_path,
    )

    args = ctx.actions.args()
    args.add("--pretty")
    args.add("--declaration", "true")
    args.add("--rootDir", "%s/%s.ts" % (output_.path, ctx.attr.name))
    args.add("--moduleResolution", "node")
    args.add("--sourceMap", "true")
    args.add("--inlineSources")
    args.add("--typeRoots", "%s/%s.ts/node_modules/@types" % (output_.path, ctx.attr.name))
    args.add("--outDir", cjs_info.package.path)
    args.add_all(ctx.attr.compiler_options)
    args.add_all(ts)

    ctx.actions.run(
        arguments = [args],
        env = {
            "NODE_OPTIONS_APPEND": "-r ./%s" % ctx.file._fs_linker.path,
            "NODE_FS_PACKAGE_MANIFEST": package_manifest.path,
        },
        executable = compiler.bin.files_to_run.executable,
        inputs = depset(
            ts + [package_manifest, ctx.file._fs_linker],
            transitive =
                [transitive_descriptors] +
                [ts_info.transitive_declarations for ts_info in ts_deps],
        ),
        mnemonic = "TypescriptCompile",
        outputs = declarations + js + maps,
        tools = [compiler.bin.files_to_run],
    )

    transitive_declarations = depset(
        declarations,
        transitive = [dep.transitive_declarations for dep in ts_deps],
    )

    ts_info = TsInfo(
        name = cjs_info.name,
        package = cjs_info.package,
        transitive_declarations = transitive_declarations,
        transitive_deps = transitive_deps,
        transitive_descriptors = transitive_descriptors,
        transitive_packages = transitive_packages,
    )

    js_transitive_descriptors = depset(
        cjs_info.descriptors,
        transitive = [js_info.transitive_descriptors for js_info in js_deps],
    )
    js_transitive_deps = depset(
        [
            create_dep(id = cjs_info.package.id, dep = dep[JsInfo].package.id, name = dep[JsInfo].name, label = dep.label)
            for dep in ctx.attr.deps
            if JsInfo in dep
        ],
        transitive = [js_info.transitive_deps for js_info in js_deps],
    )
    js_transitive_packages = depset(
        [cjs_info.package],
        transitive =
            [js_info.transitive_packages for js_info in js_deps],
    )
    transitive_js = depset(
        js,
        transitive = [js_info.transitive_js for js_info in js_deps],
    )
    transitive_srcs = depset(
        maps,
        transitive = [js_info.transitive_srcs for js_info in js_deps],
    )

    js_info = JsInfo(
        name = cjs_info.name,
        package = cjs_info.package,
        transitive_deps = js_transitive_deps,
        transitive_descriptors = js_transitive_descriptors,
        transitive_js = transitive_js,
        transitive_packages = js_transitive_packages,
        transitive_srcs = transitive_srcs,
    )

    default_info = DefaultInfo(
        files = depset(declarations + js),
    )

    cjs_entries = CjsEntries(
        name = cjs_info.name,
        package = cjs_info.package,
        transitive_deps = depset(transitive = [js_info.transitive_deps, ts_info.transitive_deps]),
        transitive_packages = depset(transitive = [js_info.transitive_packages, ts_info.transitive_packages]),
        transitive_files = depset(transitive = [js_info.transitive_descriptors, ts_info.transitive_descriptors, ts_info.transitive_declarations, js_info.transitive_js, js_info.transitive_srcs]),
    )

    return [default_info, cjs_entries, js_info, ts_info]

ts_simple_library = rule(
    implementation = _ts_simple_library_impl,
    attrs = {
        "srcs": attr.label_list(
            allow_files = [".js", ".json", ".ts"],
            doc = "TypeScript sources",
            mandatory = True,
        ),
        "compiler_options": attr.string_list(
            doc = "Compiler CLI options",
        ),
        "deps": attr.label_list(
            doc = "Dependencies",
            providers = [[JsInfo], [TsInfo]],
        ),
        "libs": attr.string_list(),
        "root": attr.label(
            mandatory = True,
            providers = [CjsInfo],
        ),
        "strip_prefix": attr.string(
            doc = "Strip prefix",
        ),
        "prefix": attr.string(
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
            "@better_rules_javascript//worker/lib",
            "@better_rules_javascript_npm//argparse:lib",
            "@better_rules_javascript_npm//@types/argparse:lib",
            "@better_rules_javascript_npm//@types/node:lib",
        ],
        visibility = ["//visibility:private"],
    )

    ts_simple_library(
        name = "%s.dts_lib" % name,
        srcs = ["@better_rules_javascript//typescript/dts-compiler:src"],
        compiler = "@better_rules_javascript//rules:simple_tsc",
        root = ":%s.root" % name,
        compiler_options = ["--esModuleInterop", "--lib", "dom,es2019", "--types", "node"],
        strip_prefix = "better_rules_javascript/typescript/dts-compiler",
        deps = [
            ts,
            "@better_rules_javascript_npm//argparse:lib",
            "@better_rules_javascript//worker/lib",
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

    nodejs_binary(
        main = "src/main.js",
        name = "%s.dts_bin" % name,
        dep = ":%s.dts_lib" % name,
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
        runtime = ctx.attr.runtime[JsInfo] if ctx.attr.runtime else None,
    )

    return [ts_compiler_info]

ts_compiler = rule(
    implementation = _ts_compiler_impl,
    attrs = {
        "bin": attr.label(
            cfg = "exec",
            doc = "Declaration compiler executable.",
            executable = True,
        ),
        "transpile_bin": attr.label(
            cfg = "exec",
            doc = "JS compiler executable.",
            executable = True,
        ),
        "runtime": attr.label(
            doc = "Runtime library. If set, importHelpers will be used.",
            providers = [JsInfo],
        ),
    },
)

def _tsconfig_impl(ctx):
    cjs_info = ctx.attr.root[CjsInfo]
    deps = [ctx.attr.dep[TsconfigInfo]] if ctx.attr.dep else []
    prefix = output_prefix(cjs_info.package.path, ctx.label, ctx.actions)
    if ctx.attr.path:
        strip_prefix = runfile_path(ctx.workspace_name, ctx.file.src)
        prefix = "%s/%s" % (prefix, ctx.attr.path) if prefix else ctx.attr.path
    else:
        strip_prefix = default_strip_prefix(ctx)

    config = create_entries(
        actions = ctx.actions,
        ctx = ctx,
        prefix = prefix,
        srcs = ctx.files.src,
        strip_prefix = strip_prefix,
    )[0]

    transitive_configs = depset(
        [config],
        transitive = [tsconfig_info.transitive_configs for tsconfig_info in deps],
    )
    transitive_packages = depset(
        [cjs_info.package],
        transitive = [tsconfig_info.transitive_packages for tsconfig_info in deps],
    )
    transitive_deps = depset(
        [create_dep(
            id = cjs_info.package.id,
            dep = ctx.attr.dep[TsconfigInfo].package.id,
            name = ctx.attr.dep[TsconfigInfo].name,
            label = ctx.attr.dep.label,
        )] if ctx.attr.dep else [],
        transitive = [tsconfig_info.transitive_deps for tsconfig_info in deps],
    )
    transitive_descriptors = depset(
        cjs_info.descriptors,
        transitive = [tsconfig_info.transitive_descriptors for tsconfig_info in deps],
    )
    tsconfig_info = TsconfigInfo(
        config = config,
        name = cjs_info.name,
        package = cjs_info.package,
        transitive_configs = transitive_configs,
        transitive_packages = transitive_packages,
        transitive_deps = transitive_deps,
        transitive_descriptors = transitive_descriptors,
    )

    return [tsconfig_info]

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
    cjs_info = ctx.attr.root[CjsInfo]
    config = ctx.attr._config[DefaultInfo]
    compiler = ctx.attr.compiler[TsCompilerInfo]
    js_deps = [dep[JsInfo] for dep in ctx.attr.deps + ctx.attr.global_deps if JsInfo in dep]
    if compiler.runtime:
        js_deps.append(compiler.runtime)
    ts_deps = [dep[TsInfo] for dep in ctx.attr.deps + ctx.attr.global_deps if TsInfo in dep]
    output_ = output(ctx.label, ctx.actions)
    prefix = output_prefix(cjs_info.package.path, ctx.label, ctx.actions)
    if ctx.attr.prefix:
        prefix = "%s/%s" % (prefix, ctx.attr.prefix)
    tsconfig_info = ctx.attr.config[TsconfigInfo] if ctx.attr.config else None
    strip_prefix = ctx.attr.strip_prefix or default_strip_prefix(ctx)

    # package manifest
    transitive_descriptors = depset(
        cjs_info.descriptors,
        transitive = [ts_info.transitive_descriptors for ts_info in ts_deps],
    )
    transitive_deps = depset(
        [
            create_dep(id = cjs_info.package.id, dep = dep[TsInfo].package.id, name = dep[TsInfo].name, label = dep.label)
            for dep in ctx.attr.deps
            if TsInfo in dep
        ],
        transitive = [ts_info.transitive_deps for ts_info in ts_deps],
    )
    transitive_packages = depset(
        [cjs_info.package],
        transitive = [ts_info.transitive_packages for ts_info in ts_deps],
    )

    package_manifest = ctx.actions.declare_file("%s/package-manifest.json" % ctx.attr.name)
    gen_manifest(
        actions = ctx.actions,
        manifest_bin = ctx.attr._manifest[DefaultInfo],
        manifest = package_manifest,
        packages = depset(
            [
                create_package(
                    id = "",
                    path = "%s/%s.ts" % (output_.path, ctx.attr.name),
                    short_path = "%s/%s.ts" % (output_.short_path, ctx.attr.name),
                    label = cjs_info.package.label,
                ),
            ] + ([compiler.runtime.package] if compiler.runtime else []),
            transitive = [transitive_packages] + ([tsconfig_info.transitive_packages] if tsconfig_info else []),
        ),
        deps = depset(
            ([
                create_dep(
                    dep = compiler.runtime.package.id,
                    id = "",
                    label = ctx.label,
                    name = "tslib",
                ),
            ] if compiler.runtime else []) + [
                create_dep(id = "", dep = dep[TsInfo].package.id, name = dep[TsInfo].name, label = dep.label)
                for dep in ctx.attr.deps
                if TsInfo in dep
            ],
            transitive = [transitive_deps] + ([tsconfig_info.transitive_deps] if tsconfig_info else []),
        ),
        globals = [create_global(id = dep[TsInfo].package.id, name = dep[TsInfo].name) for dep in ctx.attr.global_deps if TsInfo in dep],
        package_path = package_path,
    )

    transpile_tsconfig = ctx.actions.declare_file("%s/js-tsconfig.json" % ctx.attr.name)
    args = ctx.actions.args()
    if ctx.attr.config:
        args.add("--config", tsconfig_info.config)
    args.add("--import-helpers", "true" if compiler.runtime else "false")
    args.add("--out-dir", ("%s/%s" % (output_.path, prefix)) if prefix else output_.path)
    args.add("--root-dir", "%s/%s.ts" % (output_.path, ctx.attr.name))
    args.add(transpile_tsconfig)
    ctx.actions.run(
        arguments = [args],
        inputs = depset(
            [],
            transitive = ([tsconfig_info.transitive_configs, tsconfig_info.transitive_descriptors] if tsconfig_info else []),
        ),
        executable = config.files_to_run.executable,
        tools = [config.files_to_run],
        outputs = [transpile_tsconfig],
    )

    # transpile
    declarations = []
    js = []
    ts = []
    maps = []
    for src in ctx.files.srcs:
        path = runfile_path(ctx.workspace_name, src)
        if strip_prefix:
            if not path.startswith(strip_prefix + "/"):
                fail("Source %s does not have prefix %s" % (path, strip_prefix))
            path = path[len(strip_prefix + "/"):]
        path2 = path if not ctx.attr.prefix else ctx.attr.prefix + "/" + path
        if prefix:
            path = "%s/%s" % (prefix, path)
        ts_ = ctx.actions.declare_file(
            "%s.ts/%s" % (
                ctx.attr.name,
                (path2 if output_.path.startswith(cjs_info.package.path) else output_.path[len(cjs_info.package.path) + 1:] + "/" + path2),
            ),
        )
        ts.append(ts_)
        ctx.actions.run(
            arguments = [src.path, ts_.path],
            executable = "cp",
            inputs = [src],
            mnemonic = "CopyFile",
            outputs = [ts_],
            progress_message = "Copying file to %{output}",
        )

        if not path.endswith(".d.ts"):
            js_ = ctx.actions.declare_file(compiled_path(path))
            js.append(js_)

            if path.endswith(".js") or path.endswith(".ts"):
                declaration = ctx.actions.declare_file(declaration_path(path))
                declarations.append(declaration)
                map = ctx.actions.declare_file(map_path(compiled_path(path)))
                maps.append(map)
                args = ctx.actions.args()
                args.add("--config", transpile_tsconfig)
                args.add("--manifest", package_manifest)
                args.add("--js", js_)
                args.add("--map", map)
                args.add(src)
                args.set_param_file_format("multiline")
                args.use_param_file("@%s", use_always = True)
                ctx.actions.run(
                    arguments = [args],
                    executable = compiler.transpile_bin.files_to_run.executable,
                    execution_requirements = {"supports-workers": "1"},
                    inputs = depset(
                        [src, transpile_tsconfig, package_manifest],
                        transitive = ([tsconfig_info.transitive_configs, tsconfig_info.transitive_descriptors] if tsconfig_info else []),
                    ),
                    mnemonic = "TypeScriptTranspile",
                    outputs = [js_, map],
                    tools = [compiler.transpile_bin.files_to_run],
                )
            else:
                ctx.actions.symlink(
                    output = js_,
                    target_file = src,
                    progress_message = "Copying file to %{output}",
                )

    # create tsconfig
    tsconfig = ctx.actions.declare_file("%s/tsconfig.json" % ctx.attr.name)
    args = ctx.actions.args()
    if ctx.attr.config:
        args.add("--config", tsconfig_info.config)
    args.add("--out-dir", ("%s/%s" % (output_.path, prefix)) if prefix else output_.path)
    args.add("--root-dir", "%s/%s.ts" % (output_.path, ctx.attr.name))
    args.add("--root-dirs", "%s/%s.ts" % (output_.path, ctx.attr.name))
    args.add("--root-dirs", ("%s/%s" % (output_.path, prefix)) if prefix else output_.path)
    args.add("--type-root", ("%s/%s.ts/node_modules/@types") % (output_.path, ctx.attr.name))
    args.add(tsconfig)
    args.add_all(ts)
    ctx.actions.run(
        arguments = [args],
        inputs = depset(
            [],
            transitive = ([tsconfig_info.transitive_configs, tsconfig_info.transitive_descriptors] if tsconfig_info else []),
        ),
        executable = config.files_to_run.executable,
        tools = [config.files_to_run],
        outputs = [tsconfig],
    )

    # compile
    if declarations:
        ctx.actions.run(
            arguments = ["-p", tsconfig.path],
            env = {
                "NODE_OPTIONS_APPEND": "-r ./%s" % ctx.file._fs_linker.path,
                "NODE_FS_PACKAGE_MANIFEST": package_manifest.path,
            },
            executable = compiler.bin.files_to_run.executable,
            inputs = depset(
                [package_manifest, ctx.file._fs_linker, tsconfig] + ts,
                transitive = [transitive_descriptors] + [ts_info.transitive_declarations for ts_info in ts_deps] + ([tsconfig_info.transitive_configs, tsconfig_info.transitive_descriptors] if tsconfig_info else []),
            ),
            mnemonic = "TypeScriptCompile",
            outputs = declarations,
            tools = [compiler.bin.files_to_run],
        )

    transitive_declarations = depset(
        declarations + [js_ for js_ in js if js_.path.endswith(".json")],
        transitive = [ts_info.transitive_declarations for ts_info in ts_deps],
    )

    ts_info = TsInfo(
        package = cjs_info.package,
        name = cjs_info.name,
        transitive_declarations = transitive_declarations,
        transitive_descriptors = transitive_descriptors,
        transitive_deps = transitive_deps,
        transitive_packages = transitive_packages,
    )

    js_transitive_descriptors = depset(
        cjs_info.descriptors,
        transitive = [js_info.transitive_descriptors for js_info in js_deps],
    )
    js_transitive_deps = depset(
        [
            create_dep(id = cjs_info.package.id, dep = dep[JsInfo].package.id, name = dep[JsInfo].name, label = dep.label)
            for dep in ctx.attr.deps
            if JsInfo in dep
        ] + [
            create_dep(
                dep = id,
                id = cjs_info.package.id,
                label = Label(id),
                name = name,
            )
            for name, id in ctx.attr.extra_deps.items()
        ] + ([
            create_dep(id = cjs_info.package.id, dep = compiler.runtime.package.id, name = compiler.runtime.name, label = ctx.attr.compiler.label),
        ] if compiler.runtime else []),
        transitive = [js_info.transitive_deps for js_info in js_deps],
    )
    js_transitive_packages = depset(
        [cjs_info.package],
        transitive =
            [js_info.transitive_packages for js_info in js_deps],
    )
    transitive_js = depset(
        js,
        transitive = [js_info.transitive_js for js_info in js_deps],
    )
    transitive_srcs = depset(
        maps,
        transitive = [js_info.transitive_srcs for js_info in js_deps],
    )

    js_info = JsInfo(
        name = cjs_info.name,
        package = cjs_info.package,
        transitive_deps = js_transitive_deps,
        transitive_descriptors = js_transitive_descriptors,
        transitive_js = transitive_js,
        transitive_packages = js_transitive_packages,
        transitive_srcs = transitive_srcs,
    )

    default_info = DefaultInfo(
        files = depset(declarations + js),
    )

    cjs_entries = CjsEntries(
        name = cjs_info.name,
        package = cjs_info.package,
        transitive_packages = depset(transitive = [transitive_packages, js_transitive_packages]),
        transitive_deps = depset(transitive = [transitive_deps, js_transitive_deps]),
        transitive_files = depset(
            transitive = [transitive_descriptors, js_transitive_descriptors, transitive_declarations, transitive_js, transitive_srcs],
        ),
    )

    return [cjs_entries, default_info, js_info, ts_info]

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
            allow_files = [".js", ".json", ".ts"],
            doc = "TypeScript sources",
            mandatory = True,
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
        "prefix": attr.string(
            doc = "Prefix",
        ),
        "compiler": attr.label(
            mandatory = True,
            providers = [TsCompilerInfo],
        ),
    },
)

def _ts_import_impl(ctx):
    cjs_info = ctx.attr.root[CjsInfo]
    js_deps = [dep[JsInfo] for dep in ctx.attr.deps if JsInfo in dep]
    ts_deps = [dep[TsInfo] for dep in ctx.attr.deps if TsInfo in dep]
    strip_prefix = ctx.attr.strip_prefix or default_strip_prefix(ctx)

    prefix = output_prefix(cjs_info.package.path, ctx.label, ctx.actions)
    if ctx.attr.prefix:
        prefix = "%s/%s" % (prefix, ctx.attr.prefix)

    declarations = create_entries(
        ctx = ctx,
        actions = ctx.actions,
        srcs = ctx.files.declarations,
        prefix = prefix,
        strip_prefix = strip_prefix,
    )

    js = create_entries(
        ctx = ctx,
        actions = ctx.actions,
        srcs = ctx.files.js,
        prefix = prefix,
        strip_prefix = ctx.attr.strip_prefix,
    )

    transitive_declarations = depset(
        declarations,
        transitive = [ts_info.transitive_declarations for ts_info in ts_deps],
    )
    transitive_descriptors = depset(
        cjs_info.descriptors,
        transitive = [ts_info.transitive_descriptors for ts_info in ts_deps],
    )
    transitive_deps = depset(
        [
            create_dep(id = cjs_info.package.id, dep = dep[TsInfo].package.id, name = dep[TsInfo].name, label = dep.label)
            for dep in ctx.attr.deps
            if TsInfo in dep
        ],
        transitive = [ts_info.transitive_deps for ts_info in ts_deps],
    )
    transitive_packages = depset(
        [cjs_info.package],
        transitive = [ts_info.transitive_packages for ts_info in ts_deps],
    )

    ts_info = TsInfo(
        name = cjs_info.name,
        package = cjs_info.package,
        transitive_declarations = transitive_declarations,
        transitive_deps = transitive_deps,
        transitive_descriptors = transitive_descriptors,
        transitive_packages = transitive_packages,
    )

    transitive_js = depset(
        js,
        transitive = [js_info.transitive_js for js_info in js_deps],
    )
    transitive_srcs = depset(
        [],
        transitive = [js_info.transitive_js for js_info in js_deps],
    )
    js_transitive_descriptors = depset(
        cjs_info.descriptors,
        transitive = [js_info.transitive_descriptors for js_info in js_deps],
    )
    js_transitive_deps = depset(
        [
            create_dep(id = cjs_info.package.id, dep = dep[JsInfo].package.id, label = dep.label, name = dep[JsInfo].name)
            for dep in ctx.attr.deps
            if JsInfo in dep
        ] + [
            create_dep(
                dep = id,
                id = cjs_info.package.id,
                label = Label(id),
                name = name,
            )
            for name, id in ctx.attr.extra_deps.items()
        ],
        transitive = [js_info.transitive_deps for js_info in js_deps],
    )
    js_transitive_packages = depset(
        [cjs_info.package],
        transitive = [js_info.transitive_packages for js_info in js_deps],
    )

    js_info = JsInfo(
        name = cjs_info.name,
        package = cjs_info.package,
        transitive_deps = js_transitive_deps,
        transitive_descriptors = js_transitive_descriptors,
        transitive_js = transitive_js,
        transitive_packages = js_transitive_packages,
        transitive_srcs = transitive_srcs,
    )

    cjs_entries = CjsEntries(
        name = cjs_info.name,
        package = cjs_info.package,
        transitive_packages = depset(transitive = [transitive_packages, js_transitive_packages]),
        transitive_deps = depset(transitive = [transitive_deps, js_transitive_deps]),
        transitive_files = depset(
            transitive = [transitive_descriptors, js_transitive_descriptors, transitive_declarations, transitive_js, transitive_srcs],
        ),
    )

    return [cjs_entries, js_info, ts_info]

ts_import = rule(
    implementation = _ts_import_impl,
    attrs = {
        "declarations": attr.label_list(
            doc = "Typescript declarations",
            allow_files = [".d.ts"],
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
        "prefix": attr.string(
            doc = "Prefix",
        ),
    },
    doc = "Import existing files",
)
