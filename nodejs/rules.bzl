load("@bazel_skylib//lib:paths.bzl", "paths")
load("@bazel_skylib//lib:shell.bzl", "shell")
load("@rules_file//file:rules.bzl", "untar")
load("@rules_pkg//pkg:providers.bzl", "PackageFilegroupInfo", "PackageFilesInfo", "PackageSymlinkInfo")
load("@rules_pkg//pkg:tar.bzl", "pkg_tar")
load("//commonjs:providers.bzl", "CjsInfo", "CjsPath", "create_globals", "create_links", "create_package", "gen_manifest", "package_path")
load("//javascript:providers.bzl", "JsInfo")
load("//pkg:rules.bzl", "pkg_install")
load("//util:path.bzl", "nearest", "relativize", "runfile_path")
load(":providers.bzl", "NodejsInfo", "NodejsRuntimeInfo")

def configure_nodejs_runtime(name, repo_name, nodejs_runtime_rule, visibility = None):
    native.toolchain_type(name = "%s.toolchain_type" % name, visibility = visibility)

    native.toolchain(
        name = "%s.darwin_arm64_toolchain" % name,
        target_compatible_with = [
            "@platforms//cpu:arm64",
            "@platforms//os:osx",
        ],
        toolchain = "@%s_darwin_arm64//:nodejs" % repo_name,
        toolchain_type = ":%s.toolchain_type" % name,
        visibility = visibility,
    )

    native.toolchain(
        name = "%s.darwin_x86_64_toolchain" % name,
        target_compatible_with = [
            "@platforms//cpu:x86_64",
            "@platforms//os:osx",
        ],
        toolchain = "@%s_darwin_x86_64//:nodejs" % repo_name,
        toolchain_type = ":%s.toolchain_type" % name,
        visibility = visibility,
    )

    native.toolchain(
        name = "%s.linux_arm64_toolchain" % name,
        target_compatible_with = [
            "@platforms//cpu:arm64",
            "@platforms//os:linux",
        ],
        toolchain = "@%s_linux_arm64//:nodejs" % repo_name,
        toolchain_type = ":%s.toolchain_type" % name,
        visibility = visibility,
    )

    native.toolchain(
        name = "%s.linux_x86_64_toolchain" % name,
        target_compatible_with = [
            "@platforms//cpu:x86_64",
            "@platforms//os:linux",
        ],
        toolchain = "@%s_linux_x86_64//:nodejs" % repo_name,
        toolchain_type = ":%s.toolchain_type" % name,
        visibility = visibility,
    )

    native.toolchain(
        name = "%s.windows_x86_64_toolchain" % name,
        target_compatible_with = [
            "@platforms//cpu:x86_64",
            "@platforms//os:windows",
        ],
        toolchain = "@%s_windows_x86_64//:nodejs" % repo_name,
        toolchain_type = ":%s.toolchain_type" % name,
        visibility = visibility,
    )

    nodejs_runtime_rule(
        name = name,
        visibility = visibility,
    )

def _nodejs_impl(ctx):
    nodejs_runtime = ctx.attr.runtime[NodejsRuntimeInfo]
    options = ctx.attr.options

    nodejs_info = NodejsInfo(
        bin = nodejs_runtime.bin,
        options = options,
    )

    return [nodejs_info]

nodejs = rule(
    attrs = {
        "runtime": attr.label(
            mandatory = True,
            providers = [NodejsRuntimeInfo],
        ),
        "options": attr.string_list(),
    },
    implementation = _nodejs_impl,
    provides = [NodejsInfo],
)

def _nodejs_toolchain_impl(ctx):
    bin = ctx.file.bin

    toolchain_info = platform_common.ToolchainInfo(
        bin = bin,
    )
    return [toolchain_info]

nodejs_toolchain = rule(
    implementation = _nodejs_toolchain_impl,
    attrs = {
        "bin": attr.label(
            doc = "Node.js executable",
            allow_single_file = True,
            mandatory = True,
        ),
    },
    provides = [platform_common.ToolchainInfo],
)

