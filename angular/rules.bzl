load("@rules_file//util:path.bzl", "runfile_path")
load("@bazel_skylib//rules:common_settings.bzl", "BuildSettingInfo")
load("//commonjs:providers.bzl", "CjsInfo", "create_cjs_info", "gen_manifest", "package_path")
load("//commonjs:rules.bzl", "cjs_root")
load("//javascript:providers.bzl", "JsInfo", "create_js_info")
load("//javascript:rules.bzl", "js_export")
load("//util:path.bzl", "output", "output_name")
load("//nodejs:rules.bzl", "nodejs_binary")
load("//typescript:providers.bzl", "TsInfo", "create_ts_info", "declaration_path", "is_declaration", "is_directory", "is_json", "js_path", "map_path")
load(":providers.bzl", "AngularCompilerInfo", "resource_path")

def _module(module):
    if module == "node":
        return "commonjs"
    return module

def configure_angular_compiler(name, core, compiler_cli, ts, tslib, reflect_metadata, visibility = None):
    nodejs_binary(
        main = "lib/tsc.js",
        name = "%s.tsc_bin" % name,
        node = "@better_rules_javascript//rules:nodejs",
        dep = ts,
        visibility = ["//visibility:private"],
    )

    js_export(
        name = "%s.js_lib" % name,
        dep = "@better_rules_javascript//angular/js-compiler:lib",
        deps = [ts],
        visibility = ["//visibility:private"],
    )

    nodejs_binary(
        main = "src/main.js",
        name = "%s.js_bin" % name,
        node = "@better_rules_javascript//rules:nodejs",
        dep = ":%s.js_lib" % name,
        visibility = ["//visibility:private"],
    )

    nodejs_binary(
        name = "%s.bin" % name,
        dep = compiler_cli,
        main = "bundles/src/bin/ngc.js",
        node = "@better_rules_javascript//rules:nodejs",
        visibility = ["//visibility:private"],
    )

    angular_compiler(
        name = name,
        bin = ":%s.bin" % name,
        lib = [core, tslib],
        js_compiler = ":%s.js_bin" % name,
        tsc_bin = ":%s.tsc_bin" % name,
    )

