# CommonJS

better_rules_javascript organizes modules and other files into CommonJS
"packages."

While the focus is JavaScript, this is also the organization used for other
language, like CSS.

<!-- START doctoc -->
<!-- END doctoc -->

# Guide

## Example

**package.json**

```json
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
