load("//commonjs:workspace.bzl", "cjs_npm_plugin")
load("//nodejs:workspace.bzl", "nodejs_repositories", "nodejs_toolchains")
load("//npm:workspace.bzl", "npm")
load("//typescript:workspace.bzl", "ts_npm_plugin")
load("//commonjs:workspace.bzl", "cjs_directory_npm_plugin")
load("//typescript:workspace.bzl", "ts_directory_npm_plugin")
load(":nodejs.bzl", "NODEJS_REPOSITORIES")
load(":npm_data.bzl", "PACKAGES", "ROOTS")

def repositories():
    nodejs_repositories(
        name = "better_rules_javascript_nodejs",
        repositories = NODEJS_REPOSITORIES["17"],
    )

    nodejs_toolchains(
        toolchain = "@better_rules_javascript//rules:nodejs_runtime",
        repositories = NODEJS_REPOSITORIES["17"],
    )

    plugins = [
        cjs_directory_npm_plugin(),
        ts_directory_npm_plugin(),
    ]
    npm("better_rules_javascript_npm", PACKAGES, ROOTS, plugins)
