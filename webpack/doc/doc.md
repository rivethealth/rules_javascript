# Webpack

Webpack bundles modules into one or more files.

<!-- START doctoc -->
<!-- END doctoc -->

# Guide

## Example

**a.js**

```js
export const a = "apple";
```

**b.js**

```js
import { a } from "./a";

console.log(a);
```

**webpack.config.js**

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

**BUILD.bzl**

```bzl
load("@better_rules_javascript//commonjs:rules.bzl", "cjs_root")
load("@better_rules_javascript//javascript:rules.bzl", "js_library")
load("@better_rules_javascript//webpack:rules.bzl", "configure_webpack", "webpack_bundle")

webpack_bundle(
    name = "bundle",
    dep = ":b",
    root = ":root",
    webpack = ":webpack",
)

js_library(
    name = "lib",
    root = ":root",
    srcs = ["a.js", "b.js"],
)

cjs_root(
  name = "root",
)

configure_webpack(
    name = "webpack",
    config = "webpack.config.js",
    config_dep = ":webpack_config",
)

js_library(
    name = "webpack_config",
    root = ":root",
    srcs = ["webpack.config.js"],
)
```
