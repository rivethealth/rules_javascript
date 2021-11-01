load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

DEFAULT_NODE_VERSION = "16.9.1"

NODEJS_URLS = [
    "https://nodejs.org/dist/{url}",
    "https://mirror.bazel.build/nodejs.org/dist/{url}",
]

NODEJS_REPOSITORIES = {
    "12.9.1": {
        "darwin_x86_64": {
            "url": "v12.9.1/node-v12.9.1-darwin-x64.tar.gz",
            "prefix": "node-v12.9.1-darwin-x64",
            "sha256": "9aaf29d30056e2233fd15dfac56eec12e8342d91bb6c13d54fb5e599383dddb9",
        },
        "linux_x86_64": {
            "url": "v12.9.1/node-v12.9.1-linux-x64.tar.gz",
            "prefix": "node-v12.9.1-linux-x64",
            "sha256": "5488e9d9e860eb344726aabdc8f90d09e36602da38da3d16a7ee852fd9fbd91f",
        },
        "windows_x86_64": {
            "url": "v12.9.1/node-v12.9.1-win-x64.zip",
            "prefix": "node-v12.9.1-win-x64",
            "sha256": "35b682df8bd057c81bb30460d606b81e252fc263eb7532e647aa3350ee0ceb64",
        },
    },
    "14.9.0": {
        "darwin_x86_64": {
            "url": "v14.9.0/node-v14.9.0-darwin-x64.tar.gz",
            "prefix": "node-v14.9.0-darwin-x64",
            "sha256": "8427e07e3ca70d6ccf5274dde535c9a42b7f873f5a086323eaf2406cdb324daf",
        },
        "linux_x86_64": {
            "url": "v14.9.0/node-v14.9.0-linux-x64.tar.gz",
            "prefix": "node-v14.9.0-linux-x64",
            "sha256": "78b9e06c40a34ae1b7e0540bc3667459ed6439bbc4deff0bbe13f32817e8ac9c",
        },
        "windows_x86_64": {
            "url": "v14.9.0/node-v14.9.0-win-x64.zip",
            "prefix": "node-v14.9.0-win-x64",
            "sha256": "bcd3fc61739e7ac9a4b6103da3fe5f8c9e310b7b0f1b1f0200d5a4b5dd65d723",
        },
    },
    "16.9.1": {
        "darwin_x86_64": {
            "url": "v16.9.1/node-v16.9.1-darwin-x64.tar.gz",
            "prefix": "node-v16.9.1-darwin-x64",
            "sha256": "90ff3ce95882ad41ae5c7a2f4f7303e9ba445caf5ef41d270a385c0a76e43bc6",
        },
        "linux_x86_64": {
            "url": "v16.9.1/node-v16.9.1-linux-x64.tar.gz",
            "prefix": "node-v16.9.1-linux-x64",
            "sha256": "1d48c69e4141792f314d29f081501dc22218cfc22f9992c098f7e3f5e0531139",
        },
        "windows_x86_64": {
            "url": "v16.9.1/node-v16.9.1-win-x64.zip",
            "prefix": "node-v16.9.1-win-x64",
            "sha256": "44b36846f45c3599d4230008cc5064d3e72405eea26268731b2374fe4ab998ed",
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
