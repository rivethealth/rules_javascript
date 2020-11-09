<!-- Generated with Stardoc: http://skydoc.bazel.build -->

<a id="#js_import"></a>

## js_import

<pre>
js_import(<a href="#js_import-name">name</a>, <a href="#js_import-dep">dep</a>, <a href="#js_import-package_name">package_name</a>)
</pre>



**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="js_import-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/docs/build-ref.html#name">Name</a> | required |  |
| <a id="js_import-dep"></a>dep |  Package   | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | required |  |
| <a id="js_import-package_name"></a>package_name |  Package name   | String | optional | "" |


<a id="#js_library"></a>

## js_library

<pre>
js_library(<a href="#js_library-name">name</a>, <a href="#js_library-deps">deps</a>, <a href="#js_library-main">main</a>, <a href="#js_library-package_name">package_name</a>, <a href="#js_library-prefix">prefix</a>, <a href="#js_library-srcs">srcs</a>, <a href="#js_library-strip_prefix">strip_prefix</a>)
</pre>



**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="js_library-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/docs/build-ref.html#name">Name</a> | required |  |
| <a id="js_library-deps"></a>deps |  Dependencies   | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional | [] |
| <a id="js_library-main"></a>main |  Main file, if not index.js   | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | optional | None |
| <a id="js_library-package_name"></a>package_name |  Package name. Defaults to repository_name()/package_name().   | String | optional | "" |
| <a id="js_library-prefix"></a>prefix |  Add prefix   | String | optional | "" |
| <a id="js_library-srcs"></a>srcs |  JavaScript files. Must be within one of roots.   | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional | [] |
| <a id="js_library-strip_prefix"></a>strip_prefix |  Remove prefix. Defaults to repository_name()/package_name().   | String | optional | "" |