def _nodejs_simple_binary_implementation(ctx):
    actions = ctx.actions
    node = ctx.attr.node[NodejsInfo]
    node_options = node.options + ctx.attr.node_options
    path = ctx.attr.path
    src = ctx.file.src

    module = runfile_path(ctx.workspace_name, src)
    if path:
        module = "%s/%s" % (module, path)

    bin = actions.declare_file("%s/bin" % ctx.label.name)
    actions.expand_template(
        template = ctx.file._runner,
        output = bin,
        substitutions = {
            "%{example}": ctx.file.src.short_path,
            "%{module}": shell.quote(module),
            "%{node}": shell.quote(runfile_path(ctx.workspace_name, node.bin)),
            "%{node_options}": " ".join([shell.quote(option) for option in node_options]),
        },
        is_executable = True,
    )

    runfiles = ctx.files._bash_runfiles + [ctx.file.src, node.bin]
    default_info = DefaultInfo(executable = bin, runfiles = ctx.runfiles(runfiles))

    return default_info

nodejs_simple_binary = rule(
    attrs = {
        "src": attr.label(mandatory = True, allow_single_file = True, doc = "Source file"),
        "node": attr.label(
            mandatory = True,
            providers = [NodejsInfo],
        ),
        "node_options": attr.string_list(),
        "path": attr.label(
            doc = "Path to file, if src is directory",
        ),
        "_bash_runfiles": attr.label(
            allow_files = True,
            default = "@bazel_tools//tools/bash/runfiles",
        ),
        "_runner": attr.label(
            allow_single_file = True,
            default = "simple-runner.sh.tpl",
        ),
    },
    doc = "Node.js executable, from a single file.",
    executable = True,
    implementation = _nodejs_simple_binary_implementation,
)

def _nodejs_binary_impl(ctx):
    actions = ctx.actions
    env = ctx.attr.env
    manifest = ctx.attr._manifest[DefaultInfo]
    js_dep = ctx.attr.dep[0][JsInfo]
    cjs_dep = ctx.attr.dep[0][CjsInfo] if CjsInfo in ctx.attr.dep[0] else None
    main = ctx.attr.main
    module_linker_cjs = ctx.attr._module_linker[CjsInfo]
    module_linker_js = ctx.attr._module_linker[JsInfo]
    preload_cjs = [target[CjsInfo] for target in ctx.attr.preload]
    preload_js = [target[JsInfo] for target in ctx.attr.preload]
    name = ctx.attr.name
    node = ctx.attr.node[NodejsInfo]
    node_options = ctx.attr.node_options + node.options
    esm_linker_cjs = ctx.attr._esm_linker[CjsInfo]
    esm_linker_js = ctx.attr._esm_linker[JsInfo]
    runner = ctx.file._runner
    runtime_cjs = ctx.attr._runtime[CjsInfo]
    runtime_js = ctx.attr._runtime[JsInfo]
    workspace_name = ctx.workspace_name

    preload_modules = [
        "%s/%s" % (runfile_path(workspace_name, target[CjsInfo].package), target[CjsPath].path)
        for target in ctx.attr.preload
    ]

    transitive_packages = depset(
        transitive =
            ([cjs_dep.transitive_packages] if cjs_dep else []) +
            [cjs_info.transitive_packages for cjs_info in preload_cjs],
    )

    transitive_links = depset(
        transitive =
            ([cjs_dep.transitive_links] if cjs_dep else []) +
            [cjs_info.transitive_links for cjs_info in preload_cjs],
    )

    def package_path(package):
        return runfile_path(workspace_name, package)

    package_manifest = actions.declare_file("%s.packages.json" % name)
    gen_manifest(
        actions = actions,
        manifest_bin = manifest,
        manifest = package_manifest,
        packages = transitive_packages,
        deps = transitive_links,
        package_path = package_path,
    )

    main_module = "%s/%s" % (runfile_path(workspace_name, cjs_dep.package), main) if cjs_dep else main

    bin = actions.declare_file(name)
    actions.expand_template(
        template = runner,
        output = bin,
        substitutions = {
            "%{env}": " ".join(["%s=%s" % (name, shell.quote(value)) for name, value in env.items()]),
            "%{esm_loader}": shell.quote("%s/dist/bundle.js" % runfile_path(workspace_name, esm_linker_cjs.package)),
            "%{main_module}": shell.quote(main_module),
            "%{node}": shell.quote(runfile_path(workspace_name, node.bin)),
            "%{node_options}": " ".join(
                [shell.quote(option) for option in node_options] +
                [option for module in preload_modules for option in ["-r", '"$(abspath "$RUNFILES_DIR"/%s)"' % module]],
            ),
            "%{package_manifest}": shell.quote(runfile_path(workspace_name, package_manifest)),
            "%{module_linker}": shell.quote("%s/dist/bundle.js" % runfile_path(workspace_name, module_linker_cjs.package)),
            "%{runtime}": shell.quote("%s/dist/bundle.js" % runfile_path(workspace_name, runtime_cjs.package)),
        },
        is_executable = True,
    )

    runfiles = ctx.runfiles(
        files = [node.bin, package_manifest] + ctx.files.data,
        transitive_files = depset(
            transitive = [js_dep.transitive_files] +
                         [esm_linker_js.transitive_files, module_linker_js.transitive_files, runtime_js.transitive_files] +
                         [js_dep.transitive_files for js_dep in preload_js],
        ),
    )
    runfiles = runfiles.merge_all(
        [dep[DefaultInfo].default_runfiles for dep in ctx.attr.data],
    )

    default_info = DefaultInfo(
        executable = bin,
        runfiles = runfiles,
    )

    return [default_info]

