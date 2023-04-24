# Webpack

Webpack bundles modules into one or more files.

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Guide](#guide)
  - [Example](#example)
- [//webpack:providers.bzl](#webpackprovidersbzl)
  - [WebpackInfo](#webpackinfo)
- [//webpack:rules.bzl](#webpackrulesbzl)
  - [webpack](#webpack)
  - [webpack_bundle](#webpack_bundle)
  - [webpack_server](#webpack_server)
  - [configure_webpack](#configure_webpack)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Guide

## Example

**lib.js**

```js
export const a = "apple";
```

**main.js**

```js
import { a } from "./lib";

console.log(a);
```

**webpack.config.js**

```js
module.exports = {
  entry: "./main.js",
};
```

**BUILD.bzl**

```bzl
load("@better_rules_javascript//commonjs:rules.bzl", "cjs_root")
load("@better_rules_javascript//javascript:rules.bzl", "js_library")
load("@better_rules_javascript//webpack:rules.bzl", "configure_webpack", "webpack_bundle")

webpack_bundle(
    name = "bundle",
    dep = ":b",
    root = ":root",
    webpack = ":webpack",
)

js_library(
    name = "lib",
    root = ":root",
    srcs = ["a.js", "b.js"],
)

cjs_root(
  name = "root",
)

configure_webpack(
    name = "webpack",
    config = "webpack.config.js",
    config_dep = ":webpack_config",
)

js_library(
    name = "webpack_config",
    root = ":root",
    srcs = ["webpack.config.js"],
)
```

# //webpack:providers.bzl

<!-- Generated with Stardoc: http://skydoc.bazel.build -->

<a id="WebpackInfo"></a>

## WebpackInfo

<pre>
WebpackInfo(<a href="#WebpackInfo-bin">bin</a>, <a href="#WebpackInfo-server">server</a>, <a href="#WebpackInfo-client_cjs">client_cjs</a>, <a href="#WebpackInfo-client_js">client_js</a>, <a href="#WebpackInfo-config_path">config_path</a>)
</pre>

Webpack configuration

**FIELDS**

| Name                                            | Description               |
| :---------------------------------------------- | :------------------------ |
| <a id="WebpackInfo-bin"></a>bin                 | Webpack executable        |
| <a id="WebpackInfo-server"></a>server           | Webpack server executable |
| <a id="WebpackInfo-client_cjs"></a>client_cjs   | Webpack dev server lib    |
| <a id="WebpackInfo-client_js"></a>client_js     | Webpack dev server lib    |
| <a id="WebpackInfo-config_path"></a>config_path | Config path               |

# //webpack:rules.bzl

<!-- Generated with Stardoc: http://skydoc.bazel.build -->

<a id="webpack"></a>

## webpack

<pre>
webpack(<a href="#webpack-name">name</a>, <a href="#webpack-bin">bin</a>, <a href="#webpack-client">client</a>, <a href="#webpack-config">config</a>, <a href="#webpack-config_dep">config_dep</a>, <a href="#webpack-language">language</a>, <a href="#webpack-module">module</a>, <a href="#webpack-server">server</a>)
</pre>

Webpack tools

**ATTRIBUTES**

| Name                                      | Description                    | Type                                                                | Mandatory | Default               |
| :---------------------------------------- | :----------------------------- | :------------------------------------------------------------------ | :-------- | :-------------------- |
| <a id="webpack-name"></a>name             | A unique name for this target. | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required  |                       |
| <a id="webpack-bin"></a>bin               | Webpack executable             | <a href="https://bazel.build/concepts/labels">Label</a>             | required  |                       |
| <a id="webpack-client"></a>client         | -                              | <a href="https://bazel.build/concepts/labels">List of labels</a>    | required  |                       |
| <a id="webpack-config"></a>config         | -                              | String                                                              | required  |                       |
| <a id="webpack-config_dep"></a>config_dep | -                              | <a href="https://bazel.build/concepts/labels">Label</a>             | required  |                       |
| <a id="webpack-language"></a>language     | -                              | String                                                              | optional  | <code>"es2020"</code> |
| <a id="webpack-module"></a>module         | -                              | String                                                              | optional  | <code>"esnext"</code> |
| <a id="webpack-server"></a>server         | -                              | <a href="https://bazel.build/concepts/labels">Label</a>             | required  |                       |

<a id="webpack_bundle"></a>

## webpack_bundle

<pre>
webpack_bundle(<a href="#webpack_bundle-name">name</a>, <a href="#webpack_bundle-dep">dep</a>, <a href="#webpack_bundle-output">output</a>, <a href="#webpack_bundle-root">root</a>, <a href="#webpack_bundle-webpack">webpack</a>)
</pre>

Webpack bundle

**ATTRIBUTES**

| Name                                       | Description                                        | Type                                                                | Mandatory | Default         |
| :----------------------------------------- | :------------------------------------------------- | :------------------------------------------------------------------ | :-------- | :-------------- |
| <a id="webpack_bundle-name"></a>name       | A unique name for this target.                     | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required  |                 |
| <a id="webpack_bundle-dep"></a>dep         | JavaScript dependencies                            | <a href="https://bazel.build/concepts/labels">Label</a>             | required  |                 |
| <a id="webpack_bundle-output"></a>output   | Output directory. Defaults to the name of the rule | String                                                              | optional  | <code>""</code> |
| <a id="webpack_bundle-root"></a>root       | CommonJS package root                              | <a href="https://bazel.build/concepts/labels">Label</a>             | required  |                 |
| <a id="webpack_bundle-webpack"></a>webpack | Webpack tools                                      | <a href="https://bazel.build/concepts/labels">Label</a>             | required  |                 |

<a id="webpack_server"></a>

## webpack_server

<pre>
webpack_server(<a href="#webpack_server-name">name</a>, <a href="#webpack_server-dep">dep</a>, <a href="#webpack_server-language">language</a>, <a href="#webpack_server-module">module</a>, <a href="#webpack_server-webpack">webpack</a>)
</pre>

Run a webpack server

**ATTRIBUTES**

| Name                                         | Description                    | Type                                                                | Mandatory | Default         |
| :------------------------------------------- | :----------------------------- | :------------------------------------------------------------------ | :-------- | :-------------- |
| <a id="webpack_server-name"></a>name         | A unique name for this target. | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required  |                 |
| <a id="webpack_server-dep"></a>dep           | JavaScript dependencies        | <a href="https://bazel.build/concepts/labels">Label</a>             | required  |                 |
| <a id="webpack_server-language"></a>language | -                              | String                                                              | optional  | <code>""</code> |
| <a id="webpack_server-module"></a>module     | -                              | String                                                              | optional  | <code>""</code> |
| <a id="webpack_server-webpack"></a>webpack   | Webpack tools                  | <a href="https://bazel.build/concepts/labels">Label</a>             | required  |                 |

<a id="configure_webpack"></a>

## configure_webpack

<pre>
configure_webpack(<a href="#configure_webpack-name">name</a>, <a href="#configure_webpack-config">config</a>, <a href="#configure_webpack-config_dep">config_dep</a>, <a href="#configure_webpack-cli">cli</a>, <a href="#configure_webpack-webpack">webpack</a>, <a href="#configure_webpack-dev_server">dev_server</a>, <a href="#configure_webpack-node_options">node_options</a>, <a href="#configure_webpack-visibility">visibility</a>)
</pre>

Set up webpack tools.

**PARAMETERS**

| Name                                                    | Description                | Default Value                                                       |
| :------------------------------------------------------ | :------------------------- | :------------------------------------------------------------------ |
| <a id="configure_webpack-name"></a>name                 | Name                       | none                                                                |
| <a id="configure_webpack-config"></a>config             | Configuration path         | none                                                                |
| <a id="configure_webpack-config_dep"></a>config_dep     | Configuration library      | none                                                                |
| <a id="configure_webpack-cli"></a>cli                   | Webpack CLI library        | <code>"@better_rules_javascript//webpack:webpack_cli"</code>        |
| <a id="configure_webpack-webpack"></a>webpack           | Webpack library            | <code>"@better_rules_javascript//webpack"</code>                    |
| <a id="configure_webpack-dev_server"></a>dev_server     | Webpack dev server library | <code>"@better_rules_javascript//webpack:webpack_dev_server"</code> |
| <a id="configure_webpack-node_options"></a>node_options | Node.js options            | <code>[]</code>                                                     |
| <a id="configure_webpack-visibility"></a>visibility     | Visibility                 | <code>None</code>                                                   |
