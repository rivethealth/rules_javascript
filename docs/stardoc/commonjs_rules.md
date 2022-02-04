<!-- Generated with Stardoc: http://skydoc.bazel.build -->

<a id="#cjs_descriptors"></a>

## cjs_descriptors

<pre>
cjs_descriptors(<a href="#cjs_descriptors-name">name</a>, <a href="#cjs_descriptors-prefix">prefix</a>, <a href="#cjs_descriptors-srcs">srcs</a>, <a href="#cjs_descriptors-strip_prefix">strip_prefix</a>)
</pre>

**ATTRIBUTES**

| Name                                                  | Description                    | Type                                                                        | Mandatory | Default |
| :---------------------------------------------------- | :----------------------------- | :-------------------------------------------------------------------------- | :-------- | :------ |
| <a id="cjs_descriptors-name"></a>name                 | A unique name for this target. | <a href="https://bazel.build/docs/build-ref.html#name">Name</a>             | required  |         |
| <a id="cjs_descriptors-prefix"></a>prefix             | -                              | String                                                                      | optional  | ""      |
| <a id="cjs_descriptors-srcs"></a>srcs                 | -                              | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | required  |         |
| <a id="cjs_descriptors-strip_prefix"></a>strip_prefix | -                              | String                                                                      | optional  | ""      |

<a id="#cjs_root"></a>

## cjs_root

<pre>
cjs_root(<a href="#cjs_root-name">name</a>, <a href="#cjs_root-deps">deps</a>, <a href="#cjs_root-descriptors">descriptors</a>, <a href="#cjs_root-id">id</a>, <a href="#cjs_root-package_name">package_name</a>, <a href="#cjs_root-path">path</a>, <a href="#cjs_root-strip_prefix">strip_prefix</a>)
</pre>

CommonJS-style root

**ATTRIBUTES**

| Name                                           | Description                    | Type                                                                        | Mandatory | Default |
| :--------------------------------------------- | :----------------------------- | :-------------------------------------------------------------------------- | :-------- | :------ |
| <a id="cjs_root-name"></a>name                 | A unique name for this target. | <a href="https://bazel.build/docs/build-ref.html#name">Name</a>             | required  |         |
| <a id="cjs_root-deps"></a>deps                 | Dependencies                   | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional  | []      |
| <a id="cjs_root-descriptors"></a>descriptors   | package.json descriptors       | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional  | []      |
| <a id="cjs_root-id"></a>id                     | -                              | String                                                                      | optional  | ""      |
| <a id="cjs_root-package_name"></a>package_name | Package name                   | String                                                                      | optional  | ""      |
| <a id="cjs_root-path"></a>path                 | -                              | String                                                                      | optional  | ""      |
| <a id="cjs_root-strip_prefix"></a>strip_prefix | -                              | String                                                                      | optional  | ""      |
