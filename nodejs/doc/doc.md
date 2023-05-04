# Node.js

Node.js is most common execution environment outside a web browser.

<!-- START doctoc -->
<!-- END doctoc -->

# Guide

## Reference

[Starlark reference](stardoc/nodejs.md)

## Example

**package.json**

```json
{}
```

**main.js**

```js
console.log("Hello world");
```

**BUILD.bazel**

```bzl
load("@better_rules_javascript//commonjs:rules.bzl", "cjs_root")
load("@better_rules_javascript//javascript:rules.bzl", "js_library")
load("@better_rules_javascript//nodejs:rules.bzl", "nodejs_binary")

cjs_root(
  name = "root",
  descriptor = "package.json",
  package_name = "example",
)

js_library(
    name = "main",
    root = ":root",
    srcs = ["main.js"],
)

nodejs_binary(
    name = "bin",
    dep = ":main",
    main = "main.js",
)
```

Then

```txt
$ bazel run //:bin
Hello world
```

## IDEs

IDEs use `node_modules`. To install external dependencies or link local files:

**BUILD.bazel**

```bzl
load("@better_rules_javascript//nodejs:rules.bzl", "nodejs_install", "nodejs_modules_package")

nodejs_install(
  name = "nodejs_install",
  src = ":node_modules",
)

nodejs_modules_package(
  name = "node_modules",
  deps = ["@npm//external-example:lib"],
  links = ["//internal-example:root"],
)
```

Then run:

```sh
bazel run :nodejs_install
```
