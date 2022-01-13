<!-- Generated with Stardoc: http://skydoc.bazel.build -->

<a id="#SimpleTsCompilerInfo"></a>

## SimpleTsCompilerInfo

<pre>
SimpleTsCompilerInfo(<a href="#SimpleTsCompilerInfo-bin">bin</a>, <a href="#SimpleTsCompilerInfo-js_deps">js_deps</a>, <a href="#SimpleTsCompilerInfo-ts_deps">ts_deps</a>)
</pre>

TypeScript compiler

**FIELDS**

| Name                                             | Description |
| :----------------------------------------------- | :---------- |
| <a id="SimpleTsCompilerInfo-bin"></a>bin         | Executable  |
| <a id="SimpleTsCompilerInfo-js_deps"></a>js_deps | Js deps     |
| <a id="SimpleTsCompilerInfo-ts_deps"></a>ts_deps | TS deps     |

<a id="#TsCompilerInfo"></a>

## TsCompilerInfo

<pre>
TsCompilerInfo(<a href="#TsCompilerInfo-bin">bin</a>, <a href="#TsCompilerInfo-transpile_bin">transpile_bin</a>, <a href="#TsCompilerInfo-js_deps">js_deps</a>, <a href="#TsCompilerInfo-ts_deps">ts_deps</a>)
</pre>

TypeScript compiler

**FIELDS**

| Name                                                   | Description |
| :----------------------------------------------------- | :---------- |
| <a id="TsCompilerInfo-bin"></a>bin                     | Executable  |
| <a id="TsCompilerInfo-transpile_bin"></a>transpile_bin | Executable  |
| <a id="TsCompilerInfo-js_deps"></a>js_deps             | JS deps     |
| <a id="TsCompilerInfo-ts_deps"></a>ts_deps             | TS deps     |

<a id="#TsInfo"></a>

## TsInfo

<pre>
TsInfo(<a href="#TsInfo-name">name</a>, <a href="#TsInfo-package">package</a>, <a href="#TsInfo-transitive_deps">transitive_deps</a>, <a href="#TsInfo-transitive_files">transitive_files</a>, <a href="#TsInfo-transitive_packages">transitive_packages</a>, <a href="#TsInfo-transitive_srcs">transitive_srcs</a>)
</pre>

TypeScript

**FIELDS**

| Name                                                       | Description                                 |
| :--------------------------------------------------------- | :------------------------------------------ |
| <a id="TsInfo-name"></a>name                               | Package name                                |
| <a id="TsInfo-package"></a>package                         | CommonJS package                            |
| <a id="TsInfo-transitive_deps"></a>transitive_deps         | Depset of extra links                       |
| <a id="TsInfo-transitive_files"></a>transitive_files       | Depset of files (descriptors, declarations) |
| <a id="TsInfo-transitive_packages"></a>transitive_packages | Depset of packages                          |
| <a id="TsInfo-transitive_srcs"></a>transitive_srcs         | Depset of sources                           |

<a id="#TsconfigInfo"></a>

## TsconfigInfo

<pre>
TsconfigInfo(<a href="#TsconfigInfo-file">file</a>, <a href="#TsconfigInfo-name">name</a>, <a href="#TsconfigInfo-package">package</a>, <a href="#TsconfigInfo-transitive_deps">transitive_deps</a>, <a href="#TsconfigInfo-transitive_files">transitive_files</a>, <a href="#TsconfigInfo-transitive_packages">transitive_packages</a>)
</pre>

TypeScript config file

**FIELDS**

| Name                                                             | Description                                 |
| :--------------------------------------------------------------- | :------------------------------------------ |
| <a id="TsconfigInfo-file"></a>file                               | Config file                                 |
| <a id="TsconfigInfo-name"></a>name                               | Package name                                |
| <a id="TsconfigInfo-package"></a>package                         | Package                                     |
| <a id="TsconfigInfo-transitive_deps"></a>transitive_deps         | Depset of extra links                       |
| <a id="TsconfigInfo-transitive_files"></a>transitive_files       | Depset of files (descriptors, config files) |
| <a id="TsconfigInfo-transitive_packages"></a>transitive_packages | Depset of packages                          |

<a id="#create_deps"></a>

## create_deps

<pre>
create_deps(<a href="#create_deps-package">package</a>, <a href="#create_deps-label">label</a>, <a href="#create_deps-ts_infos">ts_infos</a>)
</pre>

**PARAMETERS**

| Name                                      | Description               | Default Value |
| :---------------------------------------- | :------------------------ | :------------ |
| <a id="create_deps-package"></a>package   | <p align="center"> - </p> | none          |
| <a id="create_deps-label"></a>label       | <p align="center"> - </p> | none          |
| <a id="create_deps-ts_infos"></a>ts_infos | <p align="center"> - </p> | none          |

<a id="#create_extra_deps"></a>

## create_extra_deps

<pre>
create_extra_deps(<a href="#create_extra_deps-package">package</a>, <a href="#create_extra_deps-label">label</a>, <a href="#create_extra_deps-extra_deps">extra_deps</a>)
</pre>

**PARAMETERS**

| Name                                                | Description               | Default Value |
| :-------------------------------------------------- | :------------------------ | :------------ |
| <a id="create_extra_deps-package"></a>package       | <p align="center"> - </p> | none          |
| <a id="create_extra_deps-label"></a>label           | <p align="center"> - </p> | none          |
| <a id="create_extra_deps-extra_deps"></a>extra_deps | <p align="center"> - </p> | none          |

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

<a id="#target_deps"></a>

## target_deps

<pre>
target_deps(<a href="#target_deps-package">package</a>, <a href="#target_deps-targets">targets</a>)
</pre>

**PARAMETERS**

| Name                                    | Description               | Default Value |
| :-------------------------------------- | :------------------------ | :------------ |
| <a id="target_deps-package"></a>package | <p align="center"> - </p> | none          |
| <a id="target_deps-targets"></a>targets | <p align="center"> - </p> | none          |

<a id="#target_globals"></a>

## target_globals

<pre>
target_globals(<a href="#target_globals-targets">targets</a>)
</pre>

**PARAMETERS**

| Name                                       | Description               | Default Value |
| :----------------------------------------- | :------------------------ | :------------ |
| <a id="target_globals-targets"></a>targets | <p align="center"> - </p> | none          |
