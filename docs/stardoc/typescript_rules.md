<!-- Generated with Stardoc: http://skydoc.bazel.build -->

<a id="#ts_compiler"></a>

## ts_compiler

<pre>
ts_compiler(<a href="#ts_compiler-name">name</a>, <a href="#ts_compiler-bin">bin</a>, <a href="#ts_compiler-runtime">runtime</a>, <a href="#ts_compiler-transpile_bin">transpile_bin</a>)
</pre>

**ATTRIBUTES**

| Name                                                | Description                                          | Type                                                               | Mandatory | Default |
| :-------------------------------------------------- | :--------------------------------------------------- | :----------------------------------------------------------------- | :-------- | :------ |
| <a id="ts_compiler-name"></a>name                   | A unique name for this target.                       | <a href="https://bazel.build/docs/build-ref.html#name">Name</a>    | required  |         |
| <a id="ts_compiler-bin"></a>bin                     | Declaration compiler executable.                     | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | optional  | None    |
| <a id="ts_compiler-runtime"></a>runtime             | Runtime library. If set, importHelpers will be used. | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | optional  | None    |
| <a id="ts_compiler-transpile_bin"></a>transpile_bin | JS compiler executable.                              | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | optional  | None    |

<a id="#ts_import"></a>

## ts_import

<pre>
ts_import(<a href="#ts_import-name">name</a>, <a href="#ts_import-declarations">declarations</a>, <a href="#ts_import-deps">deps</a>, <a href="#ts_import-js">js</a>, <a href="#ts_import-prefix">prefix</a>, <a href="#ts_import-root">root</a>, <a href="#ts_import-strip_prefix">strip_prefix</a>)
</pre>

Import existing files

**ATTRIBUTES**

| Name                                            | Description                              | Type                                                                        | Mandatory | Default |
| :---------------------------------------------- | :--------------------------------------- | :-------------------------------------------------------------------------- | :-------- | :------ |
| <a id="ts_import-name"></a>name                 | A unique name for this target.           | <a href="https://bazel.build/docs/build-ref.html#name">Name</a>             | required  |         |
| <a id="ts_import-declarations"></a>declarations | Typescript declarations                  | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional  | []      |
| <a id="ts_import-deps"></a>deps                 | Dependencies                             | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional  | []      |
| <a id="ts_import-js"></a>js                     | JavaScript                               | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional  | []      |
| <a id="ts_import-prefix"></a>prefix             | Prefix                                   | String                                                                      | optional  | ""      |
| <a id="ts_import-root"></a>root                 | CommonJS root                            | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a>          | required  |         |
| <a id="ts_import-strip_prefix"></a>strip_prefix | Strip prefix, defaults to CjsRoot prefix | String                                                                      | optional  | ""      |

<a id="#ts_library"></a>

## ts_library

<pre>
ts_library(<a href="#ts_library-name">name</a>, <a href="#ts_library-compiler">compiler</a>, <a href="#ts_library-config">config</a>, <a href="#ts_library-deps">deps</a>, <a href="#ts_library-global_deps">global_deps</a>, <a href="#ts_library-prefix">prefix</a>, <a href="#ts_library-root">root</a>, <a href="#ts_library-srcs">srcs</a>, <a href="#ts_library-strip_prefix">strip_prefix</a>)
</pre>

**ATTRIBUTES**

| Name                                             | Description                    | Type                                                                        | Mandatory | Default |
| :----------------------------------------------- | :----------------------------- | :-------------------------------------------------------------------------- | :-------- | :------ |
| <a id="ts_library-name"></a>name                 | A unique name for this target. | <a href="https://bazel.build/docs/build-ref.html#name">Name</a>             | required  |         |
| <a id="ts_library-compiler"></a>compiler         | -                              | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a>          | required  |         |
| <a id="ts_library-config"></a>config             | -                              | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a>          | optional  | None    |
| <a id="ts_library-deps"></a>deps                 | Dependencies                   | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional  | []      |
| <a id="ts_library-global_deps"></a>global_deps   | Types                          | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional  | []      |
| <a id="ts_library-prefix"></a>prefix             | Prefix                         | String                                                                      | optional  | ""      |
| <a id="ts_library-root"></a>root                 | -                              | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a>          | required  |         |
| <a id="ts_library-srcs"></a>srcs                 | TypeScript sources             | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | required  |         |
| <a id="ts_library-strip_prefix"></a>strip_prefix | Strip prefix                   | String                                                                      | optional  | ""      |

<a id="#ts_simple_compiler"></a>

## ts_simple_compiler

<pre>
ts_simple_compiler(<a href="#ts_simple_compiler-name">name</a>, <a href="#ts_simple_compiler-bin">bin</a>)
</pre>

**ATTRIBUTES**

| Name                                     | Description                    | Type                                                               | Mandatory | Default |
| :--------------------------------------- | :----------------------------- | :----------------------------------------------------------------- | :-------- | :------ |
| <a id="ts_simple_compiler-name"></a>name | A unique name for this target. | <a href="https://bazel.build/docs/build-ref.html#name">Name</a>    | required  |         |
| <a id="ts_simple_compiler-bin"></a>bin   | -                              | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | optional  | None    |

