<!-- Generated with Stardoc: http://skydoc.bazel.build -->

<a id="#nodejs_binary"></a>

## nodejs_binary

<pre>
nodejs_binary(<a href="#nodejs_binary-name">name</a>, <a href="#nodejs_binary-data">data</a>, <a href="#nodejs_binary-dep">dep</a>, <a href="#nodejs_binary-env">env</a>, <a href="#nodejs_binary-include_sources">include_sources</a>, <a href="#nodejs_binary-main">main</a>, <a href="#nodejs_binary-node_options">node_options</a>)
</pre>

Node.js binary

**ATTRIBUTES**

| Name                                                      | Description                    | Type                                                                                      | Mandatory | Default |
| :-------------------------------------------------------- | :----------------------------- | :---------------------------------------------------------------------------------------- | :-------- | :------ |
| <a id="nodejs_binary-name"></a>name                       | A unique name for this target. | <a href="https://bazel.build/docs/build-ref.html#name">Name</a>                           | required  |         |
| <a id="nodejs_binary-data"></a>data                       | Runtime data                   | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a>               | optional  | []      |
| <a id="nodejs_binary-dep"></a>dep                         | -                              | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a>                        | required  |         |
| <a id="nodejs_binary-env"></a>env                         | Environment variables          | <a href="https://bazel.build/docs/skylark/lib/dict.html">Dictionary: String -> String</a> | optional  | {}      |
| <a id="nodejs_binary-include_sources"></a>include_sources | -                              | Boolean                                                                                   | optional  | True    |
| <a id="nodejs_binary-main"></a>main                       | -                              | String                                                                                    | optional  | ""      |
| <a id="nodejs_binary-node_options"></a>node_options       | -                              | List of strings                                                                           | optional  | []      |

<a id="#nodejs_simple_binary"></a>

## nodejs_simple_binary

<pre>
nodejs_simple_binary(<a href="#nodejs_simple_binary-name">name</a>, <a href="#nodejs_simple_binary-src">src</a>)
</pre>

Node.js executable, from a single bundled file

**ATTRIBUTES**

| Name                                       | Description                    | Type                                                               | Mandatory | Default |
| :----------------------------------------- | :----------------------------- | :----------------------------------------------------------------- | :-------- | :------ |
| <a id="nodejs_simple_binary-name"></a>name | A unique name for this target. | <a href="https://bazel.build/docs/build-ref.html#name">Name</a>    | required  |         |
| <a id="nodejs_simple_binary-src"></a>src   | Source file                    | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | required  |         |