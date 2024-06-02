# Node.js

Node.js is most common execution environment outside a web browser.

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Guide](#guide)
  - [Reference](#reference)
  - [Example](#example)
  - [IDEs](#ides)
- [//nodejs:providers.bzl](#nodejsprovidersbzl)
  - [NodejsInfo](#nodejsinfo)
  - [NodejsRuntimeInfo](#nodejsruntimeinfo)
  - [nodejs_runtime_rule](#nodejs_runtime_rule)
- [//nodejs:rules.bzl](#nodejsrulesbzl)
  - [nodejs](#nodejs)
  - [nodejs_binary](#nodejs_binary)
  - [nodejs_binary_package](#nodejs_binary_package)
  - [nodejs_modules_binary](#nodejs_modules_binary)
  - [nodejs_modules_package](#nodejs_modules_package)
  - [nodejs_simple_binary](#nodejs_simple_binary)
  - [nodejs_system_runtime](#nodejs_system_runtime)
  - [nodejs_toolchain](#nodejs_toolchain)
  - [configure_nodejs_runtime](#configure_nodejs_runtime)
  - [nodejs_install](#nodejs_install)
  - [nodejs_modules](#nodejs_modules)
- [//nodejs:workspace.bzl](#nodejsworkspacebzl)
  - [nodejs_repositories](#nodejs_repositories)
  - [nodejs_toolchains](#nodejs_toolchains)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Guide

## Reference

[Starlark reference](stardoc/nodejs.md)

## Example

**package.json**

```json
{}
```

**main.js**

```js
console.log("Hello world");
```

**BUILD.bazel**

```bzl
load("@better_rules_javascript//commonjs:rules.bzl", "cjs_root")
load("@better_rules_javascript//javascript:rules.bzl", "js_library")
load("@better_rules_javascript//nodejs:rules.bzl", "nodejs_binary")

cjs_root(
  name = "root",
  descriptor = "package.json",
  package_name = "example",
)

js_library(
    name = "main",
    root = ":root",
    srcs = ["main.js"],
)

nodejs_binary(
    name = "bin",
    dep = ":main",
    main = "main.js",
)
```

Then

```txt
$ bazel run //:bin
Hello world
```

## IDEs

IDEs use `node_modules`. To install external dependencies or link local files:

**BUILD.bazel**

```bzl
load("@better_rules_javascript//nodejs:rules.bzl", "nodejs_install", "nodejs_modules_package")

nodejs_install(
  name = "nodejs_install",
  src = ":node_modules",
)

nodejs_modules_package(
  name = "node_modules",
  deps = ["@npm//external-example:lib"],
  links = ["//internal-example:root"],
)
```

Then run:

```sh
bazel run :nodejs_install
```

# //nodejs:providers.bzl

<!-- Generated with Stardoc: http://skydoc.bazel.build -->

<a id="NodejsInfo"></a>

## NodejsInfo

<pre>
NodejsInfo(<a href="#NodejsInfo-bin">bin</a>, <a href="#NodejsInfo-options">options</a>)
</pre>

Node.js executable information.

**FIELDS**

| Name                                   | Description        |
| :------------------------------------- | :----------------- |
| <a id="NodejsInfo-bin"></a>bin         | Node.js executable |
| <a id="NodejsInfo-options"></a>options | Node.js options    |

<a id="NodejsRuntimeInfo"></a>

## NodejsRuntimeInfo

<pre>
NodejsRuntimeInfo(<a href="#NodejsRuntimeInfo-bin">bin</a>)
</pre>

Node.js runtime.

**FIELDS**

| Name                                  | Description        |
| :------------------------------------ | :----------------- |
| <a id="NodejsRuntimeInfo-bin"></a>bin | Node.js executable |

<a id="nodejs_runtime_rule"></a>

## nodejs_runtime_rule

<pre>
nodejs_runtime_rule(<a href="#nodejs_runtime_rule-name">name</a>)
</pre>

**PARAMETERS**

| Name                                      | Description               | Default Value |
| :---------------------------------------- | :------------------------ | :------------ |
| <a id="nodejs_runtime_rule-name"></a>name | <p align="center"> - </p> | none          |

# //nodejs:rules.bzl

<!-- Generated with Stardoc: http://skydoc.bazel.build -->

<a id="nodejs"></a>

## nodejs

<pre>
nodejs(<a href="#nodejs-name">name</a>, <a href="#nodejs-options">options</a>, <a href="#nodejs-runtime">runtime</a>)
</pre>

**ATTRIBUTES**

| Name                               | Description                    | Type                                                                | Mandatory | Default         |
| :--------------------------------- | :----------------------------- | :------------------------------------------------------------------ | :-------- | :-------------- |
| <a id="nodejs-name"></a>name       | A unique name for this target. | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required  |                 |
| <a id="nodejs-options"></a>options | -                              | List of strings                                                     | optional  | <code>[]</code> |
| <a id="nodejs-runtime"></a>runtime | -                              | <a href="https://bazel.build/concepts/labels">Label</a>             | required  |                 |

<a id="nodejs_binary"></a>

## nodejs_binary

<pre>
nodejs_binary(<a href="#nodejs_binary-name">name</a>, <a href="#nodejs_binary-data">data</a>, <a href="#nodejs_binary-dep">dep</a>, <a href="#nodejs_binary-env">env</a>, <a href="#nodejs_binary-main">main</a>, <a href="#nodejs_binary-node">node</a>, <a href="#nodejs_binary-node_options">node_options</a>, <a href="#nodejs_binary-preload">preload</a>)
</pre>

Node.js binary

**ATTRIBUTES**

| Name                                                | Description                    | Type                                                                          | Mandatory | Default              |
| :-------------------------------------------------- | :----------------------------- | :---------------------------------------------------------------------------- | :-------- | :------------------- |
| <a id="nodejs_binary-name"></a>name                 | A unique name for this target. | <a href="https://bazel.build/concepts/labels#target-names">Name</a>           | required  |                      |
| <a id="nodejs_binary-data"></a>data                 | Runtime data                   | <a href="https://bazel.build/concepts/labels">List of labels</a>              | optional  | <code>[]</code>      |
| <a id="nodejs_binary-dep"></a>dep                   | JavaScript library.            | <a href="https://bazel.build/concepts/labels">Label</a>                       | required  |                      |
| <a id="nodejs_binary-env"></a>env                   | Environment variables          | <a href="https://bazel.build/rules/lib/dict">Dictionary: String -> String</a> | optional  | <code>{}</code>      |
| <a id="nodejs_binary-main"></a>main                 | -                              | String                                                                        | required  |                      |
| <a id="nodejs_binary-node"></a>node                 | -                              | <a href="https://bazel.build/concepts/labels">Label</a>                       | optional  | <code>:nodejs</code> |
| <a id="nodejs_binary-node_options"></a>node_options | Node.js options                | List of strings                                                               | optional  | <code>[]</code>      |
| <a id="nodejs_binary-preload"></a>preload           | Preloaded modules              | <a href="https://bazel.build/concepts/labels">List of labels</a>              | optional  | <code>[]</code>      |

<a id="nodejs_binary_package"></a>

## nodejs_binary_package

<pre>
nodejs_binary_package(<a href="#nodejs_binary_package-name">name</a>, <a href="#nodejs_binary_package-dep">dep</a>, <a href="#nodejs_binary_package-env">env</a>, <a href="#nodejs_binary_package-main">main</a>, <a href="#nodejs_binary_package-node">node</a>, <a href="#nodejs_binary_package-node_options">node_options</a>, <a href="#nodejs_binary_package-preload">preload</a>)
</pre>

Create executable tar

**ATTRIBUTES**

| Name                                                        | Description                    | Type                                                                          | Mandatory | Default              |
| :---------------------------------------------------------- | :----------------------------- | :---------------------------------------------------------------------------- | :-------- | :------------------- |
| <a id="nodejs_binary_package-name"></a>name                 | A unique name for this target. | <a href="https://bazel.build/concepts/labels#target-names">Name</a>           | required  |                      |
| <a id="nodejs_binary_package-dep"></a>dep                   | -                              | <a href="https://bazel.build/concepts/labels">Label</a>                       | required  |                      |
| <a id="nodejs_binary_package-env"></a>env                   | Environment variables          | <a href="https://bazel.build/rules/lib/dict">Dictionary: String -> String</a> | optional  | <code>{}</code>      |
| <a id="nodejs_binary_package-main"></a>main                 | -                              | String                                                                        | required  |                      |
| <a id="nodejs_binary_package-node"></a>node                 | -                              | <a href="https://bazel.build/concepts/labels">Label</a>                       | optional  | <code>:nodejs</code> |
| <a id="nodejs_binary_package-node_options"></a>node_options | Node.js options                | List of strings                                                               | optional  | <code>[]</code>      |
| <a id="nodejs_binary_package-preload"></a>preload           | Preloaded modules              | <a href="https://bazel.build/concepts/labels">List of labels</a>              | optional  | <code>[]</code>      |

<a id="nodejs_modules_binary"></a>

## nodejs_modules_binary

<pre>
nodejs_modules_binary(<a href="#nodejs_modules_binary-name">name</a>, <a href="#nodejs_modules_binary-env">env</a>, <a href="#nodejs_modules_binary-main">main</a>, <a href="#nodejs_modules_binary-main_package">main_package</a>, <a href="#nodejs_modules_binary-modules">modules</a>, <a href="#nodejs_modules_binary-node">node</a>, <a href="#nodejs_modules_binary-node_options">node_options</a>, <a href="#nodejs_modules_binary-path">path</a>)
</pre>

**ATTRIBUTES**

| Name                                                        | Description                    | Type                                                                          | Mandatory | Default              |
| :---------------------------------------------------------- | :----------------------------- | :---------------------------------------------------------------------------- | :-------- | :------------------- |
| <a id="nodejs_modules_binary-name"></a>name                 | A unique name for this target. | <a href="https://bazel.build/concepts/labels#target-names">Name</a>           | required  |                      |
| <a id="nodejs_modules_binary-env"></a>env                   | -                              | <a href="https://bazel.build/rules/lib/dict">Dictionary: String -> String</a> | optional  | <code>{}</code>      |
| <a id="nodejs_modules_binary-main"></a>main                 | -                              | String                                                                        | optional  | <code>""</code>      |
| <a id="nodejs_modules_binary-main_package"></a>main_package | -                              | String                                                                        | required  |                      |
| <a id="nodejs_modules_binary-modules"></a>modules           | -                              | <a href="https://bazel.build/concepts/labels">Label</a>                       | required  |                      |
| <a id="nodejs_modules_binary-node"></a>node                 | -                              | <a href="https://bazel.build/concepts/labels">Label</a>                       | optional  | <code>:nodejs</code> |
| <a id="nodejs_modules_binary-node_options"></a>node_options | -                              | List of strings                                                               | optional  | <code>[]</code>      |
| <a id="nodejs_modules_binary-path"></a>path                 | -                              | String                                                                        | optional  | <code>""</code>      |

<a id="nodejs_modules_package"></a>

## nodejs_modules_package

<pre>
nodejs_modules_package(<a href="#nodejs_modules_package-name">name</a>, <a href="#nodejs_modules_package-deps">deps</a>, <a href="#nodejs_modules_package-links">links</a>)
</pre>

**ATTRIBUTES**

| Name                                           | Description                    | Type                                                                | Mandatory | Default         |
| :--------------------------------------------- | :----------------------------- | :------------------------------------------------------------------ | :-------- | :-------------- |
| <a id="nodejs_modules_package-name"></a>name   | A unique name for this target. | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required  |                 |
| <a id="nodejs_modules_package-deps"></a>deps   | -                              | <a href="https://bazel.build/concepts/labels">List of labels</a>    | optional  | <code>[]</code> |
| <a id="nodejs_modules_package-links"></a>links | -                              | <a href="https://bazel.build/concepts/labels">List of labels</a>    | optional  | <code>[]</code> |

<a id="nodejs_simple_binary"></a>

## nodejs_simple_binary

<pre>
nodejs_simple_binary(<a href="#nodejs_simple_binary-name">name</a>, <a href="#nodejs_simple_binary-node">node</a>, <a href="#nodejs_simple_binary-node_options">node_options</a>, <a href="#nodejs_simple_binary-path">path</a>, <a href="#nodejs_simple_binary-src">src</a>)
</pre>

Node.js executable, from a single file.

**ATTRIBUTES**

| Name                                                       | Description                       | Type                                                                | Mandatory | Default           |
| :--------------------------------------------------------- | :-------------------------------- | :------------------------------------------------------------------ | :-------- | :---------------- |
| <a id="nodejs_simple_binary-name"></a>name                 | A unique name for this target.    | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required  |                   |
| <a id="nodejs_simple_binary-node"></a>node                 | -                                 | <a href="https://bazel.build/concepts/labels">Label</a>             | required  |                   |
| <a id="nodejs_simple_binary-node_options"></a>node_options | -                                 | List of strings                                                     | optional  | <code>[]</code>   |
| <a id="nodejs_simple_binary-path"></a>path                 | Path to file, if src is directory | <a href="https://bazel.build/concepts/labels">Label</a>             | optional  | <code>None</code> |
| <a id="nodejs_simple_binary-src"></a>src                   | Source file                       | <a href="https://bazel.build/concepts/labels">Label</a>             | required  |                   |

<a id="nodejs_system_runtime"></a>

## nodejs_system_runtime

<pre>
nodejs_system_runtime(<a href="#nodejs_system_runtime-name">name</a>, <a href="#nodejs_system_runtime-node">node</a>)
</pre>

**ATTRIBUTES**

| Name                                        | Description                    | Type                                                                | Mandatory | Default |
| :------------------------------------------ | :----------------------------- | :------------------------------------------------------------------ | :-------- | :------ |
| <a id="nodejs_system_runtime-name"></a>name | A unique name for this target. | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required  |         |
| <a id="nodejs_system_runtime-node"></a>node | -                              | String                                                              | required  |         |

<a id="nodejs_toolchain"></a>

## nodejs_toolchain

<pre>
nodejs_toolchain(<a href="#nodejs_toolchain-name">name</a>, <a href="#nodejs_toolchain-bin">bin</a>)
</pre>

**ATTRIBUTES**

| Name                                   | Description                    | Type                                                                | Mandatory | Default |
| :------------------------------------- | :----------------------------- | :------------------------------------------------------------------ | :-------- | :------ |
| <a id="nodejs_toolchain-name"></a>name | A unique name for this target. | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required  |         |
| <a id="nodejs_toolchain-bin"></a>bin   | Node.js executable             | <a href="https://bazel.build/concepts/labels">Label</a>             | required  |         |

<a id="configure_nodejs_runtime"></a>

## configure_nodejs_runtime

<pre>
configure_nodejs_runtime(<a href="#configure_nodejs_runtime-name">name</a>, <a href="#configure_nodejs_runtime-repo_name">repo_name</a>, <a href="#configure_nodejs_runtime-nodejs_runtime_rule">nodejs_runtime_rule</a>, <a href="#configure_nodejs_runtime-visibility">visibility</a>)
</pre>

**PARAMETERS**

| Name                                                                         | Description               | Default Value     |
| :--------------------------------------------------------------------------- | :------------------------ | :---------------- |
| <a id="configure_nodejs_runtime-name"></a>name                               | <p align="center"> - </p> | none              |
| <a id="configure_nodejs_runtime-repo_name"></a>repo_name                     | <p align="center"> - </p> | none              |
| <a id="configure_nodejs_runtime-nodejs_runtime_rule"></a>nodejs_runtime_rule | <p align="center"> - </p> | none              |
| <a id="configure_nodejs_runtime-visibility"></a>visibility                   | <p align="center"> - </p> | <code>None</code> |

<a id="nodejs_install"></a>

## nodejs_install

<pre>
nodejs_install(<a href="#nodejs_install-name">name</a>, <a href="#nodejs_install-src">src</a>, <a href="#nodejs_install-path">path</a>, <a href="#nodejs_install-kwargs">kwargs</a>)
</pre>

**PARAMETERS**

| Name                                     | Description               | Default Value     |
| :--------------------------------------- | :------------------------ | :---------------- |
| <a id="nodejs_install-name"></a>name     | <p align="center"> - </p> | none              |
| <a id="nodejs_install-src"></a>src       | <p align="center"> - </p> | none              |
| <a id="nodejs_install-path"></a>path     | <p align="center"> - </p> | <code>None</code> |
| <a id="nodejs_install-kwargs"></a>kwargs | <p align="center"> - </p> | none              |

<a id="nodejs_modules"></a>

## nodejs_modules

<pre>
nodejs_modules(<a href="#nodejs_modules-name">name</a>, <a href="#nodejs_modules-deps">deps</a>, <a href="#nodejs_modules-kwargs">kwargs</a>)
</pre>

**PARAMETERS**

| Name                                     | Description               | Default Value |
| :--------------------------------------- | :------------------------ | :------------ |
| <a id="nodejs_modules-name"></a>name     | <p align="center"> - </p> | none          |
| <a id="nodejs_modules-deps"></a>deps     | <p align="center"> - </p> | none          |
| <a id="nodejs_modules-kwargs"></a>kwargs | <p align="center"> - </p> | none          |

# //nodejs:workspace.bzl

<!-- Generated with Stardoc: http://skydoc.bazel.build -->

<a id="nodejs_repositories"></a>

## nodejs_repositories

<pre>
nodejs_repositories(<a href="#nodejs_repositories-name">name</a>, <a href="#nodejs_repositories-repositories">repositories</a>)
</pre>

**PARAMETERS**

| Name                                                      | Description               | Default Value |
| :-------------------------------------------------------- | :------------------------ | :------------ |
| <a id="nodejs_repositories-name"></a>name                 | <p align="center"> - </p> | none          |
| <a id="nodejs_repositories-repositories"></a>repositories | <p align="center"> - </p> | none          |

<a id="nodejs_toolchains"></a>

## nodejs_toolchains

<pre>
nodejs_toolchains(<a href="#nodejs_toolchains-toolchain">toolchain</a>, <a href="#nodejs_toolchains-repositories">repositories</a>)
</pre>

**PARAMETERS**

| Name                                                    | Description               | Default Value |
| :------------------------------------------------------ | :------------------------ | :------------ |
| <a id="nodejs_toolchains-toolchain"></a>toolchain       | <p align="center"> - </p> | none          |
| <a id="nodejs_toolchains-repositories"></a>repositories | <p align="center"> - </p> | none          |
