load("//commonjs:workspace.bzl", "cjs_npm_plugin")
load("//javascript:workspace.bzl", "js_npm_plugin")

def npm_import_external_rule(plugins):
    def impl(ctx):
        deps = ctx.attr.deps
        extra_deps = ctx.attr.extra_deps
        id = ctx.attr.id
        package_name = ctx.attr.package_name

        ctx.download_and_extract(
            ctx.attr.urls,
            "tmp",
            integrity = ctx.attr.integrity,
        )

        # packages can have different prefixes
        mv_result = ctx.execute(["sh", "-c", "mv tmp/* npm"])
        if mv_result.return_code:
            fail("Could not extract package")

        files_result = ctx.execute(["find", "npm", "-type", "f"])
        if files_result.return_code:
            fail("Could not list files")
        files = files_result.stdout.split("\n")
        sass = False and any([file.endswith(".scss") for file in files])
        typescript = any([file.endswith(".d.ts") for file in files])

        # if ctx.name.startswith("npm_protobufjs"):
        #     # protobufjs attempts to run npm install dependencies(!!)
        #     # this may be fixed when protobufjs-cli is released
        #     ctx.execute(["sh", "-c", "echo 'exports.setup = () => {}' >> npm/cli/util.js"])
        #     ctx.execute(["sh", "-c", "echo 'require(\"./targets/json-module\")' >> npm/cli/util.js"])
        #     ctx.execute(["sh", "-c", "echo 'require(\"./targets/json\")' >> npm/cli/util.js"])
        #     ctx.execute(["sh", "-c", "echo 'require(\"./targets/proto\")' >> npm/cli/util.js"])
        #     ctx.execute(["sh", "-c", "echo 'require(\"./targets/proto2\")' >> npm/cli/util.js"])
        #     ctx.execute(["sh", "-c", "echo 'require(\"./targets/proto3\")' >> npm/cli/util.js"])
        #     ctx.execute(["sh", "-c", "echo 'require(\"./targets/static-module\")' >> npm/cli/util.js"])
        #     ctx.execute(["sh", "-c", "echo 'require(\"./targets/static\")' >> npm/cli/util.js"])
        #     deps = list(deps)
        #     deps.append("@npm_chalk4.1.0//:lib")
        #     deps.append("@npm_escodegen2.0.0//:lib")
        #     deps.append("@npm_espree7.3.0//:lib")
        #     deps.append("@npm_glob7.1.6//:lib")
        #     deps.append("@npm_minimist1.2.5//:lib")
        #     deps.append("@npm_uglify_js3.11.6//:lib")
        #     deps.append("@npm_estraverse5.2.0//:lib")

        build = """
    package(default_visibility = ["//visibility:public"])
        """.strip()
        build += "\n"

        package = struct(
            id = id,
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
                doc = "Dependencies",
            ),
            "extra_deps": attr.string_dict(
                doc = "Extra dependencies.",
            ),
            "id": attr.string(
                mandatory = True,
            ),
            "package_name": attr.string(
                mandatory = True,
            ),
            "urls": attr.string_list(
                doc = "URLs",
                mandatory = True,
            ),
            "integrity": attr.string(
                doc = "Integrity",
            ),
        },
    )

def npm_import_rule(plugins):
    def impl(ctx):
        packages = ctx.attr.packages

        for package_name, repo in packages.items():
            build = """
    package(default_visibility = ["//visibility:public"])
            """.strip()
            build += "\n"

            for plugin in plugins:
                content = plugin.alias_build(repo)
                if content:
                    build += content
                    build += "\n"

            ctx.file("%s/BUILD.bazel" % package_name, build)

    return repository_rule(
        implementation = impl,
        attrs = {
            "packages": attr.string_dict(
                doc = "Packages",
            ),
        },
    )

def package_repo_name(name):
    if name.startswith("@"):
        name = name[len("@"):]
    name = name.replace("@", "_")
    name = name.replace("/", "_")
    return name

DEFAULT_PLUGINS = [
    cjs_npm_plugin(),
    js_npm_plugin(),
]

def npm(name, packages, roots, plugins = DEFAULT_PLUGINS):
    npm_import_external = npm_import_external_rule(plugins)
    npm_import = npm_import_rule(plugins)

    for package in packages:
        repo_name = package_repo_name(package["id"])
        npm_import_external(
            name = "%s_%s" % (name, repo_name),
            package_name = package["name"],
            deps = ["%s_%s" % (name, package_repo_name(dep["dep"])) for dep in package["deps"]],
            id = "%s_%s" % (name, repo_name),
            extra_deps = {n: "%s_%s" % (name, package_repo_name(id)) for n, id in package.get("extra_deps", {}).items()},
            urls = [package["url"]],
            integrity = package["integrity"] if "integrity" in package and not package["integrity"].startswith("sha1-") else None,
        )
    root_packages = {root["name"]: "%s_%s" % (name, package_repo_name(root["dep"])) for root in roots}
    npm_import(name = name, packages = root_packages)
