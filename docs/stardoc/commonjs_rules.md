<!-- Generated with Stardoc: http://skydoc.bazel.build -->

<a id="#cjs_import"></a>

## cjs_import

<pre>
cjs_import(<a href="#cjs_import-name">name</a>, <a href="#cjs_import-dep">dep</a>, <a href="#cjs_import-package_name">package_name</a>)
</pre>

CommonJS alias

**ATTRIBUTES**

| Name                                             | Description                    | Type                                                               | Mandatory | Default |
| :----------------------------------------------- | :----------------------------- | :----------------------------------------------------------------- | :-------- | :------ |
| <a id="cjs_import-name"></a>name                 | A unique name for this target. | <a href="https://bazel.build/docs/build-ref.html#name">Name</a>    | required  |         |
| <a id="cjs_import-dep"></a>dep                   | CommonJS root                  | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | required  |         |
| <a id="cjs_import-package_name"></a>package_name | Import alias                   | String                                                             | required  |         |

<a id="#cjs_root"></a>

## cjs_root

<pre>
cjs_root(<a href="#cjs_root-name">name</a>, <a href="#cjs_root-deps">deps</a>, <a href="#cjs_root-descriptor">descriptor</a>, <a href="#cjs_root-package_name">package_name</a>)
</pre>

CommonJS-style root

**ATTRIBUTES**

| Name                                           | Description                    | Type                                                                        | Mandatory | Default |
| :--------------------------------------------- | :----------------------------- | :-------------------------------------------------------------------------- | :-------- | :------ |
| <a id="cjs_root-name"></a>name                 | A unique name for this target. | <a href="https://bazel.build/docs/build-ref.html#name">Name</a>             | required  |         |
| <a id="cjs_root-deps"></a>deps                 | Dependencies                   | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional  | []      |
| <a id="cjs_root-descriptor"></a>descriptor     | package.json descriptor        | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a>          | required  |         |
| <a id="cjs_root-package_name"></a>package_name | Package name                   | String                                                                      | required  |         |
