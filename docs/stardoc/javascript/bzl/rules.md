<!-- Generated with Stardoc: http://skydoc.bazel.build -->

<a id="#js_import"></a>

## js_import

<pre>
js_import(<a href="#js_import-name">name</a>, <a href="#js_import-deps">deps</a>, <a href="#js_import-global_deps">global_deps</a>, <a href="#js_import-js_name">js_name</a>)
</pre>

Collect imports.

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="js_import-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/docs/build-ref.html#name">Name</a> | required |  |
| <a id="js_import-deps"></a>deps |  Dependencies.   | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional | [] |
| <a id="js_import-global_deps"></a>global_deps |  Global dependencies   | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional | [] |
| <a id="js_import-js_name"></a>js_name |  Package name.   | String | optional | "" |


<a id="#js_library"></a>

## js_library

<pre>
js_library(<a href="#js_library-name">name</a>, <a href="#js_library-deps">deps</a>, <a href="#js_library-global_deps">global_deps</a>, <a href="#js_library-js_name">js_name</a>, <a href="#js_library-main">main</a>, <a href="#js_library-prefix">prefix</a>, <a href="#js_library-srcs">srcs</a>, <a href="#js_library-strip_prefix">strip_prefix</a>)
</pre>

JavaScript library

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="js_library-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/docs/build-ref.html#name">Name</a> | required |  |
| <a id="js_library-deps"></a>deps |  Dependencies.   | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional | [] |
| <a id="js_library-global_deps"></a>global_deps |  Global depenedencies   | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional | [] |
| <a id="js_library-js_name"></a>js_name |  Package name. Defaults to @repository_name/js_name.   | String | optional | "" |
| <a id="js_library-main"></a>main |  Main module, if not index.js.   | String | optional | "" |
| <a id="js_library-prefix"></a>prefix |  Prefix to add. Defaults to empty.   | String | optional | "" |
| <a id="js_library-srcs"></a>srcs |  JavaScript files.   | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | required |  |
| <a id="js_library-strip_prefix"></a>strip_prefix |  Remove prefix. Defaults to repository_name/js_name.   | String | optional | "" |


<a id="#default_package_name"></a>

## default_package_name

<pre>
default_package_name(<a href="#default_package_name-ctx">ctx</a>)
</pre>



**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="default_package_name-ctx"></a>ctx |  <p align="center"> - </p>   |  none |


<a id="#default_strip_prefix"></a>

## default_strip_prefix

<pre>
default_strip_prefix(<a href="#default_strip_prefix-ctx">ctx</a>)
</pre>



**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="default_strip_prefix-ctx"></a>ctx |  <p align="center"> - </p>   |  none |


