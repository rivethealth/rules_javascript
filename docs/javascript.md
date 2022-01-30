# JavaScript

JavaScript libraries are JavaScript files and their dependencies.

Each JS library is within a CommonJS root. For discussion on JS module
resolution, see [Module Resolution](module.md).

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Example](#example)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Module type

The module type is requested using the `//javascript:module` setting.

Examples:

- It is set via transform by `nodejs_binary` to be `node`
- It is used by the `ts_library` to set the `module` compiler option.

`js_library` does not enforce that files adhere to this requirement, or
automatically transform them. Modules should already be in a format compatible
with the final runtime/bundler.

## Example

**package.json**

```json
{}
```

**lib.js**

```js
export const text = "Hello world";
```

**main.js**

```js
import { text } from "./a";

console.log(text);
```

**BAZEL.build**

```bzl
load("@better_rules_javascript//commonjs:rules.bzl", "cjs_root")
load("@better_rules_javascript//javascript:rules.bzl", "js_library")

cjs_root(
    name = "root",
    descriptor = "package.json",
)

js_library(
    name = "lib",
    root = ":root",
    srcs = ["lib.js"],
)

js_library(
    name = "main",
    deps = [":lib"],
    root = ":root",
    srcs = ["main.js"],
)
```