def _angular_library(ctx):
    actions = ctx.actions
    compiler = ctx.attr.compiler[AngularCompilerInfo]
    cjs_deps = compiler.cjs_deps + [target[CjsInfo] for target in ctx.attr.deps]
    cjs_root = ctx.attr.root[CjsInfo]
    compilation_mode = ctx.var["COMPILATION_MODE"]
    config = ctx.attr._config[DefaultInfo]
    declaration_prefix = ctx.attr.declaration_prefix
    fs_linker_cjs = ctx.attr._fs_linker[CjsInfo]
    fs_linker_js = ctx.attr._fs_linker[JsInfo]
    js_deps = compiler.js_deps + [dep[JsInfo] for dep in ctx.attr.deps if JsInfo in dep]
    js_prefix = ctx.attr.js_prefix
    label = ctx.label
    module = _module(ctx.attr._module[BuildSettingInfo].value)
    name = ctx.attr.name
    output_ = output(ctx.label, actions)
    source_map = ctx.attr._source_map[BuildSettingInfo].value
    src_prefix = ctx.attr.src_prefix
    strip_prefix = ctx.attr.strip_prefix
    ts_deps = compiler.ts_deps + [dep[TsInfo] for dep in ctx.attr.deps if TsInfo in dep]
    tsconfig_js = ctx.attr.config_dep and ctx.attr.config_dep[JsInfo]
    tsconfig_path = ctx.attr.config
    tsconfig_dep = ctx.attr.config_dep[CjsInfo] if ctx.attr.config_dep else None
    workspace_name = ctx.workspace_name

    if tsconfig_path and not tsconfig_dep:
        fail("tsconfig attribute requires non-empty tsconfig_dep attribute")

    declarations = []
    inputs = []
    js = []
    outputs = []

    # resource

    for file in ctx.files.resources:
        path = output_name(
            file = file,
            label = label,
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
            inputs.append(resource)
        else:
            js_path_ = output_name(
                file = file,
                label = label,
                prefix = js_prefix,
                strip_prefix = strip_prefix,
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
        if tsconfig_path:
            args.add("--config", "%s/%s" % (tsconfig_dep.package.path, tsconfig_path))
        args.add("--empty", "true")
        args.add("--module", module)
        args.add("--source-map", json.encode(source_map))
        args.add("--out-dir", "%s/%s" % (output_.path, js_prefix) if js_prefix else output_.path)
        args.add("--root-dir", "%s/%s" % (output_.path, src_prefix) if src_prefix else output_.path)
        args.add(transpile_tsconfig)
        actions.run(
            arguments = [args],
            executable = config.files_to_run.executable,
            tools = [config.files_to_run],
            outputs = [transpile_tsconfig],
        )

        # JS package manifest
        transpile_package_manifest = actions.declare_file("%s/js-package-manifest.json" % ctx.attr.name)
        transpile_cjs_info = create_cjs_info(
            cjs_root = cjs_root,
            label = label,
            deps = ([tsconfig_dep] if tsconfig_dep else []) + compiler.cjs_deps,
        )
        gen_manifest(
            actions = actions,
            deps = transpile_cjs_info.transitive_links,
            manifest = transpile_package_manifest,
            manifest_bin = ctx.attr._manifest[DefaultInfo],
            package_path = package_path,
            packages = transpile_cjs_info.transitive_packages,
        )

    # transpile
    for file in ctx.files.srcs:
        path = output_name(
            file = file,
            label = label,
            prefix = src_prefix,
            strip_prefix = strip_prefix,
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

        if not is_declaration(path):
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
            if file.is_directory:
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
                if source_map:
                    map = actions.declare_file(map_path(js_path(js_path_)))
                declaration = actions.declare_file(declaration_path(declaration_path_))
                declarations.append(declaration)
                outputs.append(declaration)

                if compilation_mode == "opt":
                    outputs.append(js_)
                    if source_map:
                        outputs.append(map)
                else:
                    js_outputs = [js_]
                    if source_map:
                        js_outputs.append(map)
                    args = actions.args()
                    args.add("--config", transpile_tsconfig)
                    args.add("--manifest", transpile_package_manifest)
                    args.add(ts_.path)
                    args.set_param_file_format("multiline")
                    args.use_param_file("@%s", use_always = True)
                    actions.run(
                        arguments = [args],
                        executable = compiler.js_compiler.files_to_run.executable,
                        execution_requirements = {"supports-workers": "1"},
                        inputs = depset(
                            [ts_, transpile_package_manifest, transpile_tsconfig],
                            transitive = [js_info.transitive_files for js_info in compiler.js_deps] + [tsconfig_js.transitive_files] if tsconfig_js else [],
                        ),
                        mnemonic = "TypeScriptTranspile",
                        outputs = js_outputs,
                        tools = [compiler.js_compiler.files_to_run],
                    )

    # compile declarations
    if outputs:
        # create tsconfig
        tsconfig = actions.declare_file("%s.tsconfig.json" % ctx.attr.name)
        args = actions.args()
        if tsconfig_path:
            args.add("--config", "%s/%s" % (tsconfig_dep.package.path, tsconfig_path))
        args.add("--out-dir", "%s/%s" % (output_.path, js_prefix) if js_prefix else output_.path)
        args.add("--declaration-dir", "%s/%s" % (output_.path, declaration_prefix) if declaration_prefix else output_.path)
        args.add("--module", module)
        args.add("--root-dir", "%s/%s" % (output_.path, src_prefix) if src_prefix else output_.path)
        if compilation_mode == "opt":
            args.add("--source-map", json.encode(source_map))
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
            deps = ([tsconfig_dep] if tsconfig_dep else []) + cjs_deps,
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

        if compilation_mode == "opt":
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
                        [js_info.transitive_files for js_info in compiler.js_deps] +
                        [ts_info.transitive_files for ts_info in ts_deps],
                ),
                mnemonic = "AngularCompile",
                outputs = outputs,
                tools = [compiler.bin.files_to_run],
            )
        else:
            actions.run(
                arguments = ["-p", tsconfig.path],
                env = {
                    "NODE_OPTIONS_APPEND": "-r ./%s/dist/bundle.js" % fs_linker_cjs.package.path,
                    "NODE_FS_PACKAGE_MANIFEST": package_manifest.path,
                },
                executable = compiler.tsc_bin.files_to_run.executable,
                inputs = depset(
                    [package_manifest, tsconfig] + inputs,
                    transitive = [cjs_root.transitive_files, fs_linker_js.transitive_files] +
                                 ([tsconfig_js.transitive_files] if tsconfig_js else []) +
                                 [js_info.transitive_files for js_info in compiler.js_deps] +
                                 [ts_info.transitive_files for ts_info in ts_deps],
                ),
                mnemonic = "TypeScriptCompile",
                outputs = outputs,
                tools = [compiler.tsc_bin.files_to_run],
            )

    default_info = DefaultInfo(
        files = depset(js),
    )

    output_group_info = OutputGroupInfo(
        dts = depset(declarations),
        _validation = depset(declarations),
    )

    cjs_info = create_cjs_info(
        label = label,
        cjs_root = cjs_root,
        deps = cjs_deps,
        files = declarations,
    )

    js_info = create_js_info(
        cjs_root = cjs_root,
        files = js,
        deps = js_deps + compiler.js_deps,
    )

    ts_info = create_ts_info(
        cjs_root = cjs_root,
        files = declarations,
        deps = ts_deps,
    )

    return [cjs_info, default_info, js_info, output_group_info, ts_info]

angular_library = rule(
    implementation = _angular_library,
    attrs = {
        "compiler": attr.label(
            doc = "Angular compiler.",
            mandatory = True,
            providers = [AngularCompilerInfo],
        ),
        "config": attr.string(),
        "config_dep": attr.label(
            doc = "Tsconfig.",
            providers = [JsInfo, CjsInfo],
        ),
        "deps": attr.label_list(
            doc = "Dependencies.",
            providers = [[CjsInfo, JsInfo], [CjsInfo, TsInfo]],
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
        "_config": attr.label(
            cfg = "exec",
            executable = True,
            default = "//typescript/config:bin",
        ),
        "_fs_linker": attr.label(
            default = "//nodejs/fs-linker:dist_lib",
            providers = [CjsInfo, JsInfo],
        ),
        "_manifest": attr.label(
            cfg = "exec",
            executable = True,
            default = "//commonjs/manifest:bin",
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
    provides = [CjsInfo, JsInfo, TsInfo],
)

def _angular_compiler_impl(ctx):
    bin = ctx.attr.bin[DefaultInfo]
    js_deps = [dep[JsInfo] for dep in ctx.attr.lib]
    ts_deps = [dep[TsInfo] for dep in ctx.attr.lib]
    js_compiler = ctx.attr.js_compiler[DefaultInfo]
    resource_compiler = ctx.attr.resource_compiler[DefaultInfo]
    cjs_deps = [target[CjsInfo] for target in ctx.attr.lib]
    tsc_bin = ctx.attr.tsc_bin[DefaultInfo]

    angular_compiler_info = AngularCompilerInfo(
        bin = bin,
        cjs_deps = cjs_deps,
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
        "lib": attr.label_list(
            mandatory = True,
            providers = [[CjsInfo, JsInfo], [CjsInfo, TsInfo]],
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
