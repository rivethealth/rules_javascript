load("@rules_file//util:path.bzl", "runfile_path")
load("//commonjs:providers.bzl", "CjsEntries", "CjsInfo", "create_dep", "create_global", "create_package", "default_strip_prefix", "gen_manifest", "output_name", "output_root", "package_path")
load("//commonjs:rules.bzl", "cjs_root")
load("//javascript:providers.bzl", "JsInfo", js_create_deps = "create_deps", js_target_deps = "target_deps")
load("//util:path.bzl", "output")
load("//nodejs:rules.bzl", "nodejs_binary")
load("//typescript:providers.bzl", "TsInfo", "TsconfigInfo", "create_deps", "declaration_path", "is_declaration", "is_directory", "is_json", "js_path", "map_path", "target_deps", "target_globals")
load("//typescript:rules.bzl", "ts_library", "tsconfig")
load(":providers.bzl", "AngularCompilerInfo", "resource_path")

def configure_angular_compiler(name, core, compiler_cli, ts, tslib, reflect_metadata, ngc_main = "bundles/src/bin/ngc.js", visibility = None):
    cjs_root(
        name = "%s.root" % name,
        package_name = "@better-rules-javascript/angular-js-compiler",
        descriptors = ["@better_rules_javascript//angular/js-compiler:descriptors"],
        sealed = True,
        strip_prefix = "better_rules_javascript/angular/js-compiler",
        visibility = ["//visibility:private"],
    )

    nodejs_binary(
        main = "lib/tsc.js",
        name = "%s.tsc_bin" % name,
        dep = ts,
        visibility = ["//visibility:private"],
    )

    tsconfig(
        name = "%s.tsconfig" % name,
        src = "@better_rules_javascript//angular/js-compiler:tsconfig",
        dep = "@better_rules_javascript//rules:tsconfig",
        root = ":%s.root" % name,
        path = "tsconfig.json",
    )

    ts_library(
        name = "%s.js_lib" % name,
        srcs = ["@better_rules_javascript//angular/js-compiler:src"],
        compiler = "@better_rules_javascript//rules:tsc",
        root = ":%s.root" % name,
        config = ":%s.tsconfig" % name,
        strip_prefix = "better_rules_javascript/angular/js-compiler",
        deps = [
            ts,
            "@better_rules_javascript//bazel/worker:lib",
            "@better_rules_javascript//commonjs/package:lib",
            "@better_rules_javascript//nodejs/fs-linker:lib",
            "@better_rules_javascript//util/json:lib",
            "@better_rules_javascript_npm//@types/argparse:lib",
            "@better_rules_javascript_npm//@types/node:lib",
            "@better_rules_javascript_npm//argparse:lib",
        ],
        visibility = ["//visibility:private"],
    )

    nodejs_binary(
        main = "src/main.js",
        name = "%s.js_bin" % name,
        dep = ":%s.js_lib" % name,
        visibility = ["//visibility:private"],
    )

    nodejs_binary(
        name = "%s.bin" % name,
        dep = compiler_cli,
        global_deps = [reflect_metadata],
        main = ngc_main,
        visibility = ["//visibility:private"],
    )

    angular_compiler(
        name = name,
        bin = ":%s.bin" % name,
        js_deps = [core, tslib],
        ts_deps = [core, tslib],
        js_compiler = ":%s.js_bin" % name,
        tsc_bin = ":%s.tsc_bin" % name,
    )

