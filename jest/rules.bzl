load("@bazel_skylib//lib:shell.bzl", "shell")
load("//commonjs:providers.bzl", "create_dep", "create_global", "create_package", "gen_manifest")
load("//nodejs:providers.bzl", "NODE_MODULES_PREFIX", "modules_links", "package_path_name")
load("//javascript:providers.bzl", "JsInfo")
load("//util:path.bzl", "output", "runfile_path")

def _jest_transition_impl(settings, attrs):
    return {"//javascript:module": "node"}

_jest_transition = transition(
    implementation = _jest_transition_impl,
    inputs = [],
    outputs = ["//javascript:module"],
)

def _jest_test_impl(ctx):
    actions = ctx.actions
    env = ctx.attr.env
    manifest_bin = ctx.attr._manifest[DefaultInfo]
    config_dep = ctx.attr.config_dep[0][JsInfo]
    config = ctx.attr.config
    name = ctx.attr.name
    node_options = ctx.attr.node_options
    js_info = ctx.attr.jest[0][JsInfo]
    jest_haste_map = ctx.attr.jest_haste_map[0][JsInfo]
    js_deps = [config_dep, js_info, jest_haste_map] + [dep[JsInfo] for dep in ctx.attr.deps + ctx.attr.global_deps]
    js_globals = [dep[JsInfo] for dep in ctx.attr.global_deps]
    output_ = output(label = ctx.label, actions = actions)

    nodejs_toolchain = ctx.toolchains["@better_rules_javascript//nodejs:toolchain_type"]

    haste_map = actions.declare_file("%s/haste-map.js" % ctx.attr.name)
    actions.symlink(
        output = haste_map,
        target_file = ctx.file._haste_map,
        progress_message = "Copying file to %{output}",
    )

    files = []
    for js_info_ in [js_info] + js_deps:
        files.append(js_info_.transitive_files)
        files.append(js_info_.transitive_srcs)

    package = create_package(
        id = "_jestconfig",
        name = "_jestconfig",
        path = "%s/%s" % (output_.path, ctx.label.name),
        short_path = "%s/%s" % (output_.short_path, ctx.label.name),
        label = ctx.label,
    )
    deps = [create_dep(
        id = "_jestconfig",
        name = "jest-haste-map",
        dep = jest_haste_map.package.id,
        label = ctx.label,
    )]

    transitive_packages = depset([package], transitive = [dep.transitive_packages for dep in js_deps])

    def package_path(package):
        return "%s/%s" % (NODE_MODULES_PREFIX, package_path_name(package.id))

    package_manifest = actions.declare_file("%s/packages.json" % ctx.label.name)
    gen_manifest(
        actions = actions,
        deps = depset(deps, transitive = [dep.transitive_deps for dep in js_deps]),
        globals = [create_global(id = dep.package.id, name = dep.name) for dep in js_globals],
        manifest = package_manifest,
        manifest_bin = manifest_bin,
        packages = transitive_packages,
        package_path = package_path,
    )

    main_module = "%s/%s/bin/jest.js" % (NODE_MODULES_PREFIX, package_path_name(js_info.package.id))

    config_file = actions.declare_file("%s/jestconfig.js" % ctx.attr.name)
    actions.expand_template(
        template = ctx.file._config,
        output = config_file,
        substitutions = {
            '"%{config}"': json.encode(
                "%s/%s/%s" % (NODE_MODULES_PREFIX, package_path_name(config_dep.package.id), config),
            ),
            '"%{roots}"': json.encode(
                json.encode(["%s/%s" % (NODE_MODULES_PREFIX, package_path_name(dep[JsInfo].package.id)) for dep in ctx.attr.deps]),
            ),
        },
    )

    bin = actions.declare_file("%s/bin" % ctx.label.name)
    actions.expand_template(
        template = ctx.file._runner,
        output = bin,
        substitutions = {
            "%{config}": "%s/%s/jestconfig.js" % (NODE_MODULES_PREFIX, package_path_name(package.id)),
            "%{env}": " ".join(["%s=%s" % (name, shell.quote(value)) for name, value in env.items()]),
            "%{fs_linker}": shell.quote(runfile_path(ctx.workspace_name, ctx.file._fs_linker)),
            "%{main_module}": shell.quote(main_module),
            "%{node}": shell.quote(runfile_path(ctx.workspace_name, nodejs_toolchain.nodejs.bin)),
            "%{node_options}": " ".join([shell.quote(option) for option in ctx.attr.node_options]),
            "%{package_manifest}": shell.quote(runfile_path(ctx.workspace_name, package_manifest)),
            "%{module_linker}": shell.quote(runfile_path(ctx.workspace_name, ctx.file._module_linker)),
            "%{workspace}": shell.quote(ctx.workspace_name),
        },
        is_executable = True,
    )

    runfiles = ctx.runfiles(
        files = [config_file, nodejs_toolchain.nodejs.bin, ctx.file._fs_linker, ctx.file._module_linker, package_manifest, haste_map] + ctx.files.data,
        transitive_files = depset(transitive = files),
        root_symlinks = modules_links(
            prefix = NODE_MODULES_PREFIX,
            packages = transitive_packages.to_list(),
            files = depset([config_file, haste_map], transitive = files).to_list(),
        ),
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

jest_test = rule(
    attrs = {
        "_allowlist_function_transition": attr.label(
            default = "@bazel_tools//tools/allowlists/function_transition_allowlist",
        ),
        "_config": attr.label(
            allow_single_file = [".js"],
            default = "//jest/config:bundle",
        ),
        "_haste_map": attr.label(
            cfg = _jest_transition,
            allow_single_file = [".js"],
            default = "//jest:haste_map",
        ),
        "_runner": attr.label(
            allow_single_file = True,
            default = "//jest:runner",
        ),
        "_fs_linker": attr.label(
            allow_single_file = True,
            default = "//nodejs/fs-linker:file",
        ),
        "_manifest": attr.label(
            cfg = "exec",
            executable = True,
            default = "//commonjs/manifest:bin",
        ),
        "_module_linker": attr.label(
            allow_single_file = True,
            default = "//nodejs/module-linker:file",
        ),
        "config": attr.string(
            mandatory = True,
        ),
        "config_dep": attr.label(
            cfg = _jest_transition,
            doc = "Jest config file.",
            mandatory = True,
            providers = [JsInfo],
        ),
        "data": attr.label_list(
            allow_files = True,
            doc = "Runtime data.",
        ),
        "deps": attr.label_list(
            cfg = _jest_transition,
            doc = "Test dependencies.",
            providers = [JsInfo],
        ),
        "env": attr.string_dict(
            doc = "Environment variables.",
        ),
        "jest": attr.label(
            cfg = _jest_transition,
            doc = "Jest dependency.",
            mandatory = True,
            providers = [JsInfo],
        ),
        "jest_haste_map": attr.label(
            cfg = _jest_transition,
            doc = "Haste map.",
            mandatory = True,
            providers = [JsInfo],
        ),
        "global_deps": attr.label_list(
            cfg = _jest_transition,
            doc = "Global dependencies.",
            providers = [JsInfo],
        ),
        "node_options": attr.string_list(
        ),
    },
    implementation = _jest_test_impl,
    test = True,
    toolchains = ["@better_rules_javascript//nodejs:toolchain_type"],
)
