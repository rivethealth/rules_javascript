<!-- Generated with Stardoc: http://skydoc.bazel.build -->

<a id="#TsProtoInfo"></a>

## TsProtoInfo

<pre>
TsProtoInfo(<a href="#TsProtoInfo-transitive_libs">transitive_libs</a>, <a href="#TsProtoInfo-transitive_packages">transitive_packages</a>, <a href="#TsProtoInfo-transitive_paths">transitive_paths</a>, <a href="#TsProtoInfo-transitive_files">transitive_files</a>,
            <a href="#TsProtoInfo-transitive_deps">transitive_deps</a>)
</pre>

**FIELDS**

| Name                                                            | Description                |
| :-------------------------------------------------------------- | :------------------------- |
| <a id="TsProtoInfo-transitive_libs"></a>transitive_libs         | Transitive library structs |
| <a id="TsProtoInfo-transitive_packages"></a>transitive_packages | Transitive packages        |
| <a id="TsProtoInfo-transitive_paths"></a>transitive_paths       | Paths of dependencies      |
| <a id="TsProtoInfo-transitive_files"></a>transitive_files       | Transitive declarations    |
| <a id="TsProtoInfo-transitive_deps"></a>transitive_deps         | Transitive deps            |

<a id="#TsProtobuf"></a>

## TsProtobuf

<pre>
TsProtobuf(<a href="#TsProtobuf-bin">bin</a>, <a href="#TsProtobuf-compiler">compiler</a>, <a href="#TsProtobuf-js_deps">js_deps</a>, <a href="#TsProtobuf-ts_deps">ts_deps</a>)
</pre>

**FIELDS**

| Name                                     | Description         |
| :--------------------------------------- | :------------------ |
| <a id="TsProtobuf-bin"></a>bin           | Plugin              |
| <a id="TsProtobuf-compiler"></a>compiler | TypeScript compiler |
| <a id="TsProtobuf-js_deps"></a>js_deps   | Runtime JsInfo      |
| <a id="TsProtobuf-ts_deps"></a>ts_deps   | Declarations        |

<a id="#TsProtosInfo"></a>

## TsProtosInfo

<pre>
TsProtosInfo(<a href="#TsProtosInfo-js">js</a>, <a href="#TsProtosInfo-ts">ts</a>, <a href="#TsProtosInfo-default">default</a>)
</pre>

**FIELDS**

| Name                                     | Description                  |
| :--------------------------------------- | :--------------------------- |
| <a id="TsProtosInfo-js"></a>js           | Dict of JsInfo by label      |
| <a id="TsProtosInfo-ts"></a>ts           | Dict of TsInfo by label      |
| <a id="TsProtosInfo-default"></a>default | Dict of DefaultInfo by label |

<a id="#create_lib"></a>

## create_lib

<pre>
create_lib(<a href="#create_lib-label">label</a>, <a href="#create_lib-path">path</a>, <a href="#create_lib-runfile_path">runfile_path</a>, <a href="#create_lib-deps">deps</a>, <a href="#create_lib-js">js</a>, <a href="#create_lib-declarations">declarations</a>, <a href="#create_lib-srcs">srcs</a>, <a href="#create_lib-js_deps">js_deps</a>, <a href="#create_lib-ts_deps">ts_deps</a>)
</pre>

    Create library struct

**PARAMETERS**

| Name                                             | Description               | Default Value |
| :----------------------------------------------- | :------------------------ | :------------ |
| <a id="create_lib-label"></a>label               | Label                     | none          |
| <a id="create_lib-path"></a>path                 | Directory path            | none          |
| <a id="create_lib-runfile_path"></a>runfile_path | <p align="center"> - </p> | none          |
| <a id="create_lib-deps"></a>deps                 | Labels of dependencies    | none          |
| <a id="create_lib-js"></a>js                     | List of declaration files | none          |
| <a id="create_lib-declarations"></a>declarations | List of declaration files | none          |
| <a id="create_lib-srcs"></a>srcs                 | List of source files      | none          |
| <a id="create_lib-js_deps"></a>js_deps           | <p align="center"> - </p> | none          |
| <a id="create_lib-ts_deps"></a>ts_deps           | <p align="center"> - </p> | none          |
