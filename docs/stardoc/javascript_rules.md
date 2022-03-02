<!-- Generated with Stardoc: http://skydoc.bazel.build -->

<a id="#js_export"></a>

## js_export

<pre>
js_export(<a href="#js_export-name">name</a>, <a href="#js_export-dep">dep</a>, <a href="#js_export-deps">deps</a>, <a href="#js_export-extra_deps">extra_deps</a>, <a href="#js_export-global_deps">global_deps</a>, <a href="#js_export-package_name">package_name</a>)
</pre>

Add dependencies, or use alias.

**ATTRIBUTES**

| Name                                            | Description                               | Type                                                                        | Mandatory | Default |
| :---------------------------------------------- | :---------------------------------------- | :-------------------------------------------------------------------------- | :-------- | :------ |
| <a id="js_export-name"></a>name                 | A unique name for this target.            | <a href="https://bazel.build/docs/build-ref.html#name">Name</a>             | required  |         |
| <a id="js_export-dep"></a>dep                   | JavaScript library.                       | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a>          | required  |         |
| <a id="js_export-deps"></a>deps                 | Dependencies to add.                      | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional  | []      |
| <a id="js_export-extra_deps"></a>extra_deps     | Extra dependencies to add.                | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional  | []      |
| <a id="js_export-global_deps"></a>global_deps   | Global dependencies to add.               | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional  | []      |
| <a id="js_export-package_name"></a>package_name | Dependency name. Defaults to root's name. | String                                                                      | optional  | ""      |

<a id="#js_library"></a>

## js_library

<pre>
js_library(<a href="#js_library-name">name</a>, <a href="#js_library-data">data</a>, <a href="#js_library-deps">deps</a>, <a href="#js_library-global_deps">global_deps</a>, <a href="#js_library-prefix">prefix</a>, <a href="#js_library-root">root</a>, <a href="#js_library-srcs">srcs</a>, <a href="#js_library-strip_prefix">strip_prefix</a>)
</pre>

JavaScript library

**ATTRIBUTES**

| Name                                             | Description                                                                    | Type                                                                        | Mandatory | Default |
| :----------------------------------------------- | :----------------------------------------------------------------------------- | :-------------------------------------------------------------------------- | :-------- | :------ |
| <a id="js_library-name"></a>name                 | A unique name for this target.                                                 | <a href="https://bazel.build/docs/build-ref.html#name">Name</a>             | required  |         |
| <a id="js_library-data"></a>data                 | Runfile files. These are added to normal runfiles tree, not CommonJS packages. | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional  | []      |
| <a id="js_library-deps"></a>deps                 | Dependencies.                                                                  | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional  | []      |
| <a id="js_library-global_deps"></a>global_deps   | Global dependencies.                                                           | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional  | []      |
| <a id="js_library-prefix"></a>prefix             | Prefix to add.                                                                 | String                                                                      | optional  | ""      |
| <a id="js_library-root"></a>root                 | -                                                                              | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a>          | required  |         |
| <a id="js_library-srcs"></a>srcs                 | JavaScript files and data.                                                     | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional  | []      |
| <a id="js_library-strip_prefix"></a>strip_prefix | Package-relative prefix to remove.                                             | String                                                                      | optional  | ""      |
