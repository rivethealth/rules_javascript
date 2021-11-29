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
