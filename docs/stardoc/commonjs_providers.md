<!-- Generated with Stardoc: http://skydoc.bazel.build -->

<a id="#CjsInfo"></a>

## CjsInfo

<pre>
CjsInfo(<a href="#CjsInfo-name">name</a>, <a href="#CjsInfo-package">package</a>, <a href="#CjsInfo-transitive_files">transitive_files</a>, <a href="#CjsInfo-transitive_packages">transitive_packages</a>, <a href="#CjsInfo-transitive_links">transitive_links</a>)
</pre>

CommonJS-style package info

**FIELDS**

| Name                                                        | Description |
| :---------------------------------------------------------- | :---------- |
| <a id="CjsInfo-name"></a>name                               | Name        |
| <a id="CjsInfo-package"></a>package                         | Package     |
| <a id="CjsInfo-transitive_files"></a>transitive_files       | Files       |
| <a id="CjsInfo-transitive_packages"></a>transitive_packages | Packages    |
| <a id="CjsInfo-transitive_links"></a>transitive_links       | Links       |

<a id="#CjsRootInfo"></a>

## CjsRootInfo

<pre>
CjsRootInfo(<a href="#CjsRootInfo-descriptors">descriptors</a>, <a href="#CjsRootInfo-package">package</a>, <a href="#CjsRootInfo-name">name</a>)
</pre>

CommonJS-style package root

**FIELDS**

| Name                                            | Description      |
| :---------------------------------------------- | :--------------- |
| <a id="CjsRootInfo-descriptors"></a>descriptors | Descriptor files |
| <a id="CjsRootInfo-package"></a>package         | Package struct   |
| <a id="CjsRootInfo-name"></a>name               | Name             |

<a id="#cjs_npm_label"></a>

## cjs_npm_label

<pre>
cjs_npm_label(<a href="#cjs_npm_label-repo">repo</a>)
</pre>

**PARAMETERS**

| Name                                | Description               | Default Value |
| :---------------------------------- | :------------------------ | :------------ |
| <a id="cjs_npm_label-repo"></a>repo | <p align="center"> - </p> | none          |

<a id="#create_cjs_info"></a>

## create_cjs_info

<pre>
create_cjs_info(<a href="#create_cjs_info-cjs_root">cjs_root</a>, <a href="#create_cjs_info-label">label</a>, <a href="#create_cjs_info-files">files</a>, <a href="#create_cjs_info-deps">deps</a>, <a href="#create_cjs_info-globals">globals</a>)
</pre>

**PARAMETERS**

| Name                                          | Description               | Default Value   |
| :-------------------------------------------- | :------------------------ | :-------------- |
| <a id="create_cjs_info-cjs_root"></a>cjs_root | <p align="center"> - </p> | none            |
| <a id="create_cjs_info-label"></a>label       | <p align="center"> - </p> | none            |
| <a id="create_cjs_info-files"></a>files       | <p align="center"> - </p> | <code>[]</code> |
| <a id="create_cjs_info-deps"></a>deps         | <p align="center"> - </p> | <code>[]</code> |
| <a id="create_cjs_info-globals"></a>globals   | <p align="center"> - </p> | <code>[]</code> |

<a id="#create_extra_deps"></a>

## create_extra_deps

<pre>
create_extra_deps(<a href="#create_extra_deps-package">package</a>, <a href="#create_extra_deps-label">label</a>, <a href="#create_extra_deps-extra_deps">extra_deps</a>)
</pre>

**PARAMETERS**

| Name                                                | Description               | Default Value |
| :-------------------------------------------------- | :------------------------ | :------------ |
| <a id="create_extra_deps-package"></a>package       | <p align="center"> - </p> | none          |
| <a id="create_extra_deps-label"></a>label           | <p align="center"> - </p> | none          |
| <a id="create_extra_deps-extra_deps"></a>extra_deps | <p align="center"> - </p> | none          |

<a id="#create_globals"></a>

## create_globals

