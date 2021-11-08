<!-- Generated with Stardoc: http://skydoc.bazel.build -->

<a id="#js_protoc"></a>

## js_protoc

<pre>
js_protoc(<a href="#js_protoc-name">name</a>, <a href="#js_protoc-root">root</a>, <a href="#js_protoc-runtime">runtime</a>)
</pre>

JavaScript protobuf tools

**ATTRIBUTES**

| Name                                  | Description                    | Type                                                               | Mandatory | Default |
| :------------------------------------ | :----------------------------- | :----------------------------------------------------------------- | :-------- | :------ |
| <a id="js_protoc-name"></a>name       | A unique name for this target. | <a href="https://bazel.build/docs/build-ref.html#name">Name</a>    | required  |         |
| <a id="js_protoc-root"></a>root       | CommonJS root                  | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | optional  | None    |
| <a id="js_protoc-runtime"></a>runtime | Runtime dependencies           | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | optional  | None    |

<a id="#js_proto_library_rule"></a>

## js_proto_library_rule

<pre>
js_proto_library_rule(<a href="#js_proto_library_rule-js_proto">js_proto</a>)
</pre>

    Create js_proto_library rule.

**PARAMETERS**

| Name                                                | Description | Default Value |
| :-------------------------------------------------- | :---------- | :------------ |
| <a id="js_proto_library_rule-js_proto"></a>js_proto | Aspect      | none          |
