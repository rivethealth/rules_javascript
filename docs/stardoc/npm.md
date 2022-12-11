# Contents

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [//npm:rules.bzl](#npmrulesbzl)
  - [yarn_audit_test](#yarn_audit_test)
  - [yarn_resolve](#yarn_resolve)
- [//npm:workspace.bzl](#npmworkspacebzl)
  - [npm](#npm)
  - [npm_import_external_rule](#npm_import_external_rule)
  - [npm_import_rule](#npm_import_rule)
  - [package_repo_name](#package_repo_name)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# //npm:rules.bzl

<!-- Generated with Stardoc: http://skydoc.bazel.build -->

<a id="#yarn_audit_test"></a>

## yarn_audit_test

<pre>
yarn_audit_test(<a href="#yarn_audit_test-name">name</a>, <a href="#yarn_audit_test-data">data</a>, <a href="#yarn_audit_test-path">path</a>)
</pre>

**ATTRIBUTES**

| Name                                  | Description                    | Type                                                                        | Mandatory | Default |
| :------------------------------------ | :----------------------------- | :-------------------------------------------------------------------------- | :-------- | :------ |
| <a id="yarn_audit_test-name"></a>name | A unique name for this target. | <a href="https://bazel.build/docs/build-ref.html#name">Name</a>             | required  |         |
| <a id="yarn_audit_test-data"></a>data | -                              | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional  | []      |
| <a id="yarn_audit_test-path"></a>path | Package relative path          | String                                                                      | optional  | ""      |

<a id="#yarn_resolve"></a>

## yarn_resolve

<pre>
yarn_resolve(<a href="#yarn_resolve-name">name</a>, <a href="#yarn_resolve-output">output</a>, <a href="#yarn_resolve-path">path</a>, <a href="#yarn_resolve-refresh">refresh</a>)
</pre>

**ATTRIBUTES**

| Name                                     | Description                                                   | Type                                                            | Mandatory | Default        |
| :--------------------------------------- | :------------------------------------------------------------ | :-------------------------------------------------------------- | :-------- | :------------- |
| <a id="yarn_resolve-name"></a>name       | A unique name for this target.                                | <a href="https://bazel.build/docs/build-ref.html#name">Name</a> | required  |                |
| <a id="yarn_resolve-output"></a>output   | Package-relative output path                                  | String                                                          | optional  | "npm_data.bzl" |
| <a id="yarn_resolve-path"></a>path       | Package-relative path to package.json and yarn.lock directory | String                                                          | optional  | ""             |
| <a id="yarn_resolve-refresh"></a>refresh | Whether to refresh                                            | Boolean                                                         | optional  | True           |

# //npm:workspace.bzl

<!-- Generated with Stardoc: http://skydoc.bazel.build -->

<a id="#npm"></a>

## npm

<pre>
npm(<a href="#npm-name">name</a>, <a href="#npm-packages">packages</a>, <a href="#npm-roots">roots</a>, <a href="#npm-plugins">plugins</a>, <a href="#npm-auth_patterns">auth_patterns</a>, <a href="#npm-netrc">netrc</a>)
</pre>

**PARAMETERS**

| Name                                        | Description               | Default Value                                                                                                                                                                                 |
| :------------------------------------------ | :------------------------ | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| <a id="npm-name"></a>name                   | <p align="center"> - </p> | none                                                                                                                                                                                          |
| <a id="npm-packages"></a>packages           | <p align="center"> - </p> | none                                                                                                                                                                                          |
| <a id="npm-roots"></a>roots                 | <p align="center"> - </p> | none                                                                                                                                                                                          |
| <a id="npm-plugins"></a>plugins             | <p align="center"> - </p> | <code>[struct(alias_build = <function alias_build>, package_build = <function package_build>), struct(alias_build = <function alias_build>, package_build = <function package_build>)]</code> |
| <a id="npm-auth_patterns"></a>auth_patterns | <p align="center"> - </p> | <code>None</code>                                                                                                                                                                             |
| <a id="npm-netrc"></a>netrc                 | <p align="center"> - </p> | <code>None</code>                                                                                                                                                                             |

<a id="#npm_import_external_rule"></a>

## npm_import_external_rule

<pre>
npm_import_external_rule(<a href="#npm_import_external_rule-plugins">plugins</a>)
</pre>

**PARAMETERS**

| Name                                                 | Description               | Default Value |
| :--------------------------------------------------- | :------------------------ | :------------ |
| <a id="npm_import_external_rule-plugins"></a>plugins | <p align="center"> - </p> | none          |

<a id="#npm_import_rule"></a>

## npm_import_rule

<pre>
npm_import_rule(<a href="#npm_import_rule-plugins">plugins</a>)
</pre>

**PARAMETERS**

| Name                                        | Description               | Default Value |
| :------------------------------------------ | :------------------------ | :------------ |
| <a id="npm_import_rule-plugins"></a>plugins | <p align="center"> - </p> | none          |

<a id="#package_repo_name"></a>

## package_repo_name

<pre>
package_repo_name(<a href="#package_repo_name-prefix">prefix</a>, <a href="#package_repo_name-name">name</a>)
</pre>

**PARAMETERS**

| Name                                        | Description               | Default Value |
| :------------------------------------------ | :------------------------ | :------------ |
| <a id="package_repo_name-prefix"></a>prefix | <p align="center"> - </p> | none          |
| <a id="package_repo_name-name"></a>name     | <p align="center"> - </p> | none          |
