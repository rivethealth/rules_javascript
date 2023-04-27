load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_file")
load("//commonjs:workspace.bzl", "cjs_npm_plugin")
load("//javascript:workspace.bzl", "js_npm_plugin")

def npm_import_external_rule(plugins):
    """Create a npm_import_external rule."""

    def impl(ctx):
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

        files_result = ctx.execute(["find", "npm", "-type", "f"])
        if files_result.return_code:
            fail("Could not list files")
        files = [file[len("npm/"):] for file in files_result.stdout.split("\n")]

        build = ""

        package = struct(
            archive = ctx.attr.package,
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
        },
    )

def npm_import_rule(plugins):
    """Create an npm import rule."""

    def impl(ctx):
        packages = ctx.attr.packages

        for package_name, repo in packages.items():
            build = ""

            for plugin in plugins:
                content = plugin.alias_build(package_name, repo)
                if content:
                    build += content
                    build += "\n"

            ctx.file("%s/BUILD.bazel" % package_name, build)

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
            deps = [json.encode({"id": package_repo_name(name, dep["id"]), "name": dep.get("name")}) for dep in package["deps"]],
            extra_deps = extra_deps,
        )
    root_packages = {root["name"]: package_repo_name(name, root["id"]) for root in roots}
    npm_import(name = name, packages = root_packages)
