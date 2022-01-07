def _cjs_npm_package_build(package):
    return """
load("@better_rules_javascript//commonjs:rules.bzl", "cjs_root")

cjs_root(
    name = "root",
    package_name = {package_name},
    descriptors = glob(["npm/**/package.json"]),
    strip_prefix = "%s/npm" % repository_name()[1:],
)
    """.strip().format(
        package_name = json.encode(package.name),
    )

def cjs_npm_plugin():
    def alias_build(repo):
        return ""

    def package_build(package, files):
        return _cjs_npm_package_build(package)

    return struct(
        alias_build = alias_build,
        package_build = package_build,
    )
