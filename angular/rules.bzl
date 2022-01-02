load("//commonjs:providers.bzl", "CjsInfo", "create_dep", "create_global", "create_package", "default_strip_prefix", "gen_manifest", "output_prefix", "package_path")
load("//commonjs:rules.bzl", "cjs_root")
load("//javascript:providers.bzl", "JsInfo")
load("//util:path.bzl", "output", "runfile_path")
load("//nodejs:rules.bzl", "nodejs_binary")
load("//typescript:providers.bzl", "TsInfo", "TsconfigInfo")
load("//typescript:rules.bzl", "compiled_path", "declaration_path", "map_path", "ts_library", "tsconfig")
load(":providers.bzl", "AngularCompilerInfo")

def _resource_path(path):
    return path + ".cjs"

def configure_angular_compiler(name, core, compiler_cli, ts, tslib, reflect_metadata, visibility = None):
    cjs_root(
        name = "%s.root" % name,
        package_name = "@better-rules-javascript/angular-js-compiler",
        descriptors = ["@better_rules_javascript//angular/js-compiler:descriptors"],
        sealed = True,
        strip_prefix = "better_rules_javascript/angular/js-compiler",
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
            "@better_rules_javascript//commonjs/package:lib",
            "@better_rules_javascript//nodejs/fs-linker:lib",
            "@better_rules_javascript//worker/lib",
            "@better_rules_javascript_npm//argparse:lib",
            "@better_rules_javascript_npm//@types/argparse:lib",
            "@better_rules_javascript_npm//@types/node:lib",
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
        main = "bundles/src/bin/ngc.js",
        visibility = ["//visibility:private"],
    )

    angular_compiler(
        name = name,
        bin = ":%s.bin" % name,
        js_deps = [core, tslib],
        ts_deps = [core, tslib],
        js_compiler = ":%s.js_bin" % name,
    )

