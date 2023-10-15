# Npm

Better_rules_javascript can use npm packages.

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Guide](#guide)
  - [Strategy](#strategy)
  - [Yarn](#yarn)
  - [IDE](#ide)
  - [Limitations](#limitations)
- [//npm:rules.bzl](#npmrulesbzl)
  - [npm_publish](#npm_publish)
  - [yarn_audit_test](#yarn_audit_test)
  - [yarn_resolve](#yarn_resolve)
  - [npm_package](#npm_package)
- [//npm:workspace.bzl](#npmworkspacebzl)
  - [npm](#npm)
  - [npm_import_external_rule](#npm_import_external_rule)
  - [npm_import_rule](#npm_import_rule)
  - [package_repo_name](#package_repo_name)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Guide

## Strategy

A package manager resolves the dependency graph. The information is converted to
Bazel repositories. This approach integrates well into the Bazel ecosystem and
avoid excessive downloads. Compare with
[rules_jvm_external](https://github.com/bazelbuild/rules_jvm_external).

better_rules_javascript uses Yarn 2.

## Yarn

### Install

Create a package.json.

**package.json**

```json
{
  "dependencies": {
    "@org/package": "^1.0.0"
  }
}
```

Create a `yarn_resolve` target.

**BUILD.bazel**

```bzl
yarn_resolve(
    name = "resolve_npm",
)
```

Resolve packages and generate npm_data.bzl

```sh
bazel run :resolve_npm
```

Load the repositories.

**WORKSPACE.bazel**

```bzl
load("@better_rules_javascript//npm:workspace.bzl", "npm")
load(":npm_data.bzl", npm_packages = "PACKAGES", npm_roots = "ROOTS")
npm("npm", npm_packages, npm_roots)
```

### Plugins

Several types of files can be distributed in NPM packages: JavaScript,
TypeScript, CSS, etc.

To support these, the npm repositories can be customized via "plugins."

The defaults are:

```bzl
load("@better_rules_javascript//commonjs:workspace.bzl", "cjs_npm_plugin")
load("@better_rules_javascript//js:workspace.bzl", "js_npm_plugin")

npm(
  name = "npm",
  packages = npm_packages,
  roots = npm_roots,
  plugins = [
    cjs_npm_plugin(),
    js_npm_plugin(),
  ]
)
```

If you use TypeScript, replace `js_npm_plugin()` with `ts_npm_plugin()`.

### Usage

JS libraries are available as `@npm//<package_name>:lib`.

For example,

**BUILD.bazel**

```bzl
js_library(
    name = "example",
    deps = ["@npm//@org/package:lib"],
)
```

## IDE

To make these accessible to the IDE in `node_modules`, see
[Node.js docs](nodejs.md).

## Limitations

Post-install scripts, including native dependencies (node-gyp), are not
supported.

To support those, filter the package from `PACKAGES`, and instead use Bazel
rules to replicate the build process.

# //npm:rules.bzl

<!-- Generated with Stardoc: http://skydoc.bazel.build -->

<a id="npm_publish"></a>

## npm_publish

<pre>
npm_publish(<a href="#npm_publish-name">name</a>, <a href="#npm_publish-src">src</a>)
</pre>

**ATTRIBUTES**

| Name                              | Description                    | Type                                                                | Mandatory | Default |
| :-------------------------------- | :----------------------------- | :------------------------------------------------------------------ | :-------- | :------ |
| <a id="npm_publish-name"></a>name | A unique name for this target. | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required  |         |
| <a id="npm_publish-src"></a>src   | -                              | <a href="https://bazel.build/concepts/labels">Label</a>             | required  |         |

<a id="yarn_audit_test"></a>

## yarn_audit_test

<pre>
yarn_audit_test(<a href="#yarn_audit_test-name">name</a>, <a href="#yarn_audit_test-data">data</a>, <a href="#yarn_audit_test-path">path</a>)
</pre>

**ATTRIBUTES**

| Name                                  | Description                    | Type                                                                | Mandatory | Default         |
| :------------------------------------ | :----------------------------- | :------------------------------------------------------------------ | :-------- | :-------------- |
| <a id="yarn_audit_test-name"></a>name | A unique name for this target. | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required  |                 |
| <a id="yarn_audit_test-data"></a>data | -                              | <a href="https://bazel.build/concepts/labels">List of labels</a>    | optional  | <code>[]</code> |
| <a id="yarn_audit_test-path"></a>path | Package relative path          | String                                                              | optional  | <code>""</code> |

<a id="yarn_resolve"></a>

## yarn_resolve

<pre>
yarn_resolve(<a href="#yarn_resolve-name">name</a>, <a href="#yarn_resolve-output">output</a>, <a href="#yarn_resolve-path">path</a>, <a href="#yarn_resolve-refresh">refresh</a>)
</pre>

**ATTRIBUTES**

| Name                                     | Description                                                   | Type                                                                | Mandatory | Default                     |
| :--------------------------------------- | :------------------------------------------------------------ | :------------------------------------------------------------------ | :-------- | :-------------------------- |
| <a id="yarn_resolve-name"></a>name       | A unique name for this target.                                | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required  |                             |
| <a id="yarn_resolve-output"></a>output   | Package-relative output path                                  | String                                                              | optional  | <code>"npm_data.bzl"</code> |
| <a id="yarn_resolve-path"></a>path       | Package-relative path to package.json and yarn.lock directory | String                                                              | optional  | <code>""</code>             |
| <a id="yarn_resolve-refresh"></a>refresh | Whether to refresh                                            | Boolean                                                             | optional  | <code>True</code>           |

<a id="npm_package"></a>

## npm_package

<pre>
npm_package(<a href="#npm_package-name">name</a>, <a href="#npm_package-srcs">srcs</a>, <a href="#npm_package-visibility">visibility</a>, <a href="#npm_package-kwargs">kwargs</a>)
</pre>

**PARAMETERS**

| Name                                          | Description               | Default Value     |
| :-------------------------------------------- | :------------------------ | :---------------- |
| <a id="npm_package-name"></a>name             | <p align="center"> - </p> | none              |
| <a id="npm_package-srcs"></a>srcs             | <p align="center"> - </p> | none              |
| <a id="npm_package-visibility"></a>visibility | <p align="center"> - </p> | <code>None</code> |
| <a id="npm_package-kwargs"></a>kwargs         | <p align="center"> - </p> | none              |

# //npm:workspace.bzl

<!-- Generated with Stardoc: http://skydoc.bazel.build -->

<a id="npm"></a>

## npm

<pre>
npm(<a href="#npm-name">name</a>, <a href="#npm-packages">packages</a>, <a href="#npm-roots">roots</a>, <a href="#npm-plugins">plugins</a>, <a href="#npm-auth_patterns">auth_patterns</a>, <a href="#npm-netrc">netrc</a>)
</pre>

Npm repositories.

**PARAMETERS**

| Name                                        | Description   | Default Value                                                                                                                                                                                                         |
| :------------------------------------------ | :------------ | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| <a id="npm-name"></a>name                   | Namespace     | none                                                                                                                                                                                                                  |
| <a id="npm-packages"></a>packages           | Packages      | none                                                                                                                                                                                                                  |
| <a id="npm-roots"></a>roots                 | Roots         | none                                                                                                                                                                                                                  |
| <a id="npm-plugins"></a>plugins             | Plugins       | <code>[struct(alias_build = &lt;function alias_build&gt;, package_build = &lt;function package_build&gt;), struct(alias_build = &lt;function alias_build&gt;, package_build = &lt;function package_build&gt;)]</code> |
| <a id="npm-auth_patterns"></a>auth_patterns | Auth patterns | <code>None</code>                                                                                                                                                                                                     |
| <a id="npm-netrc"></a>netrc                 | Netrc         | <code>None</code>                                                                                                                                                                                                     |

<a id="npm_import_external_rule"></a>

## npm_import_external_rule

<pre>
npm_import_external_rule(<a href="#npm_import_external_rule-plugins">plugins</a>)
</pre>

Create a npm_import_external rule.

**PARAMETERS**

| Name                                                 | Description               | Default Value |
| :--------------------------------------------------- | :------------------------ | :------------ |
| <a id="npm_import_external_rule-plugins"></a>plugins | <p align="center"> - </p> | none          |

<a id="npm_import_rule"></a>

## npm_import_rule

<pre>
npm_import_rule(<a href="#npm_import_rule-plugins">plugins</a>)
</pre>

Create an npm import rule.

**PARAMETERS**

| Name                                        | Description               | Default Value |
| :------------------------------------------ | :------------------------ | :------------ |
| <a id="npm_import_rule-plugins"></a>plugins | <p align="center"> - </p> | none          |

<a id="package_repo_name"></a>

## package_repo_name

<pre>
package_repo_name(<a href="#package_repo_name-prefix">prefix</a>, <a href="#package_repo_name-name">name</a>)
</pre>

Repository name for npm package.

Replaces characters not permitted in Bazel repository names.

**PARAMETERS**

| Name                                        | Description | Default Value |
| :------------------------------------------ | :---------- | :------------ |
| <a id="package_repo_name-prefix"></a>prefix | Namespace   | none          |
| <a id="package_repo_name-name"></a>name     | ID          | none          |
