load("@bazel_skylib//lib:shell.bzl", "shell")
load("//commonjs:providers.bzl", "CjsInfo", "create_globals", "gen_manifest", "package_path")
load("//javascript:providers.bzl", "JsInfo")
load("//util:path.bzl", "runfile_path")
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

def _nodejs_binary_implementation(ctx):
    actions = ctx.actions
    env = ctx.attr.env
    manifest = ctx.attr._manifest[DefaultInfo]
    js_dep = ctx.attr.dep[0][JsInfo]
    cjs_dep = ctx.attr.dep[0][CjsInfo] if CjsInfo in ctx.attr.dep[0] else None
    main = ctx.attr.main
    module_linker_cjs = ctx.attr._module_linker[CjsInfo]
    module_linker_js = ctx.attr._module_linker[JsInfo]
    name = ctx.attr.name
    node = ctx.attr.node[NodejsInfo]
    node_options = ctx.attr.node_options + node.options
    esm_linker_cjs = ctx.attr._esm_linker[CjsInfo]
    esm_linker_js = ctx.attr._esm_linker[JsInfo]
    runner = ctx.file._runner
    runtime_cjs = ctx.attr._runtime[CjsInfo]
    runtime_js = ctx.attr._runtime[JsInfo]
    workspace_name = ctx.workspace_name

    transitive_packages = depset(transitive = [cjs_dep.transitive_packages] if cjs_dep else [])

    def package_path(package):
        return runfile_path(workspace_name, package)

    package_manifest = actions.declare_file("%s.packages.json" % name)
    gen_manifest(
        actions = actions,
        manifest_bin = manifest,
        manifest = package_manifest,
        packages = transitive_packages,
        deps = depset(transitive = [cjs_dep.transitive_links] if cjs_dep else []),
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
            "%{node_options}": " ".join([shell.quote(option) for option in node_options]),
            "%{package_manifest}": shell.quote(runfile_path(workspace_name, package_manifest)),
            "%{module_linker}": shell.quote("%s/dist/bundle.js" % runfile_path(workspace_name, module_linker_cjs.package)),
            "%{runtime}": shell.quote("%s/dist/bundle.js" % runfile_path(workspace_name, runtime_cjs.package)),
        },
        is_executable = True,
    )

    runfiles = ctx.runfiles(
        files = [node.bin, package_manifest],
        transitive_files = depset(transitive = [js_dep.transitive_files] + [esm_linker_js.transitive_files, module_linker_js.transitive_files, runtime_js.transitive_files]),
    )
    runfiles = runfiles.merge_all(
        [dep[DefaultInfo].default_runfiles for dep in ctx.attr.data if dep[DefaultInfo].default_runfiles != None],
    )

    default_info = DefaultInfo(
        executable = bin,
        runfiles = runfiles,
    )

    return [default_info]

def _nodejs_transition_impl(settings, attrs):
    return {"//javascript:module": "node"}

_nodejs_transition = transition(
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
            cfg = _nodejs_transition,
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
    implementation = _nodejs_binary_implementation,
)

def _nodejs_modules_archive_impl(ctx):
    actions = ctx.actions
    archive_linker = ctx.attr._archive_linker[DefaultInfo]
    deps = [target[CjsInfo] for target in ctx.attr.deps]
    label = ctx.label
    links = [target[CjsInfo] for target in ctx.attr.links]
    manifest_bin = ctx.attr._manifest[DefaultInfo]
    name = ctx.attr.name
    workspace_name = ctx.workspace_name

    transitive_files = depset(
        transitive = [cjs_info.transitive_files for cjs_info in deps],
    )
    transitive_packages = depset(
        [cjs_root_info.package for cjs_root_info in links],
        transitive = [cjs_info.transitive_packages for cjs_info in deps],
    )
    transitive_links = depset(
        create_globals(label, deps + links),
        transitive = [cjs_info.transitive_links for cjs_info in deps],
    )

    manifest = actions.declare_file("%s.packages.json" % name)

    def package_path(package):
        return runfile_path(workspace_name, package)

    gen_manifest(
        actions = actions,
        deps = transitive_links,
        manifest = manifest,
        manifest_bin = manifest_bin,
        package_path = package_path,
        packages = transitive_packages,
    )

    archive = actions.declare_file("%s.tar" % name)

    file_args = actions.args()
    file_args.use_param_file("@%s")
    file_args.set_param_file_format("multiline")

    link_paths = {cjs_info.package.short_path: None for cjs_info in links}

    def file_arg(file):
        parts = file.short_path.split("/")
        for i in range(len(parts)):
            root = "/".join(parts[:i])
            if root in link_paths:
                return []
        return ["--file", runfile_path(workspace_name, file), file.path]

    file_args.add_all(transitive_files, map_each = file_arg, allow_closure = True)

    args = actions.args()
    args.add("--node-modules", "true")
    for cjs_info in links:
        args.add("--link")
        args.add(package_path(cjs_info.package))
        args.add(cjs_info.package.short_path)
    args.add("--manifest", manifest)
    args.add(archive)

    actions.run(
        arguments = [file_args, args],
        inputs = depset([manifest], transitive = [transitive_files]),
        outputs = [archive],
        executable = archive_linker.files_to_run.executable,
        tools = [archive_linker.files_to_run],
    )

    default_info = DefaultInfo(files = depset([archive]))

    return [default_info]

