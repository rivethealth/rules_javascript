<!-- Generated with Stardoc: http://skydoc.bazel.build -->

<a id="#JsInfo"></a>

## JsInfo

<pre>
JsInfo(<a href="#JsInfo-name">name</a>, <a href="#JsInfo-package">package</a>, <a href="#JsInfo-transitive_deps">transitive_deps</a>, <a href="#JsInfo-transitive_files">transitive_files</a>, <a href="#JsInfo-transitive_packages">transitive_packages</a>, <a href="#JsInfo-transitive_srcs">transitive_srcs</a>)
</pre>

JavaScript

**FIELDS**

| Name                                                       | Description                                           |
| :--------------------------------------------------------- | :---------------------------------------------------- |
| <a id="JsInfo-name"></a>name                               | CommonJS name                                         |
| <a id="JsInfo-package"></a>package                         | CommonJS package struct                               |
| <a id="JsInfo-transitive_deps"></a>transitive_deps         | Depset of dependency structs                          |
| <a id="JsInfo-transitive_files"></a>transitive_files       | Depset of files (descriptors, JavaScript, data files) |
| <a id="JsInfo-transitive_packages"></a>transitive_packages | Depset of packages                                    |
| <a id="JsInfo-transitive_srcs"></a>transitive_srcs         | Depset of sources                                     |

<a id="#create_deps"></a>

## create_deps

<pre>
create_deps(<a href="#create_deps-package">package</a>, <a href="#create_deps-label">label</a>, <a href="#create_deps-js_infos">js_infos</a>)
</pre>

**PARAMETERS**

| Name                                      | Description               | Default Value |
| :---------------------------------------- | :------------------------ | :------------ |
| <a id="create_deps-package"></a>package   | <p align="center"> - </p> | none          |
| <a id="create_deps-label"></a>label       | <p align="center"> - </p> | none          |
| <a id="create_deps-js_infos"></a>js_infos | <p align="center"> - </p> | none          |

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

<a id="#create_globals"></a>

## create_globals

<pre>
create_globals(<a href="#create_globals-label">label</a>, <a href="#create_globals-js_infos">js_infos</a>)
</pre>

**PARAMETERS**

| Name                                         | Description               | Default Value |
| :------------------------------------------- | :------------------------ | :------------ |
| <a id="create_globals-label"></a>label       | <p align="center"> - </p> | none          |
| <a id="create_globals-js_infos"></a>js_infos | <p align="center"> - </p> | none          |

<a id="#js_npm_label"></a>

## js_npm_label

<pre>
js_npm_label(<a href="#js_npm_label-repo">repo</a>)
</pre>

**PARAMETERS**

| Name                               | Description               | Default Value |
| :--------------------------------- | :------------------------ | :------------ |
| <a id="js_npm_label-repo"></a>repo | <p align="center"> - </p> | none          |

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
