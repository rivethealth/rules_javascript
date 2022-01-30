<!-- Generated with Stardoc: http://skydoc.bazel.build -->

<a id="#jest_test"></a>

## jest_test

<pre>
jest_test(<a href="#jest_test-name">name</a>, <a href="#jest_test-config">config</a>, <a href="#jest_test-data">data</a>, <a href="#jest_test-deps">deps</a>, <a href="#jest_test-env">env</a>, <a href="#jest_test-global_deps">global_deps</a>, <a href="#jest_test-jest">jest</a>, <a href="#jest_test-jest_haste_map">jest_haste_map</a>, <a href="#jest_test-node_options">node_options</a>)
</pre>

**ATTRIBUTES**

| Name                                                | Description                    | Type                                                                                      | Mandatory | Default |
| :-------------------------------------------------- | :----------------------------- | :---------------------------------------------------------------------------------------- | :-------- | :------ |
| <a id="jest_test-name"></a>name                     | A unique name for this target. | <a href="https://bazel.build/docs/build-ref.html#name">Name</a>                           | required  |         |
| <a id="jest_test-config"></a>config                 | Jest config file.              | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a>                        | required  |         |
| <a id="jest_test-data"></a>data                     | Runtime data.                  | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a>               | optional  | []      |
| <a id="jest_test-deps"></a>deps                     | Test dependencies.             | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a>               | optional  | []      |
| <a id="jest_test-env"></a>env                       | Environment variables.         | <a href="https://bazel.build/docs/skylark/lib/dict.html">Dictionary: String -> String</a> | optional  | {}      |
| <a id="jest_test-global_deps"></a>global_deps       | Global dependencies.           | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a>               | optional  | []      |
| <a id="jest_test-jest"></a>jest                     | Jest dependency.               | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a>                        | required  |         |
| <a id="jest_test-jest_haste_map"></a>jest_haste_map | Haste map.                     | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a>                        | required  |         |
| <a id="jest_test-node_options"></a>node_options     | -                              | List of strings                                                                           | optional  | []      |
