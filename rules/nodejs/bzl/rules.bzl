load("@bazel_skylib//lib:shell.bzl", "shell")
load("//rules/javascript/bzl:providers.bzl", "JsInfo", "create_js", "create_package", "create_package_dep", "merge_js")
load("//rules/util/bzl:path.bzl", "runfile_path")
load("//rules/util/bzl:json.bzl", "json")

def _package_arg(package):
    arg = struct(
        id = package.id,
        name = package.name,
        main = package.main,
        modules = tuple([struct(name = module.name, file = module.file.path) for module in package.modules]),
        deps = [struct(id = str(dep.id), name = dep.name) for dep in package.deps],
    )
    return json.encode(struct(type = "PACKAGE", value = arg))

def _package_run_arg(package):
    arg = struct(
        id = package.id,
        name = package.name,
        main = package.main,
        modules = tuple([struct(name = module.name, file = module.file.short_path) for module in package.modules]),
        deps = [struct(id = str(dep.id), name = dep.name) for dep in package.deps],
    )
    return json.encode(struct(type = "PACKAGE", value = arg))

def _global_arg(id):
    return json.encode(struct(type = "GLOBAL", value = id))

def _nodejs_binary_implementation(ctx):
    js_info = ctx.attr.dep[JsInfo]

    bin, runfiles = create_nodejs_binary(
        ctx,
        js_info,
        ctx.attr.main,
        struct(
            bash_runfiles = ctx.files._bash_runfiles,
            launcher = ctx.file._launcher,
            resolver = ctx.file._resolver,
            shim = ctx.file._shim,
        ),
    )

    default_info = DefaultInfo(executable = bin, runfiles = ctx.runfiles(transitive_files = runfiles))
    return default_info

def write_packages_manifest(ctx, file, js_info):
    package_args = ctx.actions.args()
    package_args.set_param_file_format("multiline")
    package_args.add_all(js_info.transitive_packages, map_each = _package_arg)
    package_args.add_all(js_info.global_package_ids, map_each = _global_arg)
    ctx.actions.write(file, package_args)

def write_packages_run_manifest(ctx, file, js_info):
    package_args = ctx.actions.args()
    package_args.set_param_file_format("multiline")
    package_args.add_all(js_info.transitive_packages, map_each = _package_run_arg)
    package_args.add_all(js_info.global_package_ids, map_each = _global_arg)
    ctx.actions.write(file, package_args)

def create_nodejs_binary(ctx, js_info, main, helpers):
    nodejs_toolchain = ctx.toolchains["@better_rules_javascript//rules/nodejs:toolchain_type"]

    package_deps = [create_package_dep(js_info.name, id) for id in js_info.ids]
    package = create_package("", js_info.name, deps = tuple(package_deps))
    js_info = create_js(package, deps = [js_info])

    packages_manifest = ctx.actions.declare_file("%s/packages-manifest.txt" % ctx.label.name)
    write_packages_run_manifest(ctx, packages_manifest, js_info)

    bin = ctx.actions.declare_file("%s/bin" % ctx.label.name)
    ctx.actions.expand_template(
        template = helpers.launcher,
        output = bin,
        substitutions = {
            "%{main_module}": shell.quote("%s/%s" % (js_info.name, main) if main else js_info.name),
            "%{node}": shell.quote(runfile_path(ctx, nodejs_toolchain.nodejs.bin)),
            "%{packages_manifest}": shell.quote(runfile_path(ctx, packages_manifest)),
            "%{resolver}": shell.quote(runfile_path(ctx, helpers.resolver)),
            "%{shim}": shell.quote(runfile_path(ctx, helpers.shim)),
            "%{workspace}": shell.quote(ctx.workspace_name),
        },
        is_executable = True,
    )
    runfiles = depset(
        helpers.bash_runfiles + [nodejs_toolchain.nodejs.bin, helpers.shim, helpers.resolver, packages_manifest],
        transitive = [
            js_info.transitive_files,
            js_info.transitive_source_maps,
        ],
    )

    return bin, runfiles

nodejs_binary = rule(
    attrs = {
        "dep": attr.label(mandatory = True, providers = [JsInfo]),
        "main": attr.string(
            default = "",
        ),
        "_bash_runfiles": attr.label(
            allow_files = True,
            default = "@bazel_tools//tools/bash/runfiles",
        ),
        "_launcher": attr.label(
            allow_single_file = True,
            default = "//rules/nodejs:node_launcher.sh.tpl",
        ),
        "_resolver": attr.label(
            allow_single_file = True,
            default = "//rules/javascript:resolver.js",
        ),
        "_shim": attr.label(
            allow_single_file = True,
            default = "//rules/nodejs:shim.js",
        ),
    },
    executable = True,
    implementation = _nodejs_binary_implementation,
    toolchains = ["@better_rules_javascript//rules/nodejs:toolchain_type"],
)

def _nodejs_runner_implementation(ctx):
    nodejs_toolchain = ctx.toolchains["@better_rules_javascript//rules/nodejs:toolchain_type"]

    bin = ctx.actions.declare_file("%s/bin" % ctx.label.name)

    ctx.actions.expand_template(
        template = ctx.file._runner,
        output = bin,
        substitutions = {
            "%{node}": shell.quote(runfile_path(ctx, nodejs_toolchain.nodejs.bin)),
            "%{resolver}": shell.quote(runfile_path(ctx, ctx.file._resolver)),
            "%{shim}": shell.quote(runfile_path(ctx, ctx.file._shim)),
            "%{workspace}": shell.quote(ctx.workspace_name),
        },
        is_executable = True,
    )
    runfiles = depset(ctx.files._bash_runfiles + [nodejs_toolchain.nodejs.bin, ctx.file._shim, ctx.file._resolver])

    default_info = DefaultInfo(executable = bin, runfiles = ctx.runfiles(transitive_files = runfiles))
    return default_info

nodejs_runner = rule(
    attrs = {
        "_bash_runfiles": attr.label(
            allow_files = True,
            default = "@bazel_tools//tools/bash/runfiles",
        ),
        "_runner": attr.label(
            allow_single_file = True,
            default = "//rules/nodejs:runner.sh.tpl",
        ),
        "_resolver": attr.label(
            allow_single_file = True,
            default = "//rules/javascript:resolver.js",
        ),
        "_shim": attr.label(
            allow_single_file = True,
            default = "//rules/nodejs:shim.js",
        ),
    },
    executable = True,
    implementation = _nodejs_runner_implementation,
    toolchains = ["@better_rules_javascript//rules/nodejs:toolchain_type"],
)
