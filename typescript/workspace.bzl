load("//commonjs:providers.bzl", "cjs_npm_label")
load("//javascript:providers.bzl", "JsInfo", "js_npm_label")

def _ts_npm_alias_build(repo):
    return """
alias(
    name = "lib",
    actual = {label}
)
    """.strip().format(
        label = json.encode(js_npm_label(repo)),
    )

def _ts_npm_package_build(exclude_suffixes, package, files):
    excludes = ["npm/**/*%s" % suffix for suffix in exclude_suffixes]

    if not any([file.endswith(".d.ts") for file in files]):
        return """
load("@better_rules_javascript//javascript:rules.bzl", "js_library")

js_library(
    name = "lib",
    root = ":root",
    deps = {deps},
    extra_deps = {extra_deps},
    srcs = glob(["npm/**/*"], ["npm/**/package.json"] + {excludes}),
    strip_prefix = "%s/npm" % repository_name()[1:],
)
        """.strip().format(
            deps = json.encode([js_npm_label(dep) for dep in package.deps]),
            excludes = excludes,
            extra_deps = json.encode({name: js_npm_label(dep) for name, dep in package.extra_deps.items()}),
        )

    return """
load("@better_rules_javascript//typescript:rules.bzl", "ts_import")

ts_import(
    name = "lib",
    root = ":root",
    declarations = glob(["npm/**/*.d.ts"]),
    deps = {deps},
    extra_deps = {extra_deps},
    js = glob(["npm/**/*"], ["npm/**/package.json"] + {excludes}),
    strip_prefix = "%s/npm" % repository_name()[1:],
)
    """.strip().format(
        deps = json.encode([js_npm_label(dep) for dep in package.deps]),
        excludes = excludes,
        extra_deps = json.encode({name: cjs_npm_label(dep) for name, dep in package.extra_deps.items()}),
    )

def ts_npm_plugin(exclude_suffixes = []):
    def alias_build(repo):
        return _ts_npm_alias_build(repo)

    def package_build(package, files):
        return _ts_npm_package_build(exclude_suffixes, package, files)

    return struct(
        alias_build = alias_build,
        package_build = package_build,
    )
