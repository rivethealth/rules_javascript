# Jest

Jest tests JavaScript.

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Reference](#reference)
- [Install](#install)
- [Options](#options)
- [Use](#use)
- [Snapshots](#snapshots)
- [//jest:rules.bzl](#jestrulesbzl)
  - [jest_test](#jest_test)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Reference

[Starlark reference](stardoc/jest.md)

## Install

Add jest as an [external dependency](#external_dependencies).

## Options

By default, Jest uses `-i --no-cache`. Add options via test arguments.

Sharding support requires Jest v28.

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
    node = "@better_rules_javascript//rules:nodejs",
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

# //jest:rules.bzl

<!-- Generated with Stardoc: http://skydoc.bazel.build -->

<a id="jest_test"></a>

## jest_test

<pre>
jest_test(<a href="#jest_test-name">name</a>, <a href="#jest_test-bash_preamble">bash_preamble</a>, <a href="#jest_test-config">config</a>, <a href="#jest_test-config_dep">config_dep</a>, <a href="#jest_test-data">data</a>, <a href="#jest_test-dep">dep</a>, <a href="#jest_test-env">env</a>, <a href="#jest_test-jest">jest</a>, <a href="#jest_test-node">node</a>, <a href="#jest_test-node_options">node_options</a>)
</pre>

**ATTRIBUTES**

| Name                                              | Description                                       | Type                                                                          | Mandatory | Default               |
| :------------------------------------------------ | :------------------------------------------------ | :---------------------------------------------------------------------------- | :-------- | :-------------------- |
| <a id="jest_test-name"></a>name                   | A unique name for this target.                    | <a href="https://bazel.build/concepts/labels#target-names">Name</a>           | required  |                       |
| <a id="jest_test-bash_preamble"></a>bash_preamble | -                                                 | String                                                                        | optional  | <code>""</code>       |
| <a id="jest_test-config"></a>config               | Path to config file, relative to config_dep root. | String                                                                        | required  |                       |
| <a id="jest_test-config_dep"></a>config_dep       | Jest config dependency.                           | <a href="https://bazel.build/concepts/labels">Label</a>                       | required  |                       |
| <a id="jest_test-data"></a>data                   | Runtime data.                                     | <a href="https://bazel.build/concepts/labels">List of labels</a>              | optional  | <code>[]</code>       |
| <a id="jest_test-dep"></a>dep                     | Test dependency.                                  | <a href="https://bazel.build/concepts/labels">Label</a>                       | required  |                       |
| <a id="jest_test-env"></a>env                     | Environment variables.                            | <a href="https://bazel.build/rules/lib/dict">Dictionary: String -> String</a> | optional  | <code>{}</code>       |
| <a id="jest_test-jest"></a>jest                   | Jest dependency.                                  | <a href="https://bazel.build/concepts/labels">Label</a>                       | required  |                       |
| <a id="jest_test-node"></a>node                   | -                                                 | <a href="https://bazel.build/concepts/labels">Label</a>                       | optional  | <code>//nodejs</code> |
| <a id="jest_test-node_options"></a>node_options   | Node.js options.                                  | List of strings                                                               | optional  | <code>[]</code>       |
