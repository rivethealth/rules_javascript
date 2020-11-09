load("//rules/nodejs/bzl:workspace.bzl", nodejs_repositories = "repositories")
load("//rules/npm/bzl:workspace.bzl", "npm_package", "npm_roots", npm_repositories = "repositories")
load(":npm_data.bzl", "PACKAGES", "ROOTS")

def repositories():
    nodejs_repositories()
    npm_repositories()

    for package in PACKAGES:
        npm_package("better_rules_javascript_npm", package)
    npm_roots("better_rules_javascript_npm", ROOTS)
