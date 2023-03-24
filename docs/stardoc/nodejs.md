# Contents

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [//nodejs:providers.bzl](#nodejsprovidersbzl)
  - [NodejsInfo](#nodejsinfo)
  - [NodejsRuntimeInfo](#nodejsruntimeinfo)
  - [nodejs_runtime_rule](#nodejs_runtime_rule)
- [//nodejs:rules.bzl](#nodejsrulesbzl)
  - [nodejs](#nodejs)
  - [nodejs_binary](#nodejs_binary)
  - [nodejs_binary_archive](#nodejs_binary_archive)
  - [nodejs_install](#nodejs_install)
  - [nodejs_modules_archive](#nodejs_modules_archive)
  - [nodejs_simple_binary](#nodejs_simple_binary)
  - [nodejs_system_runtime](#nodejs_system_runtime)
  - [nodejs_toolchain](#nodejs_toolchain)
  - [configure_nodejs_runtime](#configure_nodejs_runtime)
- [//nodejs:workspace.bzl](#nodejsworkspacebzl)
  - [nodejs_repositories](#nodejs_repositories)
  - [nodejs_toolchains](#nodejs_toolchains)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

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
nodejs_binary(<a href="#nodejs_binary-name">name</a>, <a href="#nodejs_binary-data">data</a>, <a href="#nodejs_binary-dep">dep</a>, <a href="#nodejs_binary-env">env</a>, <a href="#nodejs_binary-main">main</a>, <a href="#nodejs_binary-node">node</a>, <a href="#nodejs_binary-node_options">node_options</a>)
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

<a id="nodejs_binary_archive"></a>

## nodejs_binary_archive

<pre>
nodejs_binary_archive(<a href="#nodejs_binary_archive-name">name</a>, <a href="#nodejs_binary_archive-dep">dep</a>, <a href="#nodejs_binary_archive-env">env</a>, <a href="#nodejs_binary_archive-main">main</a>, <a href="#nodejs_binary_archive-node">node</a>, <a href="#nodejs_binary_archive-node_options">node_options</a>)
</pre>

Create executable tar

**ATTRIBUTES**

| Name                                                        | Description                    | Type                                                                          | Mandatory | Default              |
| :---------------------------------------------------------- | :----------------------------- | :---------------------------------------------------------------------------- | :-------- | :------------------- |
| <a id="nodejs_binary_archive-name"></a>name                 | A unique name for this target. | <a href="https://bazel.build/concepts/labels#target-names">Name</a>           | required  |                      |
| <a id="nodejs_binary_archive-dep"></a>dep                   | -                              | <a href="https://bazel.build/concepts/labels">Label</a>                       | required  |                      |
| <a id="nodejs_binary_archive-env"></a>env                   | Environment variables          | <a href="https://bazel.build/rules/lib/dict">Dictionary: String -> String</a> | optional  | <code>{}</code>      |
| <a id="nodejs_binary_archive-main"></a>main                 | -                              | String                                                                        | required  |                      |
| <a id="nodejs_binary_archive-node"></a>node                 | -                              | <a href="https://bazel.build/concepts/labels">Label</a>                       | optional  | <code>:nodejs</code> |
| <a id="nodejs_binary_archive-node_options"></a>node_options | Node.js options                | List of strings                                                               | optional  | <code>[]</code>      |

<a id="nodejs_install"></a>

## nodejs_install

<pre>
nodejs_install(<a href="#nodejs_install-name">name</a>, <a href="#nodejs_install-archive">archive</a>, <a href="#nodejs_install-path">path</a>)
</pre>

**ATTRIBUTES**

| Name                                       | Description                    | Type                                                                | Mandatory | Default           |
| :----------------------------------------- | :----------------------------- | :------------------------------------------------------------------ | :-------- | :---------------- |
| <a id="nodejs_install-name"></a>name       | A unique name for this target. | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required  |                   |
| <a id="nodejs_install-archive"></a>archive | -                              | <a href="https://bazel.build/concepts/labels">Label</a>             | required  |                   |
| <a id="nodejs_install-path"></a>path       | Path from root of workspace    | <a href="https://bazel.build/concepts/labels">Label</a>             | optional  | <code>None</code> |

<a id="nodejs_modules_archive"></a>

## nodejs_modules_archive

<pre>
nodejs_modules_archive(<a href="#nodejs_modules_archive-name">name</a>, <a href="#nodejs_modules_archive-deps">deps</a>, <a href="#nodejs_modules_archive-links">links</a>)
</pre>

node_modules tar

**ATTRIBUTES**

| Name                                           | Description                    | Type                                                                | Mandatory | Default         |
| :--------------------------------------------- | :----------------------------- | :------------------------------------------------------------------ | :-------- | :-------------- |
| <a id="nodejs_modules_archive-name"></a>name   | A unique name for this target. | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required  |                 |
| <a id="nodejs_modules_archive-deps"></a>deps   | -                              | <a href="https://bazel.build/concepts/labels">List of labels</a>    | optional  | <code>[]</code> |
| <a id="nodejs_modules_archive-links"></a>links | -                              | <a href="https://bazel.build/concepts/labels">List of labels</a>    | optional  | <code>[]</code> |

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
