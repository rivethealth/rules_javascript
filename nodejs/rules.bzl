load("@bazel_skylib//lib:shell.bzl", "shell")
load("//commonjs:providers.bzl", "CjsInfo", "create_globals", "create_package", "gen_manifest", "package_path")
load("//javascript:providers.bzl", "JsInfo", "create_js_info")
load("//util:path.bzl", "output", "runfile_path")
load(":providers.bzl", "NODE_MODULES_PREFIX", "modules_links", "package_path_name")

def _nodejs_simple_binary_implementation(ctx):
    actions = ctx.actions
    nodejs_toolchain = ctx.toolchains["@better_rules_javascript//nodejs:toolchain_type"]
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
            "%{module}": shell.quote(module),
            "%{node}": shell.quote(runfile_path(ctx.workspace_name, nodejs_toolchain.nodejs.bin)),
            "%{example}": ctx.file.src.short_path,
        },
        is_executable = True,
    )

    runfiles = ctx.files._bash_runfiles + [ctx.file.src, nodejs_toolchain.nodejs.bin]
    default_info = DefaultInfo(executable = bin, runfiles = ctx.runfiles(runfiles))

    return default_info

nodejs_simple_binary = rule(
    attrs = {
        "src": attr.label(mandatory = True, allow_single_file = True, doc = "Source file"),
        "path": attr.label(
            doc = "Path to file, if src is directory",
        ),
        "_bash_runfiles": attr.label(
            allow_files = True,
            default = "@bazel_tools//tools/bash/runfiles",
        ),
        "_runner": attr.label(
            allow_single_file = True,
            default = "//nodejs:simple_runner",
        ),
    },
    doc = "Node.js executable, from a single file.",
    executable = True,
    implementation = _nodejs_simple_binary_implementation,
    toolchains = ["@better_rules_javascript//nodejs:toolchain_type"],
)

def _nodejs_binary_implementation(ctx):
    actions = ctx.actions
    env = ctx.attr.env
    manifest = ctx.attr._manifest[DefaultInfo]
    js_dep = ctx.attr.dep[0][JsInfo]
    js_deps = [js_dep]
    cjs_dep = ctx.attr.dep[0][CjsInfo]
    cjs_deps = [cjs_dep]
    module_linker_cjs = ctx.attr._module_linker[CjsInfo]
    module_linker_js = ctx.attr._module_linker[JsInfo]
    name = ctx.attr.name
    node_options = ctx.attr.node_options
    esm_linker_cjs = ctx.attr._esm_linker[CjsInfo]
    esm_linker_js = ctx.attr._esm_linker[JsInfo]
    runner = ctx.file._runner
    runtime_cjs = ctx.attr._runtime[CjsInfo]
    runtime_js = ctx.attr._runtime[JsInfo]
    workspace_name = ctx.workspace_name

    nodejs_toolchain = ctx.toolchains["@better_rules_javascript//nodejs:toolchain_type"]

    transitive_packages = depset(transitive = [dep.transitive_packages for dep in cjs_deps])

    def package_path(package):
        return "%s/%s" % (NODE_MODULES_PREFIX, package_path_name(workspace_name, package.short_path))

    package_manifest = actions.declare_file("%s.packages.json" % name)
    gen_manifest(
        actions = actions,
        manifest_bin = manifest,
        manifest = package_manifest,
        packages = transitive_packages,
        deps = depset(transitive = [dep.transitive_links for dep in cjs_deps]),
        package_path = package_path,
    )

    main_module = "%s/%s/%s" % (NODE_MODULES_PREFIX, package_path_name(workspace_name, cjs_dep.package.short_path), ctx.attr.main)

    bin = actions.declare_file(name)
    actions.expand_template(
        template = runner,
        output = bin,
        substitutions = {
            "%{env}": " ".join(["%s=%s" % (name, shell.quote(value)) for name, value in env.items()]),
            "%{esm_loader}": shell.quote("%s/dist/bundle.js" % runfile_path(workspace_name, esm_linker_cjs.package)),
            "%{main_module}": shell.quote(main_module),
            "%{node}": shell.quote(runfile_path(workspace_name, nodejs_toolchain.nodejs.bin)),
            "%{node_options}": " ".join([shell.quote(option) for option in node_options]),
            "%{package_manifest}": shell.quote(runfile_path(workspace_name, package_manifest)),
            "%{module_linker}": shell.quote("%s/dist/bundle.js" % runfile_path(workspace_name, module_linker_cjs.package)),
            "%{runtime}": shell.quote("%s/dist/bundle.js" % runfile_path(workspace_name, runtime_cjs.package)),
        },
        is_executable = True,
    )

    symlinks = modules_links(
        files = depset(transitive = [js_info.transitive_files for js_info in js_deps]).to_list(),
        packages = transitive_packages.to_list(),
        prefix = NODE_MODULES_PREFIX,
        workspace_name = workspace_name,
    )

    runfiles = ctx.runfiles(
        files =
            [
                nodejs_toolchain.nodejs.bin,
                package_manifest,
            ],
        transitive_files = depset(transitive = [esm_linker_js.transitive_files, module_linker_js.transitive_files, runtime_js.transitive_files]),
        root_symlinks = symlinks,
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
            providers = [CjsInfo, JsInfo],
        ),
        "env": attr.string_dict(
            doc = "Environment variables",
        ),
        "main": attr.string(
            mandatory = True,
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
            default = "//nodejs:runner",
        ),
        "_runtime": attr.label(
            default = "//nodejs/runtime:dist_lib",
            providers = [CjsInfo, JsInfo],
        ),
    },
    doc = "Node.js binary",
    executable = True,
    implementation = _nodejs_binary_implementation,
    toolchains = ["@better_rules_javascript//nodejs:toolchain_type"],
)

