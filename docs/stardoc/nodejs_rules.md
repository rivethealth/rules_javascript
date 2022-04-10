<!-- Generated with Stardoc: http://skydoc.bazel.build -->

<a id="#nodejs"></a>

## nodejs

<pre>
nodejs(<a href="#nodejs-name">name</a>, <a href="#nodejs-options">options</a>, <a href="#nodejs-runtime">runtime</a>)
</pre>

**ATTRIBUTES**

| Name                               | Description                    | Type                                                               | Mandatory | Default |
| :--------------------------------- | :----------------------------- | :----------------------------------------------------------------- | :-------- | :------ |
| <a id="nodejs-name"></a>name       | A unique name for this target. | <a href="https://bazel.build/docs/build-ref.html#name">Name</a>    | required  |         |
| <a id="nodejs-options"></a>options | -                              | List of strings                                                    | optional  | []      |
| <a id="nodejs-runtime"></a>runtime | -                              | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | required  |         |

<a id="#nodejs_archive"></a>

## nodejs_archive

<pre>
nodejs_archive(<a href="#nodejs_archive-name">name</a>, <a href="#nodejs_archive-deps">deps</a>, <a href="#nodejs_archive-links">links</a>)
</pre>

**ATTRIBUTES**

| Name                                   | Description                    | Type                                                                        | Mandatory | Default |
| :------------------------------------- | :----------------------------- | :-------------------------------------------------------------------------- | :-------- | :------ |
| <a id="nodejs_archive-name"></a>name   | A unique name for this target. | <a href="https://bazel.build/docs/build-ref.html#name">Name</a>             | required  |         |
| <a id="nodejs_archive-deps"></a>deps   | -                              | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional  | []      |
| <a id="nodejs_archive-links"></a>links | -                              | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional  | []      |

<a id="#nodejs_binary"></a>

## nodejs_binary

<pre>
nodejs_binary(<a href="#nodejs_binary-name">name</a>, <a href="#nodejs_binary-data">data</a>, <a href="#nodejs_binary-dep">dep</a>, <a href="#nodejs_binary-env">env</a>, <a href="#nodejs_binary-main">main</a>, <a href="#nodejs_binary-node">node</a>, <a href="#nodejs_binary-node_options">node_options</a>)
</pre>

Node.js binary

**ATTRIBUTES**

| Name                                                | Description                    | Type                                                                                      | Mandatory | Default |
| :-------------------------------------------------- | :----------------------------- | :---------------------------------------------------------------------------------------- | :-------- | :------ |
| <a id="nodejs_binary-name"></a>name                 | A unique name for this target. | <a href="https://bazel.build/docs/build-ref.html#name">Name</a>                           | required  |         |
| <a id="nodejs_binary-data"></a>data                 | Runtime data                   | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a>               | optional  | []      |
| <a id="nodejs_binary-dep"></a>dep                   | JavaScript library.            | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a>                        | required  |         |
| <a id="nodejs_binary-env"></a>env                   | Environment variables          | <a href="https://bazel.build/docs/skylark/lib/dict.html">Dictionary: String -> String</a> | optional  | {}      |
| <a id="nodejs_binary-main"></a>main                 | -                              | String                                                                                    | required  |         |
| <a id="nodejs_binary-node"></a>node                 | -                              | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a>                        | required  |         |
| <a id="nodejs_binary-node_options"></a>node_options | Node.js options                | List of strings                                                                           | optional  | []      |

<a id="#nodejs_binary_archive"></a>

## nodejs_binary_archive

<pre>
nodejs_binary_archive(<a href="#nodejs_binary_archive-name">name</a>, <a href="#nodejs_binary_archive-dep">dep</a>, <a href="#nodejs_binary_archive-env">env</a>, <a href="#nodejs_binary_archive-main">main</a>, <a href="#nodejs_binary_archive-node_options">node_options</a>)
</pre>

