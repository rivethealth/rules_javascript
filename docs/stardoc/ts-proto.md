# Contents

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [//ts-proto:providers.bzl](#ts-protoprovidersbzl)
  - [TsProtoInfo](#tsprotoinfo)
  - [TsProtobuf](#tsprotobuf)
  - [TsProtosInfo](#tsprotosinfo)
  - [create_lib](#create_lib)
- [//ts-proto:rules.bzl](#ts-protorulesbzl)
  - [ts_proto_export](#ts_proto_export)
  - [ts_protoc](#ts_protoc)
  - [configure_ts_protoc](#configure_ts_protoc)
  - [ts_proto_libraries_rule](#ts_proto_libraries_rule)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# //ts-proto:providers.bzl

<!-- Generated with Stardoc: http://skydoc.bazel.build -->

<a id="#TsProtoInfo"></a>

## TsProtoInfo

<pre>
TsProtoInfo(<a href="#TsProtoInfo-transitive_libs">transitive_libs</a>)
</pre>

TS proto info

**FIELDS**

| Name                                                    | Description          |
| :------------------------------------------------------ | :------------------- |
| <a id="TsProtoInfo-transitive_libs"></a>transitive_libs | Transitive libraries |

<a id="#TsProtobuf"></a>

## TsProtobuf

<pre>
TsProtobuf(<a href="#TsProtobuf-bin">bin</a>, <a href="#TsProtobuf-tsc">tsc</a>, <a href="#TsProtobuf-deps_cjs">deps_cjs</a>, <a href="#TsProtobuf-deps_js">deps_js</a>, <a href="#TsProtobuf-deps_ts">deps_ts</a>, <a href="#TsProtobuf-options">options</a>)
</pre>

TypeScript Protobuf compiler

**FIELDS**

| Name                                     | Description         |
| :--------------------------------------- | :------------------ |
| <a id="TsProtobuf-bin"></a>bin           | Plugin              |
| <a id="TsProtobuf-tsc"></a>tsc           | TypeScript compiler |
| <a id="TsProtobuf-deps_cjs"></a>deps_cjs | List of CjsInfo     |
| <a id="TsProtobuf-deps_js"></a>deps_js   | List of JsInfo      |
| <a id="TsProtobuf-deps_ts"></a>deps_ts   | List of TsInfo      |
| <a id="TsProtobuf-options"></a>options   | Options             |

<a id="#TsProtosInfo"></a>

## TsProtosInfo

<pre>
TsProtosInfo(<a href="#TsProtosInfo-cjs">cjs</a>, <a href="#TsProtosInfo-js">js</a>, <a href="#TsProtosInfo-ts">ts</a>, <a href="#TsProtosInfo-default">default</a>)
</pre>

**FIELDS**

| Name                                     | Description                  |
| :--------------------------------------- | :--------------------------- |
| <a id="TsProtosInfo-cjs"></a>cjs         | Dict of CjsInfo by label     |
| <a id="TsProtosInfo-js"></a>js           | Dict of JsInfo by label      |
| <a id="TsProtosInfo-ts"></a>ts           | Dict of TsInfo by label      |
| <a id="TsProtosInfo-default"></a>default | Dict of DefaultInfo by label |

<a id="#create_lib"></a>

## create_lib

<pre>
create_lib(<a href="#create_lib-label">label</a>, <a href="#create_lib-path">path</a>, <a href="#create_lib-files">files</a>, <a href="#create_lib-deps">deps</a>)
</pre>

    Create library struct

**PARAMETERS**

| Name                               | Description              | Default Value |
| :--------------------------------- | :----------------------- | :------------ |
| <a id="create_lib-label"></a>label | Label                    | none          |
| <a id="create_lib-path"></a>path   | Directory path           | none          |
| <a id="create_lib-files"></a>files | List of TypeScript files | none          |
| <a id="create_lib-deps"></a>deps   | Labels of dependencies   | none          |

# //ts-proto:rules.bzl

<!-- Generated with Stardoc: http://skydoc.bazel.build -->

<a id="#ts_proto_export"></a>

## ts_proto_export

<pre>
ts_proto_export(<a href="#ts_proto_export-name">name</a>, <a href="#ts_proto_export-dep">dep</a>, <a href="#ts_proto_export-lib">lib</a>)
</pre>

TypeScript protobuf library

**ATTRIBUTES**

| Name                                  | Description                    | Type                                                               | Mandatory | Default |
| :------------------------------------ | :----------------------------- | :----------------------------------------------------------------- | :-------- | :------ |
| <a id="ts_proto_export-name"></a>name | A unique name for this target. | <a href="https://bazel.build/docs/build-ref.html#name">Name</a>    | required  |         |
| <a id="ts_proto_export-dep"></a>dep   | -                              | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | optional  | None    |
| <a id="ts_proto_export-lib"></a>lib   | -                              | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | optional  | None    |

<a id="#ts_protoc"></a>

## ts_protoc

<pre>
ts_protoc(<a href="#ts_protoc-name">name</a>, <a href="#ts_protoc-bin">bin</a>, <a href="#ts_protoc-deps">deps</a>, <a href="#ts_protoc-options">options</a>, <a href="#ts_protoc-tsc">tsc</a>)
</pre>

**ATTRIBUTES**

| Name                                  | Description                    | Type                                                                        | Mandatory | Default |
| :------------------------------------ | :----------------------------- | :-------------------------------------------------------------------------- | :-------- | :------ |
| <a id="ts_protoc-name"></a>name       | A unique name for this target. | <a href="https://bazel.build/docs/build-ref.html#name">Name</a>             | required  |         |
| <a id="ts_protoc-bin"></a>bin         | Protoc plugin                  | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a>          | required  |         |
| <a id="ts_protoc-deps"></a>deps       | Dependencies                   | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | required  |         |
| <a id="ts_protoc-options"></a>options | -                              | List of strings                                                             | optional  | []      |
| <a id="ts_protoc-tsc"></a>tsc         | TypeScript compiler            | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a>          | required  |         |

<a id="#configure_ts_protoc"></a>

## configure_ts_protoc

<pre>
configure_ts_protoc(<a href="#configure_ts_protoc-name">name</a>, <a href="#configure_ts_protoc-tsc">tsc</a>, <a href="#configure_ts_protoc-ts_proto">ts_proto</a>, <a href="#configure_ts_protoc-deps">deps</a>, <a href="#configure_ts_protoc-options">options</a>, <a href="#configure_ts_protoc-visibility">visibility</a>)
</pre>

**PARAMETERS**

| Name                                                  | Description               | Default Value     |
| :---------------------------------------------------- | :------------------------ | :---------------- |
| <a id="configure_ts_protoc-name"></a>name             | <p align="center"> - </p> | none              |
| <a id="configure_ts_protoc-tsc"></a>tsc               | <p align="center"> - </p> | none              |
| <a id="configure_ts_protoc-ts_proto"></a>ts_proto     | <p align="center"> - </p> | none              |
| <a id="configure_ts_protoc-deps"></a>deps             | <p align="center"> - </p> | none              |
| <a id="configure_ts_protoc-options"></a>options       | <p align="center"> - </p> | <code>[]</code>   |
| <a id="configure_ts_protoc-visibility"></a>visibility | <p align="center"> - </p> | <code>None</code> |

<a id="#ts_proto_libraries_rule"></a>

## ts_proto_libraries_rule

<pre>
ts_proto_libraries_rule(<a href="#ts_proto_libraries_rule-aspect">aspect</a>, <a href="#ts_proto_libraries_rule-compiler">compiler</a>)
</pre>

**PARAMETERS**

| Name                                                  | Description               | Default Value |
| :---------------------------------------------------- | :------------------------ | :------------ |
| <a id="ts_proto_libraries_rule-aspect"></a>aspect     | <p align="center"> - </p> | none          |
| <a id="ts_proto_libraries_rule-compiler"></a>compiler | <p align="center"> - </p> | none          |
