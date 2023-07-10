# Contents

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [//typescript:providers.bzl](#typescriptprovidersbzl)
  - [TsCompilerInfo](#tscompilerinfo)
  - [TsInfo](#tsinfo)
  - [create_ts_info](#create_ts_info)
  - [declaration_path](#declaration_path)
  - [is_declaration](#is_declaration)
  - [is_json](#is_json)
  - [js_path](#js_path)
  - [map_path](#map_path)
  - [module](#module)
  - [target](#target)
- [//typescript:rules.bzl](#typescriptrulesbzl)
  - [js_import_ts](#js_import_ts)
  - [ts_compiler](#ts_compiler)
  - [ts_export](#ts_export)
  - [ts_import](#ts_import)
  - [ts_library](#ts_library)
  - [configure_ts_compiler](#configure_ts_compiler)
- [//typescript:workspace.bzl](#typescriptworkspacebzl)
  - [ts_directory_npm_plugin](#ts_directory_npm_plugin)
  - [ts_npm_plugin](#ts_npm_plugin)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# //typescript:providers.bzl

<!-- Generated with Stardoc: http://skydoc.bazel.build -->

TypeScript helpers

<a id="TsCompilerInfo"></a>

## TsCompilerInfo

<pre>
TsCompilerInfo(<a href="#TsCompilerInfo-bin">bin</a>, <a href="#TsCompilerInfo-transpile_bin">transpile_bin</a>, <a href="#TsCompilerInfo-runtime_cjs">runtime_cjs</a>, <a href="#TsCompilerInfo-runtime_js">runtime_js</a>)
</pre>

TypeScript compiler

**FIELDS**

| Name                                                   | Description              |
| :----------------------------------------------------- | :----------------------- |
| <a id="TsCompilerInfo-bin"></a>bin                     | Compile executable.      |
| <a id="TsCompilerInfo-transpile_bin"></a>transpile_bin | JS transpile executable. |
| <a id="TsCompilerInfo-runtime_cjs"></a>runtime_cjs     | List of runtime CjsInfo. |
| <a id="TsCompilerInfo-runtime_js"></a>runtime_js       | Runtime files.           |

<a id="TsInfo"></a>

## TsInfo

<pre>
TsInfo(<a href="#TsInfo-transitive_files">transitive_files</a>)
</pre>

TypeScript

**FIELDS**

| Name                                                 | Description                                 |
| :--------------------------------------------------- | :------------------------------------------ |
| <a id="TsInfo-transitive_files"></a>transitive_files | Depset of files (descriptors, declarations) |

<a id="create_ts_info"></a>

## create_ts_info

<pre>
create_ts_info(<a href="#create_ts_info-cjs_root">cjs_root</a>, <a href="#create_ts_info-files">files</a>, <a href="#create_ts_info-deps">deps</a>)
</pre>

**PARAMETERS**

| Name                                         | Description               | Default Value   |
| :------------------------------------------- | :------------------------ | :-------------- |
| <a id="create_ts_info-cjs_root"></a>cjs_root | <p align="center"> - </p> | none            |
| <a id="create_ts_info-files"></a>files       | <p align="center"> - </p> | <code>[]</code> |
| <a id="create_ts_info-deps"></a>deps         | <p align="center"> - </p> | <code>[]</code> |

<a id="declaration_path"></a>

## declaration_path

<pre>
declaration_path(<a href="#declaration_path-path">path</a>)
</pre>

**PARAMETERS**

| Name                                   | Description               | Default Value |
| :------------------------------------- | :------------------------ | :------------ |
| <a id="declaration_path-path"></a>path | <p align="center"> - </p> | none          |

<a id="is_declaration"></a>

## is_declaration

<pre>
is_declaration(<a href="#is_declaration-path">path</a>)
</pre>

**PARAMETERS**

| Name                                 | Description               | Default Value |
| :----------------------------------- | :------------------------ | :------------ |
| <a id="is_declaration-path"></a>path | <p align="center"> - </p> | none          |

<a id="is_json"></a>

## is_json

<pre>
is_json(<a href="#is_json-path">path</a>)
</pre>

**PARAMETERS**

| Name                          | Description               | Default Value |
| :---------------------------- | :------------------------ | :------------ |
| <a id="is_json-path"></a>path | <p align="center"> - </p> | none          |

<a id="js_path"></a>

## js_path

<pre>
js_path(<a href="#js_path-path">path</a>, <a href="#js_path-jsx">jsx</a>)
</pre>

**PARAMETERS**

| Name                          | Description               | Default Value        |
| :---------------------------- | :------------------------ | :------------------- |
| <a id="js_path-path"></a>path | <p align="center"> - </p> | none                 |
| <a id="js_path-jsx"></a>jsx   | <p align="center"> - </p> | <code>"react"</code> |

<a id="map_path"></a>

## map_path

<pre>
map_path(<a href="#map_path-path">path</a>)
</pre>

**PARAMETERS**

| Name                           | Description               | Default Value |
| :----------------------------- | :------------------------ | :------------ |
| <a id="map_path-path"></a>path | <p align="center"> - </p> | none          |

<a id="module"></a>

## module

<pre>
module(<a href="#module-module">module</a>)
</pre>

**PARAMETERS**

| Name                             | Description               | Default Value |
| :------------------------------- | :------------------------ | :------------ |
| <a id="module-module"></a>module | <p align="center"> - </p> | none          |

<a id="target"></a>

## target

<pre>
target(<a href="#target-language">language</a>)
</pre>

**PARAMETERS**

| Name                                 | Description               | Default Value |
| :----------------------------------- | :------------------------ | :------------ |
| <a id="target-language"></a>language | <p align="center"> - </p> | none          |

# //typescript:rules.bzl

<!-- Generated with Stardoc: http://skydoc.bazel.build -->

TypeScript rules

<a id="js_import_ts"></a>

## js_import_ts

<pre>
js_import_ts(<a href="#js_import_ts-name">name</a>, <a href="#js_import_ts-dep">dep</a>)
</pre>

Use TS as JS.

**ATTRIBUTES**

| Name                               | Description                    | Type                                                                | Mandatory | Default |
| :--------------------------------- | :----------------------------- | :------------------------------------------------------------------ | :-------- | :------ |
| <a id="js_import_ts-name"></a>name | A unique name for this target. | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required  |         |
| <a id="js_import_ts-dep"></a>dep   | -                              | <a href="https://bazel.build/concepts/labels">Label</a>             | required  |         |

<a id="ts_compiler"></a>

## ts_compiler

<pre>
ts_compiler(<a href="#ts_compiler-name">name</a>, <a href="#ts_compiler-bin">bin</a>, <a href="#ts_compiler-runtime">runtime</a>, <a href="#ts_compiler-transpile_bin">transpile_bin</a>)
</pre>

**ATTRIBUTES**

| Name                                                | Description                      | Type                                                                | Mandatory | Default           |
| :-------------------------------------------------- | :------------------------------- | :------------------------------------------------------------------ | :-------- | :---------------- |
| <a id="ts_compiler-name"></a>name                   | A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required  |                   |
| <a id="ts_compiler-bin"></a>bin                     | Declaration compiler executable. | <a href="https://bazel.build/concepts/labels">Label</a>             | required  |                   |
| <a id="ts_compiler-runtime"></a>runtime             | Runtime library.                 | <a href="https://bazel.build/concepts/labels">Label</a>             | optional  | <code>None</code> |
| <a id="ts_compiler-transpile_bin"></a>transpile_bin | JS compiler executable.          | <a href="https://bazel.build/concepts/labels">Label</a>             | required  |                   |

<a id="ts_export"></a>

## ts_export

<pre>
ts_export(<a href="#ts_export-name">name</a>, <a href="#ts_export-dep">dep</a>, <a href="#ts_export-deps">deps</a>, <a href="#ts_export-extra_deps">extra_deps</a>, <a href="#ts_export-global_deps">global_deps</a>, <a href="#ts_export-package_name">package_name</a>)
</pre>

Add dependencies, or use alias.

**ATTRIBUTES**

| Name                                            | Description                               | Type                                                                | Mandatory | Default         |
| :---------------------------------------------- | :---------------------------------------- | :------------------------------------------------------------------ | :-------- | :-------------- |
| <a id="ts_export-name"></a>name                 | A unique name for this target.            | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required  |                 |
| <a id="ts_export-dep"></a>dep                   | JavaScript library.                       | <a href="https://bazel.build/concepts/labels">Label</a>             | required  |                 |
| <a id="ts_export-deps"></a>deps                 | Dependencies to add.                      | <a href="https://bazel.build/concepts/labels">List of labels</a>    | optional  | <code>[]</code> |
| <a id="ts_export-extra_deps"></a>extra_deps     | Extra dependencies to add.                | <a href="https://bazel.build/concepts/labels">List of labels</a>    | optional  | <code>[]</code> |
| <a id="ts_export-global_deps"></a>global_deps   | Global dependencies to add.               | <a href="https://bazel.build/concepts/labels">List of labels</a>    | optional  | <code>[]</code> |
| <a id="ts_export-package_name"></a>package_name | Dependency name. Defaults to root's name. | String                                                              | optional  | <code>""</code> |

<a id="ts_import"></a>

## ts_import

<pre>
ts_import(<a href="#ts_import-name">name</a>, <a href="#ts_import-compile_deps">compile_deps</a>, <a href="#ts_import-declarations">declarations</a>, <a href="#ts_import-deps">deps</a>, <a href="#ts_import-js">js</a>, <a href="#ts_import-js_prefix">js_prefix</a>, <a href="#ts_import-root">root</a>)
</pre>

TypeScript library with pre-existing declaration files.

**ATTRIBUTES**

| Name                                            | Description                        | Type                                                                | Mandatory | Default           |
| :---------------------------------------------- | :--------------------------------- | :------------------------------------------------------------------ | :-------- | :---------------- |
| <a id="ts_import-name"></a>name                 | A unique name for this target.     | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required  |                   |
| <a id="ts_import-compile_deps"></a>compile_deps | Compile-only dependencies.         | <a href="https://bazel.build/concepts/labels">List of labels</a>    | optional  | <code>[]</code>   |
| <a id="ts_import-declarations"></a>declarations | Typescript declarations            | <a href="https://bazel.build/concepts/labels">List of labels</a>    | optional  | <code>[]</code>   |
| <a id="ts_import-deps"></a>deps                 | Dependencies                       | <a href="https://bazel.build/concepts/labels">List of labels</a>    | optional  | <code>[]</code>   |
| <a id="ts_import-js"></a>js                     | JavaScript                         | <a href="https://bazel.build/concepts/labels">List of labels</a>    | optional  | <code>[]</code>   |
| <a id="ts_import-js_prefix"></a>js_prefix       | Prefix to add to JavaScript files. | String                                                              | optional  | <code>""</code>   |
| <a id="ts_import-root"></a>root                 | CommonJS root                      | <a href="https://bazel.build/concepts/labels">Label</a>             | optional  | <code>None</code> |

<a id="ts_library"></a>

## ts_library

<pre>
ts_library(<a href="#ts_library-name">name</a>, <a href="#ts_library-compile_deps">compile_deps</a>, <a href="#ts_library-compiler">compiler</a>, <a href="#ts_library-config">config</a>, <a href="#ts_library-config_dep">config_dep</a>, <a href="#ts_library-data">data</a>, <a href="#ts_library-declaration_prefix">declaration_prefix</a>, <a href="#ts_library-deps">deps</a>,
           <a href="#ts_library-js_prefix">js_prefix</a>, <a href="#ts_library-jsx">jsx</a>, <a href="#ts_library-module">module</a>, <a href="#ts_library-root">root</a>, <a href="#ts_library-srcs">srcs</a>, <a href="#ts_library-strip_prefix">strip_prefix</a>, <a href="#ts_library-target">target</a>)
</pre>

TypeScript library.

**ATTRIBUTES**

| Name                                                         | Description                                                                                                   | Type                                                                | Mandatory | Default              |
| :----------------------------------------------------------- | :------------------------------------------------------------------------------------------------------------ | :------------------------------------------------------------------ | :-------- | :------------------- |
| <a id="ts_library-name"></a>name                             | A unique name for this target.                                                                                | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required  |                      |
| <a id="ts_library-compile_deps"></a>compile_deps             | Compile-only dependencies.                                                                                    | <a href="https://bazel.build/concepts/labels">List of labels</a>    | optional  | <code>[]</code>      |
| <a id="ts_library-compiler"></a>compiler                     | Compiler.                                                                                                     | <a href="https://bazel.build/concepts/labels">Label</a>             | optional  | <code>:tsc</code>    |
| <a id="ts_library-config"></a>config                         | Tsconfig path.                                                                                                | String                                                              | optional  | <code>""</code>      |
| <a id="ts_library-config_dep"></a>config_dep                 | Tsconfig dependency.                                                                                          | <a href="https://bazel.build/concepts/labels">Label</a>             | optional  | <code>None</code>    |
| <a id="ts_library-data"></a>data                             | Runfile files. These are added to normal runfiles tree, not CommonJS packages.                                | <a href="https://bazel.build/concepts/labels">List of labels</a>    | optional  | <code>[]</code>      |
| <a id="ts_library-declaration_prefix"></a>declaration_prefix | Declaration output directory.                                                                                 | String                                                              | optional  | <code>""</code>      |
| <a id="ts_library-deps"></a>deps                             | JS and TS dependencies                                                                                        | <a href="https://bazel.build/concepts/labels">List of labels</a>    | optional  | <code>[]</code>      |
| <a id="ts_library-js_prefix"></a>js_prefix                   | JavaScript output directory.                                                                                  | String                                                              | optional  | <code>""</code>      |
| <a id="ts_library-jsx"></a>jsx                               | How JSX is emitted: react (default) or preserve                                                               | String                                                              | optional  | <code>"react"</code> |
| <a id="ts_library-module"></a>module                         | Module type. By default, uses //javascript:module.                                                            | String                                                              | optional  | <code>""</code>      |
| <a id="ts_library-root"></a>root                             | CommonJS package root.                                                                                        | <a href="https://bazel.build/concepts/labels">Label</a>             | optional  | <code>None</code>    |
| <a id="ts_library-srcs"></a>srcs                             | TypeScript sources. If providing directories, the \*\_prefix attributes must be used to separate the outputs. | <a href="https://bazel.build/concepts/labels">List of labels</a>    | optional  | <code>[]</code>      |
| <a id="ts_library-strip_prefix"></a>strip_prefix             | Source root.                                                                                                  | String                                                              | optional  | <code>""</code>      |
| <a id="ts_library-target"></a>target                         | Target language. By default, uses //javascript:language.                                                      | String                                                              | optional  | <code>""</code>      |

<a id="configure_ts_compiler"></a>

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

# //typescript:workspace.bzl

<!-- Generated with Stardoc: http://skydoc.bazel.build -->

TypeScript repositories

<a id="ts_directory_npm_plugin"></a>

## ts_directory_npm_plugin

<pre>
ts_directory_npm_plugin()
</pre>

<a id="ts_npm_plugin"></a>

## ts_npm_plugin

<pre>
ts_npm_plugin(<a href="#ts_npm_plugin-exclude_suffixes">exclude_suffixes</a>)
</pre>

**PARAMETERS**

| Name                                                        | Description               | Default Value   |
| :---------------------------------------------------------- | :------------------------ | :-------------- |
| <a id="ts_npm_plugin-exclude_suffixes"></a>exclude_suffixes | <p align="center"> - </p> | <code>[]</code> |
