# CommonJS

better_rules_javascript organizes modules and other files into CommonJS
"packages."

While the focus is JavaScript, this is also the organization used for other
language, like CSS.

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Guide](#guide)
  - [Example](#example)
- [//commonjs:providers.bzl](#commonjsprovidersbzl)
  - [CjsInfo](#cjsinfo)
  - [CjsPath](#cjspath)
  - [cjs_npm_label](#cjs_npm_label)
  - [create_cjs_info](#create_cjs_info)
  - [create_extra_deps](#create_extra_deps)
  - [create_globals](#create_globals)
  - [create_link](#create_link)
  - [create_links](#create_links)
  - [create_package](#create_package)
  - [gen_manifest](#gen_manifest)
  - [package_path](#package_path)
- [//commonjs:rules.bzl](#commonjsrulesbzl)
  - [cjs_descriptors](#cjs_descriptors)
  - [cjs_root](#cjs_root)
- [//commonjs:workspace.bzl](#commonjsworkspacebzl)
  - [cjs_directory_npm_plugin](#cjs_directory_npm_plugin)
  - [cjs_npm_plugin](#cjs_npm_plugin)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Guide

## Example

**package.json**

```json
{}
```

**BUILD.bazel**

```bzl
load("@better_rules_javascript//commonjs:rules.bzl", "cjs_root")

cjs_root(
    name = "root",
    descriptor = "package.json",
    package_name = "example",
)
```

# //commonjs:providers.bzl

<!-- Generated with Stardoc: http://skydoc.bazel.build -->

<a id="CjsInfo"></a>

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

<a id="CjsPath"></a>

## CjsPath

<pre>
CjsPath(<a href="#CjsPath-path">path</a>)
</pre>

CommonJS path

**FIELDS**

| Name                          | Description                    |
| :---------------------------- | :----------------------------- |
| <a id="CjsPath-path"></a>path | Path relative to CommonJS root |

<a id="cjs_npm_label"></a>

## cjs_npm_label

<pre>
cjs_npm_label(<a href="#cjs_npm_label-repo">repo</a>)
</pre>

**PARAMETERS**

| Name                                | Description               | Default Value |
| :---------------------------------- | :------------------------ | :------------ |
| <a id="cjs_npm_label-repo"></a>repo | <p align="center"> - </p> | none          |

<a id="create_cjs_info"></a>

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

<a id="create_extra_deps"></a>

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

<a id="create_globals"></a>

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

<a id="create_link"></a>

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

<a id="create_links"></a>

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

<a id="create_package"></a>

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

<a id="gen_manifest"></a>

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

<a id="package_path"></a>

## package_path

<pre>
package_path(<a href="#package_path-package">package</a>)
</pre>

**PARAMETERS**

| Name                                     | Description               | Default Value |
| :--------------------------------------- | :------------------------ | :------------ |
| <a id="package_path-package"></a>package | <p align="center"> - </p> | none          |

# //commonjs:rules.bzl

<!-- Generated with Stardoc: http://skydoc.bazel.build -->

<a id="cjs_descriptors"></a>

## cjs_descriptors

<pre>
cjs_descriptors(<a href="#cjs_descriptors-name">name</a>, <a href="#cjs_descriptors-prefix">prefix</a>, <a href="#cjs_descriptors-srcs">srcs</a>, <a href="#cjs_descriptors-strip_prefix">strip_prefix</a>)
</pre>

CommonJS descriptors.

**ATTRIBUTES**

| Name                                                  | Description                        | Type                                                                | Mandatory | Default         |
| :---------------------------------------------------- | :--------------------------------- | :------------------------------------------------------------------ | :-------- | :-------------- |
| <a id="cjs_descriptors-name"></a>name                 | A unique name for this target.     | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required  |                 |
| <a id="cjs_descriptors-prefix"></a>prefix             | Prefix to add.                     | String                                                              | optional  | <code>""</code> |
| <a id="cjs_descriptors-srcs"></a>srcs                 | Descriptors.                       | <a href="https://bazel.build/concepts/labels">List of labels</a>    | required  |                 |
| <a id="cjs_descriptors-strip_prefix"></a>strip_prefix | Package-relative prefix to remove. | String                                                              | optional  | <code>""</code> |

<a id="cjs_root"></a>

## cjs_root

<pre>
cjs_root(<a href="#cjs_root-name">name</a>, <a href="#cjs_root-descriptors">descriptors</a>, <a href="#cjs_root-package_name">package_name</a>, <a href="#cjs_root-path">path</a>, <a href="#cjs_root-prefix">prefix</a>, <a href="#cjs_root-strip_prefix">strip_prefix</a>)
</pre>

CommonJS-style package root.

**ATTRIBUTES**

| Name                                           | Description                                                 | Type                                                                | Mandatory | Default         |
| :--------------------------------------------- | :---------------------------------------------------------- | :------------------------------------------------------------------ | :-------- | :-------------- |
| <a id="cjs_root-name"></a>name                 | A unique name for this target.                              | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required  |                 |
| <a id="cjs_root-descriptors"></a>descriptors   | package.json descriptors.                                   | <a href="https://bazel.build/concepts/labels">List of labels</a>    | optional  | <code>[]</code> |
| <a id="cjs_root-package_name"></a>package_name | Package name. By default, @workspace_name/path-to-directory | String                                                              | optional  | <code>""</code> |
| <a id="cjs_root-path"></a>path                 | Root path, relative to package                              | String                                                              | optional  | <code>""</code> |
| <a id="cjs_root-prefix"></a>prefix             | -                                                           | String                                                              | optional  | <code>""</code> |
| <a id="cjs_root-strip_prefix"></a>strip_prefix | -                                                           | String                                                              | optional  | <code>""</code> |

# //commonjs:workspace.bzl

<!-- Generated with Stardoc: http://skydoc.bazel.build -->

<a id="cjs_directory_npm_plugin"></a>

## cjs_directory_npm_plugin

<pre>
cjs_directory_npm_plugin()
</pre>

<a id="cjs_npm_plugin"></a>

## cjs_npm_plugin

<pre>
cjs_npm_plugin()
</pre>
