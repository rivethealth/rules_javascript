<!-- Generated with Stardoc: http://skydoc.bazel.build -->

<a id="#JsPackage"></a>

## JsPackage

<pre>
JsPackage(<a href="#JsPackage-id">id</a>, <a href="#JsPackage-name">name</a>, <a href="#JsPackage-transitive_files">transitive_files</a>, <a href="#JsPackage-transitive_packages">transitive_packages</a>, <a href="#JsPackage-transitive_source_maps">transitive_source_maps</a>)
</pre>

JavaScript package

A package is a set of modules that share a module prefix and dependencies.


**FIELDS**


| Name  | Description |
| :------------- | :------------- |
| <a id="JsPackage-id"></a>id |  ID    |
| <a id="JsPackage-name"></a>name |  Default module prefix    |
| <a id="JsPackage-transitive_files"></a>transitive_files |  Depset of files    |
| <a id="JsPackage-transitive_packages"></a>transitive_packages |  Depset of packages    |
| <a id="JsPackage-transitive_source_maps"></a>transitive_source_maps |  Depset of source maps    |


<a id="#create_module"></a>

## create_module

<pre>
create_module(<a href="#create_module-name">name</a>, <a href="#create_module-file">file</a>)
</pre>



**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="create_module-name"></a>name |  <p align="center"> - </p>   |  none |
| <a id="create_module-file"></a>file |  <p align="center"> - </p>   |  none |


<a id="#create_package"></a>

## create_package

<pre>
create_package(<a href="#create_package-id">id</a>, <a href="#create_package-name">name</a>, <a href="#create_package-main">main</a>, <a href="#create_package-modules">modules</a>, <a href="#create_package-deps">deps</a>)
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
| <a id="create_package-main"></a>main |  <p align="center"> - </p>   |  none |
| <a id="create_package-modules"></a>modules |  <p align="center"> - </p>   |  none |
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


