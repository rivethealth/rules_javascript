<!-- Generated with Stardoc: http://skydoc.bazel.build -->

<a id="#yarn_resolve"></a>

## yarn_resolve

<pre>
yarn_resolve(<a href="#yarn_resolve-name">name</a>, <a href="#yarn_resolve-output">output</a>, <a href="#yarn_resolve-path">path</a>, <a href="#yarn_resolve-refresh">refresh</a>)
</pre>

**ATTRIBUTES**

| Name                                     | Description                                                               | Type                                                            | Mandatory | Default        |
| :--------------------------------------- | :------------------------------------------------------------------------ | :-------------------------------------------------------------- | :-------- | :------------- |
| <a id="yarn_resolve-name"></a>name       | A unique name for this target.                                            | <a href="https://bazel.build/docs/build-ref.html#name">Name</a> | required  |                |
| <a id="yarn_resolve-output"></a>output   | Starlark output path, relative to repository root                         | String                                                          | optional  | "npm_data.bzl" |
| <a id="yarn_resolve-path"></a>path       | Path to package.json and yarn.lock directory, relative to repository root | String                                                          | optional  | "."            |
| <a id="yarn_resolve-refresh"></a>refresh | Whether to refresh                                                        | Boolean                                                         | optional  | True           |
