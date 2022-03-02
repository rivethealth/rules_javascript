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