<pre>
create_globals(<a href="#create_globals-label">label</a>, <a href="#create_globals-cjs_infos">cjs_infos</a>)
</pre>

Create globals.

**PARAMETERS**

| Name                                           | Description  | Default Value |
| :--------------------------------------------- | :----------- | :------------ |
| <a id="create_globals-label"></a>label         | Source label | none          |
| <a id="create_globals-cjs_infos"></a>cjs_infos | CjsInfo      | none          |

<a id="#create_link"></a>

## create_link

<pre>
create_link(<a href="#create_link-path">path</a>, <a href="#create_link-name">name</a>, <a href="#create_link-dep">dep</a>, <a href="#create_link-label">label</a>)
</pre>

Create link for CommonJs package.

**PARAMETERS**

| Name                                | Description             | Default Value |
| :---------------------------------- | :---------------------- | :------------ |
| <a id="create_link-path"></a>path   | Package path            | none          |
| <a id="create_link-name"></a>name   | Name                    | none          |
| <a id="create_link-dep"></a>dep     | Dependency package path | none          |
| <a id="create_link-label"></a>label | Source label            | none          |

<a id="#create_links"></a>

## create_links

<pre>
create_links(<a href="#create_links-package">package</a>, <a href="#create_links-label">label</a>, <a href="#create_links-cjs_infos">cjs_infos</a>)
</pre>

Create deps.

**PARAMETERS**

| Name                                         | Description    | Default Value |
| :------------------------------------------- | :------------- | :------------ |
| <a id="create_links-package"></a>package     | Package struct | none          |
| <a id="create_links-label"></a>label         | Source label   | none          |
| <a id="create_links-cjs_infos"></a>cjs_infos | CjsInfo        | none          |

<a id="#create_package"></a>

## create_package

<pre>
create_package(<a href="#create_package-name">name</a>, <a href="#create_package-path">path</a>, <a href="#create_package-short_path">short_path</a>, <a href="#create_package-label">label</a>)
</pre>

Create CommonJs package definition.

**PARAMETERS**

| Name                                             | Description                  | Default Value |
| :----------------------------------------------- | :--------------------------- | :------------ |
| <a id="create_package-name"></a>name             | Name                         | none          |
| <a id="create_package-path"></a>path             | Path of root directory       | none          |
| <a id="create_package-short_path"></a>short_path | Short path of root directory | none          |
| <a id="create_package-label"></a>label           | Source label                 | none          |

<a id="#gen_manifest"></a>

## gen_manifest

<pre>
gen_manifest(<a href="#gen_manifest-actions">actions</a>, <a href="#gen_manifest-manifest_bin">manifest_bin</a>, <a href="#gen_manifest-manifest">manifest</a>, <a href="#gen_manifest-packages">packages</a>, <a href="#gen_manifest-deps">deps</a>, <a href="#gen_manifest-package_path">package_path</a>)
</pre>

Create package manifest.

**PARAMETERS**

| Name                                               | Description                    | Default Value |
| :------------------------------------------------- | :----------------------------- | :------------ |
| <a id="gen_manifest-actions"></a>actions           | Actions struct                 | none          |
| <a id="gen_manifest-manifest_bin"></a>manifest_bin | Manfiest generation executable | none          |
| <a id="gen_manifest-manifest"></a>manifest         | Manifest output                | none          |
| <a id="gen_manifest-packages"></a>packages         | Depset of packages             | none          |
| <a id="gen_manifest-deps"></a>deps                 | Depset of dependencies         | none          |
| <a id="gen_manifest-package_path"></a>package_path | Function for package path      | none          |

<a id="#package_path"></a>

## package_path

<pre>
package_path(<a href="#package_path-package">package</a>)
</pre>

**PARAMETERS**

| Name                                     | Description               | Default Value |
| :--------------------------------------- | :------------------------ | :------------ |
| <a id="package_path-package"></a>package | <p align="center"> - </p> | none          |
