load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

DEFAULT_NODE_VERSION = "14.9.0"

NODEJS_URLS = [
    "https://nodejs.org/dist/{url}",
    "https://mirror.bazel.build/nodejs.org/dist/{url}",
]

NODEJS_REPOSITORIES = {
    "10.16.0": {
        "darwin_x86_64": {
            "url": "v10.16.0/node-v10.16.0-darwin-x64.tar.gz",
            "prefix": "node-v10.16.0-darwin-x64",
            "sha256": "6c009df1b724026d84ae9a838c5b382662e30f6c5563a0995532f2bece39fa9c",
        },
        "linux_x86_64": {
            "url": "v10.16.0/node-v10.16.0-linux-x64.tar.xz",
            "prefix": "node-v10.16.0-linux-x64",
            "sha256": "1827f5b99084740234de0c506f4dd2202a696ed60f76059696747c34339b9d48",
        },
        "windows_x86_64": {
            "url": "v10.16.0/node-v10.16.0-win-x64.zip",
            "prefix": "node-v10.16.0-win-x64",
            "sha256": "aa22cb357f0fb54ccbc06b19b60e37eefea5d7dd9940912675d3ed988bf9a059",
        },
    },
    "12.9.1": {
        "darwin_x86_64": {
            "url": "v12.9.1/node-v12.9.1-darwin-x64.tar.gz",
            "prefix": "node-v12.9.1-darwin-x64",
            "sha256": "9aaf29d30056e2233fd15dfac56eec12e8342d91bb6c13d54fb5e599383dddb9",
        },
        "linux_x86_64": {
            "url": "v12.9.1/node-v12.9.1-linux-x64.tar.xz",
            "prefix": "node-v12.9.1-linux-x64",
            "sha256": "680a1263c9f5f91adadcada549f0a9c29f1b26d09658d2b501c334c3f63719e5",
        },
        "windows_x86_64": {
            "url": "v12.9.1/node-v12.9.1-win-x64.zip",
            "prefix": "node-v12.9.1-win-x64",
            "sha256": "35b682df8bd057c81bb30460d606b81e252fc263eb7532e647aa3350ee0ceb64",
        },
    },
    "14.9.0": {
        # todo: update hashes
        "darwin_x86_64": {
            "url": "v14.9.0/node-v14.9.0-darwin-x64.tar.gz",
            "prefix": "node-v14.9.0-darwin-x64",
            "sha256": "00af29d30056e2233fd15dfac56eec12e8342d91bb6c13d54fb5e599383dddb9",
        },
        "linux_x86_64": {
            "url": "v14.9.0/node-v14.9.0-linux-x64.tar.xz",
            "prefix": "node-v14.9.0-linux-x64",
            "sha256": "ded70899f43cf8138f88b838aecff5045e763bcab91c4b7f57fe5b69c6722df4",
        },
        "windows_x86_64": {
            "url": "v14.9.0/node-v14.9.0-win-x64.zip",
            "prefix": "node-v14.9.0-win-x64",
            "sha256": "00b682df8bd057c81bb30460d606b81e252fc263eb7532e647aa3350ee0ceb64",
        },
    },
}

def repositories(nodejs_repositories = NODEJS_REPOSITORIES[DEFAULT_NODE_VERSION]):
    for [platform, nodejs_repository] in nodejs_repositories.items():
        http_archive(
            name = "nodejs_%s" % platform,
            build_file = "@better_rules_javascript//rules/nodejs:nodejs.BUILD.bazel",
            sha256 = nodejs_repository["sha256"],
            strip_prefix = nodejs_repository["prefix"],
            urls = [url.format(url = nodejs_repository["url"]) for url in NODEJS_URLS],
        )

        native.register_toolchains("@better_rules_javascript//rules/nodejs:nodejs_%s_toolchain" % platform)
