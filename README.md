# rules_javascript

[![Build](https://github.com/rivethealth/rules_javascript/actions/workflows/build.yml/badge.svg)](https://github.com/rivethealth/rules_javascript/actions/workflows/build.yml)

Bazel rules for JavaScript, TypeScript, and related technologies.

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Philosophy](#philosophy)
- [Install](#install)
- [Example](#example)
- [Documentation](#documentation)
- [Differences with rules_nodejs](#differences-with-rules_nodejs)
- [Developing](#developing)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Philosophy

1. Flexibility and extensibility
1. Performance
1. Bazel idioms
1. Clear separation of concerns

## Install

**WORKSPACE.bazel**

```bzl
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

# skylib

SKYLIB_VERSION = "16de038c484145363340eeaf0e97a0c9889a931b"
http_archive(
    name = "bazel_skylib",
    sha256 = "96e0cd3f731f0caef9e9919aa119ecc6dace36b149c2f47e40aa50587790402b",
    strip_prefix = "bazel-skylib-%s" % SKYLIB_VERSION,
    urls = ["https://github.com/bazelbuild/bazel-skylib/archive/%s.tar.gz" % SKYLIB_VERSION],
)

# better_rules_javascript

JAVACRIPT_VERSION = "..."
http_archive(
    name = "better_rules_javascript",
    strip_prefix = "rules_javascript-%s" % JAVASCRIPT_VERSION,
    urls = ["https://github.com/rivethealth/rules_javascript/archive/%s.tar.gz" % JAVACRIPT_VERSION],
)

load("@better_rules_javascript//rules:workspace.bzl", javascript_repositories = "respositories")
javascript_respositories()
```

## Example

**main.ts**

```ts
console.log("Hello world");
```

**tsconfig.json**

```json
{ "compilerOptions": { "lib": ["dom"] } }
```

**BUILD.bazel**

```bzl
load("@better_rules_javascript//commonjs:rules.bzl", "cjs_root")
load("@better_rules_javascript//javascript:rules.bzl", "js_library")
load("@better_rules_javascript//typescript:rules.bzl", "tsconfig", "ts_library")
load("@better_rules_javascript//nodejs:rules.bzl", "nodejs_binary")

nodejs_binary(
    name = "bin",
    dep = ":lib",
    main = "main.js",
)

ts_library(
    name = "lib",
    config = ":tsconfig",
    root = ":root",
    srcs = ["main.ts"],
    deps = [":lib"],
)

cjs_root(
  name = "root",
  package_name = "example",
)

js_library(
    name = "tsconfig",
    root = ":root",
    srcs = ["tsconfig.json"],
)
```

Running:

```sh
$ bazel run //:bin
Hello world
```

## Documentation

See [documentation](docs/index.md).

## Developing

See [DEVELOPING.md](DEVELOPING.md).
