# Npm

Better_rules_javascript can use npm packages.

A package manager resolves the
dependency graph. The information is converted to Bazel repositories. This approach integrates very into the Bazel ecosystem and avoid excessive downloads.

Currently, only the yarn package manager is supported.

## Yarn

### Install

Create a package.json.

**package.json**

```json
{
  "dependencies": {
    "@org/package": "1.0.0"
  }
}
```

```sh
bazel run @better_rules_javascript//npm/yarn-gen:bin -- --refresh npm_data.bzl
```

For full options, see

```sh
bazel run @better_rules_javascript//npm/yarn-gen:bin -- --help
```

Then load the repositories.

**WORKSPACE.bazel**

```bzl
load("@better_rules_javascript//npm:workspace.bzl", "npm")
load(":npm_data.bzl", NPM_PACKAGES = "PACKAGES", NPM_ROOTS = "ROOTS")
npm("npm", NPM_PACKAGES, NPM_ROOTS)
```

### Usage

NPM packages are available as `@npm//<package_name>:lib`, e.g.

**BUILD.bazel**

```bzl
js_library(
    name = "example",
    deps = ["@npm//org_package:lib"],
)
```

## IDE

IDEs require modules installed in `node_modules`. This is done as a side-effect of `npm/yarn-gen:bin` with `--refresh`. Otherwise, this can be
done separately with `yarn install`.

## Limitations

Native dependencies (node-gyp) are not currently supported.
