load("@bazel_skylib//lib:shell.bzl", "shell")
load("//rules/javascript/bzl:providers.bzl", "JsPackage")
load("//rules/util/bzl:path.bzl", "runfile_path")
load("//rules/util/bzl:json.bzl", "json")

def _package_arg(package):
    arg = struct(
        id = str(package.id),
        name = package.name,
        main = package.main,
        modules = tuple([struct(name = module.name, file = module.file.short_path) for module in package.modules]),
        deps = [struct(id = str(dep.id), name = dep.name) for dep in package.deps],
    )
    return json.encode(arg)

def _nodejs_binary_implementation(ctx):
    js_package = ctx.attr.dep[JsPackage]

    bin, runfiles = create_nodejs_binary(
        ctx,
        js_package,
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

def create_nodejs_binary(ctx, js_package, main, helpers):
    nodejs_toolchain = ctx.toolchains["@better_rules_javascript//rules/nodejs:toolchain_type"]

    packages_manifest = ctx.actions.declare_file("%s/packages-manifest.txt" % ctx.label.name)
    package_args = ctx.actions.args()
    package_args.set_param_file_format("multiline")
    package_args.add_all(js_package.transitive_packages, map_each = _package_arg)
    ctx.actions.write(packages_manifest, package_args)

    bin = ctx.actions.declare_file("%s/bin" % ctx.label.name)
    ctx.actions.expand_template(
        template = helpers.launcher,
        output = bin,
        substitutions = {
            "%{main_module}": shell.quote("<main>/%s" % main if main else "<main>"),
            "%{main_package}": shell.quote(str(js_package.id)),
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
            js_package.transitive_files,
            js_package.transitive_source_maps,
        ],
    )

    return bin, runfiles

nodejs_binary = rule(
    attrs = {
        "dep": attr.label(mandatory = True, providers = [JsPackage]),
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
