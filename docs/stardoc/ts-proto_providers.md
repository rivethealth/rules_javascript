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
| <a id="TsProtosInfo-cjs"></a>cjs         | CjsInfo                      |
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
