<!-- Generated with Stardoc: http://skydoc.bazel.build -->

<a id="#js_library"></a>

## js_library

<pre>
js_library(<a href="#js_library-name">name</a>, <a href="#js_library-deps">deps</a>, <a href="#js_library-extra_deps">extra_deps</a>, <a href="#js_library-prefix">prefix</a>, <a href="#js_library-root">root</a>, <a href="#js_library-srcs">srcs</a>, <a href="#js_library-strip_prefix">strip_prefix</a>)
</pre>

JavaScript library

**ATTRIBUTES**

| Name                                             | Description                                                                          | Type                                                                                      | Mandatory | Default |
| :----------------------------------------------- | :----------------------------------------------------------------------------------- | :---------------------------------------------------------------------------------------- | :-------- | :------ |
| <a id="js_library-name"></a>name                 | A unique name for this target.                                                       | <a href="https://bazel.build/docs/build-ref.html#name">Name</a>                           | required  |         |
| <a id="js_library-deps"></a>deps                 | Dependencies.                                                                        | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a>               | optional  | []      |
| <a id="js_library-extra_deps"></a>extra_deps     | Extra dependencies.                                                                  | <a href="https://bazel.build/docs/skylark/lib/dict.html">Dictionary: String -> String</a> | optional  | {}      |
| <a id="js_library-prefix"></a>prefix             | Prefix to add. Defaults to empty.                                                    | String                                                                                    | optional  | ""      |
| <a id="js_library-root"></a>root                 | -                                                                                    | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a>                        | required  |         |
| <a id="js_library-srcs"></a>srcs                 | JavaScript files and data.                                                           | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a>               | optional  | []      |
| <a id="js_library-strip_prefix"></a>strip_prefix | Remove prefix, based on runfile path. Defaults to &lt;workspace&gt;/&lt;package&gt;. | String                                                                                    | optional  | ""      |
