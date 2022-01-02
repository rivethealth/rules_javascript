<!-- Generated with Stardoc: http://skydoc.bazel.build -->

<a id="#angular_compiler"></a>

## angular_compiler

<pre>
angular_compiler(<a href="#angular_compiler-name">name</a>, <a href="#angular_compiler-bin">bin</a>, <a href="#angular_compiler-js_compiler">js_compiler</a>, <a href="#angular_compiler-js_deps">js_deps</a>, <a href="#angular_compiler-resource_compiler">resource_compiler</a>, <a href="#angular_compiler-ts_deps">ts_deps</a>)
</pre>

**ATTRIBUTES**

| Name                                                             | Description                    | Type                                                                        | Mandatory | Default                         |
| :--------------------------------------------------------------- | :----------------------------- | :-------------------------------------------------------------------------- | :-------- | :------------------------------ |
| <a id="angular_compiler-name"></a>name                           | A unique name for this target. | <a href="https://bazel.build/docs/build-ref.html#name">Name</a>             | required  |                                 |
| <a id="angular_compiler-bin"></a>bin                             | -                              | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a>          | required  |                                 |
| <a id="angular_compiler-js_compiler"></a>js_compiler             | -                              | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a>          | required  |                                 |
| <a id="angular_compiler-js_deps"></a>js_deps                     | -                              | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | required  |                                 |
| <a id="angular_compiler-resource_compiler"></a>resource_compiler | -                              | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a>          | optional  | //angular/resource-compiler:bin |
| <a id="angular_compiler-ts_deps"></a>ts_deps                     | -                              | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | required  |                                 |

<a id="#angular_library"></a>

## angular_library

<pre>
angular_library(<a href="#angular_library-name">name</a>, <a href="#angular_library-compiler">compiler</a>, <a href="#angular_library-config">config</a>, <a href="#angular_library-deps">deps</a>, <a href="#angular_library-extra_deps">extra_deps</a>, <a href="#angular_library-global_deps">global_deps</a>, <a href="#angular_library-prefix">prefix</a>, <a href="#angular_library-resources">resources</a>, <a href="#angular_library-root">root</a>,
                <a href="#angular_library-srcs">srcs</a>, <a href="#angular_library-strip_prefix">strip_prefix</a>)
</pre>

**ATTRIBUTES**

| Name                                                  | Description                    | Type                                                                                      | Mandatory | Default |
| :---------------------------------------------------- | :----------------------------- | :---------------------------------------------------------------------------------------- | :-------- | :------ |
| <a id="angular_library-name"></a>name                 | A unique name for this target. | <a href="https://bazel.build/docs/build-ref.html#name">Name</a>                           | required  |         |
| <a id="angular_library-compiler"></a>compiler         | Angular compiler.              | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a>                        | required  |         |
| <a id="angular_library-config"></a>config             | Tsconfig.                      | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a>                        | optional  | None    |
| <a id="angular_library-deps"></a>deps                 | Dependencies.                  | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a>               | optional  | []      |
| <a id="angular_library-extra_deps"></a>extra_deps     | Extra dependencies.            | <a href="https://bazel.build/docs/skylark/lib/dict.html">Dictionary: String -> String</a> | optional  | {}      |
| <a id="angular_library-global_deps"></a>global_deps   | Dependencies.                  | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a>               | optional  | []      |
| <a id="angular_library-prefix"></a>prefix             | -                              | String                                                                                    | optional  | ""      |
| <a id="angular_library-resources"></a>resources       | -                              | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a>               | optional  | []      |
| <a id="angular_library-root"></a>root                 | CommonJS root                  | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a>                        | required  |         |
| <a id="angular_library-srcs"></a>srcs                 | -                              | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a>               | required  |         |
| <a id="angular_library-strip_prefix"></a>strip_prefix | -                              | String                                                                                    | optional  | ""      |

<a id="#configure_angular_compiler"></a>

## configure_angular_compiler

<pre>
configure_angular_compiler(<a href="#configure_angular_compiler-name">name</a>, <a href="#configure_angular_compiler-core">core</a>, <a href="#configure_angular_compiler-compiler_cli">compiler_cli</a>, <a href="#configure_angular_compiler-ts">ts</a>, <a href="#configure_angular_compiler-tslib">tslib</a>, <a href="#configure_angular_compiler-reflect_metadata">reflect_metadata</a>, <a href="#configure_angular_compiler-visibility">visibility</a>)
</pre>

**PARAMETERS**

| Name                                                                     | Description               | Default Value     |
| :----------------------------------------------------------------------- | :------------------------ | :---------------- |
| <a id="configure_angular_compiler-name"></a>name                         | <p align="center"> - </p> | none              |
| <a id="configure_angular_compiler-core"></a>core                         | <p align="center"> - </p> | none              |
| <a id="configure_angular_compiler-compiler_cli"></a>compiler_cli         | <p align="center"> - </p> | none              |
| <a id="configure_angular_compiler-ts"></a>ts                             | <p align="center"> - </p> | none              |
| <a id="configure_angular_compiler-tslib"></a>tslib                       | <p align="center"> - </p> | none              |
| <a id="configure_angular_compiler-reflect_metadata"></a>reflect_metadata | <p align="center"> - </p> | none              |
| <a id="configure_angular_compiler-visibility"></a>visibility             | <p align="center"> - </p> | <code>None</code> |
