load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

_NODEJS_URL = "https://nodejs.org/dist/%s"

def nodejs_repositories(name, repositories):
    for [platform, repository] in repositories.items():
        http_archive(
            name = "%s_%s" % (name, platform),
            build_file = "@better_rules_javascript//nodejs:nodejs.BUILD.bazel",
            sha256 = repository["sha256"],
            strip_prefix = repository["prefix"],
            url = _NODEJS_URL % repository["url"],
        )

def nodejs_toolchains(toolchain, repositories):
    for platform in repositories:
        native.register_toolchains("%s.%s_toolchain" % (toolchain, platform))