def _nodejs_transition_impl(settings, attrs):
    return {"//javascript:module": "node"}

nodejs_transition = transition(
    implementation = _nodejs_transition_impl,
    inputs = [],
    outputs = ["//javascript:module"],
)

nodejs_binary = rule(
    attrs = {
        "data": attr.label_list(
            doc = "Runtime data",
            allow_files = True,
        ),
        "dep": attr.label(
            cfg = nodejs_transition,
            doc = "JavaScript library.",
            mandatory = True,
            providers = [JsInfo],
        ),
        "env": attr.string_dict(
            doc = "Environment variables",
        ),
        "main": attr.string(
            mandatory = True,
        ),
        "node": attr.label(
            default = ":nodejs",
            providers = [NodejsInfo],
        ),
        "node_options": attr.string_list(
            doc = "Node.js options",
        ),
        "preload": attr.label_list(
            cfg = nodejs_transition,
            doc = "Preloaded modules",
            providers = [CjsInfo, CjsPath, JsInfo],
        ),
        "_allowlist_function_transition": attr.label(
            default = "@bazel_tools//tools/allowlists/function_transition_allowlist",
        ),
        "_esm_linker": attr.label(
            default = "//nodejs/esm-linker:dist_lib",
            providers = [CjsInfo, JsInfo],
        ),
        "_module_linker": attr.label(
            default = "//nodejs/module-linker:dist_lib",
            providers = [CjsInfo, JsInfo],
        ),
        "_manifest": attr.label(
            cfg = "exec",
            executable = True,
            default = "//commonjs/manifest:bin",
        ),
        "_runner": attr.label(
            allow_single_file = True,
            default = "runner.sh.tpl",
        ),
        "_runtime": attr.label(
            default = "//nodejs/runtime:dist_lib",
            providers = [CjsInfo, JsInfo],
        ),
    },
    doc = "Node.js binary",
    executable = True,
    implementation = _nodejs_binary_impl,
)

def _nodejs_modules_binary_impl(ctx):
    actions = ctx.actions
    env = ctx.attr.env
    modules = ctx.file.modules
    main = ctx.attr.main
    main_package = ctx.attr.main_package
    name = ctx.attr.name
    node = ctx.attr.node[NodejsInfo]
    node_options = ctx.attr.node_options
    runner = ctx.file._runner
    workspace = ctx.workspace_name

    main_module = "/".join([part for part in [runfile_path(workspace, modules), main_package, main] if part])

    executable = actions.declare_file(name)
    actions.expand_template(
        is_executable = True,
        output = executable,
        substitutions = {
            "%{env}": " ".join(["%s=%s" % (name, shell.quote(value)) for name, value in env.items()]),
            "%{main_module}": shell.quote(main_module),
            "%{node}": shell.quote(runfile_path(workspace, node.bin)),
            "%{node_options}": " ".join([shell.quote(option) for option in node_options]),
        },
        template = runner,
    )

    runfiles = ctx.runfiles(files = [modules, node.bin])
    default_info = DefaultInfo(executable = executable, runfiles = runfiles)

    return [default_info]

nodejs_modules_binary = rule(
    attrs = {
        "env": attr.string_dict(),
        "main": attr.string(),
        "main_package": attr.string(mandatory = True),
        "modules": attr.label(allow_single_file = True, mandatory = True),
        "node": attr.label(default = ":nodejs", providers = [NodejsInfo]),
        "node_options": attr.string_list(),
        "path": attr.string(),
        "_runner": attr.label(
            allow_single_file = True,
            default = "modules-binary-runner.sh.tpl",
        ),
    },
    executable = True,
    implementation = _nodejs_modules_binary_impl,
)

