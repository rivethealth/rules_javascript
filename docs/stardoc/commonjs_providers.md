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

<a id="#cjs_path"></a>

## cjs_path

<pre>
cjs_path(<a href="#cjs_path-id">id</a>)
</pre>

**PARAMETERS**

| Name                       | Description               | Default Value |
| :------------------------- | :------------------------ | :------------ |
| <a id="cjs_path-id"></a>id | <p align="center"> - </p> | none          |

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
