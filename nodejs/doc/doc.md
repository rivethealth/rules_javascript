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

IDEs use `node_modules`. To install external dependencies there, create a tar
with `nodejs_archive`.

```bzl
load("@better_rules_javascript//nodejs:rules.bzl", "nodejs_archive")

nodejs_archive(
  name = "archive",
  deps = [
    "@npm/example:lib"
  ],
)
```

Then run

```sh
bazel build :archive
tar xf bazel-bin/archive/modules.tar -C .node_modules
ln -s .node_modules/_ node_modules
mkdir -p node_modules/@better-rules-javascript
```

To link local dependencies, run

```sh
ln -rs foo node_modules/@example/foo
ln -rs bar node_modules/@example/bar
```
