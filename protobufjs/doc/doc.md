# Protobuf.js

<!-- START doctoc -->
<!-- END doctoc -->

# Guide

## Reference

[Starlark reference](stardoc/protobufjs.md)

## Install

Add protobufjs as an [external dependency](#external-dependencies).

## Configure

**BUILD.bazel**

```bzl
load("@better_rules_javascript//protobufjs:rules.bzl", configure_js_proto)

configure_js_proto(
    name = "js_proto",
    dep = "@npm//protobufjs:lib",
)
```

## Use

```bzl
load("@better_rules_javascript//commonjs:rules.bzl", "cjs_root")
load("@better_rules_javascript//protobufjs:rules.bzl", "js_proto_library")
load("@rules_proto//proto:defs.bzl", "proto_library")

cjs_root(
    descriptor = "package.json",
    name = "root",
)

proto_library(
    name = "proto",
    srcs = glob(["**/*.proto"]),
)

js_proto_library(
    module_name = "pb.js",
    name = "proto_js",
    root = ":root",
    js_proto = "//:js_protojs",
    deps = [":proto"],
)
```
