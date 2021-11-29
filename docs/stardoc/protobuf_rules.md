<!-- Generated with Stardoc: http://skydoc.bazel.build -->

<a id="#js_proto_export"></a>

## js_proto_export

<pre>
js_proto_export(<a href="#js_proto_export-name">name</a>, <a href="#js_proto_export-dep">dep</a>, <a href="#js_proto_export-lib">lib</a>)
</pre>

TypeScript protobuf library

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
