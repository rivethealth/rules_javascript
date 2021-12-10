<!-- Generated with Stardoc: http://skydoc.bazel.build -->

<a id="#SimpleTsCompilerInfo"></a>

## SimpleTsCompilerInfo

<pre>
SimpleTsCompilerInfo(<a href="#SimpleTsCompilerInfo-bin">bin</a>)
</pre>

TypeScript compiler

**FIELDS**

| Name                                     | Description |
| :--------------------------------------- | :---------- |
| <a id="SimpleTsCompilerInfo-bin"></a>bin | Executable  |

<a id="#TsCompilerInfo"></a>

## TsCompilerInfo

<pre>
TsCompilerInfo(<a href="#TsCompilerInfo-bin">bin</a>, <a href="#TsCompilerInfo-transpile_bin">transpile_bin</a>, <a href="#TsCompilerInfo-runtime">runtime</a>)
</pre>

TypeScript compiler

**FIELDS**

| Name                                                   | Description     |
| :----------------------------------------------------- | :-------------- |
| <a id="TsCompilerInfo-bin"></a>bin                     | Executable      |
| <a id="TsCompilerInfo-transpile_bin"></a>transpile_bin | Executable      |
| <a id="TsCompilerInfo-runtime"></a>runtime             | Runtime library |

<a id="#TsInfo"></a>

## TsInfo

<pre>
TsInfo(<a href="#TsInfo-name">name</a>, <a href="#TsInfo-package">package</a>, <a href="#TsInfo-transitive_deps">transitive_deps</a>, <a href="#TsInfo-transitive_declarations">transitive_declarations</a>, <a href="#TsInfo-transitive_descriptors">transitive_descriptors</a>,
       <a href="#TsInfo-transitive_packages">transitive_packages</a>)
</pre>

TypeScript

**FIELDS**

| Name                                                               | Description                            |
| :----------------------------------------------------------------- | :------------------------------------- |
| <a id="TsInfo-name"></a>name                                       | Pacakge name                           |
| <a id="TsInfo-package"></a>package                                 | CommonJS package                       |
| <a id="TsInfo-transitive_deps"></a>transitive_deps                 | Depset of extra links                  |
| <a id="TsInfo-transitive_declarations"></a>transitive_declarations | Depset of TypeScript declaration files |
| <a id="TsInfo-transitive_descriptors"></a>transitive_descriptors   | Depset of package descriptors          |
| <a id="TsInfo-transitive_packages"></a>transitive_packages         | Depset of packages                     |
