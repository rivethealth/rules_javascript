load("//commonjs:workspace.bzl", "cjs_directory_npm_plugin")
load("//npm:workspace.bzl", "npm")
load("//typescript:workspace.bzl", "ts_directory_npm_plugin")
load("//tools/npm:npm.bzl", "PACKAGES", "ROOTS")

def npm_deps():
    npm(
        name = "npm",
        packages = PACKAGES,
        roots = ROOTS,
        plugins = [
            cjs_directory_npm_plugin(),
            ts_directory_npm_plugin(),
        ],
    )
