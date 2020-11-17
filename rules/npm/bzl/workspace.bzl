load("//rules/util/bzl:json.bzl", "json")

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

    deps = list(ctx.attr.deps)

    if ctx.name.startswith("npm_protobufjs"):
        ctx.execute(["sh", "-c", "echo 'exports.setup = () => {}' >> npm/cli/util.js"])
        ctx.execute(["sh", "-c", "echo 'require(\"./targets/json-module\")' >> npm/cli/util.js"])
        ctx.execute(["sh", "-c", "echo 'require(\"./targets/json\")' >> npm/cli/util.js"])
        ctx.execute(["sh", "-c", "echo 'require(\"./targets/proto\")' >> npm/cli/util.js"])
        ctx.execute(["sh", "-c", "echo 'require(\"./targets/proto2\")' >> npm/cli/util.js"])
        ctx.execute(["sh", "-c", "echo 'require(\"./targets/proto3\")' >> npm/cli/util.js"])
        ctx.execute(["sh", "-c", "echo 'require(\"./targets/static-module\")' >> npm/cli/util.js"])
        ctx.execute(["sh", "-c", "echo 'require(\"./targets/static\")' >> npm/cli/util.js"])
        deps.append("@npm_chalk4.1.0//:js")
        deps.append("@npm_escodegen2.0.0//:js")
        deps.append("@npm_espree7.3.0//:js")
        deps.append("@npm_glob7.1.6//:js")
        deps.append("@npm_minimist1.2.5//:js")
        deps.append("@npm_uglify_js3.11.6//:js")
        deps.append("@npm_estraverse5.2.0//:js")

    main_result = ctx.execute(["jq", "-r", ".main", "npm/package.json"])
    if main_result.return_code:
        fail("Reading package.json failed")
    if main_result.stdout.rstrip() == "null":
        main = ""
    else:
        main = main_result.stdout.rstrip()
        if main.startswith("./"):
            main = main[len("./"):]

    name_result = ctx.execute(["jq", "-r", ".name", "npm/package.json"])
    if name_result.return_code:
        fail("Reading package.json failed")
    package_name = name_result.stdout.rstrip()
    if package_name == "@types/node":
        build = """
load("@better_rules_javascript//rules/javascript/bzl:rules.bzl", "js_library")
load("@better_rules_typescript//rules/typescript/bzl:rules.bzl", "ts_import")

package(default_visibility = ["//visibility:public"])

js_library(
    main = {main},
    name = "lib",
    deps = {js_deps},
    js_name = {js_name},
    srcs = glob(["npm/**/*"]),
    strip_prefix = "%s/npm" % repository_name()[1:],
)

ts_import(
    main = {main},
    name = "js",
    deps = {ts_deps},
    js_name = {js_name},
    ambiant = glob(["npm/**/*.d.ts"], ["npm/ts3.3/**", "npm/ts3.6/**"]) + ["npm/ts3.3/base.d.ts", "npm/ts3.6/base.d.ts"],
    strip_prefix = "%s/npm" % repository_name()[1:],
)
        """.format(
            main = json.encode(main),
            js_deps = json.encode(deps),
            ts_deps = json.encode([":lib"] + deps),
            js_name = json.encode(package_name),
        )
    else:
        if package_name.startswith("@types/"):
            ts_package_name = package_name[len("@types/"):]
        else:
            ts_package_name = package_name

        build = """
load("@better_rules_javascript//rules/javascript/bzl:rules.bzl", "js_library")
load("@better_rules_typescript//rules/typescript/bzl:rules.bzl", "ts_import")

package(default_visibility = ["//visibility:public"])

js_library(
    main = {main},
    name = "lib",
    deps = {js_deps},
    js_name = {js_name},
    srcs = glob(["npm/**/*"]),
    strip_prefix = "%s/npm" % repository_name()[1:],
)

ts_import(
    main = {main},
    name = "js",
    deps = {ts_deps},
    js_name = {ts_name},
    declarations = glob(["npm/**/*.d.ts"]),
    strip_prefix = "%s/npm" % repository_name()[1:],
)
        """.format(
            main = json.encode(main),
            js_deps = json.encode(deps),
            ts_deps = json.encode([":lib"] + deps),
            js_name = json.encode(package_name),
            ts_name = json.encode(ts_package_name),
        )

    ctx.file("BUILD.bazel", build)

js_import_external = repository_rule(
    implementation = _js_import_external_impl,
    attrs = {
        "deps": attr.string_list(
            doc = "Dependencies",
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
    for package_name, label in ctx.attr.packages.items():
        if package_name.startswith("@types/"):
            js_name = package_name[len("@types/"):]
        else:
            js_name = package_name
        build = """
load("@better_rules_typescript//rules/typescript/bzl:rules.bzl", "ts_import")

package(default_visibility = ["//visibility:public"])

ts_import(
    name = "js",
    js_name = %s,
    deps = [%s],
)
        """ % (json.encode(js_name), json.encode(label))

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
        name = name + "_" + package_repo_name(package["name"]),
        deps = ["@%s_%s//:js" % (name, package_repo_name(dep["dep"])) for dep in package["deps"]],
        urls = [package["url"]],
        integrity = package["integrity"] if not package["integrity"].startswith("sha1-") else None,
    )

def npm_roots(name, roots):
    root_packages = {root["name"]: "@%s_%s//:js" % (name, package_repo_name(root["dep"])) for root in roots}
    js_import_npm(name = name, packages = root_packages)

def repositories():
    js_import_external(
        name = "better_rules_javascript_yarnpkg_lockfile",
        integrity = "sha512-GpSwvyXOcOOlV70vbnzjj4fW5xW/FdUF6nQEt1ENy7m4ZCczi1+/buVUPAqmGfqznsORNFzUMjctTIp8a9tuCQ==",
        urls = ["https://registry.yarnpkg.com/@yarnpkg/lockfile/-/lockfile-1.1.0.tgz#e77a97fbd345b76d83245edcd17d393b1b41fb31"],
    )

    js_import_external(
        name = "better_rules_javascript_argparse",
        integrity = "sha512-o5Roy6tNG4SL/FOkCAN6RzjiakZS25RLYFrcMttJqbdd8BWrnA+fGz57iN5Pb06pvBGvl5gQ0B48dJlslXvoTg==",
        urls = ["https://registry.yarnpkg.com/argparse/-/argparse-1.0.10.tgz#bcd6791ea5ae09725e17e5ad988134cd40b3d911"],
        deps = [
            "@better_rules_javascript_sprintf_js//:js",
        ],
    )

    js_import_external(
        name = "better_rules_javascript_sprintf_js",
        # integrity = "sha1-BOaSb2YolTVPPdAVIDYzuFcpfiw=",
        urls = ["https://registry.yarnpkg.com/sprintf-js/-/sprintf-js-1.0.3.tgz#04e6926f662895354f3dd015203633b857297e2c"],
    )

    js_import_npm(
        name = "better_rules_javascript_npm_internal",
        packages = {
            "@yarnpkg/lockfile": "@better_rules_javascript_yarnpkg_lockfile//:js",
            "argparse": "@better_rules_javascript_argparse//:js",
        },
    )

def npm(name, packages, roots):
    for package in packages:
        npm_package(name, package)
    npm_roots(name, roots)
