load("//commonjs:providers.bzl", "cjs_npm_label")
load("//javascript:providers.bzl", "JsInfo", "js_npm_inner_label", "js_npm_label")
load("//javascript:workspace.bzl", "js_directory_npm_plugin")

def _ts_npm_alias_build(package_name, repo):
    return """
load("@better_rules_javascript//typescript:rules.bzl", "ts_export")

ts_export(
    name = "lib",
    dep = {label},
    package_name = {package_name},
    visibility = ["//visibility:public"],
)
    """.strip().format(
        label = json.encode(js_npm_label(repo)),
        package_name = json.encode(package_name),
    )

def _ts_directory_npm_package_build(package, files):
    if not any([file.endswith(".d.ts") for file in files]):
        return js_directory_npm_plugin().package_build(package, files)

    deps = []
    exports = []
    for i, dep in enumerate(package.deps):
        if not dep.name:
            deps.append(js_npm_label(dep.id))
            continue
        name = "import%s" % i
        deps.append(name)
        exports.append(
            """
ts_export(
    name = {name},
    dep = {dep},
    package_name = {package_name},
)
""".strip().format(
                name = json.encode(name),
                dep = json.encode(js_npm_label(dep.id)),
                package_name = json.encode(dep.name),
            ),
        )

    result = """
load("@better_rules_javascript//typescript:rules.bzl", "ts_export", "ts_import")

{exports}

ts_import(
    name = "lib.inner",
    declarations = [":root"],
    deps = {deps},
    root = ":root",
    js = [":root"],
    visibility = ["//visibility:public"],
)

ts_export(
    name = "lib",
    dep = ":lib.inner",
    extra_deps = {extra_deps},
    visibility = ["//visibility:public"]
)
    """.strip().format(
        deps = json.encode(deps),
        exports = "\n\n".join(exports),
        extra_deps = json.encode([":lib.export.%s" % i for i in range(len(package.extra_deps))]),
    )
    result += "\n"

    for i, (id, deps) in enumerate(package.extra_deps.items()):
        result += """
ts_export(
    name = {name},
    dep = {dep},
    deps = {deps},
)
        """.strip().format(
            name = json.encode("lib.export.%s" % i),
            dep = json.encode(js_npm_inner_label(id)),
            deps = json.encode([js_npm_inner_label(dep["id"]) for dep in deps]),
        )
        result += "\n"

    return result

def _ts_npm_package_build(exclude_suffixes, package, files):
    excludes = ["npm/**/*%s" % suffix for suffix in exclude_suffixes]

    if not any([file.endswith(".d.ts") for file in files]):
        return """
load("@better_rules_javascript//javascript:rules.bzl", "js_library")

js_library(
    name = "lib",
    root = ":root",
    deps = {deps},
    # extra_deps = {extra_deps},
    srcs = glob(["npm/**/*"], ["npm/**/package.json"] + {excludes}),
    strip_prefix = "npm",
)
        """.strip().format(
            deps = json.encode([js_npm_label(dep) for dep in package.deps]),
            excludes = excludes,
            extra_deps = json.encode(package.extra_deps),
        )

    return """
load("@better_rules_javascript//typescript:rules.bzl", "ts_import")

ts_import(
    name = "lib",
    root = ":root",
    declarations = glob(["npm/**/*.d.ts"]),
    deps = {deps},
    # extra_deps = {extra_deps},
    js = glob(["npm/**/*"], ["npm/**/package.json"] + {excludes}),
    strip_prefix = "npm",
)
    """.strip().format(
        deps = json.encode([js_npm_label(dep) for dep in package.deps]),
        excludes = excludes,
        extra_deps = json.encode(package.extra_deps),
    )

def ts_directory_npm_plugin():
    def alias_build(package_name, repo):
        return _ts_npm_alias_build(package_name, repo)

    def package_build(package, files):
        return _ts_directory_npm_package_build(package, files)

    return struct(
        alias_build = alias_build,
        package_build = package_build,
    )

def ts_npm_plugin(exclude_suffixes = []):
    def alias_build(package_name, repo):
        return _ts_npm_alias_build(package_name, repo)

    def package_build(package, files):
        return _ts_npm_package_build(exclude_suffixes, package, files)

    return struct(
        alias_build = alias_build,
        package_build = package_build,
    )
