load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_file")
load("//commonjs:workspace.bzl", "cjs_npm_plugin")
load("//javascript:workspace.bzl", "js_npm_plugin")

def _npm_import_external_impl(ctx, plugins):
    deps = [struct(id = dep["id"], name = dep["name"]) for dep in [json.decode(d) for d in ctx.attr.deps]]
    extra_deps = {id: [json.decode(d) for d in deps] for id, deps in ctx.attr.extra_deps.items()}
    package_name = ctx.attr.package_name

    ctx.extract(
        archive = ctx.attr.package,
        output = "tmp",
    )

    # packages can have different prefixes
    mv_result = ctx.execute(["sh", "-c", "mv tmp/* npm && rm -fr npm/node_modules"])
    if mv_result.return_code:
        fail("Could not extract package")

    ctx.execute(["rm", "-r", "tmp"])

    patch_args = "--directory=npm --strip=1 --forward --reject-file=-"
    for patch in ctx.attr.patches:
        patch_result = ctx.execute([
            "sh", "-c", "patch %s < %s" % (patch_args, ctx.path(patch)),
        ])
        # Ignore return code 2, which signals the patch has already been applied
        if patch_result.return_code != 0 and patch_result.return_code != 2:
            fail("Could not apply patch %s: %s" % (patch, patch_result.stderr))

    files_result = ctx.execute(["find", "npm", "-type", "f"])
    if files_result.return_code:
        fail("Could not list files")
    files = [file[len("npm/"):] for file in files_result.stdout.split("\n")]

    final_package_path = ctx.attr.package
    if ctx.attr.patches:
        tar_result = ctx.execute([
            "tar", "czf", "patched-package.tgz", "--strip-components=1", "npm/"
        ])
        if tar_result.return_code:
            fail("Could not tar up patched-package.tgz")
        final_package_path = "patched-package.tgz"

    # Don't leave the package contents sitting around now that we're done. Bazel
    # builds will always extract from the .tgz file, so anyone wanting to tinker
    # should go poke at the .tgz.
    ctx.execute(["rm", "-r", "npm/"])

    build = ""

    package = struct(
        archive = final_package_path,
        deps = deps,
        extra_deps = extra_deps,
        name = package_name,
    )

    for plugin in plugins:
        content = plugin.package_build(package, files)
        if content:
            build += content
            build += "\n"

    ctx.file("BUILD.bazel", build)

def npm_import_external_rule(plugins):
    """Create a npm_import_external rule."""

    def impl(ctx):
        _npm_import_external_impl(ctx, plugins)

    return repository_rule(
        implementation = impl,
        attrs = {
            "deps": attr.string_list(
                doc = "Dependencies.",
            ),
            "extra_deps": attr.string_list_dict(
                doc = "Extra dependencies.",
            ),
            "package": attr.label(
                mandatory = True,
            ),
            "package_name": attr.string(
                doc = "Package name.",
                mandatory = True,
            ),
            "patches": attr.label_list(
                allow_files = True,
                mandatory = True,
            ),
        },
    )

def _npm_import_impl(ctx, plugins):
    packages = ctx.attr.packages

    for package_name, repo in packages.items():
        build = ""

        for plugin in plugins:
            content = plugin.alias_build(package_name, repo)
            if content:
                build += content
                build += "\n"

        ctx.file("%s/BUILD.bazel" % package_name, build)

def npm_import_rule(plugins):
    """Create an npm import rule."""

    def impl(ctx):
        _npm_import_impl(ctx, plugins)

    return repository_rule(
        implementation = impl,
        attrs = {
            "packages": attr.string_dict(
                mandatory = True,
                doc = "Packages.",
            ),
        },
    )

def package_repo_name(prefix, name):
    """Repository name for npm package.

    Replaces characters not permitted in Bazel repository names.

    Args:
        prefix: Namespace
        name: ID
    """
    if name.startswith("@"):
        name = name[len("@"):]
    name = name.replace("@", "_")
    name = name.replace("/", "_")
    return "%s_%s" % (prefix, name)

DEFAULT_PLUGINS = [
    cjs_npm_plugin(),
    js_npm_plugin(),
]

def npm(name, packages, roots, plugins = DEFAULT_PLUGINS, auth_patterns = None, netrc = None):
    """Npm repositories.

    Args:
        name: Namespace
        packages: Packages
        roots: Roots
        plugins: Plugins
        auth_patterns: Auth patterns
        netrc: Netrc
    """

    npm_import_external = npm_import_external_rule(plugins)
    npm_import = npm_import_rule(plugins)

    for id, package in packages.items():
        repo_name = package_repo_name(name, id)

        extra_deps = {
            package_repo_name(name, id): [json.encode({"id": package_repo_name(name, d["id"]), "name": d.get("name")}) for d in deps]
            for id, deps in package["extra_deps"].items()
        }
        if "file" in package:
            file = package["file"]
        elif "url" in package:
            package_repo = "%s.package" % repo_name
            http_file(
                name = package_repo,
                auth_patterns = auth_patterns,
                integrity = package.get("integrity"),
                downloaded_file_path = "package.tgz",
                netrc = netrc,
                url = package["url"],
            )
            file = "@%s//file:package.tgz" % package_repo
        npm_import_external(
            name = repo_name,
            package = file,
            package_name = package["name"],
            patches = package.get("patches", []),
            deps = [json.encode({"id": package_repo_name(name, dep["id"]), "name": dep.get("name")}) for dep in package["deps"]],
            extra_deps = extra_deps,
        )
    root_packages = {root["name"]: package_repo_name(name, root["id"]) for root in roots}
    npm_import(name = name, packages = root_packages)
