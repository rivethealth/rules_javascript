load("@bazel_skylib//lib:shell.bzl", "shell")
load("//commonjs:providers.bzl", "create_global")
load("//commonjs:rules.bzl", "gen_manifest")
load("//javascript:providers.bzl", "JsInfo")
load("//util:path.bzl", "output", "runfile_path")

NODE_MODULES_PREFIX = "_nodejs/node_modules"

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
            default = "//nodejs:simple_runner.sh.tpl",
        ),
    },
    doc = "Node.js executable, from a single bundled file",
    executable = True,
    implementation = _nodejs_simple_binary_implementation,
    toolchains = ["@better_rules_javascript//nodejs:toolchain_type"],
)

def package_path_name(id):
    return id.replace("@", "").replace(":", "_").replace("/", "_")

def node_modules_links(packages, files):
    result = {}
    packages_dict = {package.short_path: package for package in packages}
    for file in files:
        parts = file.short_path.split("/")
        found = False
        for i in range(1, len(parts)):
            root = "/".join(parts[:i])
            if root in packages_dict:
                package = packages_dict[root]
                path = "%s/%s/%s" % (NODE_MODULES_PREFIX, package_path_name(package.id), "/".join(parts[i:]))
                result[path] = file
                found = True
                break
        if not found:
            fail("No packages found for file %s" % file.short_path)
    return result

def gen_links(actions, prefix, packages):
    links = []

    for package in packages.to_list():
        link = actions.declare_symlink("%s/%s" % (prefix, package_path_name(package.id)))
        actions.run(
            executable = "ln",
            arguments = ["-rs", package.path, link.path],
            outputs = [link],
        )
        links.append(link)

    return links

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
            "%{main_module}": shell.quote(main_module),
            "%{node}": shell.quote(runfile_path(ctx.workspace_name, nodejs_toolchain.nodejs.bin)),
            "%{node_options}": " ".join([shell.quote(option) for option in ctx.attr.node_options]),
            "%{package_manifest}": shell.quote(runfile_path(ctx.workspace_name, package_manifest)),
            "%{module_linker}": shell.quote(runfile_path(ctx.workspace_name, ctx.file._module_linker)),
            "%{workspace}": shell.quote(ctx.workspace_name),
        },
        is_executable = True,
    )

    symlinks = node_modules_links(
        packages = transitive_packages.to_list(),
        files = depset(transitive = files).to_list(),
    )

    runfiles = ctx.runfiles(
        files = [nodejs_toolchain.nodejs.bin, ctx.file._module_linker, package_manifest] + ctx.files.preload + ctx.files.data,
        transitive_files = depset([package_manifest], transitive = files),
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
        "_runner": attr.label(
            allow_single_file = True,
            default = "//nodejs:runner.sh.tpl",
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
    },
    doc = "Node.js binary",
    executable = True,
    implementation = _nodejs_binary_implementation,
    toolchains = ["@better_rules_javascript//nodejs:toolchain_type"],
)
