# Npm

Better_rules_javascript can use npm packages.

<!-- START doctoc -->
<!-- END doctoc -->

# Guide

## Strategy

A package manager resolves the dependency graph. The information is converted to
Bazel repositories. This approach integrates well into the Bazel ecosystem and
avoid excessive downloads. Compare with
[rules_jvm_external](https://github.com/bazelbuild/rules_jvm_external).

better_rules_javascript uses Yarn 2.

## Yarn

### Install

Create a package.json.

**package.json**

```json
{
  "dependencies": {
    "@org/package": "^1.0.0"
  }
}
```

Create a `yarn_resolve` target.

**BUILD.bazel**

```bzl
yarn_resolve(
    name = "resolve_npm",
)
```

Resolve packages and generate npm_data.bzl

```sh
bazel run :resolve_npm
```

Load the repositories.

**WORKSPACE.bazel**

```bzl
load("@better_rules_javascript//npm:workspace.bzl", "npm")
load(":npm_data.bzl", npm_packages = "PACKAGES", npm_roots = "ROOTS")
npm("npm", npm_packages, npm_roots)
```

### Plugins

Several types of files can be distributed in NPM packages: JavaScript,
TypeScript, CSS, etc.

To support these, the npm repositories can be customized via "plugins."

The defaults are:

```bzl
load("@better_rules_javascript//commonjs:workspace.bzl", "cjs_npm_plugin")
load("@better_rules_javascript//js:workspace.bzl", "js_npm_plugin")

npm(
  name = "npm",
  packages = npm_packages,
  roots = npm_roots,
  plugins = [
    cjs_npm_plugin(),
    js_npm_plugin(),
  ]
)
```

If you use TypeScript, replace `js_npm_plugin()` with `ts_npm_plugin()`.

### Usage

JS libraries are available as `@npm//<package_name>:lib`.

For example,

**BUILD.bazel**

```bzl
js_library(
    name = "example",
    deps = ["@npm//@org/package:lib"],
)
```

## IDE

To make these accessible to the IDE in `node_modules`, see
[Node.js docs](nodejs.md).

## Limitations

Post-install scripts, including native dependencies (node-gyp), are not
supported.

To support those, filter the package from `PACKAGES`, and instead use Bazel
rules to replicate the build process.
