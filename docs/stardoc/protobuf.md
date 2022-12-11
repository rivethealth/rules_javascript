# Contents

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

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

# //protobuf:aspects.bzl

<!-- Generated with Stardoc: http://skydoc.bazel.build -->

<a id="#js_proto_aspect"></a>

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

<a id="#JsProtoInfo"></a>

## JsProtoInfo

<pre>
JsProtoInfo(<a href="#JsProtoInfo-transitive_libs">transitive_libs</a>)
</pre>

**FIELDS**

| Name                                                    | Description                |
| :------------------------------------------------------ | :------------------------- |
| <a id="JsProtoInfo-transitive_libs"></a>transitive_libs | Transitive library structs |

<a id="#JsProtobuf"></a>

## JsProtobuf

<pre>
JsProtobuf(<a href="#JsProtobuf-runtime">runtime</a>)
</pre>

**FIELDS**

| Name                                   | Description          |
| :------------------------------------- | :------------------- |
| <a id="JsProtobuf-runtime"></a>runtime | Runtime dependencies |

<a id="#create_lib"></a>

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

<a id="#js_proto_export"></a>

## js_proto_export

<pre>
js_proto_export(<a href="#js_proto_export-name">name</a>, <a href="#js_proto_export-dep">dep</a>, <a href="#js_proto_export-lib">lib</a>)
</pre>

JavaScript protobuf library

**ATTRIBUTES**

| Name                                  | Description                    | Type                                                               | Mandatory | Default |
| :------------------------------------ | :----------------------------- | :----------------------------------------------------------------- | :-------- | :------ |
| <a id="js_proto_export-name"></a>name | A unique name for this target. | <a href="https://bazel.build/docs/build-ref.html#name">Name</a>    | required  |         |
| <a id="js_proto_export-dep"></a>dep   | -                              | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | optional  | None    |
| <a id="js_proto_export-lib"></a>lib   | -                              | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | optional  | None    |

<a id="#js_protoc"></a>

## js_protoc

<pre>
js_protoc(<a href="#js_protoc-name">name</a>, <a href="#js_protoc-runtime">runtime</a>)
</pre>

JavaScript protobuf tools

**ATTRIBUTES**

| Name                                  | Description                    | Type                                                               | Mandatory | Default |
| :------------------------------------ | :----------------------------- | :----------------------------------------------------------------- | :-------- | :------ |
| <a id="js_protoc-name"></a>name       | A unique name for this target. | <a href="https://bazel.build/docs/build-ref.html#name">Name</a>    | required  |         |
| <a id="js_protoc-runtime"></a>runtime | Runtime dependencies           | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | optional  | None    |

<a id="#js_proto_libraries_rule"></a>

## js_proto_libraries_rule

<pre>
js_proto_libraries_rule(<a href="#js_proto_libraries_rule-js_proto">js_proto</a>)
</pre>

    Create js_proto_library rule.

**PARAMETERS**

| Name                                                  | Description | Default Value |
| :---------------------------------------------------- | :---------- | :------------ |
| <a id="js_proto_libraries_rule-js_proto"></a>js_proto | Aspect      | none          |
