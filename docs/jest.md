# Jest

Jest tests JavaScript.

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Install](#install)
- [Use](#use)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Install

Add jest as an [external dependency](#external_dependencies).

## Use

**example/example.js**

```js
export function add(a, b) {
  return a + b;
}
```

**example/example.spec.js**

```js
const { add } = require("./example");

test("adds", () => {
  expect(add(1, 2)).toBe(3);
});
```

**example/jest.config.js**

```js
exports.verbose = true;
```

**example/BUILD.bzl**

```bzl
load("@better_rules_javascript//commonjs:rules.bzl", "cjs_root")
load("@better_rules_javascript//javascript:rules.bzl", "js_library")
load("@better_rules_javascript//jest:rules.bzl", "jest_test")

cjs_root(
    name = "root",
)

js_library(
    name = "jest_config",
    root = ":root",
    srcs = ["jest.config.js"],
)

js_library(
    name = "lib",
    root = ":root",
    srcs = ["example.js"],
)

jest_test(
    name = "test",
    config = "jest.config.js",
    config_dep = ":jest_config",
    dep = ":test_lib",
    jest = "@npm//jest:lib",
)

js_library(
    name = "test_lib",
    root = ":root",
    srcs = ["example.spec.js"],
)
```

## Snapshots

To update snapshots, run the test as an executable with
[`-u`/`--update-snapshot`](https://jestjs.io/docs/cli#--updatesnapshot).

```sh
bazel run :example -- -u
```
