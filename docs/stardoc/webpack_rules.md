<!-- Generated with Stardoc: http://skydoc.bazel.build -->

<a id="#webpack"></a>

## webpack

<pre>
webpack(<a href="#webpack-name">name</a>, <a href="#webpack-bin">bin</a>, <a href="#webpack-config">config</a>, <a href="#webpack-config_dep">config_dep</a>)
</pre>

Webpack tools

**ATTRIBUTES**

| Name                                      | Description                    | Type                                                               | Mandatory | Default |
| :---------------------------------------- | :----------------------------- | :----------------------------------------------------------------- | :-------- | :------ |
| <a id="webpack-name"></a>name             | A unique name for this target. | <a href="https://bazel.build/docs/build-ref.html#name">Name</a>    | required  |         |
| <a id="webpack-bin"></a>bin               | Webpack executable             | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | required  |         |
| <a id="webpack-config"></a>config         | -                              | String                                                             | required  |         |
| <a id="webpack-config_dep"></a>config_dep | -                              | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | required  |         |

<a id="#webpack_bundle"></a>

## webpack_bundle

<pre>
webpack_bundle(<a href="#webpack_bundle-name">name</a>, <a href="#webpack_bundle-dep">dep</a>, <a href="#webpack_bundle-webpack">webpack</a>)
</pre>

Webpack bundle

**ATTRIBUTES**

| Name                                       | Description                    | Type                                                               | Mandatory | Default |
| :----------------------------------------- | :----------------------------- | :----------------------------------------------------------------- | :-------- | :------ |
| <a id="webpack_bundle-name"></a>name       | A unique name for this target. | <a href="https://bazel.build/docs/build-ref.html#name">Name</a>    | required  |         |
| <a id="webpack_bundle-dep"></a>dep         | JavaScript dependencies        | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | optional  | None    |
| <a id="webpack_bundle-webpack"></a>webpack | Webpack tools                  | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | required  |         |

<a id="#configure_webpack"></a>

## configure_webpack

<pre>
configure_webpack(<a href="#configure_webpack-name">name</a>, <a href="#configure_webpack-dep">dep</a>, <a href="#configure_webpack-config_dep">config_dep</a>, <a href="#configure_webpack-config">config</a>, <a href="#configure_webpack-visibility">visibility</a>)
</pre>

Set up webpack tools.

**PARAMETERS**

| Name                                                | Description               | Default Value     |
| :-------------------------------------------------- | :------------------------ | :---------------- |
| <a id="configure_webpack-name"></a>name             | Name                      | none              |
| <a id="configure_webpack-dep"></a>dep               | Webpack library           | none              |
| <a id="configure_webpack-config_dep"></a>config_dep | Configuration dependency  | none              |
| <a id="configure_webpack-config"></a>config         | Configuration path        | none              |
| <a id="configure_webpack-visibility"></a>visibility | <p align="center"> - </p> | <code>None</code> |
