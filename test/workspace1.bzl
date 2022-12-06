load("@rules_proto//proto:repositories.bzl", "rules_proto_dependencies", "rules_proto_toolchains")
load("@rules_proto_grpc//:repositories.bzl", "rules_proto_grpc_repos", "rules_proto_grpc_toolchains")
load("//commonjs:workspace.bzl", "cjs_directory_npm_plugin")
load("//npm:workspace.bzl", "npm")
load("//rules:workspace.bzl", javascript_repositories = "repositories")
load("//tools/npm:npm.bzl", "PACKAGES", "ROOTS")
load("//typescript:workspace.bzl", "ts_directory_npm_plugin")

def test_repositories1():
    # Protobuf

    rules_proto_dependencies()

    rules_proto_toolchains()

    # Protobuf

    rules_proto_grpc_toolchains()

    rules_proto_grpc_repos()

    # JavaScript

    javascript_repositories()

    plugins = [
        cjs_directory_npm_plugin(),
        ts_directory_npm_plugin(),
    ]
    npm("npm", PACKAGES, ROOTS, plugins)
