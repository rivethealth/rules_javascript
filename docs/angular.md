# Angular

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [//angular:providers.bzl](#angularprovidersbzl)
  - [AngularCompilerInfo](#angularcompilerinfo)
  - [resource_path](#resource_path)
- [//angular:rules.bzl](#angularrulesbzl)
  - [angular_compiler](#angular_compiler)
  - [angular_library](#angular_library)
  - [configure_angular_compiler](#configure_angular_compiler)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# //angular:providers.bzl

<!-- Generated with Stardoc: http://skydoc.bazel.build -->

Angular Providers

<a id="AngularCompilerInfo"></a>

## AngularCompilerInfo

<pre>
AngularCompilerInfo(<a href="#AngularCompilerInfo-bin">bin</a>, <a href="#AngularCompilerInfo-cjs_deps">cjs_deps</a>, <a href="#AngularCompilerInfo-js_deps">js_deps</a>, <a href="#AngularCompilerInfo-ts_deps">ts_deps</a>, <a href="#AngularCompilerInfo-js_compiler">js_compiler</a>, <a href="#AngularCompilerInfo-resource_compiler">resource_compiler</a>, <a href="#AngularCompilerInfo-tsc_bin">tsc_bin</a>)
</pre>

Angular compiler

**FIELDS**

| Name                                                                | Description         |
| :------------------------------------------------------------------ | :------------------ |
| <a id="AngularCompilerInfo-bin"></a>bin                             | Executable          |
| <a id="AngularCompilerInfo-cjs_deps"></a>cjs_deps                   | CommonJS deps       |
| <a id="AngularCompilerInfo-js_deps"></a>js_deps                     | JS deps             |
| <a id="AngularCompilerInfo-ts_deps"></a>ts_deps                     | TS deps             |
| <a id="AngularCompilerInfo-js_compiler"></a>js_compiler             | Executable          |
| <a id="AngularCompilerInfo-resource_compiler"></a>resource_compiler | Resource compiler   |
| <a id="AngularCompilerInfo-tsc_bin"></a>tsc_bin                     | TypeScript compiler |

<a id="resource_path"></a>

## resource_path

<pre>
resource_path(<a href="#resource_path-path">path</a>)
</pre>

**PARAMETERS**

| Name                                | Description               | Default Value |
| :---------------------------------- | :------------------------ | :------------ |
| <a id="resource_path-path"></a>path | <p align="center"> - </p> | none          |

# //angular:rules.bzl

<!-- Generated with Stardoc: http://skydoc.bazel.build -->

<a id="angular_compiler"></a>

## angular_compiler

<pre>
angular_compiler(<a href="#angular_compiler-name">name</a>, <a href="#angular_compiler-bin">bin</a>, <a href="#angular_compiler-js_compiler">js_compiler</a>, <a href="#angular_compiler-lib">lib</a>, <a href="#angular_compiler-resource_compiler">resource_compiler</a>, <a href="#angular_compiler-tsc_bin">tsc_bin</a>)
</pre>

**ATTRIBUTES**

| Name                                                             | Description                    | Type                                                                | Mandatory | Default                                      |
| :--------------------------------------------------------------- | :----------------------------- | :------------------------------------------------------------------ | :-------- | :------------------------------------------- |
| <a id="angular_compiler-name"></a>name                           | A unique name for this target. | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required  |                                              |
| <a id="angular_compiler-bin"></a>bin                             | -                              | <a href="https://bazel.build/concepts/labels">Label</a>             | required  |                                              |
| <a id="angular_compiler-js_compiler"></a>js_compiler             | -                              | <a href="https://bazel.build/concepts/labels">Label</a>             | required  |                                              |
| <a id="angular_compiler-lib"></a>lib                             | -                              | <a href="https://bazel.build/concepts/labels">List of labels</a>    | required  |                                              |
| <a id="angular_compiler-resource_compiler"></a>resource_compiler | -                              | <a href="https://bazel.build/concepts/labels">Label</a>             | optional  | <code>//angular/resource-compiler:bin</code> |
| <a id="angular_compiler-tsc_bin"></a>tsc_bin                     | -                              | <a href="https://bazel.build/concepts/labels">Label</a>             | required  |                                              |

<a id="angular_library"></a>

## angular_library

<pre>
angular_library(<a href="#angular_library-name">name</a>, <a href="#angular_library-compiler">compiler</a>, <a href="#angular_library-config">config</a>, <a href="#angular_library-config_dep">config_dep</a>, <a href="#angular_library-declaration_prefix">declaration_prefix</a>, <a href="#angular_library-deps">deps</a>, <a href="#angular_library-extra_deps">extra_deps</a>, <a href="#angular_library-js_prefix">js_prefix</a>,
                <a href="#angular_library-jsx">jsx</a>, <a href="#angular_library-resources">resources</a>, <a href="#angular_library-root">root</a>, <a href="#angular_library-src_prefix">src_prefix</a>, <a href="#angular_library-srcs">srcs</a>, <a href="#angular_library-strip_prefix">strip_prefix</a>)
</pre>

**ATTRIBUTES**

| Name                                                              | Description                                               | Type                                                                          | Mandatory | Default              |
| :---------------------------------------------------------------- | :-------------------------------------------------------- | :---------------------------------------------------------------------------- | :-------- | :------------------- |
| <a id="angular_library-name"></a>name                             | A unique name for this target.                            | <a href="https://bazel.build/concepts/labels#target-names">Name</a>           | required  |                      |
| <a id="angular_library-compiler"></a>compiler                     | Angular compiler.                                         | <a href="https://bazel.build/concepts/labels">Label</a>                       | required  |                      |
| <a id="angular_library-config"></a>config                         | -                                                         | String                                                                        | optional  | <code>""</code>      |
| <a id="angular_library-config_dep"></a>config_dep                 | Tsconfig.                                                 | <a href="https://bazel.build/concepts/labels">Label</a>                       | optional  | <code>None</code>    |
| <a id="angular_library-declaration_prefix"></a>declaration_prefix | Prepend path to TypeScript declarations.                  | String                                                                        | optional  | <code>""</code>      |
| <a id="angular_library-deps"></a>deps                             | Dependencies.                                             | <a href="https://bazel.build/concepts/labels">List of labels</a>              | optional  | <code>[]</code>      |
| <a id="angular_library-extra_deps"></a>extra_deps                 | Extra dependencies.                                       | <a href="https://bazel.build/rules/lib/dict">Dictionary: String -> String</a> | optional  | <code>{}</code>      |
| <a id="angular_library-js_prefix"></a>js_prefix                   | Prepend path to JavaScript.                               | String                                                                        | optional  | <code>""</code>      |
| <a id="angular_library-jsx"></a>jsx                               | How JSX is emitted: react (default) or preserve           | String                                                                        | optional  | <code>"react"</code> |
| <a id="angular_library-resources"></a>resources                   | Style and template files.                                 | <a href="https://bazel.build/concepts/labels">List of labels</a>              | optional  | <code>[]</code>      |
| <a id="angular_library-root"></a>root                             | CommonJS root                                             | <a href="https://bazel.build/concepts/labels">Label</a>                       | required  |                      |
| <a id="angular_library-src_prefix"></a>src_prefix                 | Prepend path to TypeScript sources and Angular resources. | String                                                                        | optional  | <code>""</code>      |
| <a id="angular_library-srcs"></a>srcs                             | TypeScript sources.                                       | <a href="https://bazel.build/concepts/labels">List of labels</a>              | required  |                      |
| <a id="angular_library-strip_prefix"></a>strip_prefix             | Root directory (relative to runfile)                      | String                                                                        | optional  | <code>""</code>      |

<a id="configure_angular_compiler"></a>

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
