load("//commonjs:workspace.bzl", "cjs_npm_plugin")
load("//nodejs:workspace.bzl", nodejs_repositories = "repositories")
load("//npm:workspace.bzl", "npm")
load("//typescript:workspace.bzl", "ts_npm_plugin")
load(":npm_data.bzl", "PACKAGES", "ROOTS")
load("//commonjs:workspace.bzl", "cjs_directory_npm_plugin")
load("//typescript:workspace.bzl", "ts_directory_npm_plugin")

def repositories():
    nodejs_repositories()

    plugins = [
        cjs_directory_npm_plugin(),
        ts_directory_npm_plugin(),
    ]
    npm("better_rules_javascript_npm", PACKAGES, ROOTS, plugins)
