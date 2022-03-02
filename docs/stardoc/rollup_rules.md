<!-- Generated with Stardoc: http://skydoc.bazel.build -->

<a id="#rollup"></a>

## rollup

<pre>
rollup(<a href="#rollup-name">name</a>, <a href="#rollup-bin">bin</a>, <a href="#rollup-config">config</a>, <a href="#rollup-config_dep">config_dep</a>)
</pre>

Rollup tools.

**ATTRIBUTES**

| Name                                     | Description                    | Type                                                               | Mandatory | Default |
| :--------------------------------------- | :----------------------------- | :----------------------------------------------------------------- | :-------- | :------ |
| <a id="rollup-name"></a>name             | A unique name for this target. | <a href="https://bazel.build/docs/build-ref.html#name">Name</a>    | required  |         |
| <a id="rollup-bin"></a>bin               | Rollup executable              | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | required  |         |
| <a id="rollup-config"></a>config         | Config.                        | String                                                             | required  |         |
| <a id="rollup-config_dep"></a>config_dep | Config dependency.             | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | required  |         |

<a id="#rollup_bundle"></a>

## rollup_bundle

<pre>
rollup_bundle(<a href="#rollup_bundle-name">name</a>, <a href="#rollup_bundle-dep">dep</a>, <a href="#rollup_bundle-output">output</a>, <a href="#rollup_bundle-output_directory">output_directory</a>, <a href="#rollup_bundle-rollup">rollup</a>)
</pre>

Rollup bundle

**ATTRIBUTES**

| Name                                                        | Description                    | Type                                                               | Mandatory | Default |
| :---------------------------------------------------------- | :----------------------------- | :----------------------------------------------------------------- | :-------- | :------ |
| <a id="rollup_bundle-name"></a>name                         | A unique name for this target. | <a href="https://bazel.build/docs/build-ref.html#name">Name</a>    | required  |         |
| <a id="rollup_bundle-dep"></a>dep                           | JavaScript dependencies        | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | optional  | None    |
| <a id="rollup_bundle-output"></a>output                     | -                              | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | optional  |         |
| <a id="rollup_bundle-output_directory"></a>output_directory | -                              | String                                                             | optional  | ""      |
| <a id="rollup_bundle-rollup"></a>rollup                     | Rollup tools                   | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | required  |         |

<a id="#configure_rollup"></a>

## configure_rollup

<pre>
configure_rollup(<a href="#configure_rollup-name">name</a>, <a href="#configure_rollup-dep">dep</a>, <a href="#configure_rollup-config">config</a>, <a href="#configure_rollup-config_dep">config_dep</a>, <a href="#configure_rollup-visibility">visibility</a>)
</pre>

Set up rollup tools.

**PARAMETERS**

| Name                                               | Description               | Default Value     |
| :------------------------------------------------- | :------------------------ | :---------------- |
| <a id="configure_rollup-name"></a>name             | Name                      | none              |
| <a id="configure_rollup-dep"></a>dep               | Rollup library            | none              |
| <a id="configure_rollup-config"></a>config         | Configuration             | none              |
| <a id="configure_rollup-config_dep"></a>config_dep | <p align="center"> - </p> | none              |
| <a id="configure_rollup-visibility"></a>visibility | <p align="center"> - </p> | <code>None</code> |
