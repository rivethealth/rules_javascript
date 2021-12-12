<!-- Generated with Stardoc: http://skydoc.bazel.build -->

<a id="#js_export_file"></a>

## js_export_file

<pre>
js_export_file(<a href="#js_export_file-name">name</a>, <a href="#js_export_file-dep">dep</a>, <a href="#js_export_file-path">path</a>)
</pre>

Export file from JS library.

**ATTRIBUTES**

| Name                                 | Description                    | Type                                                               | Mandatory | Default |
| :----------------------------------- | :----------------------------- | :----------------------------------------------------------------- | :-------- | :------ |
| <a id="js_export_file-name"></a>name | A unique name for this target. | <a href="https://bazel.build/docs/build-ref.html#name">Name</a>    | required  |         |
| <a id="js_export_file-dep"></a>dep   | Dependency.                    | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | required  |         |
| <a id="js_export_file-path"></a>path | Path.                          | String                                                             | required  |         |

<a id="#js_file"></a>

## js_file

<pre>
js_file(<a href="#js_file-name">name</a>, <a href="#js_file-deps">deps</a>, <a href="#js_file-extra_deps">extra_deps</a>, <a href="#js_file-path">path</a>, <a href="#js_file-root">root</a>, <a href="#js_file-src">src</a>)
</pre>

Create JS file.

**ATTRIBUTES**

| Name                                      | Description                    | Type                                                                                      | Mandatory | Default |
| :---------------------------------------- | :----------------------------- | :---------------------------------------------------------------------------------------- | :-------- | :------ |
| <a id="js_file-name"></a>name             | A unique name for this target. | <a href="https://bazel.build/docs/build-ref.html#name">Name</a>                           | required  |         |
| <a id="js_file-deps"></a>deps             | Dependencies.                  | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a>               | optional  | []      |
| <a id="js_file-extra_deps"></a>extra_deps | Extra dependencies.            | <a href="https://bazel.build/docs/skylark/lib/dict.html">Dictionary: String -> String</a> | optional  | {}      |
| <a id="js_file-path"></a>path             | Path                           | String                                                                                    | optional  | ""      |
| <a id="js_file-root"></a>root             | CommonJS root                  | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a>                        | required  |         |
| <a id="js_file-src"></a>src               | -                              | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a>                        | required  |         |

<a id="#js_import"></a>

## js_import

<pre>
js_import(<a href="#js_import-name">name</a>, <a href="#js_import-dep">dep</a>, <a href="#js_import-package_name">package_name</a>)
</pre>

JavaScript import

**ATTRIBUTES**

| Name                                            | Description                    | Type                                                               | Mandatory | Default |
| :---------------------------------------------- | :----------------------------- | :----------------------------------------------------------------- | :-------- | :------ |
| <a id="js_import-name"></a>name                 | A unique name for this target. | <a href="https://bazel.build/docs/build-ref.html#name">Name</a>    | required  |         |
| <a id="js_import-dep"></a>dep                   | -                              | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | required  |         |
| <a id="js_import-package_name"></a>package_name | Package alias                  | String                                                             | optional  | ""      |

<a id="#js_library"></a>

## js_library

<pre>
js_library(<a href="#js_library-name">name</a>, <a href="#js_library-deps">deps</a>, <a href="#js_library-extra_deps">extra_deps</a>, <a href="#js_library-prefix">prefix</a>, <a href="#js_library-root">root</a>, <a href="#js_library-srcs">srcs</a>, <a href="#js_library-strip_prefix">strip_prefix</a>)
</pre>

JavaScript library

**ATTRIBUTES**

| Name                                             | Description                       | Type                                                                                      | Mandatory | Default |
| :----------------------------------------------- | :-------------------------------- | :---------------------------------------------------------------------------------------- | :-------- | :------ |
| <a id="js_library-name"></a>name                 | A unique name for this target.    | <a href="https://bazel.build/docs/build-ref.html#name">Name</a>                           | required  |         |
| <a id="js_library-deps"></a>deps                 | Dependencies.                     | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a>               | optional  | []      |
| <a id="js_library-extra_deps"></a>extra_deps     | Extra dependencies.               | <a href="https://bazel.build/docs/skylark/lib/dict.html">Dictionary: String -> String</a> | optional  | {}      |
| <a id="js_library-prefix"></a>prefix             | Prefix to add. Defaults to empty. | String                                                                                    | optional  | ""      |
| <a id="js_library-root"></a>root                 | -                                 | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a>                        | required  |         |
| <a id="js_library-srcs"></a>srcs                 | JavaScript files and data.        | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a>               | required  |         |
| <a id="js_library-strip_prefix"></a>strip_prefix | Remove prefix. Defaults to empty. | String                                                                                    | optional  | ""      |
