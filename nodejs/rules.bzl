load("@bazel_skylib//lib:shell.bzl", "shell")
load("//commonjs:providers.bzl", "CjsInfo", "create_package", "gen_manifest", "package_path")
load("//javascript:providers.bzl", "JsInfo", "create_js_info")
load("//util:path.bzl", "output", "runfile_path")
load(":providers.bzl", "NODE_MODULES_PREFIX", "modules_links", "package_path_name")

def _nodejs_simple_binary_implementation(ctx):
    actions = ctx.actions
    nodejs_toolchain = ctx.toolchains["@better_rules_javascript//nodejs:toolchain_type"]

    bin = actions.declare_file("%s/bin" % ctx.label.name)
    actions.expand_template(
        template = ctx.file._runner,
        output = bin,
        substitutions = {
            "%{module}": shell.quote(runfile_path(ctx.workspace_name, ctx.file.src)),
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
        "src": attr.label(mandatory = True, allow_single_file = [".js"], doc = "Source file"),
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
    module_linker = ctx.file._module_linker
    name = ctx.attr.name
    node_options = ctx.attr.node_options
    esm_linker = ctx.file._esm_linker
    runner = ctx.file._runner
    runtime = ctx.file._runtime
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
            "%{esm_loader}": shell.quote(runfile_path(workspace_name, esm_linker)),
            "%{main_module}": shell.quote(main_module),
            "%{node}": shell.quote(runfile_path(workspace_name, nodejs_toolchain.nodejs.bin)),
            "%{node_options}": " ".join([shell.quote(option) for option in node_options]),
            "%{package_manifest}": shell.quote(runfile_path(workspace_name, package_manifest)),
            "%{module_linker}": shell.quote(runfile_path(workspace_name, module_linker)),
            "%{runtime}": shell.quote(runfile_path(workspace_name, runtime)),
        },
        is_executable = True,
    )

    # TODO: remove once scripts are cjs
    package_json = actions.declare_file("%s.package.json" % ctx.attr.name)
    ctx.actions.write(package_json, "{}")

    js_info = create_js_info(deps = js_deps)
    symlinks = modules_links(
        files = js_info.transitive_files.to_list(),
        packages = transitive_packages.to_list(),
        prefix = NODE_MODULES_PREFIX,
        workspace_name = workspace_name,
    )
    symlinks["package.json"] = package_json

    runfiles = ctx.runfiles(
        files =
            [
                nodejs_toolchain.nodejs.bin,
                runtime,
                esm_linker,
                module_linker,
                package_manifest,
            ],
        root_symlinks = symlinks,
    )
    runfiles = runfiles.merge_all([dep[DefaultInfo].default_runfiles for dep in ctx.attr.data if dep[DefaultInfo].default_runfiles != None])

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
            allow_single_file = [".js"],
            default = "//nodejs/esm-linker:file",
        ),
        "_module_linker": attr.label(
            allow_single_file = True,
            default = "//nodejs/module-linker:file",
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
            allow_single_file = [".js"],
            default = "//nodejs/runtime:file",
        ),
    },
    doc = "Node.js binary",
    executable = True,
    implementation = _nodejs_binary_implementation,
    toolchains = ["@better_rules_javascript//nodejs:toolchain_type"],
)

CjsEntries = provider()  # TODO: remove
create_link = None
create_global = None

def _nodejs_archive_impl(ctx):
    actions = ctx.actions
    archive_linker = ctx.attr._archive_linker[DefaultInfo]
    manifest = ctx.attr._manifest[DefaultInfo]
    deps = [dep[CjsEntries] for dep in ctx.attr.deps]
    links = [dep[CjsInfo] for dep in ctx.attr.links]
    name = ctx.attr.name

    package = create_package(
        name = "",
        path = "_",
        short_path = "_",
        label = ctx.label,
    )

    package_deps = [
        create_link(id = "_", dep = dep[CjsEntries].package.id, name = dep[CjsEntries].name, label = dep.label)
        for dep in ctx.attr.deps
    ] + [
        create_link(id = "_", dep = dep[CjsInfo].package.id, name = dep[CjsInfo].name, label = dep.label)
        for dep in ctx.attr.links
    ]

    transitive_links = depset(
        package_deps,
        transitive = [cjs_entries.transitive_links for cjs_entries in deps],
    )
    transitive_files = depset(
        transitive = [cjs_entries.transitive_files for cjs_entries in deps],
    )
    transitive_packages = depset(
        [package] + [dep.package for dep in links],
        transitive = [cjs_entries.transitive_packages for cjs_entries in deps],
    )

    package_manifest = actions.declare_file("%s.packages.json" % name)
    gen_manifest(
        actions = actions,
        manifest_bin = manifest,
        manifest = package_manifest,
        packages = transitive_packages,
        deps = transitive_links,
        globals = [],
        package_path = package_path,
    )

    archive = actions.declare_file("%s.tar" % name)

    args = actions.args()
    args.use_param_file("@%s")
    args.set_param_file_format("multiline")
    for dep in links:
        args.add("--link", dep.package.id)
        args.add("../%s" % dep.package.short_path)
    args.add("--manifest", package_manifest)
    args.add("--root", "_")
    args.add("--output", archive)
    args.add_all(transitive_files)

    actions.run(
        arguments = [args],
        inputs = depset([package_manifest], transitive = [transitive_files]),
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
            providers = [CjsEntries],
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
            executable = True,
            default = "//nodejs/archive-linker:bin",
        ),
        "_manifest": attr.label(
            cfg = "exec",
            executable = True,
            default = "//commonjs/manifest:bin",
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
    env = ctx.attr.env
    name = ctx.attr.name
    node_options = ctx.attr.node_options
    manifest = ctx.attr._manifest[DefaultInfo]
    js_globals = [dep[JsInfo] for dep in ctx.attr.global_deps]
    archive_runner = ctx.file._archive_runner
    js_info = ctx.attr.dep[0][JsInfo]
    deps = [js_info] + js_globals
    workspace_name = workspace_name

    transitive_links = depset(
        transitive = [js_info.transitive_links for js_info in deps],
    )
    transitive_files = depset(
        transitive = [js_info.transitive_files for js_info in deps],
    )
    transitive_packages = depset(
        transitive = [js_info.transitive_packages for js_info in deps],
    )
    transitive_srcs = depset(
        transitive = [js_info.transitive_srcs for js_info in deps],
    )

    main_module = "%s/%s" % (package_path_name(workspace_name, js_info.package.id), ctx.attr.main)

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

    package_manifest = actions.declare_file("%s.packages.json" % name)
    gen_manifest(
        actions = actions,
        manifest_bin = manifest,
        manifest = package_manifest,
        packages = transitive_packages,
        deps = transitive_links,
        globals = [create_global(id = dep.package.id, name = dep.name) for dep in js_globals],
        package_path = package_path,
    )

    archive = actions.declare_file("%s.tar" % name)

    args = actions.args()
    args.use_param_file("@%s")
    args.set_param_file_format("multiline")
    args.add("--bin", bin)
    args.add("--manifest", package_manifest)
    args.add("--output", archive)
    args.add_all(transitive_files)
    args.add_all(transitive_srcs)

    actions.run(
        arguments = [args],
        inputs = depset([bin, package_manifest], transitive = [transitive_files, transitive_srcs]),
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
            providers = [JsInfo],
        ),
        "env": attr.string_dict(
            doc = "Environment variables",
        ),
        "global_deps": attr.label_list(
            cfg = _nodejs_transition,
            providers = [JsInfo],
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
