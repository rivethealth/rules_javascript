# Contents

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [//jest:rules.bzl](#jestrulesbzl)
  - [jest_test](#jest_test)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# //jest:rules.bzl

<!-- Generated with Stardoc: http://skydoc.bazel.build -->

<a id="#jest_test"></a>

## jest_test

<pre>
jest_test(<a href="#jest_test-name">name</a>, <a href="#jest_test-bash_preamble">bash_preamble</a>, <a href="#jest_test-config">config</a>, <a href="#jest_test-config_dep">config_dep</a>, <a href="#jest_test-data">data</a>, <a href="#jest_test-dep">dep</a>, <a href="#jest_test-env">env</a>, <a href="#jest_test-jest">jest</a>, <a href="#jest_test-node">node</a>, <a href="#jest_test-node_options">node_options</a>)
</pre>

**ATTRIBUTES**

| Name                                              | Description                                       | Type                                                                                      | Mandatory | Default  |
| :------------------------------------------------ | :------------------------------------------------ | :---------------------------------------------------------------------------------------- | :-------- | :------- |
| <a id="jest_test-name"></a>name                   | A unique name for this target.                    | <a href="https://bazel.build/docs/build-ref.html#name">Name</a>                           | required  |          |
| <a id="jest_test-bash_preamble"></a>bash_preamble | -                                                 | String                                                                                    | optional  | ""       |
| <a id="jest_test-config"></a>config               | Path to config file, relative to config_dep root. | String                                                                                    | required  |          |
| <a id="jest_test-config_dep"></a>config_dep       | Jest config dependency.                           | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a>                        | required  |          |
| <a id="jest_test-data"></a>data                   | Runtime data.                                     | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a>               | optional  | []       |
| <a id="jest_test-dep"></a>dep                     | Test dependency.                                  | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a>                        | required  |          |
| <a id="jest_test-env"></a>env                     | Environment variables.                            | <a href="https://bazel.build/docs/skylark/lib/dict.html">Dictionary: String -> String</a> | optional  | {}       |
| <a id="jest_test-jest"></a>jest                   | Jest dependency.                                  | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a>                        | required  |          |
| <a id="jest_test-node"></a>node                   | -                                                 | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a>                        | optional  | //nodejs |
| <a id="jest_test-node_options"></a>node_options   | Node.js options.                                  | List of strings                                                                           | optional  | []       |
