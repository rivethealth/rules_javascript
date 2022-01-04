load("@bazel_skylib//lib:shell.bzl", "shell")
load("//commonjs:providers.bzl", "CjsEntries", "create_dep", "create_global", "create_package", "gen_manifest", "package_path")
load("//javascript:providers.bzl", "JsInfo")
load("//util:path.bzl", "output", "runfile_path")
load(":providers.bzl", "NODE_MODULES_PREFIX", "modules_links", "package_path_name")

def _nodejs_simple_binary_implementation(ctx):
    nodejs_toolchain = ctx.toolchains["@better_rules_javascript//nodejs:toolchain_type"]

    bin = ctx.actions.declare_file("%s/bin" % ctx.label.name)
    ctx.actions.expand_template(
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
    env = ctx.attr.env
    js_info = ctx.attr.dep[JsInfo]
    js_deps = [js_info] + [dep[JsInfo] for dep in ctx.attr.global_deps + ctx.attr.other_deps]
    js_globals = [dep[JsInfo] for dep in ctx.attr.global_deps]
    name = ctx.label.name
    node_options = ctx.attr.node_options

    nodejs_toolchain = ctx.toolchains["@better_rules_javascript//nodejs:toolchain_type"]

    files = []
    for js_info_ in js_deps:
        files.append(js_info_.transitive_descriptors)
        files.append(js_info_.transitive_js)
        if ctx.attr.include_sources:
            files.append(js_info_.transitive_srcs)

    transitive_packages = depset(transitive = [dep.transitive_packages for dep in js_deps])

    def package_path(package):
        return "%s/%s" % (NODE_MODULES_PREFIX, package_path_name(package.id))

    package_manifest = ctx.actions.declare_file("%s/packages.json" % ctx.label.name)
    gen_manifest(
        actions = ctx.actions,
        manifest_bin = ctx.attr._manifest[DefaultInfo],
        manifest = package_manifest,
        packages = transitive_packages,
        deps = depset(transitive = [dep.transitive_deps for dep in js_deps]),
        globals = [create_global(id = dep.package.id, name = dep.name) for dep in js_globals],
        package_path = package_path,
    )

    main_module = "%s/%s/%s" % (NODE_MODULES_PREFIX, package_path_name(js_info.package.id), ctx.attr.main)

    bin = ctx.actions.declare_file("%s/bin" % ctx.label.name)
    for file in ctx.files.preload:
        node_options.append("-r")
        node_options.append("./%s" % file.short_path)

    ctx.actions.expand_template(
        template = ctx.file._runner,
        output = bin,
        substitutions = {
            "%{env}": " ".join(["%s=%s" % (name, shell.quote(value)) for name, value in env.items()]),
            "%{esm_loader}": shell.quote(runfile_path(ctx.workspace_name, ctx.file._esm_linker)),
            "%{main_module}": shell.quote(main_module),
            "%{node}": shell.quote(runfile_path(ctx.workspace_name, nodejs_toolchain.nodejs.bin)),
            "%{node_options}": " ".join([shell.quote(option) for option in ctx.attr.node_options]),
            "%{package_manifest}": shell.quote(runfile_path(ctx.workspace_name, package_manifest)),
            "%{module_linker}": shell.quote(runfile_path(ctx.workspace_name, ctx.file._module_linker)),
            "%{runtime}": shell.quote(runfile_path(ctx.workspace_name, ctx.file._runtime)),
        },
        is_executable = True,
    )

    symlinks = modules_links(
        prefix = NODE_MODULES_PREFIX,
        packages = transitive_packages.to_list(),
        files = depset(transitive = files).to_list(),
    )

    runfiles = ctx.runfiles(
        files = [nodejs_toolchain.nodejs.bin, ctx.file._runtime, ctx.file._esm_linker, ctx.file._module_linker, package_manifest] + ctx.files.preload + ctx.files.data,
        root_symlinks = symlinks,
    )

    for dep in ctx.attr.data:
        if DefaultInfo not in dep:
            continue
        if dep[DefaultInfo].default_runfiles != None:
            runfiles = runfiles.merge(dep[DefaultInfo].default_runfiles)

    default_info = DefaultInfo(
        executable = bin,
        runfiles = runfiles,
    )

    return [default_info]

nodejs_binary = rule(
    attrs = {
        "data": attr.label_list(
            allow_files = True,
            providers = [DefaultInfo],
            doc = "Runtime data",
        ),
        "dep": attr.label(mandatory = True, providers = [JsInfo]),
        "global_deps": attr.label_list(providers = [JsInfo]),
        "env": attr.string_dict(
            doc = "Environment variables",
        ),
        "main": attr.string(
            mandatory = True,
        ),
        "node_options": attr.string_list(
        ),
        "include_sources": attr.bool(
            default = True,
        ),
        "other_deps": attr.label_list(providers = [JsInfo]),
        "preload": attr.label_list(
            allow_files = [".js"],
            doc = "Preload modules",
        ),
        "_esm_linker": attr.label(
            allow_single_file = [".js"],
            default = "//nodejs/esm-linker:file",
        ),
        "_runner": attr.label(
            allow_single_file = True,
            default = "//nodejs:runner",
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

def _nodejs_archive_impl(ctx):
    archive_linker = ctx.attr._archive_linker[DefaultInfo]
    manifest = ctx.attr._manifest[DefaultInfo]
    deps = [dep[CjsEntries] for dep in ctx.attr.deps]

    package = create_package(
        id = "_",
        name = "",
        path = "_",
        short_path = "_",
        label = ctx.label,
    )

    package_deps = [
        create_dep(id = "_", dep = dep[CjsEntries].package.id, name = dep[CjsEntries].name, label = dep.label)
        for dep in ctx.attr.deps
    ]

    transitive_deps = depset(
        package_deps,
        transitive = [cjs_entries.transitive_deps for cjs_entries in deps],
    )
    transitive_files = depset(
        transitive = [cjs_entries.transitive_files for cjs_entries in deps],
    )
    transitive_packages = depset(
        [package],
        transitive = [cjs_entries.transitive_packages for cjs_entries in deps],
    )

    package_manifest = ctx.actions.declare_file("%s/packages.json" % ctx.label.name)
    gen_manifest(
        actions = ctx.actions,
        manifest_bin = manifest,
        manifest = package_manifest,
        packages = transitive_packages,
        deps = transitive_deps,
        globals = [],
        package_path = package_path,
    )

    archive = ctx.actions.declare_file("%s/modules.tar" % ctx.attr.name)

    args = ctx.actions.args()
    args.use_param_file("@%s")
    args.set_param_file_format("multiline")
    args.add("--manifest", package_manifest)
    args.add("--root", "_")
    args.add("--output", archive)
    args.add_all(transitive_files)

    ctx.actions.run(
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
            providers = [CjsEntries],
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
