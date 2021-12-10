def _js_import_external_impl(ctx):
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
    typescript = any([file.endswith(".d.ts") for file in files])

    deps = ctx.attr.deps

    if ctx.name.startswith("npm_protobufjs"):
        # protobufjs attempts to run npm install dependencies(!!)
        # this may be fixed when protobufjs-cli is released
        ctx.execute(["sh", "-c", "echo 'exports.setup = () => {}' >> npm/cli/util.js"])
        ctx.execute(["sh", "-c", "echo 'require(\"./targets/json-module\")' >> npm/cli/util.js"])
        ctx.execute(["sh", "-c", "echo 'require(\"./targets/json\")' >> npm/cli/util.js"])
        ctx.execute(["sh", "-c", "echo 'require(\"./targets/proto\")' >> npm/cli/util.js"])
        ctx.execute(["sh", "-c", "echo 'require(\"./targets/proto2\")' >> npm/cli/util.js"])
        ctx.execute(["sh", "-c", "echo 'require(\"./targets/proto3\")' >> npm/cli/util.js"])
        ctx.execute(["sh", "-c", "echo 'require(\"./targets/static-module\")' >> npm/cli/util.js"])
        ctx.execute(["sh", "-c", "echo 'require(\"./targets/static\")' >> npm/cli/util.js"])
        deps = list(deps)
        deps.append("@npm_chalk4.1.0//:lib")
        deps.append("@npm_escodegen2.0.0//:lib")
        deps.append("@npm_espree7.3.0//:lib")
        deps.append("@npm_glob7.1.6//:lib")
        deps.append("@npm_minimist1.2.5//:lib")
        deps.append("@npm_uglify_js3.11.6//:lib")
        deps.append("@npm_estraverse5.2.0//:lib")

    build = """
load("@better_rules_javascript//commonjs:rules.bzl", "cjs_root")
    """.strip()
    build += "\n"

    if typescript:
        build += """
load("@better_rules_typescript//typescript:rules.bzl", "ts_import")
        """.strip()
        build += "\n"
    else:
        build += """
load("@better_rules_javascript//javascript:rules.bzl", "js_library")
        """.strip()
        build += "\n"

    build += """
package(default_visibility = ["//visibility:public"])

cjs_root(
    descriptors = glob(["npm/**/package.json"]),
    name = "root",
    package_name = {package_name},
    strip_prefix = "%s/npm" % {name},
)
    """.strip().format(
        package_name = json.encode(ctx.attr.package_name),
        name = json.encode(ctx.name),
    )

    build += "\n"

    if typescript:
        build += """
ts_import(
    declarations = glob(["npm/**/*.d.ts"]),
    name = "lib",
    root = ":root",
    deps = {deps},
    js = glob(["npm/**/*"]),
    strip_prefix = "%s/npm" % repository_name()[1:],
)
        """.strip().format(
            deps = json.encode(deps),
        )
        build += "\n"
    else:
        build += """
js_library(
    name = "lib",
    root = ":root",
    deps = {deps},
    srcs = glob(["npm/**/*"]),
    strip_prefix = "%s/npm" % repository_name()[1:],
)
        """.strip().format(
            deps = json.encode(deps),
        )
        build += "\n"
    ctx.file("BUILD.bazel", build)

js_import_external = repository_rule(
    implementation = _js_import_external_impl,
    attrs = {
        "deps": attr.string_list(
            doc = "Dependencies",
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

def _js_import_npm_impl(ctx):
    for package_name, repo in ctx.attr.packages.items():
        build = """
package(default_visibility = ["//visibility:public"])

alias(
    name = "root",
    actual = {root}
)

alias(
    name = "lib",
    actual = {lib}
)
        """.strip().format(
            root = json.encode(repo + "//:root"),
            lib = json.encode(repo + "//:lib"),
        )

        ctx.file("%s/BUILD.bazel" % package_name, build)

js_import_npm = repository_rule(
    implementation = _js_import_npm_impl,
    attrs = {
        "packages": attr.string_dict(
            doc = "Packages",
        ),
    },
)

def package_repo_name(name):
    name = name.replace("@", "")
    name = name.replace("/", "_")
    name = name.replace("-", "_")
    return name

def npm_package(name, package):
    js_import_external(
        name = name + "_" + package_repo_name(package["id"]),
        package_name = package["name"],
        deps = ["@%s_%s//:lib" % (name, package_repo_name(dep["dep"])) for dep in package["deps"]],
        urls = [package["url"]],
        integrity = package["integrity"] if "integrity" in package and not package["integrity"].startswith("sha1-") else None,
    )

def npm_roots(name, roots):
    root_packages = {package_repo_name(root["name"]): "@%s_%s" % (name, package_repo_name(root["dep"])) for root in roots}
    js_import_npm(name = name, packages = root_packages)

def repositories():
    pass

def npm(name, packages, roots):
    for package in packages:
        npm_package(name, package)
    npm_roots(name, roots)
