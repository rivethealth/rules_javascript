# Webpack

Webpack bundles modules into one or more files.

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Reference](#reference)
- [Install](#install)
- [Use](#use)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Reference

[Starlark reference](stardoc/webpack.md)

## Install

Add webpack as an [external dependency](#external_dependencies).

## Use

**example/a.js**

```js
export const a = "apple";
```

**example/b.js**

```js
import { a } from "./a";

console.log(a);
```

**example/webpack.config.js**

```js
const path = require("path");

module.exports = {
  entry: path.resolve(`${process.env.WEBPACK_INPUT_ROOT}/b.js`),
  output: {
    filename: path.basename(process.env.WEBPACK_OUTPUT),
    path: path.resolve(path.dirname(process.env.WEBPACK_OUTPUT)),
  },
};
```

**example/BUILD.bzl**

```bzl
load("@better_rules_javascript//commonjs:rules.bzl", "cjs_root")
load("@better_rules_javascript//javascript:rules.bzl", "js_file", "js_library")
load("@better_rules_javascript//webpack:rules.bzl", "configure_webpack", "webpack_bundle")

cjs_root(
  name = "root",
  descriptors = [],
)

js_library(
    name = "js",
    root = ":root",
    srcs = ["a.js", "b.js"],
)

js_file(
    name = "webpack_config",
    root = ":root",
    src = "webpack.config.js",
)

configure_webpack(
    name = "webpack",
    config = ":webpack_config",
    dep = "@npm//webpack:lib",
    # TODO: devserver
)

webpack_bundle(
    name = "bundle",
    dep = ":b",
    webpack = ":webpack",
)
```