def _angular_library(ctx):
    compilation_mode = ctx.var["COMPILATION_MODE"]
    cjs_info = ctx.attr.root[CjsInfo]
    config = ctx.attr._config[DefaultInfo]
    compiler = ctx.attr.compiler[AngularCompilerInfo]
    js_deps = compiler.js_deps + [dep[JsInfo] for dep in ctx.attr.deps + ctx.attr.global_deps if JsInfo in dep]
    ts_deps = compiler.ts_deps + [dep[TsInfo] for dep in ctx.attr.deps + ctx.attr.global_deps if TsInfo in dep]
    output_ = output(ctx.label, ctx.actions)
    prefix = output_prefix(cjs_info.package.path, ctx.label, ctx.actions)
    if ctx.attr.prefix:
        prefix = "%s/%s" % (prefix, ctx.attr.prefix)
    tsconfig_info = ctx.attr.config[TsconfigInfo] if ctx.attr.config else None
    strip_prefix = ctx.attr.strip_prefix or default_strip_prefix(ctx)

    compilation_mode = ctx.var["COMPILATION_MODE"]
    tsconfig_info = ctx.attr.config[TsconfigInfo] if ctx.attr.config else None

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
        transitive = [ts_info.transitive_packages for ts_info in js_deps + ts_deps],
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
                    name = cjs_info.name,
                    path = "%s/%s.ts" % (output_.path, ctx.attr.name),
                    short_path = "%s/%s.ts" % (output_.short_path, ctx.attr.name),
                    label = cjs_info.package.label,
                ),
            ],
            transitive = [transitive_packages] + ([tsconfig_info.transitive_packages] if tsconfig_info else []),
        ),
        deps = depset(
            [
                create_dep(
                    dep = js_info.package.id,
                    id = "",
                    label = ctx.label,
                    name = js_info.name,
                )
                for js_info in js_deps
            ] + [
                create_dep(
                    dep = ts_info.package.id,
                    id = "",
                    label = ctx.label,
                    name = ts_info.name,
                )
                for ts_info in ts_deps
            ] + [
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
    args.add("--import-helpers", "true")
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
                if compilation_mode != "opt":
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
                        executable = compiler.js_compiler.files_to_run.executable,
                        # execution_requirements = {"supports-workers": "1"},
                        inputs = depset(
                            [src, transpile_tsconfig, package_manifest],
                            transitive = ([tsconfig_info.transitive_configs, tsconfig_info.transitive_descriptors] if tsconfig_info else []),
                        ),
                        mnemonic = "TypeScriptTranspile",
                        outputs = [js_, map],
                        tools = [compiler.js_compiler.files_to_run],
                    )
            else:
                ctx.actions.symlink(
                    output = js_,
                    target_file = src,
                    progress_message = "Copying file to %{output}",
                )

    resources = []
    for file in ctx.files.resources:
        path = runfile_path(ctx.workspace_name, file)
        if strip_prefix:
            if not path.startswith(strip_prefix + "/"):
                fail("Source %s does not have prefix %s" % (path, strip_prefix))
            path = path[len(strip_prefix + "/"):]
        path2 = path if not ctx.attr.prefix else ctx.attr.prefix + "/" + path
        if prefix:
            path = "%s/%s" % (prefix, path)
        resource = ctx.actions.declare_file(
            "%s.ts/%s" % (
                ctx.attr.name,
                (path2 if output_.path.startswith(cjs_info.package.path) else output_.path[len(cjs_info.package.path) + 1:] + "/" + path2),
            ),
        )
        resources.append(resource)
        ctx.actions.run(
            arguments = [file.path, resource.path],
            executable = "cp",
            inputs = [file],
            mnemonic = "CopyFile",
            outputs = [resource],
            progress_message = "Copying file to %{output}",
        )

    if compilation_mode != "opt":
        for resource in ctx.files.resources:
            path = runfile_path(ctx.workspace_name, resource)
            if strip_prefix:
                if not path.startswith(strip_prefix + "/"):
                    fail("Source %s does not have prefix %s" % (path, strip_prefix))
                path = path[len(strip_prefix + "/"):]
            if prefix:
                path = "%s/%s" % (prefix, path)
            js_ = ctx.actions.declare_file(_resource_path(path))
            js.append(js_)
            args = ctx.actions.args()
            args.add(resource)
            args.add(js_)
            args.set_param_file_format("multiline")
            args.use_param_file("@%s", use_always = True)
            ctx.actions.run(
                arguments = [args],
                executable = compiler.resource_compiler.files_to_run.executable,
                # execution_requirements = {"supports-workers": "1"},
                inputs = [resource],
                mnemonic = "TypeScriptTranspile",
                outputs = [js_],
                tools = [compiler.resource_compiler.files_to_run],
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
    if compilation_mode == "opt" or declarations:
        ctx.actions.run(
            arguments = ["-p", tsconfig.path],
            env = {
                "NODE_OPTIONS_APPEND": "-r ./%s" % ctx.file._fs_linker.path,
                "NODE_FS_PACKAGE_MANIFEST": package_manifest.path,
            },
            executable = compiler.bin.files_to_run.executable,
            inputs = depset(
                [package_manifest, ctx.file._fs_linker, tsconfig] + ts + resources,
                transitive = [transitive_descriptors] + [ts_info.transitive_declarations for ts_info in ts_deps] + ([tsconfig_info.transitive_configs, tsconfig_info.transitive_descriptors] if tsconfig_info else []),
            ),
            mnemonic = "TypeScriptCompile",
            outputs = declarations + (js + maps if compilation_mode == "opt" else []),
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

    transitive_descriptors = depset(
        cjs_info.descriptors,
        transitive = [js_info.transitive_descriptors for js_info in js_deps],
    )
    transitive_deps = depset(
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
            create_dep(id = cjs_info.package.id, dep = js_info.package.id, name = js_info.name, label = ctx.attr.compiler.label)
            for js_info in js_deps
        ]),
        transitive = [js_info.transitive_deps for js_info in js_deps],
    )
    transitive_packages = depset(
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
        transitive_deps = transitive_deps,
        transitive_descriptors = transitive_descriptors,
        transitive_js = transitive_js,
        transitive_packages = transitive_packages,
        transitive_srcs = transitive_srcs,
    )

    default_info = DefaultInfo(
        files = depset(declarations + js),
    )
    return [default_info, js_info, ts_info]

angular_library = rule(
    implementation = _angular_library,
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
        "prefix": attr.string(),
        "strip_prefix": attr.string(),
        "resources": attr.label_list(
            allow_files = True,
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
        ),
    },
)

def _angular_compiler_impl(ctx):
    bin = ctx.attr.bin[DefaultInfo]
    js_deps = [dep[JsInfo] for dep in ctx.attr.js_deps]
    ts_deps = [dep[TsInfo] for dep in ctx.attr.ts_deps]
    js_compiler = ctx.attr.js_compiler[DefaultInfo]
    resource_compiler = ctx.attr.resource_compiler[DefaultInfo]

    angular_compiler_info = AngularCompilerInfo(
        bin = bin,
        js_deps = js_deps,
        ts_deps = ts_deps,
        js_compiler = js_compiler,
        resource_compiler = resource_compiler,
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
    },
    implementation = _angular_compiler_impl,
)