def _archive_files(packages, files, workspace_name, links = []):
    result = {}
    link_paths = {cjs_info.package.path: None for cjs_info in links}
    packages_dict = {package.short_path: package for package in packages}
    for file in files:
        parts = file.short_path.split("/")
        found = False
        for i in reversed(range(len(parts) + 1)):
            root = "/".join(parts[:i])
            package = packages_dict.get(root, None)
            if package != None:
                found = True
                if package.path in link_paths:
                    break
                package_root = package_path_name(workspace_name, package.short_path)
                path = ".packages/%s" % "/".join([package_root] + parts[i:])
                result[path] = file
                break
        if not found:
            print(packages_dict.keys())
            fail("No packages found for file %s" % file.short_path)
    return result

def _node_package_path(workspace_name, package):
    return ".packages/%s" % package_path_name(workspace_name, package.short_path)

def _nodejs_archive_impl(ctx):
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

    files = _archive_files(
        links = links,
        files = transitive_files.to_list(),
        packages = transitive_packages.to_list(),
        workspace_name = workspace_name,
    )

    manifest = actions.declare_file("%s.packages.json" % name)

    def package_path(package):
        return _node_package_path(workspace_name, package)

    gen_manifest(
        actions = actions,
        deps = transitive_links,
        manifest = manifest,
        manifest_bin = manifest_bin,
        package_path = package_path,
        packages = transitive_packages,
    )

    archive = actions.declare_file("%s.tar" % name)

    link_paths = {cjs_info.package.path: None for cjs_info in links}

    file_args = actions.args()
    file_args.use_param_file("@%s")
    file_args.set_param_file_format("multiline")
    for name, file in files.items():
        file_args.add("--file")
        file_args.add(name)
        file_args.add(file.path)

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

nodejs_archive = rule(
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
    implementation = _nodejs_archive_impl,
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
            default = ":install_runner",
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
    label = ctx.label
    node_options = ctx.attr.node_options
    manifest_bin = ctx.attr._manifest[DefaultInfo]
    archive_runner = ctx.file._archive_runner
    js_info = ctx.attr.dep[0][JsInfo]
    workspace_name = ctx.workspace_name

    main_module = "%s/%s" % (package_path_name(workspace_name, cjs_info.package.short_path), main)

    bin = actions.declare_file(name)
    actions.expand_template(
        template = archive_runner,
        output = bin,
        substitutions = {
            "%{env}": " ".join(["%s=%s" % (name, shell.quote(value)) for name, value in env.items()]),
            "%{main_module}": shell.quote(main_module),
            "%{node_options}": " ".join([shell.quote(option) for option in ctx.attr.node_options]),
        },
        is_executable = True,
    )

    files = _archive_files(
        files = js_info.transitive_files.to_list(),
        packages = cjs_info.transitive_packages.to_list(),
        workspace_name = workspace_name,
    )

    manifest = actions.declare_file("%s.packages.json" % name)

    def package_path(package):
        return _node_package_path(workspace_name, package)

    gen_manifest(
        actions = actions,
        deps = cjs_info.transitive_links,
        manifest = manifest,
        manifest_bin = manifest_bin,
        package_path = package_path,
        packages = cjs_info.transitive_packages,
    )

    archive = actions.declare_file("%s.tar" % name)

    file_args = actions.args()
    file_args.use_param_file("@%s")
    file_args.set_param_file_format("multiline")
    file_args.add("--file", "bin")
    file_args.add(bin)

    for name, file in files.items():
        file_args.add("--file", name)
        file_args.add(file.path)

    args = actions.args()
    args.add("--manifest", manifest)
    args.add(archive)

    actions.run(
        arguments = [file_args, args],
        inputs = depset([bin, manifest], transitive = [js_info.transitive_files]),
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
            default = "//nodejs:archive_runner",
        ),
        "_manifest": attr.label(
            cfg = "exec",
            executable = True,
            default = "//commonjs/manifest:bin",
        ),
    },
    implementation = _nodejs_binary_archive_impl,
)
