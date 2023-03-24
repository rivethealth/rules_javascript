# Contents

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [//javascript:providers.bzl](#javascriptprovidersbzl)
  - [JsInfo](#jsinfo)
  - [create_js_info](#create_js_info)
  - [js_npm_inner_label](#js_npm_inner_label)
  - [js_npm_label](#js_npm_label)
- [//javascript:rules.bzl](#javascriptrulesbzl)
  - [js_export](#js_export)
  - [js_library](#js_library)
- [//javascript:workspace.bzl](#javascriptworkspacebzl)
  - [js_directory_npm_plugin](#js_directory_npm_plugin)
  - [js_npm_plugin](#js_npm_plugin)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# //javascript:providers.bzl

<!-- Generated with Stardoc: http://skydoc.bazel.build -->

<a id="JsInfo"></a>

## JsInfo

<pre>
JsInfo(<a href="#JsInfo-transitive_files">transitive_files</a>)
</pre>

JavaScript

**FIELDS**

| Name                                                 | Description                                           |
| :--------------------------------------------------- | :---------------------------------------------------- |
| <a id="JsInfo-transitive_files"></a>transitive_files | Depset of files (descriptors, JavaScript, data files) |

<a id="create_js_info"></a>

## create_js_info

<pre>
create_js_info(<a href="#create_js_info-cjs_root">cjs_root</a>, <a href="#create_js_info-files">files</a>, <a href="#create_js_info-deps">deps</a>)
</pre>

**PARAMETERS**

| Name                                         | Description               | Default Value   |
| :------------------------------------------- | :------------------------ | :-------------- |
| <a id="create_js_info-cjs_root"></a>cjs_root | <p align="center"> - </p> | none            |
| <a id="create_js_info-files"></a>files       | <p align="center"> - </p> | <code>[]</code> |
| <a id="create_js_info-deps"></a>deps         | <p align="center"> - </p> | <code>[]</code> |

<a id="js_npm_inner_label"></a>

## js_npm_inner_label

<pre>
js_npm_inner_label(<a href="#js_npm_inner_label-repo">repo</a>)
</pre>

**PARAMETERS**

| Name                                     | Description               | Default Value |
| :--------------------------------------- | :------------------------ | :------------ |
| <a id="js_npm_inner_label-repo"></a>repo | <p align="center"> - </p> | none          |

<a id="js_npm_label"></a>

## js_npm_label

<pre>
js_npm_label(<a href="#js_npm_label-repo">repo</a>)
</pre>

**PARAMETERS**

| Name                               | Description               | Default Value |
| :--------------------------------- | :------------------------ | :------------ |
| <a id="js_npm_label-repo"></a>repo | <p align="center"> - </p> | none          |

# //javascript:rules.bzl

<!-- Generated with Stardoc: http://skydoc.bazel.build -->

<a id="js_export"></a>

## js_export

<pre>
js_export(<a href="#js_export-name">name</a>, <a href="#js_export-dep">dep</a>, <a href="#js_export-deps">deps</a>, <a href="#js_export-extra_deps">extra_deps</a>, <a href="#js_export-global_deps">global_deps</a>, <a href="#js_export-package_name">package_name</a>)
</pre>

Add dependencies, or use alias.

**ATTRIBUTES**

| Name                                            | Description                               | Type                                                                | Mandatory | Default         |
| :---------------------------------------------- | :---------------------------------------- | :------------------------------------------------------------------ | :-------- | :-------------- |
| <a id="js_export-name"></a>name                 | A unique name for this target.            | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required  |                 |
| <a id="js_export-dep"></a>dep                   | JavaScript library.                       | <a href="https://bazel.build/concepts/labels">Label</a>             | required  |                 |
| <a id="js_export-deps"></a>deps                 | Dependencies to add.                      | <a href="https://bazel.build/concepts/labels">List of labels</a>    | optional  | <code>[]</code> |
| <a id="js_export-extra_deps"></a>extra_deps     | Extra dependencies to add.                | <a href="https://bazel.build/concepts/labels">List of labels</a>    | optional  | <code>[]</code> |
| <a id="js_export-global_deps"></a>global_deps   | Global dependencies to add.               | <a href="https://bazel.build/concepts/labels">List of labels</a>    | optional  | <code>[]</code> |
| <a id="js_export-package_name"></a>package_name | Dependency name. Defaults to root's name. | String                                                              | optional  | <code>""</code> |

<a id="js_library"></a>

## js_library

<pre>
js_library(<a href="#js_library-name">name</a>, <a href="#js_library-data">data</a>, <a href="#js_library-deps">deps</a>, <a href="#js_library-global_deps">global_deps</a>, <a href="#js_library-prefix">prefix</a>, <a href="#js_library-root">root</a>, <a href="#js_library-srcs">srcs</a>, <a href="#js_library-strip_prefix">strip_prefix</a>)
</pre>

JavaScript library

**ATTRIBUTES**

| Name                                             | Description                                                                    | Type                                                                | Mandatory | Default           |
| :----------------------------------------------- | :----------------------------------------------------------------------------- | :------------------------------------------------------------------ | :-------- | :---------------- |
| <a id="js_library-name"></a>name                 | A unique name for this target.                                                 | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required  |                   |
| <a id="js_library-data"></a>data                 | Runfile files. These are added to normal runfiles tree, not CommonJS packages. | <a href="https://bazel.build/concepts/labels">List of labels</a>    | optional  | <code>[]</code>   |
| <a id="js_library-deps"></a>deps                 | Dependencies.                                                                  | <a href="https://bazel.build/concepts/labels">List of labels</a>    | optional  | <code>[]</code>   |
| <a id="js_library-global_deps"></a>global_deps   | Global dependencies.                                                           | <a href="https://bazel.build/concepts/labels">List of labels</a>    | optional  | <code>[]</code>   |
| <a id="js_library-prefix"></a>prefix             | Prefix to add.                                                                 | String                                                              | optional  | <code>""</code>   |
| <a id="js_library-root"></a>root                 | -                                                                              | <a href="https://bazel.build/concepts/labels">Label</a>             | optional  | <code>None</code> |
| <a id="js_library-srcs"></a>srcs                 | JavaScript files and data.                                                     | <a href="https://bazel.build/concepts/labels">List of labels</a>    | optional  | <code>[]</code>   |
| <a id="js_library-strip_prefix"></a>strip_prefix | Package-relative prefix to remove.                                             | String                                                              | optional  | <code>""</code>   |

# //javascript:workspace.bzl

<!-- Generated with Stardoc: http://skydoc.bazel.build -->

<a id="js_directory_npm_plugin"></a>

## js_directory_npm_plugin

<pre>
js_directory_npm_plugin()
</pre>

<a id="js_npm_plugin"></a>

## js_npm_plugin

<pre>
js_npm_plugin(<a href="#js_npm_plugin-exclude_suffixes">exclude_suffixes</a>)
</pre>

**PARAMETERS**

| Name                                                        | Description               | Default Value   |
| :---------------------------------------------------------- | :------------------------ | :-------------- |
| <a id="js_npm_plugin-exclude_suffixes"></a>exclude_suffixes | <p align="center"> - </p> | <code>[]</code> |
