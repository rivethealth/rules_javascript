<!-- Generated with Stardoc: http://skydoc.bazel.build -->

<a id="#js_import_external"></a>

## js_import_external

<pre>
js_import_external(<a href="#js_import_external-name">name</a>, <a href="#js_import_external-package">package</a>, <a href="#js_import_external-sha256">sha256</a>, <a href="#js_import_external-src">src</a>)
</pre>



**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="js_import_external-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/docs/build-ref.html#name">Name</a> | required |  |
| <a id="js_import_external-package"></a>package |  package.json   | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | optional | None |
| <a id="js_import_external-sha256"></a>sha256 |  SHA256 digest   | String | optional | "" |
| <a id="js_import_external-src"></a>src |  -   | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | optional | @better_rules_javascript//rules/npm:BUILD.bazel.tpl |


