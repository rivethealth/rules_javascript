<!-- Generated with Stardoc: http://skydoc.bazel.build -->

<a id="#TsCompilerInfo"></a>

## TsCompilerInfo

<pre>
TsCompilerInfo(<a href="#TsCompilerInfo-bin">bin</a>, <a href="#TsCompilerInfo-transpile_bin">transpile_bin</a>, <a href="#TsCompilerInfo-runtime_cjs">runtime_cjs</a>, <a href="#TsCompilerInfo-runtime_js">runtime_js</a>)
</pre>

TypeScript compiler

**FIELDS**

| Name                                                   | Description              |
| :----------------------------------------------------- | :----------------------- |
| <a id="TsCompilerInfo-bin"></a>bin                     | Compile executable.      |
| <a id="TsCompilerInfo-transpile_bin"></a>transpile_bin | JS transpile executable. |
| <a id="TsCompilerInfo-runtime_cjs"></a>runtime_cjs     | List of runtime CjsInfo. |
| <a id="TsCompilerInfo-runtime_js"></a>runtime_js       | Runtime files.           |

<a id="#TsInfo"></a>

## TsInfo

<pre>
TsInfo(<a href="#TsInfo-transitive_files">transitive_files</a>)
</pre>

TypeScript

**FIELDS**

| Name                                                 | Description                                 |
| :--------------------------------------------------- | :------------------------------------------ |
| <a id="TsInfo-transitive_files"></a>transitive_files | Depset of files (descriptors, declarations) |

<a id="#create_ts_info"></a>

## create_ts_info

<pre>
create_ts_info(<a href="#create_ts_info-files">files</a>, <a href="#create_ts_info-deps">deps</a>)
</pre>

**PARAMETERS**

| Name                                   | Description               | Default Value   |
| :------------------------------------- | :------------------------ | :-------------- |
| <a id="create_ts_info-files"></a>files | <p align="center"> - </p> | <code>[]</code> |
| <a id="create_ts_info-deps"></a>deps   | <p align="center"> - </p> | <code>[]</code> |

<a id="#declaration_path"></a>

## declaration_path

<pre>
declaration_path(<a href="#declaration_path-path">path</a>)
</pre>

**PARAMETERS**

| Name                                   | Description               | Default Value |
| :------------------------------------- | :------------------------ | :------------ |
| <a id="declaration_path-path"></a>path | <p align="center"> - </p> | none          |

<a id="#is_declaration"></a>

## is_declaration

<pre>
is_declaration(<a href="#is_declaration-path">path</a>)
</pre>

**PARAMETERS**

| Name                                 | Description               | Default Value |
| :----------------------------------- | :------------------------ | :------------ |
| <a id="is_declaration-path"></a>path | <p align="center"> - </p> | none          |

<a id="#is_directory"></a>

## is_directory

<pre>
is_directory(<a href="#is_directory-path">path</a>)
</pre>

**PARAMETERS**

| Name                               | Description               | Default Value |
| :--------------------------------- | :------------------------ | :------------ |
| <a id="is_directory-path"></a>path | <p align="center"> - </p> | none          |

<a id="#is_json"></a>

## is_json

<pre>
is_json(<a href="#is_json-path">path</a>)
</pre>

**PARAMETERS**

| Name                          | Description               | Default Value |
| :---------------------------- | :------------------------ | :------------ |
| <a id="is_json-path"></a>path | <p align="center"> - </p> | none          |

<a id="#js_path"></a>

## js_path

<pre>
js_path(<a href="#js_path-path">path</a>)
</pre>

**PARAMETERS**

| Name                          | Description               | Default Value |
| :---------------------------- | :------------------------ | :------------ |
| <a id="js_path-path"></a>path | <p align="center"> - </p> | none          |

<a id="#map_path"></a>

## map_path

<pre>
map_path(<a href="#map_path-path">path</a>)
</pre>

**PARAMETERS**

| Name                           | Description               | Default Value |
| :----------------------------- | :------------------------ | :------------ |
| <a id="map_path-path"></a>path | <p align="center"> - </p> | none          |

<a id="#module"></a>

## module

<pre>
module(<a href="#module-module">module</a>)
</pre>

**PARAMETERS**

| Name                             | Description               | Default Value |
| :------------------------------- | :------------------------ | :------------ |
| <a id="module-module"></a>module | <p align="center"> - </p> | none          |

<a id="#target"></a>

## target

<pre>
target(<a href="#target-language">language</a>)
</pre>

**PARAMETERS**

| Name                                 | Description               | Default Value |
| :----------------------------------- | :------------------------ | :------------ |
| <a id="target-language"></a>language | <p align="center"> - </p> | none          |
