<!-- Generated with Stardoc: http://skydoc.bazel.build -->

<a id="#CjsDescriptorInfo"></a>

## CjsDescriptorInfo

<pre>
CjsDescriptorInfo(<a href="#CjsDescriptorInfo-descriptors">descriptors</a>, <a href="#CjsDescriptorInfo-path">path</a>)
</pre>

**FIELDS**

| Name                                                  | Description   |
| :---------------------------------------------------- | :------------ |
| <a id="CjsDescriptorInfo-descriptors"></a>descriptors | List of files |
| <a id="CjsDescriptorInfo-path"></a>path               | Root path     |

<a id="#CjsInfo"></a>

## CjsInfo

<pre>
CjsInfo(<a href="#CjsInfo-descriptors">descriptors</a>, <a href="#CjsInfo-package">package</a>, <a href="#CjsInfo-name">name</a>)
</pre>

CommonJS-style package

**FIELDS**

| Name                                        | Description      |
| :------------------------------------------ | :--------------- |
| <a id="CjsInfo-descriptors"></a>descriptors | Descriptor files |
| <a id="CjsInfo-package"></a>package         | Package struct   |
| <a id="CjsInfo-name"></a>name               | Name             |

<a id="#create_dep"></a>

## create_dep

<pre>
create_dep(<a href="#create_dep-id">id</a>, <a href="#create_dep-name">name</a>, <a href="#create_dep-dep">dep</a>, <a href="#create_dep-label">label</a>)
</pre>

Create link for CommonJs package.

**PARAMETERS**

| Name                               | Description           | Default Value |
| :--------------------------------- | :-------------------- | :------------ |
| <a id="create_dep-id"></a>id       | Package ID            | none          |
| <a id="create_dep-name"></a>name   | Name                  | none          |
| <a id="create_dep-dep"></a>dep     | Dependency package ID | none          |
| <a id="create_dep-label"></a>label | Source label          | none          |

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

<a id="#create_global"></a>

## create_global

<pre>
create_global(<a href="#create_global-id">id</a>, <a href="#create_global-name">name</a>)
</pre>

**PARAMETERS**

| Name                                | Description               | Default Value |
| :---------------------------------- | :------------------------ | :------------ |
| <a id="create_global-id"></a>id     | <p align="center"> - </p> | none          |
| <a id="create_global-name"></a>name | <p align="center"> - </p> | none          |

<a id="#create_package"></a>

## create_package

<pre>
create_package(<a href="#create_package-id">id</a>, <a href="#create_package-path">path</a>, <a href="#create_package-short_path">short_path</a>, <a href="#create_package-label">label</a>)
</pre>

Create package struct.

**PARAMETERS**

| Name                                             | Description             | Default Value |
| :----------------------------------------------- | :---------------------- | :------------ |
| <a id="create_package-id"></a>id                 | ID                      | none          |
| <a id="create_package-path"></a>path             | Part to directory       | none          |
| <a id="create_package-short_path"></a>short_path | Short path to directory | none          |
| <a id="create_package-label"></a>label           | Source label            | none          |

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
gen_manifest(<a href="#gen_manifest-actions">actions</a>, <a href="#gen_manifest-manifest_bin">manifest_bin</a>, <a href="#gen_manifest-manifest">manifest</a>, <a href="#gen_manifest-packages">packages</a>, <a href="#gen_manifest-deps">deps</a>, <a href="#gen_manifest-globals">globals</a>, <a href="#gen_manifest-package_path">package_path</a>)
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
| <a id="gen_manifest-package_path"></a>package_path | <p align="center"> - </p> | none          |

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

<a id="#package_path"></a>

## package_path

<pre>
package_path(<a href="#package_path-package">package</a>)
</pre>

**PARAMETERS**

| Name                                     | Description               | Default Value |
| :--------------------------------------- | :------------------------ | :------------ |
| <a id="package_path-package"></a>package | <p align="center"> - </p> | none          |
