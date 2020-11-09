load("@better_rules_javascript//npm/bzl:workspace.bzl", "npm_package", "npm_roots")
load(":npm_data.bzl", "PACKAGES", "ROOTS")

def npm(name):
    for package in PACKAGES:
        npm_package(name, package)
    npm_roots(name, ROOTS)