<a id="#ts_simple_library"></a>

## ts_simple_library

<pre>
ts_simple_library(<a href="#ts_simple_library-name">name</a>, <a href="#ts_simple_library-compiler">compiler</a>, <a href="#ts_simple_library-compiler_options">compiler_options</a>, <a href="#ts_simple_library-deps">deps</a>, <a href="#ts_simple_library-libs">libs</a>, <a href="#ts_simple_library-prefix">prefix</a>, <a href="#ts_simple_library-root">root</a>, <a href="#ts_simple_library-srcs">srcs</a>, <a href="#ts_simple_library-strip_prefix">strip_prefix</a>)
</pre>

**ATTRIBUTES**

| Name                                                            | Description                    | Type                                                                        | Mandatory | Default |
| :-------------------------------------------------------------- | :----------------------------- | :-------------------------------------------------------------------------- | :-------- | :------ |
| <a id="ts_simple_library-name"></a>name                         | A unique name for this target. | <a href="https://bazel.build/docs/build-ref.html#name">Name</a>             | required  |         |
| <a id="ts_simple_library-compiler"></a>compiler                 | -                              | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a>          | required  |         |
| <a id="ts_simple_library-compiler_options"></a>compiler_options | Compiler CLI options           | List of strings                                                             | optional  | []      |
| <a id="ts_simple_library-deps"></a>deps                         | Dependencies                   | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional  | []      |
| <a id="ts_simple_library-libs"></a>libs                         | -                              | List of strings                                                             | optional  | []      |
| <a id="ts_simple_library-prefix"></a>prefix                     | Prefix                         | String                                                                      | optional  | ""      |
| <a id="ts_simple_library-root"></a>root                         | -                              | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a>          | required  |         |
| <a id="ts_simple_library-srcs"></a>srcs                         | TypeScript sources             | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | required  |         |
| <a id="ts_simple_library-strip_prefix"></a>strip_prefix         | Strip prefix                   | String                                                                      | optional  | ""      |

<a id="#compiled_path"></a>

## compiled_path

<pre>
compiled_path(<a href="#compiled_path-input">input</a>)
</pre>

**PARAMETERS**

| Name                                  | Description               | Default Value |
| :------------------------------------ | :------------------------ | :------------ |
| <a id="compiled_path-input"></a>input | <p align="center"> - </p> | none          |

<a id="#configure_ts_compiler"></a>

## configure_ts_compiler

<pre>
configure_ts_compiler(<a href="#configure_ts_compiler-name">name</a>, <a href="#configure_ts_compiler-ts">ts</a>, <a href="#configure_ts_compiler-tslib">tslib</a>, <a href="#configure_ts_compiler-visibility">visibility</a>)
</pre>

Configure TypeScript compiler.

**PARAMETERS**

| Name                                                    | Description                                   | Default Value     |
| :------------------------------------------------------ | :-------------------------------------------- | :---------------- |
| <a id="configure_ts_compiler-name"></a>name             | Name to use for targets.                      | none              |
| <a id="configure_ts_compiler-ts"></a>ts                 | Typescript library.                           | none              |
| <a id="configure_ts_compiler-tslib"></a>tslib           | Tslib library. If set, importHelpers is true. | <code>None</code> |
| <a id="configure_ts_compiler-visibility"></a>visibility | Visibility.                                   | <code>None</code> |

<a id="#configure_ts_simple_compiler"></a>

## configure_ts_simple_compiler

<pre>
configure_ts_simple_compiler(<a href="#configure_ts_simple_compiler-name">name</a>, <a href="#configure_ts_simple_compiler-ts">ts</a>, <a href="#configure_ts_simple_compiler-visibility">visibility</a>)
</pre>

**PARAMETERS**

| Name                                                           | Description               | Default Value     |
| :------------------------------------------------------------- | :------------------------ | :---------------- |
| <a id="configure_ts_simple_compiler-name"></a>name             | <p align="center"> - </p> | none              |
| <a id="configure_ts_simple_compiler-ts"></a>ts                 | <p align="center"> - </p> | none              |
| <a id="configure_ts_simple_compiler-visibility"></a>visibility | <p align="center"> - </p> | <code>None</code> |

<a id="#declaration_path"></a>

## declaration_path

<pre>
declaration_path(<a href="#declaration_path-input">input</a>)
</pre>

**PARAMETERS**

| Name                                     | Description               | Default Value |
| :--------------------------------------- | :------------------------ | :------------ |
| <a id="declaration_path-input"></a>input | <p align="center"> - </p> | none          |

<a id="#map_path"></a>

## map_path

<pre>
map_path(<a href="#map_path-input">input</a>)
</pre>

**PARAMETERS**

| Name                             | Description               | Default Value |
| :------------------------------- | :------------------------ | :------------ |
| <a id="map_path-input"></a>input | <p align="center"> - </p> | none          |