def nodejs_modules(name, deps, **kwargs):
    untar(
        name = name,
        src = ":%s.archive" % name,
        **kwargs
    )

    pkg_tar(
        name = "%s.archive" % name,
        srcs = [":%s.package" % name],
        **kwargs
    )

    nodejs_modules_package(
        name = "%s.package" % name,
        deps = deps,
        **kwargs
    )

def _nodejs_modules_package_impl(ctx):
    deps_cjs = [target[CjsInfo] for target in ctx.attr.deps]
    deps_js = [target[JsInfo] for target in ctx.attr.deps]
    label = ctx.label
    links_cjs = [target[CjsInfo] for target in ctx.attr.links]
    workspace = ctx.workspace_name

    transitive_packages = depset(
        [cjs.package for cjs in links_cjs],
        transitive = [cjs_info.transitive_packages for cjs_info in deps_cjs],
    )
    package_paths = {
        package.path: ".content/%s" % runfile_path(workspace, package)
        for package in transitive_packages.to_list()
    } | {
        cjs.package.path: "../%s" % cjs.package.short_path
        for cjs in links_cjs
    }
    package_paths_nonempty = {}

    transitive_files = depset(
        transitive = [js_info.transitive_files for js_info in deps_js],
    )
    files_map = {}
    for file in transitive_files.to_list():
        package_path = nearest(package_paths, file.path)
        if package_path:
            if package_paths[package_path].startswith("../"):
                continue
            package_paths_nonempty[package_path] = None
        files_map[".content/%s" % runfile_path(workspace, file)] = file
    files = PackageFilesInfo(attributes = {}, dest_src_map = files_map)

    symlinks = []
    transitive_links = depset(
        create_globals(label, deps_cjs + links_cjs),
        transitive = [cjs_info.transitive_links for cjs_info in deps_cjs],
    )
    for link in transitive_links.to_list():
        if link.path == None:
            destination = link.name
        elif link.path not in package_paths_nonempty:
            continue
        elif not package_paths[link.dep].startswith("../") and link.dep not in package_paths_nonempty:
            continue
        else:
            destination = "%s/node_modules/%s" % (package_paths[link.path], link.name)
        symlink = PackageSymlinkInfo(
            destination = destination,
            target = relativize(package_paths[link.dep], paths.dirname(destination)),
        )
        symlinks.append(symlink)

    default_info = DefaultInfo(files = transitive_files)

    filegroup_info = PackageFilegroupInfo(
        pkg_dirs = [],
        pkg_files = [(files, label)],
        pkg_symlinks = [(symlink, label) for symlink in symlinks],
    )

    return [default_info, filegroup_info]

nodejs_modules_package = rule(
    attrs = {
        "deps": attr.label_list(cfg = nodejs_transition, providers = [CjsInfo]),
        "links": attr.label_list(cfg = nodejs_transition, providers = [CjsInfo]),
        "_allowlist_function_transition": attr.label(
            default = "@bazel_tools//tools/allowlists/function_transition_allowlist",
        ),
    },
    provides = [PackageFilegroupInfo],
    implementation = _nodejs_modules_package_impl,
)

