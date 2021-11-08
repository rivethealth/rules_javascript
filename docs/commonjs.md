# CommonJS

better_rules_javascript organizes modules and other files into CommonJS
"packages."

While the focus is JavaScript, this is also the organization used for other
language, like CSS.

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Example](#example)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Example

**package.json**

```bzl
{}
```

**BUILD.bazel**

```bzl
load("@better_rules_javascript//commonjs:rules.bzl", "cjs_root")

cjs_root(
    name = "root",
    descriptor = "package.json",
    package_name = "example",
)
```
