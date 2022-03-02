<!-- Generated with Stardoc: http://skydoc.bazel.build -->

<a id="#webpack"></a>

## webpack

<pre>
webpack(<a href="#webpack-name">name</a>, <a href="#webpack-bin">bin</a>, <a href="#webpack-client">client</a>, <a href="#webpack-config">config</a>, <a href="#webpack-config_dep">config_dep</a>, <a href="#webpack-language">language</a>, <a href="#webpack-module">module</a>, <a href="#webpack-server">server</a>)
</pre>

Webpack tools

**ATTRIBUTES**

| Name                                      | Description                    | Type                                                                        | Mandatory | Default  |
| :---------------------------------------- | :----------------------------- | :-------------------------------------------------------------------------- | :-------- | :------- |
| <a id="webpack-name"></a>name             | A unique name for this target. | <a href="https://bazel.build/docs/build-ref.html#name">Name</a>             | required  |          |
| <a id="webpack-bin"></a>bin               | Webpack executable             | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a>          | required  |          |
| <a id="webpack-client"></a>client         | -                              | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | required  |          |
| <a id="webpack-config"></a>config         | -                              | String                                                                      | required  |          |
| <a id="webpack-config_dep"></a>config_dep | -                              | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a>          | required  |          |
| <a id="webpack-language"></a>language     | -                              | String                                                                      | optional  | "es2020" |
| <a id="webpack-module"></a>module         | -                              | String                                                                      | optional  | "esnext" |
| <a id="webpack-server"></a>server         | -                              | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a>          | required  |          |

<a id="#webpack_bundle"></a>

## webpack_bundle

<pre>
webpack_bundle(<a href="#webpack_bundle-name">name</a>, <a href="#webpack_bundle-dep">dep</a>, <a href="#webpack_bundle-output">output</a>, <a href="#webpack_bundle-root">root</a>, <a href="#webpack_bundle-webpack">webpack</a>)
</pre>

Webpack bundle

**ATTRIBUTES**

| Name                                       | Description                                        | Type                                                               | Mandatory | Default |
| :----------------------------------------- | :------------------------------------------------- | :----------------------------------------------------------------- | :-------- | :------ |
| <a id="webpack_bundle-name"></a>name       | A unique name for this target.                     | <a href="https://bazel.build/docs/build-ref.html#name">Name</a>    | required  |         |
| <a id="webpack_bundle-dep"></a>dep         | JavaScript dependencies                            | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | required  |         |
| <a id="webpack_bundle-output"></a>output   | Output directory. Defaults to the name of the rule | String                                                             | optional  | ""      |
| <a id="webpack_bundle-root"></a>root       | CommonJS package root                              | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | required  |         |
| <a id="webpack_bundle-webpack"></a>webpack | Webpack tools                                      | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | required  |         |

<a id="#webpack_server"></a>

## webpack_server

<pre>
webpack_server(<a href="#webpack_server-name">name</a>, <a href="#webpack_server-dep">dep</a>, <a href="#webpack_server-language">language</a>, <a href="#webpack_server-module">module</a>, <a href="#webpack_server-webpack">webpack</a>)
</pre>

Run a webpack server

**ATTRIBUTES**

| Name                                         | Description                    | Type                                                               | Mandatory | Default |
| :------------------------------------------- | :----------------------------- | :----------------------------------------------------------------- | :-------- | :------ |
| <a id="webpack_server-name"></a>name         | A unique name for this target. | <a href="https://bazel.build/docs/build-ref.html#name">Name</a>    | required  |         |
| <a id="webpack_server-dep"></a>dep           | JavaScript dependencies        | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | required  |         |
| <a id="webpack_server-language"></a>language | -                              | String                                                             | optional  | ""      |
| <a id="webpack_server-module"></a>module     | -                              | String                                                             | optional  | ""      |
| <a id="webpack_server-webpack"></a>webpack   | Webpack tools                  | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | required  |         |

<a id="#configure_webpack"></a>

## configure_webpack

<pre>
configure_webpack(<a href="#configure_webpack-name">name</a>, <a href="#configure_webpack-cli">cli</a>, <a href="#configure_webpack-webpack">webpack</a>, <a href="#configure_webpack-dev_server">dev_server</a>, <a href="#configure_webpack-config">config</a>, <a href="#configure_webpack-config_dep">config_dep</a>, <a href="#configure_webpack-node_options">node_options</a>, <a href="#configure_webpack-visibility">visibility</a>)
</pre>

Set up webpack tools.

**PARAMETERS**

| Name                                                    | Description               | Default Value     |
| :------------------------------------------------------ | :------------------------ | :---------------- |
| <a id="configure_webpack-name"></a>name                 | Name                      | none              |
| <a id="configure_webpack-cli"></a>cli                   | <p align="center"> - </p> | none              |
| <a id="configure_webpack-webpack"></a>webpack           | <p align="center"> - </p> | none              |
| <a id="configure_webpack-dev_server"></a>dev_server     | <p align="center"> - </p> | none              |
| <a id="configure_webpack-config"></a>config             | Configuration             | none              |
| <a id="configure_webpack-config_dep"></a>config_dep     | <p align="center"> - </p> | none              |
| <a id="configure_webpack-node_options"></a>node_options | <p align="center"> - </p> | <code>[]</code>   |
| <a id="configure_webpack-visibility"></a>visibility     | <p align="center"> - </p> | <code>None</code> |
