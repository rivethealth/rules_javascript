load("@bazel_skylib//lib:shell.bzl", "shell")
load("//rules/module/bzl:providers.bzl", "PackageInfo")
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
    package_info = ctx.attr.dep[PackageInfo]

    bin, runfiles = create_nodejs_binary(
        ctx,
        package_info,
        ctx.attr.main,
        struct(
            loader = ctx.file._loader,
            launcher = ctx.file._launcher,
            bash_runfiles = ctx.files._bash_runfiles,
        ),
    )

    default_info = DefaultInfo(executable = bin, runfiles = ctx.runfiles(transitive_files = runfiles))
    return default_info

def create_nodejs_binary(ctx, package_info, main, helpers):
    nodejs_toolchain = ctx.toolchains["@better_rules_javascript//rules/nodejs:toolchain_type"]

    packages_manifest = ctx.actions.declare_file("%s/packages-manifest.txt" % ctx.label.name)
    package_args = ctx.actions.args()
    package_args.set_param_file_format("multiline")
    package_args.add_all(package_info.transitive_packages, map_each = _package_arg)
    ctx.actions.write(packages_manifest, package_args)

    bin = ctx.actions.declare_file("%s/bin" % ctx.label.name)
    ctx.actions.expand_template(
        template = helpers.launcher,
        output = bin,
        substitutions = {
            "%{loader}": shell.quote(runfile_path(ctx, helpers.loader)),
            "%{main_module}": shell.quote("<main>/%s" % main if main else "<main>"),
            "%{main_package}": shell.quote(str(package_info.id)),
            "%{node}": shell.quote(runfile_path(ctx, nodejs_toolchain.nodejs.bin)),
            "%{packages_manifest}": shell.quote(runfile_path(ctx, packages_manifest)),
            "%{workspace}": shell.quote(ctx.workspace_name),
        },
        is_executable = True,
    )
    runfiles = depset(
        helpers.bash_runfiles + [nodejs_toolchain.nodejs.bin, helpers.loader, packages_manifest],
        transitive = [
            package_info.transitive_files,
            package_info.transitive_source_maps,
        ],
    )

    return bin, runfiles

nodejs_binary = rule(
    attrs = {
        "dep": attr.label(mandatory = True, providers = [PackageInfo]),
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
        "_loader": attr.label(
            allow_single_file = True,
            default = "//rules/nodejs:loader.js",
        ),
    },
    executable = True,
    implementation = _nodejs_binary_implementation,
    toolchains = ["@better_rules_javascript//rules/nodejs:toolchain_type"],
)
