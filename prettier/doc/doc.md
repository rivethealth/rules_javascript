# Prettier

<!-- START doctoc -->
<!-- END doctoc -->

# Guide

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