def _nodejs_repl_impl(ctx):
    actions = ctx.actions
    env = ctx.attr.env
    manifest = ctx.attr._manifest[DefaultInfo]
    js_deps = [dep[JsInfo] for dep in ctx.attr.deps]
    cjs_deps = [dep[CjsInfo] for dep in ctx.attr.deps if CjsInfo in dep]
    label = ctx.label
    module_linker_cjs = ctx.attr._module_linker[CjsInfo]
    module_linker_js = ctx.attr._module_linker[JsInfo]
    preload_cjs = [target[CjsInfo] for target in ctx.attr.preload]
    preload_js = [target[JsInfo] for target in ctx.attr.preload]
    name = ctx.attr.name
    node = ctx.attr.node[NodejsInfo]
    node_options = ctx.attr.node_options + node.options
    esm_linker_cjs = ctx.attr._esm_linker[CjsInfo]
    esm_linker_js = ctx.attr._esm_linker[JsInfo]
    runner = ctx.file._runner
    runtime_cjs = ctx.attr._runtime[CjsInfo]
    runtime_js = ctx.attr._runtime[JsInfo]
    workspace_name = ctx.workspace_name

    preload_modules = [
        "%s/%s" % (runfile_path(workspace_name, target[CjsInfo].package), target[CjsPath].path)
        for target in ctx.attr.preload
    ]

    package = create_package(
        name = "_repl",
        path = "",
        short_path = "../_repl",
        label = str(label),
    )
    links = create_links(package = package, label = str(label), cjs_infos = cjs_deps)

    transitive_packages = depset(
        [package],
        transitive =
            [cjs_info.transitive_packages for cjs_info in cjs_deps + preload_cjs],
    )

    transitive_links = depset(
        links,
        transitive =
            [cjs_info.transitive_links for cjs_info in cjs_deps + preload_cjs],
    )

    def package_path(package):
        return runfile_path(workspace_name, package)

    package_manifest = actions.declare_file("%s.packages.json" % name)
    gen_manifest(
        actions = actions,
        manifest_bin = manifest,
        manifest = package_manifest,
        packages = transitive_packages,
        deps = transitive_links,
        package_path = package_path,
    )

    bin = actions.declare_file(name)
    actions.expand_template(
        template = runner,
        output = bin,
        substitutions = {
            "%{env}": " ".join(["%s=%s" % (name, shell.quote(value)) for name, value in env.items()]),
            "%{esm_loader}": shell.quote("%s/dist/bundle.js" % runfile_path(workspace_name, esm_linker_cjs.package)),
            "%{node}": shell.quote(runfile_path(workspace_name, node.bin)),
            "%{node_options}": " ".join(
                [shell.quote(option) for option in node_options] +
                [option for module in preload_modules for option in ["-r", '"$(abspath "$RUNFILES_DIR"/%s)"' % module]],
            ),
            "%{package_manifest}": shell.quote(runfile_path(workspace_name, package_manifest)),
            "%{module_linker}": shell.quote("%s/dist/bundle.js" % runfile_path(workspace_name, module_linker_cjs.package)),
            "%{runtime}": shell.quote("%s/dist/bundle.js" % runfile_path(workspace_name, runtime_cjs.package)),
        },
        is_executable = True,
    )

    runfiles = ctx.runfiles(
        files = [node.bin, package_manifest] + ctx.files.data,
        transitive_files = depset(
            transitive = [esm_linker_js.transitive_files, module_linker_js.transitive_files, runtime_js.transitive_files] +
                         [js_dep.transitive_files for js_dep in js_deps + preload_js],
        ),
    )
    runfiles = runfiles.merge_all(
        [dep[DefaultInfo].default_runfiles for dep in ctx.attr.data],
    )

    default_info = DefaultInfo(
        executable = bin,
        runfiles = runfiles,
    )

    return [default_info]

nodejs_repl = rule(
    attrs = {
        "data": attr.label_list(
            doc = "Runtime data",
            allow_files = True,
        ),
        "deps": attr.label_list(
            cfg = nodejs_transition,
            doc = "JavaScript libraries.",
            providers = [JsInfo],
        ),
        "env": attr.string_dict(
            doc = "Environment variables",
        ),
        "node": attr.label(
            default = ":nodejs",
            providers = [NodejsInfo],
        ),
        "node_options": attr.string_list(
            doc = "Node.js options",
        ),
        "preload": attr.label_list(
            cfg = nodejs_transition,
            doc = "Preloaded modules",
            providers = [CjsInfo, CjsPath, JsInfo],
        ),
        "_allowlist_function_transition": attr.label(
            default = "@bazel_tools//tools/allowlists/function_transition_allowlist",
        ),
        "_esm_linker": attr.label(
            default = "//nodejs/esm-linker:dist_lib",
            providers = [CjsInfo, JsInfo],
        ),
        "_module_linker": attr.label(
            default = "//nodejs/module-linker:dist_lib",
            providers = [CjsInfo, JsInfo],
        ),
        "_manifest": attr.label(
            cfg = "exec",
            executable = True,
            default = "//commonjs/manifest:bin",
        ),
        "_runner": attr.label(
            allow_single_file = True,
            default = "repl-runner.sh.tpl",
        ),
        "_runtime": attr.label(
            default = "//nodejs/runtime:dist_lib",
            providers = [CjsInfo, JsInfo],
        ),
    },
    doc = "Node.js REPL",
    executable = True,
    implementation = _nodejs_repl_impl,
)

def nodejs_install(name, src, path = None, **kwargs):
    pkg_install(
        name = name,
        pkg = src,
        path = "%s/node_modules" % path if path else "node_modules",
        **kwargs
    )

