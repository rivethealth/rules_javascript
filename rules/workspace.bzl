load("//nodejs:workspace.bzl", nodejs_repositories = "repositories")
load("//npm:workspace.bzl", "npm", npm_repositories = "repositories")
load(":npm_data.bzl", "PACKAGES", "ROOTS")

def _fix_eslint_utils(package):
    package = dict(**package)
    package["deps"] = [dep for dep in package["deps"] if dep["name"] != "eslint"]
    return package

def _fix_terser_webpack_plugin(package):
    package = dict(**package)
    package["deps"] = [dep for dep in package["deps"] if dep["name"] != "webpack"]
    return package

def _fix_webpack_cli_configtest(package):
    package = dict(**package)
    package["deps"] = [dep for dep in package["deps"] if dep["name"] != "webpack-cli"]
    return package

def _fix_webpack_cli_info(package):
    package = dict(**package)
    package["deps"] = [dep for dep in package["deps"] if dep["name"] != "webpack-cli"]
    return package

def _fix_webpack_serve(package):
    package = dict(**package)
    package["deps"] = [dep for dep in package["deps"] if dep["name"] != "webpack-cli"]
    return package

def repositories():
    nodejs_repositories()
    npm_repositories()

    packages = PACKAGES
    packages = [
        _fix_terser_webpack_plugin(package) if package["name"] == "terser-webpack-plugin" else _fix_webpack_cli_configtest(package) if package["name"] == "@webpack-cli/configtest" else _fix_webpack_cli_info(package) if package["name"] == "@webpack-cli/info" else _fix_webpack_serve(package) if package["name"] == "@webpack-cli/serve" else _fix_eslint_utils(package) if package["name"] == "eslint-utils" else package
        for package in packages
    ]

    npm("better_rules_javascript_npm", packages, ROOTS)
