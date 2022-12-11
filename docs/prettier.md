# Prettier

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Reference](#reference)
- [Install](#install)
- [Configure](#configure)
- [Use](#use)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Reference

[Starlark reference](stardoc/prettier.md)

## Install

Add prettier as an [external dependency](#external_dependencies).

## Configure

**tools/BUILD.bzl**

```bzl
load("@better_rules_javascript//prettier:rules.bzl", "configure_prettier")

configure_prettier(
    name = "prettier",
    config = "//:.prettierrc.yml", # optional
    prettier = "@npm//prettier:lib",
)
```

## Use

To format:

```sh
bazel run //:prettier_format -- write
```

To check format (e.g. in CI):

```sh
bazel run //:prettier_format
```