def _nodejs_binary_package_impl(ctx):
    actions = ctx.actions
    package_runner = ctx.file._package_runner
    dep_cjs = ctx.attr.dep[0][CjsInfo]
    env = ctx.attr.env
    main = ctx.attr.main
    name = ctx.attr.name
    node = ctx.attr.node[NodejsInfo]
    label = ctx.label
    node_options = ctx.attr.node_options
    dep_js = ctx.attr.dep[0][JsInfo]
    preload_cjs = [target[CjsInfo] for target in ctx.attr.preload]
    preload_js = [target[JsInfo] for target in ctx.attr.preload]
    workspace = ctx.workspace_name

    transitive_files = depset(
        transitive =
            [dep_js.transitive_files] +
            [js_info.transitive_files for js_info in preload_js],
    )

    transitive_packages = depset(
        transitive =
            ([dep_cjs.transitive_packages] if dep_cjs else []) +
            [cjs_info.transitive_packages for cjs_info in preload_cjs],
    )

    transitive_links = depset(
        transitive =
            ([dep_cjs.transitive_links] if dep_cjs else []) +
            [cjs_info.transitive_links for cjs_info in preload_cjs],
    )

    package_paths = {
        package.path: runfile_path(workspace, package)
        for package in transitive_packages.to_list()
    }

    preload_modules = [
        "%s/%s" % (package_paths[target[CjsInfo].package.path], target[CjsPath].path)
        for target in ctx.attr.preload
    ]

    bin = actions.declare_file(name)
    actions.expand_template(
        template = package_runner,
        output = bin,
        substitutions = {
            "%{env}": " ".join(["%s=%s" % (name, shell.quote(value)) for name, value in env.items()]),
            "%{main_module}": shell.quote("%s/%s" % (package_paths[dep_cjs.package.path], main)),
            "%{node}": shell.quote(node.bin) if type(node.bin) == "string" else '"$(dirname "$0")"/node',
            "%{node_options}": " ".join(
                [shell.quote(option) for option in node_options] +
                [option for module in preload_modules for option in ["-r", '"$(dirname "$0")"/%s' % shell.quote(module)]],
            ),
        },
        is_executable = True,
    )

    files_map = {runfile_path(workspace, file): file for file in transitive_files.to_list()}
    files_map["bin"] = bin
    if type(node.bin) != "string":
        files_map["node"] = node.bin
    files = PackageFilesInfo(dest_src_map = files_map)

    symlinks = []
    for link in transitive_links.to_list():
        if link.path == None:
            destination = "node_modules/%s" % link.name
        else:
            destination = "%s/node_modules/%s" % (package_paths[link.path], link.name)
        symlink = PackageSymlinkInfo(
            destination = destination,
            target = relativize(package_paths[link.dep], paths.dirname(destination)),
        )
        symlinks.append(symlink)

    default_info = DefaultInfo(files = depset(files_map.values()))

    filegroup_info = PackageFilegroupInfo(
        pkg_dirs = [],
        pkg_files = [(files, label)],
        pkg_symlinks = [(symlink, label) for symlink in symlinks],
    )

    return [default_info, filegroup_info]

nodejs_binary_package = rule(
    attrs = {
        "dep": attr.label(
            cfg = nodejs_transition,
            mandatory = True,
            providers = [CjsInfo, JsInfo],
        ),
        "env": attr.string_dict(
            doc = "Environment variables",
        ),
        "main": attr.string(
            mandatory = True,
        ),
        "node": attr.label(
            default = ":nodejs",
            providers = [NodejsInfo],
        ),
        "node_options": attr.string_list(
            doc = "Node.js options",
        ),
        "preload": attr.label_list(
            cfg = nodejs_transition,
            doc = "Preloaded modules",
            providers = [CjsInfo, CjsPath, JsInfo],
        ),
        "_allowlist_function_transition": attr.label(
            default = "@bazel_tools//tools/allowlists/function_transition_allowlist",
        ),
        "_package_runner": attr.label(
            allow_single_file = True,
            default = "package-runner.sh.tpl",
        ),
        "_manifest": attr.label(
            cfg = "exec",
            executable = True,
            default = "//commonjs/manifest:bin",
        ),
    },
    doc = "Create executable tar",
    implementation = _nodejs_binary_package_impl,
    provides = [PackageFilegroupInfo],
)

def _nodejs_system_runtime_impl(ctx):
    node = ctx.attr.node

    nodejs_runtime_info = NodejsRuntimeInfo(bin = node)

    return [nodejs_runtime_info]

nodejs_system_runtime = rule(
    attrs = {
        "node": attr.string(mandatory = True),
    },
    implementation = _nodejs_system_runtime_impl,
    provides = [NodejsRuntimeInfo],
)
