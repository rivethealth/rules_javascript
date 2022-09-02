load("//commonjs:workspace.bzl", "cjs_directory_npm_plugin")
load("//nodejs:workspace.bzl", "nodejs_repositories", "nodejs_toolchains")
load("//npm:workspace.bzl", "npm")
load("//typescript:workspace.bzl", "ts_directory_npm_plugin")
load(":nodejs.bzl", "NODEJS_REPOSITORIES")
load(":npm_data.bzl", "PACKAGES", "ROOTS")

def repositories(version = "18.8.0"):
    nodejs_repositories(
        name = "better_rules_javascript_nodejs",
        repositories = NODEJS_REPOSITORIES[version],
    )

    nodejs_toolchains(
        toolchain = "@better_rules_javascript//rules:nodejs_runtime",
        repositories = NODEJS_REPOSITORIES[version],
    )

    plugins = [
        cjs_directory_npm_plugin(),
        ts_directory_npm_plugin(),
    ]
    npm("better_rules_javascript_npm", PACKAGES, ROOTS, plugins)
