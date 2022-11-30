<!-- Generated with Stardoc: http://skydoc.bazel.build -->

<a id="#ts_compiler"></a>

## ts_compiler

<pre>
ts_compiler(<a href="#ts_compiler-name">name</a>, <a href="#ts_compiler-bin">bin</a>, <a href="#ts_compiler-runtime">runtime</a>, <a href="#ts_compiler-transpile_bin">transpile_bin</a>)
</pre>

**ATTRIBUTES**

| Name                                                | Description                      | Type                                                               | Mandatory | Default |
| :-------------------------------------------------- | :------------------------------- | :----------------------------------------------------------------- | :-------- | :------ |
| <a id="ts_compiler-name"></a>name                   | A unique name for this target.   | <a href="https://bazel.build/docs/build-ref.html#name">Name</a>    | required  |         |
| <a id="ts_compiler-bin"></a>bin                     | Declaration compiler executable. | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | required  |         |
| <a id="ts_compiler-runtime"></a>runtime             | Runtime library.                 | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | optional  | None    |
| <a id="ts_compiler-transpile_bin"></a>transpile_bin | JS compiler executable.          | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | required  |         |

<a id="#ts_export"></a>

## ts_export

<pre>
ts_export(<a href="#ts_export-name">name</a>, <a href="#ts_export-dep">dep</a>, <a href="#ts_export-deps">deps</a>, <a href="#ts_export-extra_deps">extra_deps</a>, <a href="#ts_export-global_deps">global_deps</a>, <a href="#ts_export-package_name">package_name</a>)
</pre>

Add dependencies, or use alias.

**ATTRIBUTES**

| Name                                            | Description                               | Type                                                                        | Mandatory | Default |
| :---------------------------------------------- | :---------------------------------------- | :-------------------------------------------------------------------------- | :-------- | :------ |
| <a id="ts_export-name"></a>name                 | A unique name for this target.            | <a href="https://bazel.build/docs/build-ref.html#name">Name</a>             | required  |         |
| <a id="ts_export-dep"></a>dep                   | JavaScript library.                       | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a>          | required  |         |
| <a id="ts_export-deps"></a>deps                 | Dependencies to add.                      | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional  | []      |
| <a id="ts_export-extra_deps"></a>extra_deps     | Extra dependencies to add.                | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional  | []      |
| <a id="ts_export-global_deps"></a>global_deps   | Global dependencies to add.               | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional  | []      |
| <a id="ts_export-package_name"></a>package_name | Dependency name. Defaults to root's name. | String                                                                      | optional  | ""      |

<a id="#ts_import"></a>

## ts_import

<pre>
ts_import(<a href="#ts_import-name">name</a>, <a href="#ts_import-declaration_prefix">declaration_prefix</a>, <a href="#ts_import-declarations">declarations</a>, <a href="#ts_import-deps">deps</a>, <a href="#ts_import-js">js</a>, <a href="#ts_import-js_prefix">js_prefix</a>, <a href="#ts_import-root">root</a>, <a href="#ts_import-strip_prefix">strip_prefix</a>)
</pre>

TypeScript library with pre-existing declaration files.

**ATTRIBUTES**

| Name                                                        | Description                                   | Type                                                                        | Mandatory | Default |
| :---------------------------------------------------------- | :-------------------------------------------- | :-------------------------------------------------------------------------- | :-------- | :------ |
| <a id="ts_import-name"></a>name                             | A unique name for this target.                | <a href="https://bazel.build/docs/build-ref.html#name">Name</a>             | required  |         |
| <a id="ts_import-declaration_prefix"></a>declaration_prefix | Prefix to add to declaration files.           | String                                                                      | optional  | ""      |
| <a id="ts_import-declarations"></a>declarations             | Typescript declarations                       | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional  | []      |
| <a id="ts_import-deps"></a>deps                             | Dependencies                                  | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional  | []      |
| <a id="ts_import-js"></a>js                                 | JavaScript                                    | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional  | []      |
| <a id="ts_import-js_prefix"></a>js_prefix                   | Prefix to add to JavaScript files.            | String                                                                      | optional  | ""      |
| <a id="ts_import-root"></a>root                             | CommonJS root                                 | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a>          | optional  | None    |
| <a id="ts_import-strip_prefix"></a>strip_prefix             | Package-relative prefix to remove from files. | String                                                                      | optional  | ""      |

<a id="#ts_library"></a>

## ts_library

