# Npm

Better_rules_javascript can use npm packages.

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Strategy](#strategy)
- [Yarn](#yarn)
- [IDE](#ide)
- [Limitations](#limitations)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Strategy

A package manager resolves the dependency graph. The information is converted to
Bazel repositories. This approach integrates well into the Bazel ecosystem and
avoid excessive downloads. Compare with
[rules_jvm_external](https://github.com/bazelbuild/rules_jvm_external).

better_rules_javascript uses Yarn 2, as its lock file provides all the necessary
information.

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

```sh
bazel run @better_rules_javascript//npm/yarn-gen:bin -- --refresh npm_data.bzl
```

Full options:

```txt
usage: yarn-gen [-h] [--dir DIR] [--lock LOCK] [--refresh] output

Convert yarn lock file to Starlark

positional arguments:
  output       Path to Starlark output.

optional arguments:
  -h, --help   show this help message and exit
  --dir DIR    Directory for refresh. Defaults to .
  --lock LOCK  Path to yarn.lock.
  --refresh    Run yarn to refresh yarn.lock.
```

Then load the repositories into the workspace.

**WORKSPACE.bazel**

```bzl
load("@better_rules_javascript//npm:workspace.bzl", "npm")
load(":npm_data.bzl", npm_packages = "PACKAGES", npm_roots = "ROOTS")
npm("npm", npm_packages, npm_roots)
```

### Plugins

Several types of files can be distributed in NPM packages: JavaScript,
TypeScript, CSS, etc.

To support these, the npm repostiories can be customized via "plugins."

```bzl
npm("npm", npm_packages, npm_roots, npm_plugins)
```

The defaults are

```bzl
load("@better_rules_javascript//commonjs:workspace.bzl", "cjs_npm_plugin")
load("@better_rules_javascript//js:workspace.bzl", "js_npm_plugin")

[
  cjs_npm_plugin(),
  js_npm_plugin(),
]
```

You may want to add others like `ts_npm_plugin()`.

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

### Executable

For convenience, the yarn executable is available as
`@better_rules_javascript//npm:yarn`.

## IDE

To make these accessible to the IDE in `node_modules`, see
[Node.js docs](nodejs.md).

## Limitations

Post-install scripts, including native dependencies (node-gyp), are not
supported.

To support those, filter the package from `PACKAGES`, and instead use Bazel
rules to replicate the build process.
