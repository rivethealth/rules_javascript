load("//rules/util/bzl:json.bzl", "json")

def _js_import_external_impl(ctx):
    ctx.download_and_extract(
        ctx.attr.urls,
        "npm",
        integrity = ctx.attr.integrity,
        stripPrefix = "package",
    )

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

    ctx.template("BUILD.bazel", ctx.attr._template, {
        "%{deps}": json.encode([dep for dep in ctx.attr.deps]),
        "%{main}": json.encode(main),
        "%{package_name}": json.encode(package_name),
        "%{include}": json.encode(["npm/%s" % pattern for pattern in ctx.attr.include]),
        "%{exclude}": json.encode(["npm/%s" % pattern for pattern in ctx.attr.exclude]),
    })

js_import_external = repository_rule(
    implementation = _js_import_external_impl,
    attrs = {
        "deps": attr.string_list(
            doc = "Dependencies",
        ),
        "include": attr.string_list(
            doc = "Include patterns",
            default = ["**/*.js", "**/*.json"],
        ),
        "exclude": attr.string_list(
            doc = "Exclude patterns",
            default = [],
        ),
        "urls": attr.string_list(
            doc = "URLs",
            mandatory = True,
        ),
        "integrity": attr.string(
            doc = "Integrity",
        ),
        "_template": attr.label(
            allow_single_file = True,
            default = "@better_rules_javascript//rules/npm:BUILD.bazel.tpl",
        ),
    },
)

def _js_import_npm_impl(ctx):
    for package_name, label in ctx.attr.packages.items():
        build = """
load("@better_rules_javascript//rules/javascript/bzl:rules.bzl", "js_import")

package(default_visibility = ["//visibility:public"])

js_import(
    name = "js",
    package_name = "%s",
    dep = "%s",
)
        """ % (package_name, label)

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