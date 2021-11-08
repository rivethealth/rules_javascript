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

Currently, only the yarn package manager is supported.

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
usage: yarn-gen [-h] [--dir DIR] [--package PACKAGE] [--lock LOCK] [--refresh] [--version {1,2}] output

Convert yarn lock file to Starlark

positional arguments:
  output             Path to Starlark output.

optional arguments:
  -h, --help         show this help message and exit
  --dir DIR          Directory for refresh. Defaults to .
  --package PACKAGE  Path to package.json.
  --lock LOCK        Path to yarn.lock.
  --refresh          Run yarn to refresh yarn.lock. For version 1, node_modules will also be updated.
  --version {1,2}    Yarn version. Defaults to 1.
```

Then load the repositories into the workspace.

**WORKSPACE.bazel**

```bzl
load("@better_rules_javascript//npm:workspace.bzl", "npm")
load(":npm_data.bzl", NPM_PACKAGES = "PACKAGES", NPM_ROOTS = "ROOTS")
npm("npm", NPM_PACKAGES, NPM_ROOTS)
```

### Usage

JS libraries are available as `@npm//<package_name>:lib`. The package name
replaces '/' with '\_' and strips other non-alpanumerics.

For example,

**BUILD.bazel**

```bzl
js_library(
    name = "example",
    deps = ["@npm//org_package:lib"],
)
```

### Executable

For convenience, yarn executables are available as targets in `npm:yarn` and
`npm:yarn2`.

## IDE

IDEs require packages installed in `node_modules`. This may be done as a
side-effect of a package manager refresh.

Otherwise, packages can be installed separately with a usual package manager
install.

## Limitations

Post-install scripts, including native dependencies (node-gyp), are not
supported.

To support those, filter the package from `PACKAGES`, and instead use Bazel
rules to replicate the build process.