nodejs_modules_archive = rule(
    attrs = {
        "deps": attr.label_list(
            cfg = _nodejs_transition,
            providers = [CjsInfo],
        ),
        "links": attr.label_list(
            cfg = _nodejs_transition,
            providers = [CjsInfo],
        ),
        "_allowlist_function_transition": attr.label(
            default = "@bazel_tools//tools/allowlists/function_transition_allowlist",
        ),
        "_archive_linker": attr.label(
            cfg = "exec",
            default = "//nodejs/archive-linker:bin",
            executable = True,
        ),
        "_manifest": attr.label(
            cfg = "exec",
            default = "//commonjs/manifest:bin",
            executable = True,
        ),
    },
    doc = "node_modules tar",
    implementation = _nodejs_modules_archive_impl,
)

def _nodejs_install_impl(ctx):
    actions = ctx.actions
    archive = ctx.file.archive
    bash_runfiles = ctx.attr._bash_runfiles[DefaultInfo]
    name = ctx.attr.name
    path = ctx.attr.path
    runner = ctx.file._runner
    workspace_name = ctx.workspace_name

    bin = actions.declare_file(name)
    node_modules = "%s/node_modules" % path if path else "node_modules"
    actions.expand_template(
        template = runner,
        output = bin,
        substitutions = {
            "%{archive}": shell.quote(runfile_path(workspace_name, archive)),
            "%{path}": shell.quote(node_modules),
        },
        is_executable = True,
    )

    runfiles = ctx.runfiles(files = [archive])
    runfiles = runfiles.merge(bash_runfiles.default_runfiles)
    default_info = DefaultInfo(
        executable = bin,
        runfiles = runfiles,
    )

    return [default_info]

nodejs_install = rule(
    attrs = {
        "_bash_runfiles": attr.label(
            default = "@bazel_tools//tools/bash/runfiles",
        ),
        "_runner": attr.label(
            allow_single_file = True,
            default = "install-runner.sh.tpl",
        ),
        "archive": attr.label(
            allow_single_file = [".tar"],
            mandatory = True,
        ),
        "path": attr.label(
            doc = "Path from root of workspace",
        ),
    },
    executable = True,
    implementation = _nodejs_install_impl,
)

def _nodejs_binary_archive_impl(ctx):
    actions = ctx.actions
    archive_linker = ctx.attr._archive_linker[DefaultInfo]
    cjs_info = ctx.attr.dep[0][CjsInfo]
    env = ctx.attr.env
    main = ctx.attr.main
    name = ctx.attr.name
    node = ctx.attr.node[NodejsInfo]
    label = ctx.label
    node_options = ctx.attr.node_options
    manifest_bin = ctx.attr._manifest[DefaultInfo]
    archive_runner = ctx.file._archive_runner
    js_info = ctx.attr.dep[0][JsInfo]
    workspace_name = ctx.workspace_name

    main_module = "%s/%s" % (runfile_path(workspace_name, cjs_info.package), main)

    bin = actions.declare_file(name)
    actions.expand_template(
        template = archive_runner,
        output = bin,
        substitutions = {
            "%{env}": " ".join(["%s=%s" % (name, shell.quote(value)) for name, value in env.items()]),
            "%{main_module}": shell.quote(main_module),
            "%{node}": shell.quote(node.bin) if type(node.bin) == "str" else '"$(dirname "$0")"/node',
            "%{node_options}": " ".join([shell.quote(option) for option in ctx.attr.node_options]),
        },
        is_executable = True,
    )

    manifest = actions.declare_file("%s.packages.json" % name)

    def package_path(package):
        return runfile_path(workspace_name, package)

    gen_manifest(
        actions = actions,
        deps = cjs_info.transitive_links,
        manifest = manifest,
        manifest_bin = manifest_bin,
        package_path = package_path,
        packages = cjs_info.transitive_packages,
    )

    archive = actions.declare_file("%s.tar" % name)

    inputs = [bin, manifest]

    file_args = actions.args()
    file_args.use_param_file("@%s")
    file_args.set_param_file_format("multiline")
    file_args.add("--file", "bin")
    file_args.add(bin)
    if type(node.bin) != "str":
        inputs.append(node.bin)
        file_args.add("--file", "node")
        file_args.add(node.bin)

    def file_arg(file):
        return ["--file", runfile_path(workspace_name, file), file.path]

    file_args.add_all(js_info.transitive_files, map_each = file_arg, allow_closure = True)

    args = actions.args()
    args.add("--manifest", manifest)
    args.add(archive)

    actions.run(
        arguments = [file_args, args],
        inputs = depset(inputs, transitive = [js_info.transitive_files]),
        outputs = [archive],
        executable = archive_linker.files_to_run.executable,
        tools = [archive_linker.files_to_run],
    )

    default_info = DefaultInfo(files = depset([archive]))

    return [default_info]

nodejs_binary_archive = rule(
    attrs = {
        "dep": attr.label(
            cfg = _nodejs_transition,
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
        "_allowlist_function_transition": attr.label(
            default = "@bazel_tools//tools/allowlists/function_transition_allowlist",
        ),
        "_archive_linker": attr.label(
            cfg = "exec",
            executable = True,
            default = "//nodejs/archive-linker:bin",
        ),
        "_archive_runner": attr.label(
            allow_single_file = True,
            default = "archive-runner.sh.tpl",
        ),
        "_manifest": attr.label(
            cfg = "exec",
            executable = True,
            default = "//commonjs/manifest:bin",
        ),
    },
    doc = "Create executable tar",
    implementation = _nodejs_binary_archive_impl,
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
