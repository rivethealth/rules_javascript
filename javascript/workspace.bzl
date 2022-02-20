load(":providers.bzl", "js_npm_inner_label", "js_npm_label")
load("//commonjs:providers.bzl", "cjs_npm_label")

def _js_npm_alias_build(repo):
    return """
alias(
    name = "lib",
    actual = {label},
    visibility = ["//visibility:public"],
)
    """.strip().format(
        label = json.encode(js_npm_label(repo)),
    )

def _js_directory_npm_package_build(package):
    result = """
load("@better_rules_javascript//javascript:rules.bzl", "js_export", "js_library")

js_library(
    name = "lib.inner",
    root = ":root",
    deps = {deps},
    srcs = [":files"],
    visibility = ["//visibility:public"],
)

js_export(
    name = "lib",
    dep = ":lib.inner",
    extra_deps = {extra_deps},
    visibility = ["//visibility:public"],
)
    """.strip().format(
        deps = json.encode([js_npm_label(dep) for dep in package.deps]),
        extra_deps = json.encode([":lib.export.%s" % i for i in range(len(package.extra_deps))]),
    )

    for i, (id, deps) in enumerate(package.extra_deps.items()):
        result += """
js_export(
    name = {name},
    dep = {dep},
    deps = {deps},
)
        """.strip().format(
            name = json.encode("lib.export.%s" % i),
            dep = json.encode(js_npm_inner_label(id)),
            deps = json.encode([js_npm_label(dep) for dep in deps]),
        )

    return result

def _js_npm_package_build(exclude_suffixes, package):
    excludes = ["npm/**/*%s" % suffix for suffix in exclude_suffixes]

    return """
load("@better_rules_javascript//javascript:rules.bzl", "js_library")

js_library(
    name = "lib",
    root = ":root",
    deps = {deps},
    # extra_deps = {extra_deps},
    srcs = glob(["npm/**/*"], ["npm/**/package.json"] + {excludes}),
)
    """.strip().format(
        deps = json.encode([js_npm_label(dep) for dep in package.deps]),
        excludes = excludes,
        extra_deps = json.encode(package.extra_deps),
    )

def js_directory_npm_plugin():
    def alias_build(repo):
        return _js_npm_alias_build(repo)

    def package_build(package, files):
        return _js_directory_npm_package_build(package)

    return struct(
        alias_build = alias_build,
        package_build = package_build,
    )

def js_npm_plugin(exclude_suffixes = []):
    def alias_build(repo):
        return _js_npm_alias_build(repo)

    def package_build(package, files):
        return _js_npm_package_build(exclude_suffixes, package)

    return struct(
        alias_build = alias_build,
        package_build = package_build,
    )
