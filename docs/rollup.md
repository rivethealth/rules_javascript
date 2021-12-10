# Rollup

Rollup bundles modules into one or more files.

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Install](#install)
- [Use](#use)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Install

Add rollup as an [external dependency](#external_dependencies).

## Use

**example/package.json**

```json
{}
```

**example/a.js**

```js
export const a = "apple";
```

**example/b.js**

```js
import { a } from "./a";

console.log(a);
```

**example/rollup.config.js**

```js
export default {
  input: `${process.env.ROLLUP_INPUT_ROOT}/index.js`,
  output: { file: process.env.ROLLUP_OUTPUT, format: "cjs" },
};
```

**example/BUILD.bzl**

```bzl
load("@better_rules_javascript//javascript:rules.bzl", "js_library")
load("@better_rules_javascript//rollup:rules.bzl", "configure_rollup", "rollup_bundle")

cjs_root(
  name = "root",
  descriptor = "package.json"
)

js_library(
    name = "js",
    root = ":root",
    srcs = ["a.js", "b.js"],
)

js_library(
    name = "rollup_config",
    root = ":root",
    srcs = ["rollup.config.js"],
)

configure_rollup(
    name = "rollup",
    config = "rollup.config.cjs",
    config_dep = ":rollup_config",
    dep = "@npm//rollup:lib",
)

rollup_bundle(
    name = "bundle",
    dep = ":b",
    rollup = ":rollup",
)
```
