load("//commonjs:workspace.bzl", "cjs_directory_npm_plugin")
load("//nodejs:workspace.bzl", "nodejs_repositories", "nodejs_toolchains")
load("//nodejs/default:nodejs.bzl", "NODEJS_REPOSITORIES")
load("//npm:workspace.bzl", "npm")
load("//typescript:workspace.bzl", "ts_directory_npm_plugin")
load(":npm_data.bzl", "PACKAGES", "ROOTS")

def repositories(version = "22.14.0"):
    nodejs_repositories(
        name = "better_rules_javascript_nodejs",
        repositories = NODEJS_REPOSITORIES[version],
    )

    nodejs_toolchains(
        toolchain = "@better_rules_javascript//nodejs/default:nodejs_runtime",
        repositories = NODEJS_REPOSITORIES[version],
    )

    npm(
        name = "better_rules_javascript_npm",
        packages = PACKAGES,
        roots = ROOTS,
        plugins = [
            cjs_directory_npm_plugin(),
            ts_directory_npm_plugin(),
        ],
    )