<pre>
ts_library(<a href="#ts_library-name">name</a>, <a href="#ts_library-compile_deps">compile_deps</a>, <a href="#ts_library-compiler">compiler</a>, <a href="#ts_library-config">config</a>, <a href="#ts_library-config_dep">config_dep</a>, <a href="#ts_library-data">data</a>, <a href="#ts_library-declaration_prefix">declaration_prefix</a>, <a href="#ts_library-deps">deps</a>,
           <a href="#ts_library-js_prefix">js_prefix</a>, <a href="#ts_library-jsx">jsx</a>, <a href="#ts_library-module">module</a>, <a href="#ts_library-root">root</a>, <a href="#ts_library-src_prefix">src_prefix</a>, <a href="#ts_library-srcs">srcs</a>, <a href="#ts_library-strip_prefix">strip_prefix</a>, <a href="#ts_library-target">target</a>)
</pre>

TypeScript library.

**ATTRIBUTES**

| Name                                                         | Description                                                                                                   | Type                                                                        | Mandatory | Default |
| :----------------------------------------------------------- | :------------------------------------------------------------------------------------------------------------ | :-------------------------------------------------------------------------- | :-------- | :------ |
| <a id="ts_library-name"></a>name                             | A unique name for this target.                                                                                | <a href="https://bazel.build/docs/build-ref.html#name">Name</a>             | required  |         |
| <a id="ts_library-compile_deps"></a>compile_deps             | Dependecies provided only at compile-time                                                                     | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional  | []      |
| <a id="ts_library-compiler"></a>compiler                     | -                                                                                                             | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a>          | required  |         |
| <a id="ts_library-config"></a>config                         | Tsconfig path.                                                                                                | String                                                                      | optional  | ""      |
| <a id="ts_library-config_dep"></a>config_dep                 | Tsconfig dependency.                                                                                          | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a>          | optional  | None    |
| <a id="ts_library-data"></a>data                             | Runfile files. These are added to normal runfiles tree, not CommonJS packages.                                | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional  | []      |
| <a id="ts_library-declaration_prefix"></a>declaration_prefix | Prefix to add to declaration files.                                                                           | String                                                                      | optional  | ""      |
| <a id="ts_library-deps"></a>deps                             | JS and TS dependencies                                                                                        | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional  | []      |
| <a id="ts_library-js_prefix"></a>js_prefix                   | Prefix to add to JavaScript files.                                                                            | String                                                                      | optional  | ""      |
| <a id="ts_library-jsx"></a>jsx                               | How JSX is emitted: react (default) or preserve                                                               | String                                                                      | optional  | "react" |
| <a id="ts_library-module"></a>module                         | Module type. By default, uses //javascript:module.                                                            | String                                                                      | optional  | ""      |
| <a id="ts_library-root"></a>root                             | CommonJS package root.                                                                                        | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a>          | optional  | None    |
| <a id="ts_library-src_prefix"></a>src_prefix                 | Prefix to add to sources.                                                                                     | String                                                                      | optional  | ""      |
| <a id="ts_library-srcs"></a>srcs                             | TypeScript sources. If providing directories, the \*\_prefix attributes must be used to separate the outputs. | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional  | []      |
| <a id="ts_library-strip_prefix"></a>strip_prefix             | Package-relative prefix to remove.                                                                            | String                                                                      | optional  | ""      |
| <a id="ts_library-target"></a>target                         | Target language. By default, uses //javascript:language.                                                      | String                                                                      | optional  | ""      |

<a id="#configure_ts_compiler"></a>

## configure_ts_compiler

<pre>
configure_ts_compiler(<a href="#configure_ts_compiler-name">name</a>, <a href="#configure_ts_compiler-ts">ts</a>, <a href="#configure_ts_compiler-tslib">tslib</a>, <a href="#configure_ts_compiler-visibility">visibility</a>)
</pre>

Configure TypeScript compiler.

**PARAMETERS**

| Name                                                    | Description              | Default Value     |
| :------------------------------------------------------ | :----------------------- | :---------------- |
| <a id="configure_ts_compiler-name"></a>name             | Name to use for targets. | none              |
| <a id="configure_ts_compiler-ts"></a>ts                 | Typescript library.      | none              |
| <a id="configure_ts_compiler-tslib"></a>tslib           | Tslib library.           | <code>None</code> |
| <a id="configure_ts_compiler-visibility"></a>visibility | Visibility.              | <code>None</code> |
