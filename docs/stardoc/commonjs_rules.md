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
cjs_root(<a href="#cjs_root-name">name</a>, <a href="#cjs_root-deps">deps</a>, <a href="#cjs_root-descriptors">descriptors</a>, <a href="#cjs_root-package_name">package_name</a>, <a href="#cjs_root-strip_prefix">strip_prefix</a>, <a href="#cjs_root-subpackages">subpackages</a>)
</pre>

CommonJS-style root

**ATTRIBUTES**

| Name                                           | Description                        | Type                                                                        | Mandatory | Default |
| :--------------------------------------------- | :--------------------------------- | :-------------------------------------------------------------------------- | :-------- | :------ |
| <a id="cjs_root-name"></a>name                 | A unique name for this target.     | <a href="https://bazel.build/docs/build-ref.html#name">Name</a>             | required  |         |
| <a id="cjs_root-deps"></a>deps                 | Dependencies                       | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional  | []      |
| <a id="cjs_root-descriptors"></a>descriptors   | package.json descriptors           | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional  | []      |
| <a id="cjs_root-package_name"></a>package_name | Package name                       | String                                                                      | required  |         |
| <a id="cjs_root-strip_prefix"></a>strip_prefix | -                                  | String                                                                      | optional  | ""      |
| <a id="cjs_root-subpackages"></a>subpackages   | Whether to allow Bazel subpackages | Boolean                                                                     | optional  | False   |

<a id="#create_entries"></a>

## create_entries

<pre>
create_entries(<a href="#create_entries-ctx">ctx</a>, <a href="#create_entries-actions">actions</a>, <a href="#create_entries-srcs">srcs</a>, <a href="#create_entries-prefix">prefix</a>, <a href="#create_entries-strip_prefix">strip_prefix</a>)
</pre>

**PARAMETERS**

| Name                                                 | Description               | Default Value |
| :--------------------------------------------------- | :------------------------ | :------------ |
| <a id="create_entries-ctx"></a>ctx                   | <p align="center"> - </p> | none          |
| <a id="create_entries-actions"></a>actions           | <p align="center"> - </p> | none          |
| <a id="create_entries-srcs"></a>srcs                 | <p align="center"> - </p> | none          |
| <a id="create_entries-prefix"></a>prefix             | <p align="center"> - </p> | none          |
| <a id="create_entries-strip_prefix"></a>strip_prefix | <p align="center"> - </p> | none          |

<a id="#default_strip_prefix"></a>

## default_strip_prefix

<pre>
default_strip_prefix(<a href="#default_strip_prefix-ctx">ctx</a>)
</pre>

**PARAMETERS**

| Name                                     | Description               | Default Value |
| :--------------------------------------- | :------------------------ | :------------ |
| <a id="default_strip_prefix-ctx"></a>ctx | <p align="center"> - </p> | none          |

<a id="#gen_manifest"></a>

## gen_manifest

<pre>
gen_manifest(<a href="#gen_manifest-actions">actions</a>, <a href="#gen_manifest-manifest_bin">manifest_bin</a>, <a href="#gen_manifest-manifest">manifest</a>, <a href="#gen_manifest-packages">packages</a>, <a href="#gen_manifest-deps">deps</a>, <a href="#gen_manifest-globals">globals</a>, <a href="#gen_manifest-runfiles">runfiles</a>)
</pre>

**PARAMETERS**

| Name                                               | Description               | Default Value |
| :------------------------------------------------- | :------------------------ | :------------ |
| <a id="gen_manifest-actions"></a>actions           | <p align="center"> - </p> | none          |
| <a id="gen_manifest-manifest_bin"></a>manifest_bin | <p align="center"> - </p> | none          |
| <a id="gen_manifest-manifest"></a>manifest         | <p align="center"> - </p> | none          |
| <a id="gen_manifest-packages"></a>packages         | <p align="center"> - </p> | none          |
| <a id="gen_manifest-deps"></a>deps                 | <p align="center"> - </p> | none          |
| <a id="gen_manifest-globals"></a>globals           | <p align="center"> - </p> | none          |
| <a id="gen_manifest-runfiles"></a>runfiles         | <p align="center"> - </p> | none          |

<a id="#output_prefix"></a>

## output_prefix

<pre>
output_prefix(<a href="#output_prefix-path">path</a>, <a href="#output_prefix-label">label</a>, <a href="#output_prefix-actions">actions</a>)
</pre>

**PARAMETERS**

| Name                                      | Description               | Default Value |
| :---------------------------------------- | :------------------------ | :------------ |
| <a id="output_prefix-path"></a>path       | <p align="center"> - </p> | none          |
| <a id="output_prefix-label"></a>label     | <p align="center"> - </p> | none          |
| <a id="output_prefix-actions"></a>actions | <p align="center"> - </p> | none          |
