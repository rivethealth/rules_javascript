<!-- Generated with Stardoc: http://skydoc.bazel.build -->

<a id="#PackageInfo"></a>

## PackageInfo

<pre>
PackageInfo(<a href="#PackageInfo-id">id</a>, <a href="#PackageInfo-name">name</a>, <a href="#PackageInfo-transitive_files">transitive_files</a>, <a href="#PackageInfo-transitive_manifests">transitive_manifests</a>, <a href="#PackageInfo-transitive_packages">transitive_packages</a>,
            <a href="#PackageInfo-transitive_source_maps">transitive_source_maps</a>)
</pre>

JavaScript package

A package is a set of modules that share a module prefix and dependencies.


**FIELDS**


| Name  | Description |
| :------------- | :------------- |
| <a id="PackageInfo-id"></a>id |  ID    |
| <a id="PackageInfo-name"></a>name |  Default module prefix    |
| <a id="PackageInfo-transitive_files"></a>transitive_files |  Depset of files    |
| <a id="PackageInfo-transitive_manifests"></a>transitive_manifests |  Depset of package manifests    |
| <a id="PackageInfo-transitive_packages"></a>transitive_packages |  Depset of packages    |
| <a id="PackageInfo-transitive_source_maps"></a>transitive_source_maps |  Depset of source maps    |


<a id="#create_package"></a>

## create_package

<pre>
create_package(<a href="#create_package-id">id</a>, <a href="#create_package-name">name</a>, <a href="#create_package-manifest">manifest</a>, <a href="#create_package-deps">deps</a>)
</pre>

    Create package.

:param Label id: ID
:param str name: Name
:param File manifest: Manifest of modules
:param list deps: List of package deps

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="create_package-id"></a>id |  <p align="center"> - </p>   |  none |
| <a id="create_package-name"></a>name |  <p align="center"> - </p>   |  none |
| <a id="create_package-manifest"></a>manifest |  <p align="center"> - </p>   |  none |
| <a id="create_package-deps"></a>deps |  <p align="center"> - </p>   |  none |


<a id="#create_package_dep"></a>

## create_package_dep

<pre>
create_package_dep(<a href="#create_package_dep-name">name</a>, <a href="#create_package_dep-id">id</a>)
</pre>

    Create package dependency definition

:param str name: Module prefix, or empty if no prefix
:param Label id: ID

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="create_package_dep-name"></a>name |  <p align="center"> - </p>   |  none |
| <a id="create_package_dep-id"></a>id |  <p align="center"> - </p>   |  none |


<a id="#merge_packages"></a>

## merge_packages

<pre>
merge_packages(<a href="#merge_packages-package">package</a>, <a href="#merge_packages-files">files</a>, <a href="#merge_packages-source_maps">source_maps</a>, <a href="#merge_packages-packages">packages</a>)
</pre>



**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="merge_packages-package"></a>package |  <p align="center"> - </p>   |  none |
| <a id="merge_packages-files"></a>files |  <p align="center"> - </p>   |  none |
| <a id="merge_packages-source_maps"></a>source_maps |  <p align="center"> - </p>   |  none |
| <a id="merge_packages-packages"></a>packages |  <p align="center"> - </p>   |  none |


