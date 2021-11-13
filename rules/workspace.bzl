load("//nodejs:workspace.bzl", nodejs_repositories = "repositories")
load("//npm:workspace.bzl", "npm", npm_repositories = "repositories")
load(":npm_data.bzl", "PACKAGES", "ROOTS")

def _fix_typescript_eslint_utils(package, eslint):
    package = dict(**package)
    package["deps"] = package["deps"] + [{"dep": eslint, "name": "eslint"}]
    return package

def _fix_typescript_eslint_plugin(package, eslint, typescript):
    package = dict(**package)
    package["deps"] = package["deps"] + [{"dep": eslint, "name": "eslint"}, {"dep": typescript, "name": "typescript"}]
    return package

def repositories():
    nodejs_repositories()
    npm_repositories()

    eslint = [package["name"] for package in PACKAGES if package["name"].startswith("eslint@")][0]
    typescript = [package["name"] for package in PACKAGES if package["name"].startswith("typescript@")][0]
    typescript_eslint_parser = [package["name"] for package in PACKAGES if package["name"].startswith("@typescript-eslint/parser@")][0]
    packages = [
        _fix_typescript_eslint_utils(package, eslint) if package["name"].startswith("@typescript-eslint/experimental-utils@") else _fix_typescript_eslint_plugin(package, eslint, typescript) if package["name"].startswith("@typescript-eslint/eslint-plugin@") else package
        for package in PACKAGES
    ]

    npm("better_rules_javascript_npm", packages, ROOTS)