**ATTRIBUTES**

| Name                                                        | Description                    | Type                                                                                      | Mandatory | Default |
| :---------------------------------------------------------- | :----------------------------- | :---------------------------------------------------------------------------------------- | :-------- | :------ |
| <a id="nodejs_binary_archive-name"></a>name                 | A unique name for this target. | <a href="https://bazel.build/docs/build-ref.html#name">Name</a>                           | required  |         |
| <a id="nodejs_binary_archive-dep"></a>dep                   | -                              | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a>                        | required  |         |
| <a id="nodejs_binary_archive-env"></a>env                   | Environment variables          | <a href="https://bazel.build/docs/skylark/lib/dict.html">Dictionary: String -> String</a> | optional  | {}      |
| <a id="nodejs_binary_archive-main"></a>main                 | -                              | String                                                                                    | required  |         |
| <a id="nodejs_binary_archive-node_options"></a>node_options | Node.js options                | List of strings                                                                           | optional  | []      |

<a id="#nodejs_install"></a>

## nodejs_install

<pre>
nodejs_install(<a href="#nodejs_install-name">name</a>, <a href="#nodejs_install-archive">archive</a>, <a href="#nodejs_install-path">path</a>)
</pre>

**ATTRIBUTES**

| Name                                       | Description                    | Type                                                               | Mandatory | Default |
| :----------------------------------------- | :----------------------------- | :----------------------------------------------------------------- | :-------- | :------ |
| <a id="nodejs_install-name"></a>name       | A unique name for this target. | <a href="https://bazel.build/docs/build-ref.html#name">Name</a>    | required  |         |
| <a id="nodejs_install-archive"></a>archive | -                              | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | required  |         |
| <a id="nodejs_install-path"></a>path       | Path from root of workspace    | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | optional  | None    |

<a id="#nodejs_simple_binary"></a>

## nodejs_simple_binary

<pre>
nodejs_simple_binary(<a href="#nodejs_simple_binary-name">name</a>, <a href="#nodejs_simple_binary-node">node</a>, <a href="#nodejs_simple_binary-node_options">node_options</a>, <a href="#nodejs_simple_binary-path">path</a>, <a href="#nodejs_simple_binary-src">src</a>)
</pre>

Node.js executable, from a single file.

**ATTRIBUTES**

| Name                                                       | Description                       | Type                                                               | Mandatory | Default |
| :--------------------------------------------------------- | :-------------------------------- | :----------------------------------------------------------------- | :-------- | :------ |
| <a id="nodejs_simple_binary-name"></a>name                 | A unique name for this target.    | <a href="https://bazel.build/docs/build-ref.html#name">Name</a>    | required  |         |
| <a id="nodejs_simple_binary-node"></a>node                 | -                                 | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | required  |         |
| <a id="nodejs_simple_binary-node_options"></a>node_options | -                                 | List of strings                                                    | optional  | []      |
| <a id="nodejs_simple_binary-path"></a>path                 | Path to file, if src is directory | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | optional  | None    |
| <a id="nodejs_simple_binary-src"></a>src                   | Source file                       | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | required  |         |

<a id="#nodejs_toolchain"></a>

## nodejs_toolchain

<pre>
nodejs_toolchain(<a href="#nodejs_toolchain-name">name</a>, <a href="#nodejs_toolchain-bin">bin</a>)
</pre>

**ATTRIBUTES**

| Name                                   | Description                    | Type                                                               | Mandatory | Default |
| :------------------------------------- | :----------------------------- | :----------------------------------------------------------------- | :-------- | :------ |
| <a id="nodejs_toolchain-name"></a>name | A unique name for this target. | <a href="https://bazel.build/docs/build-ref.html#name">Name</a>    | required  |         |
| <a id="nodejs_toolchain-bin"></a>bin   | Node.js executable             | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | required  |         |

<a id="#configure_nodejs_runtime"></a>

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
