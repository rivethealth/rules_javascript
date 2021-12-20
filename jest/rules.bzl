load("@bazel_skylib//lib:shell.bzl", "shell")
load("//commonjs:providers.bzl", "create_global")
load("//commonjs:rules.bzl", "gen_manifest", "package_short_path")
load("//javascript:providers.bzl", "JsFile", "JsInfo")
load("//util:path.bzl", "runfile_path")

def _jest_test_impl(ctx):
    env = ctx.attr.env
    manifest_bin = ctx.attr._manifest[DefaultInfo]
    config_dep = ctx.attr.config[JsInfo]
    config = ctx.attr.config[JsFile]
    js_info = ctx.attr.jest[JsInfo]
    js_deps = [js_info] + [dep[JsInfo] for dep in ctx.attr.deps + ctx.attr.global_deps + [ctx.attr.config]]
    js_globals = [dep[JsInfo] for dep in ctx.attr.global_deps]

    nodejs_toolchain = ctx.toolchains["@better_rules_javascript//nodejs:toolchain_type"]

    files = []
    for js_info_ in [js_info] + js_deps:
        files.append(js_info_.transitive_descriptors)
        files.append(js_info_.transitive_js)
        files.append(js_info_.transitive_srcs)

    package_manifest = ctx.actions.declare_file("%s/packages.json" % ctx.label.name)
    gen_manifest(
        actions = ctx.actions,
        deps = depset(transitive = [dep.transitive_deps for dep in js_deps]),
        globals = [create_global(id = dep.package.id, name = dep.name) for dep in js_globals],
        manifest = package_manifest,
        manifest_bin = manifest_bin,
        packages = depset(transitive = [dep.transitive_packages for dep in js_deps]),
        package_path = package_short_path,
    )

    main_module = "%s/bin/jest.js" % (runfile_path(ctx, js_info.package))

    config_file = ctx.actions.declare_file("%s/jestconfig.js" % ctx.attr.name)
    ctx.actions.expand_template(
        template = ctx.file._config,
        output = config_file,
        substitutions = {
            '"%{config}"': json.encode("%s/%s" % (runfile_path(ctx, config_dep.package), config.path)),
            '"%{roots}"': json.encode(json.encode([runfile_path(ctx, dep[JsInfo].package) for dep in ctx.attr.deps])),
        },
    )

    bin = ctx.actions.declare_file("%s/bin" % ctx.label.name)
    ctx.actions.expand_template(
        template = ctx.file._runner,
        output = bin,
        substitutions = {
            "%{config}": runfile_path(ctx, config_file),
            "%{env}": " ".join(["%s=%s" % (name, shell.quote(value)) for name, value in env.items()]),
            "%{fs_linker}": shell.quote(runfile_path(ctx, ctx.file._fs_linker)),
            "%{main_module}": shell.quote(main_module),
            "%{node}": shell.quote(runfile_path(ctx, nodejs_toolchain.nodejs.bin)),
            "%{package_manifest}": shell.quote(runfile_path(ctx, package_manifest)),
            "%{module_linker}": shell.quote(runfile_path(ctx, ctx.file._module_linker)),
            "%{workspace}": shell.quote(ctx.workspace_name),
        },
        is_executable = True,
    )

    default_info = DefaultInfo(
        executable = bin,
        runfiles = ctx.runfiles(
            files = [config_file, nodejs_toolchain.nodejs.bin, ctx.file._fs_linker, ctx.file._module_linker, package_manifest] + ctx.files.data,
            transitive_files = depset(transitive = files),
        ),
    )

    return [default_info]

jest_test = rule(
    attrs = {
        "config": attr.label(
            doc = "Jest config file.",
            mandatory = True,
            providers = [[JsFile, JsInfo]],
        ),
        "data": attr.label_list(
            allow_files = True,
            doc = "Runtime data.",
        ),
        "deps": attr.label_list(
            doc = "Test dependencies.",
            providers = [JsInfo],
        ),
        "env": attr.string_dict(
            doc = "Environment variables.",
        ),
        "jest": attr.label(
            doc = "Jest dependency.",
            mandatory = True,
        ),
        "global_deps": attr.label_list(
            doc = "Global dependencies.",
            providers = [JsInfo],
        ),
        "_config": attr.label(
            allow_single_file = [".js"],
            default = "//jest/config:bundle",
        ),
        "_runner": attr.label(
            allow_single_file = True,
            default = "//jest:runner",
        ),
        "_fs_linker": attr.label(
            allow_single_file = True,
            default = "//nodejs/fs-linker:file",
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
    implementation = _jest_test_impl,
    test = True,
    toolchains = ["@better_rules_javascript//nodejs:toolchain_type"],
)
