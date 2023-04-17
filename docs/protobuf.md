# Protobuf

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Guide](#guide)
  - [Reference](#reference)
  - [Install](#install)
  - [Configure](#configure)
  - [Use](#use)
- [//protobuf:aspects.bzl](#protobufaspectsbzl)
  - [js_proto_aspect](#js_proto_aspect)
- [//protobuf:providers.bzl](#protobufprovidersbzl)
  - [JsProtoInfo](#jsprotoinfo)
  - [JsProtobuf](#jsprotobuf)
  - [create_lib](#create_lib)
- [//protobuf:rules.bzl](#protobufrulesbzl)
  - [js_proto_export](#js_proto_export)
  - [js_protoc](#js_protoc)
  - [js_proto_libraries_rule](#js_proto_libraries_rule)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Guide

## Reference

[Starlark reference](stardoc/protobuf.md)

## Install

**WORKSPACE.bazel**

```bzl
PROTO_VERSION = "7e4afce6fe62dbff0a4a03450143146f9f2d7488"
http_archive(
    name = "rules_proto",
    sha256 = "8e7d59a5b12b233be5652e3d29f42fba01c7cbab09f6b3a8d0a57ed6d1e9a0da",
    strip_prefix = "rules_proto-%s" % PROTO_VERSION,
    urls = ["https://github.com/bazelbuild/rules_proto/archive/%s.tar.gz" % PROTO_VERSION],
)
load("@rules_proto//proto:repositories.bzl", "rules_proto_dependencies", "rules_proto_toolchains")
rules_proto_dependencies()
rules_proto_toolchains()

PROTO_GRPC_VERSION = "2.0.0"
http_archive(
    name = "rules_proto_grpc",
    urls = ["https://github.com/rules-proto-grpc/rules_proto_grpc/archive/%s.tar.gz" % PROTO_GRPC_VERSION],
    sha256 = "d771584bbff98698e7cb3cb31c132ee206a972569f4dc8b65acbdd934d156b33",
    strip_prefix = "rules_proto_grpc-%s" % PROTO_GRPC_VERSION,
)
load("@rules_proto_grpc//:repositories.bzl", "rules_proto_grpc_toolchains", "rules_proto_grpc_repos")
rules_proto_grpc_toolchains()
rules_proto_grpc_repos()
```

Add google-protobuf as an [external dependency](#external-dependencies).

## Configure

**BUILD.bazel**

```bzl
load("@better_rules_javascript//protobuf:rules.bzl", "js_protoc")

package(default_visibility = ["//visibility:public"])

cjs_root(
    descriptor = "proto.package.json",
    name = "proto_root",
    package_name = "@better_rules_javascript_test/proto"
)

js_protoc(
    name = "js_protoc",
    root = ":proto_root",
    runtime = "@npm//google-protobuf:lib",
)
```

**package.json**

```json
{}
```

**rules.bzl**

```bzl
load("@better_rules_javascript//protobuf:aspects.bzl", "js_proto_aspect")
load("@better_rules_javascript//protobuf:rules.bzl", "js_proto_library_rule")

js_proto = js_proto_aspect("@better_rules_javascript_test//:lib_protoc")

js_proto_library = js_proto_library_rule(js_proto)
```

## Use

```bzl
load("@rules_proto//proto:defs.bzl", "proto_library")
load("//:rules.bzl", "js_proto_library")

proto_library(
    name = "proto",
    srcs = glob(["**/*.proto"]),
)

js_proto_library(
    name = "js",
    dep = ":proto",
)
```

# //protobuf:aspects.bzl

<!-- Generated with Stardoc: http://skydoc.bazel.build -->

<a id="js_proto_aspect"></a>

## js_proto_aspect

<pre>
js_proto_aspect(<a href="#js_proto_aspect-js_protoc">js_protoc</a>)
</pre>

Create js_proto aspect.

**PARAMETERS**

| Name                                            | Description      | Default Value |
| :---------------------------------------------- | :--------------- | :------------ |
| <a id="js_proto_aspect-js_protoc"></a>js_protoc | JsProtobuf label | none          |

# //protobuf:providers.bzl

<!-- Generated with Stardoc: http://skydoc.bazel.build -->

<a id="JsProtoInfo"></a>

## JsProtoInfo

<pre>
JsProtoInfo(<a href="#JsProtoInfo-transitive_libs">transitive_libs</a>)
</pre>

**FIELDS**

| Name                                                    | Description                |
| :------------------------------------------------------ | :------------------------- |
| <a id="JsProtoInfo-transitive_libs"></a>transitive_libs | Transitive library structs |

<a id="JsProtobuf"></a>

## JsProtobuf

<pre>
JsProtobuf(<a href="#JsProtobuf-runtime">runtime</a>)
</pre>

**FIELDS**

| Name                                   | Description          |
| :------------------------------------- | :------------------- |
| <a id="JsProtobuf-runtime"></a>runtime | Runtime dependencies |

<a id="create_lib"></a>

## create_lib

<pre>
create_lib(<a href="#create_lib-label">label</a>, <a href="#create_lib-path">path</a>, <a href="#create_lib-deps">deps</a>, <a href="#create_lib-js">js</a>, <a href="#create_lib-js_deps">js_deps</a>)
</pre>

    Create library struct

**PARAMETERS**

| Name                                   | Description               | Default Value |
| :------------------------------------- | :------------------------ | :------------ |
| <a id="create_lib-label"></a>label     | Label                     | none          |
| <a id="create_lib-path"></a>path       | Directory path            | none          |
| <a id="create_lib-deps"></a>deps       | Labels of dependencies    | none          |
| <a id="create_lib-js"></a>js           | List of declaration files | none          |
| <a id="create_lib-js_deps"></a>js_deps | <p align="center"> - </p> | none          |

# //protobuf:rules.bzl

<!-- Generated with Stardoc: http://skydoc.bazel.build -->

<a id="js_proto_export"></a>

## js_proto_export

<pre>
js_proto_export(<a href="#js_proto_export-name">name</a>, <a href="#js_proto_export-dep">dep</a>, <a href="#js_proto_export-lib">lib</a>)
</pre>

JavaScript protobuf library

**ATTRIBUTES**

| Name                                  | Description                    | Type                                                                | Mandatory | Default           |
| :------------------------------------ | :----------------------------- | :------------------------------------------------------------------ | :-------- | :---------------- |
| <a id="js_proto_export-name"></a>name | A unique name for this target. | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required  |                   |
| <a id="js_proto_export-dep"></a>dep   | -                              | <a href="https://bazel.build/concepts/labels">Label</a>             | optional  | <code>None</code> |
| <a id="js_proto_export-lib"></a>lib   | -                              | <a href="https://bazel.build/concepts/labels">Label</a>             | optional  | <code>None</code> |

<a id="js_protoc"></a>

## js_protoc

<pre>
js_protoc(<a href="#js_protoc-name">name</a>, <a href="#js_protoc-runtime">runtime</a>)
</pre>

JavaScript protobuf tools

**ATTRIBUTES**

| Name                                  | Description                    | Type                                                                | Mandatory | Default           |
| :------------------------------------ | :----------------------------- | :------------------------------------------------------------------ | :-------- | :---------------- |
| <a id="js_protoc-name"></a>name       | A unique name for this target. | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required  |                   |
| <a id="js_protoc-runtime"></a>runtime | Runtime dependencies           | <a href="https://bazel.build/concepts/labels">Label</a>             | optional  | <code>None</code> |

<a id="js_proto_libraries_rule"></a>

## js_proto_libraries_rule

<pre>
js_proto_libraries_rule(<a href="#js_proto_libraries_rule-js_proto">js_proto</a>)
</pre>

    Create js_proto_library rule.

**PARAMETERS**

| Name                                                  | Description | Default Value |
| :---------------------------------------------------- | :---------- | :------------ |
| <a id="js_proto_libraries_rule-js_proto"></a>js_proto | Aspect      | none          |
