<!-- Generated with Stardoc: http://skydoc.bazel.build -->

<a id="#nodejs_toolchain"></a>

## nodejs_toolchain

<pre>
nodejs_toolchain(<a href="#nodejs_toolchain-name">name</a>, <a href="#nodejs_toolchain-nodejs">nodejs</a>)
</pre>



**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="nodejs_toolchain-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/docs/build-ref.html#name">Name</a> | required |  |
| <a id="nodejs_toolchain-nodejs"></a>nodejs |  A hermetically downloaded nodejs executable target for the target platform..   | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | required |  |


<a id="#NodeJsInfo"></a>

## NodeJsInfo

<pre>
NodeJsInfo(<a href="#NodeJsInfo-bin">bin</a>)
</pre>

Information about how to invoke the node executable.

**FIELDS**


| Name  | Description |
| :------------- | :------------- |
| <a id="NodeJsInfo-bin"></a>bin |  Node.js executable    |