def _angular_library(ctx):
    actions = ctx.actions
    cjs_info = ctx.attr.root[CjsInfo]
    compilation_mode = ctx.var["COMPILATION_MODE"]
    compiler = ctx.attr.compiler[AngularCompilerInfo]
    config = ctx.attr._config[DefaultInfo]
    declaration_prefix = ctx.attr.declaration_prefix
    fs_linker = ctx.file._fs_linker
    js_deps = compiler.js_deps + [dep[JsInfo] for dep in ctx.attr.deps + ctx.attr.global_deps if JsInfo in dep]
    js_prefix = ctx.attr.js_prefix
    name = ctx.attr.name
    label = ctx.label
    output_ = output(ctx.label, actions)
    src_prefix = ctx.attr.src_prefix
    strip_prefix = ctx.attr.strip_prefix or default_strip_prefix(ctx)
    ts_deps = compiler.ts_deps + [dep[TsInfo] for dep in ctx.attr.deps + ctx.attr.global_deps if TsInfo in dep]
    tsconfig_info = ctx.attr.config[TsconfigInfo] if ctx.attr.config else None
    workspace_name = ctx.workspace_name

    declarations = []
    inputs = []
    js = []
    js_srcs = []
    outputs = []

    # resource

    for file in ctx.files.resources:
        path = output_name(
            workspace_name = ctx.workspace_name,
            file = file,
            root = cjs_info.package,
            package_output = output_,
            prefix = js_prefix,
            strip_prefix = strip_prefix,
        )
        if compilation_mode == "opt":
            if file.path == "%s/%s" % (output_.path, path):
                resource = file
            else:
                resource = actions.declare_file(path)
                actions.symlink(
                    output = resource,
                    target_file = file,
                )
            js_srcs.append(resource)
            inputs.append(resource)
        else:
            js_path_ = output_name(
                file = file,
                package_output = output_,
                prefix = js_prefix,
                root = cjs_info.package,
                strip_prefix = strip_prefix,
                workspace_name = workspace_name,
            )
            if not file.is_directory:
                js_path_ = resource_path(js_path_)
            js_ = actions.declare_file(js_path_)
            js.append(js_)
            args = actions.args()
            args.add(file)
            args.add(js_)
            args.set_param_file_format("multiline")
            args.use_param_file("@%s", use_always = True)
            actions.run(
                arguments = [args],
                executable = compiler.resource_compiler.files_to_run.executable,
                execution_requirements = {"supports-workers": "1"},
                inputs = [file],
                mnemonic = "TypeScriptTranspile",
                outputs = [js_],
                tools = [compiler.resource_compiler.files_to_run],
            )

    if compilation_mode != "opt":
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

        # JS package manifest
        transpile_package_manifest = actions.declare_file("%s/js-package-manifest.json" % ctx.attr.name)
        gen_manifest(
            actions = actions,
            manifest_bin = ctx.attr._manifest[DefaultInfo],
            manifest = transpile_package_manifest,
            deps = depset(
                create_deps(cjs_info.package, ctx.attr.compiler.label, compiler.ts_deps),
                transitive = ([tsconfig_info.transitive_deps] if tsconfig_info else []) + [ts_info.transitive_deps for ts_info in compiler.ts_deps],
            ),
            globals = [],
            packages = depset(
                transitive = ([tsconfig_info.transitive_packages] if tsconfig_info else []) + [ts_info.transitive_packages for ts_info in compiler.ts_deps],
            ),
            package_path = package_path,
        )

        # JS tsconfig
        tsconfig = actions.declare_file("%s/tsconfig.json" % ctx.attr.name)
        args = actions.args()
        if ctx.attr.config:
            args.add("--config", tsconfig_info.file)
        args.add("--out-dir", cjs_info.package.path)
        args.add("--root-dir", cjs_info.package.path)
        args.add(tsconfig)
        actions.run(
            arguments = [args],
            executable = config.files_to_run.executable,
            tools = [config.files_to_run],
            outputs = [tsconfig],
        )

        transpile_transitive_configs = depset(
            [tsconfig],
            transitive = ([tsconfig_info.transitive_files] if tsconfig_info else []),
        )

    # transpile
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

                if compilation_mode == "opt":
                    outputs.append(js_)
                    outputs.append(map)
                else:
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
                        executable = compiler.js_compiler.files_to_run.executable,
                        execution_requirements = {"supports-workers": "1"},
                        inputs = depset(
                            [file, transpile_package_manifest, transpile_tsconfig],
                            transitive = [tsconfig_info.transitive_files] if tsconfig_info else [],
                        ),
                        mnemonic = "TypeScriptTranspile",
                        outputs = [js_, map],
                        tools = [compiler.js_compiler.files_to_run],
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

        tsconfig = actions.declare_file("%s.tsconfig.json" % ctx.attr.name)
        args = actions.args()
        if ctx.attr.config:
            args.add("--config", tsconfig_info.file)
        args.add("--out-dir", js_root)
        args.add("--declaration-dir", declaration_root)
        args.add("--root-dir", src_root)
        args.add("--type-root", "%s/node_modules/@types" % cjs_info.package.path)
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

        if compilation_mode == "opt":
            actions.run(
                arguments = ["-p", tsconfig.path],
                env = {
                    "NODE_OPTIONS_APPEND": "-r ./%s" % fs_linker.path,
                    "NODE_FS_PACKAGE_MANIFEST": package_manifest.path,
                },
                executable = compiler.bin.files_to_run.executable,
                inputs = depset(
                    [package_manifest, fs_linker, tsconfig] + cjs_info.descriptors + inputs,
                    transitive = ([tsconfig_info.transitive_files] if tsconfig_info else []) + [ts_info.transitive_files for ts_info in ts_deps],
                ),
                mnemonic = "TypeScriptCompile",
                outputs = outputs,
                tools = [compiler.bin.files_to_run],
            )
        else:
            actions.run(
                arguments = ["-p", tsconfig.path],
                env = {
                    "NODE_OPTIONS_APPEND": "-r ./%s" % fs_linker.path,
                    "NODE_FS_PACKAGE_MANIFEST": package_manifest.path,
                },
                executable = compiler.tsc_bin.files_to_run.executable,
                inputs = depset(
                    [package_manifest, fs_linker, tsconfig] + cjs_info.descriptors + inputs,
                    transitive = ([tsconfig_info.transitive_files] if tsconfig_info else []) + [ts_info.transitive_files for ts_info in ts_deps],
                ),
                mnemonic = "TypeScriptCompile",
                outputs = outputs,
                tools = [compiler.tsc_bin.files_to_run],
            )

    ts_info = TsInfo(
        name = cjs_info.name,
        package = cjs_info.package,
        transitive_deps = transitive_deps,
        transitive_files = depset(
            declarations,
            transitive = [ts_info.transitive_files for ts_info in ts_deps],
        ),
        transitive_packages = transitive_packages,
        transitive_srcs = depset(
            transitive = [ts_info.transitive_srcs for ts_info in ts_deps],
        ),
    )

    js_info = JsInfo(
        name = cjs_info.name,
        package = cjs_info.package,
        transitive_deps = depset(
            js_target_deps(cjs_info.package, ctx.attr.deps) +
            js_create_deps(cjs_info.package, ctx.attr.compiler.label, compiler.js_deps),
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

    cjs_entries = CjsEntries(
        name = cjs_info.name,
        package = cjs_info.package,
        transitive_deps = depset(transitive = [js_info.transitive_deps, ts_info.transitive_deps]),
        transitive_files = depset(transitive = [js_info.transitive_files, ts_info.transitive_files]),
        transitive_packages = depset(transitive = [js_info.transitive_packages, ts_info.transitive_packages]),
    )

    default_info = DefaultInfo(
        files = depset(declarations + js),
    )
    return [cjs_entries, default_info, js_info, ts_info]

angular_library = rule(
    implementation = _angular_library,
    attrs = {
        "_config": attr.label(
            cfg = "exec",
            executable = True,
            default = "//typescript/config:bin",
        ),
        "_fs_linker": attr.label(
            allow_single_file = [".js"],
            default = "//nodejs/fs-linker:file",
        ),
        "_manifest": attr.label(
            cfg = "exec",
            executable = True,
            default = "//commonjs/manifest:bin",
        ),
        "compiler": attr.label(
            doc = "Angular compiler.",
            mandatory = True,
            providers = [AngularCompilerInfo],
        ),
        "config": attr.label(
            doc = "Tsconfig.",
            providers = [TsconfigInfo],
        ),
        "deps": attr.label_list(
            doc = "Dependencies.",
            providers = [[JsInfo], [TsInfo]],
        ),
        "global_deps": attr.label_list(
            doc = "Dependencies.",
            providers = [[JsInfo], [TsInfo]],
        ),
        "src_prefix": attr.string(
            doc = "Prepend path to TypeScript sources and Angular resources.",
        ),
        "js_prefix": attr.string(
            doc = "Prepend path to JavaScript.",
        ),
        "declaration_prefix": attr.string(
            doc = "Prepend path to TypeScript declarations.",
        ),
        "strip_prefix": attr.string(
            doc = "Root directory (relative to runfile)",
        ),
        "resources": attr.label_list(
            allow_files = True,
            doc = "Style and template files.",
        ),
        "extra_deps": attr.string_dict(
            doc = "Extra dependencies.",
        ),
        "root": attr.label(
            doc = "CommonJS root",
            mandatory = True,
            providers = [CjsInfo],
        ),
        "srcs": attr.label_list(
            allow_files = True,
            mandatory = True,
            doc = "TypeScript sources.",
        ),
    },
)

def _angular_compiler_impl(ctx):
    bin = ctx.attr.bin[DefaultInfo]
    js_deps = [dep[JsInfo] for dep in ctx.attr.js_deps]
    ts_deps = [dep[TsInfo] for dep in ctx.attr.ts_deps]
    js_compiler = ctx.attr.js_compiler[DefaultInfo]
    resource_compiler = ctx.attr.resource_compiler[DefaultInfo]
    tsc_bin = ctx.attr.tsc_bin[DefaultInfo]

    angular_compiler_info = AngularCompilerInfo(
        bin = bin,
        js_deps = js_deps,
        ts_deps = ts_deps,
        js_compiler = js_compiler,
        resource_compiler = resource_compiler,
        tsc_bin = tsc_bin,
    )

    return [angular_compiler_info]

angular_compiler = rule(
    attrs = {
        "bin": attr.label(
            cfg = "exec",
            executable = True,
            mandatory = True,
        ),
        "js_deps": attr.label_list(
            mandatory = True,
            providers = [JsInfo],
        ),
        "ts_deps": attr.label_list(
            mandatory = True,
            providers = [TsInfo],
        ),
        "js_compiler": attr.label(
            cfg = "exec",
            executable = True,
            mandatory = True,
        ),
        "resource_compiler": attr.label(
            cfg = "exec",
            executable = True,
            default = "//angular/resource-compiler:bin",
        ),
        "tsc_bin": attr.label(
            mandatory = True,
            cfg = "exec",
            executable = True,
        ),
    },
    implementation = _angular_compiler_impl,
)
