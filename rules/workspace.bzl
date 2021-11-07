load("//nodejs:workspace.bzl", nodejs_repositories = "repositories")
load("//npm:workspace.bzl", "npm", npm_repositories = "repositories")
load(":npm_data.bzl", "PACKAGES", "ROOTS")

def repositories():
    nodejs_repositories()
    npm_repositories()

    npm("better_rules_javascript_npm", PACKAGES, ROOTS)
