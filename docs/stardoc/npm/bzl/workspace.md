<!-- Generated with Stardoc: http://skydoc.bazel.build -->

<a id="#js_import_external"></a>

## js_import_external

<pre>
js_import_external(<a href="#js_import_external-name">name</a>, <a href="#js_import_external-deps">deps</a>, <a href="#js_import_external-exclude">exclude</a>, <a href="#js_import_external-include">include</a>, <a href="#js_import_external-integrity">integrity</a>, <a href="#js_import_external-repo_mapping">repo_mapping</a>, <a href="#js_import_external-urls">urls</a>)
</pre>



**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="js_import_external-name"></a>name |  A unique name for this repository.   | <a href="https://bazel.build/docs/build-ref.html#name">Name</a> | required |  |
| <a id="js_import_external-deps"></a>deps |  Dependencies   | List of strings | optional | [] |
| <a id="js_import_external-exclude"></a>exclude |  Exclude patterns   | List of strings | optional | [] |
| <a id="js_import_external-include"></a>include |  Include patterns   | List of strings | optional | ["**/*.js", "**/*.json"] |
| <a id="js_import_external-integrity"></a>integrity |  Integrity   | String | optional | "" |
| <a id="js_import_external-repo_mapping"></a>repo_mapping |  A dictionary from local repository name to global repository name. This allows controls over workspace dependency resolution for dependencies of this repository.&lt;p&gt;For example, an entry <code>"@foo": "@bar"</code> declares that, for any time this repository depends on <code>@foo</code> (such as a dependency on <code>@foo//some:target</code>, it should actually resolve that dependency within globally-declared <code>@bar</code> (<code>@bar//some:target</code>).   | <a href="https://bazel.build/docs/skylark/lib/dict.html">Dictionary: String -> String</a> | required |  |
| <a id="js_import_external-urls"></a>urls |  URLs   | List of strings | required |  |


<a id="#js_import_npm"></a>

## js_import_npm

<pre>
js_import_npm(<a href="#js_import_npm-name">name</a>, <a href="#js_import_npm-packages">packages</a>, <a href="#js_import_npm-repo_mapping">repo_mapping</a>)
</pre>



**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="js_import_npm-name"></a>name |  A unique name for this repository.   | <a href="https://bazel.build/docs/build-ref.html#name">Name</a> | required |  |
| <a id="js_import_npm-packages"></a>packages |  Packages   | <a href="https://bazel.build/docs/skylark/lib/dict.html">Dictionary: String -> String</a> | optional | {} |
| <a id="js_import_npm-repo_mapping"></a>repo_mapping |  A dictionary from local repository name to global repository name. This allows controls over workspace dependency resolution for dependencies of this repository.&lt;p&gt;For example, an entry <code>"@foo": "@bar"</code> declares that, for any time this repository depends on <code>@foo</code> (such as a dependency on <code>@foo//some:target</code>, it should actually resolve that dependency within globally-declared <code>@bar</code> (<code>@bar//some:target</code>).   | <a href="https://bazel.build/docs/skylark/lib/dict.html">Dictionary: String -> String</a> | required |  |


<a id="#npm"></a>

## npm

<pre>
npm(<a href="#npm-name">name</a>, <a href="#npm-packages">packages</a>, <a href="#npm-roots">roots</a>)
</pre>



**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="npm-name"></a>name |  <p align="center"> - </p>   |  none |
| <a id="npm-packages"></a>packages |  <p align="center"> - </p>   |  none |
| <a id="npm-roots"></a>roots |  <p align="center"> - </p>   |  none |


<a id="#npm_package"></a>

## npm_package

<pre>
npm_package(<a href="#npm_package-name">name</a>, <a href="#npm_package-package">package</a>)
</pre>



**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="npm_package-name"></a>name |  <p align="center"> - </p>   |  none |
| <a id="npm_package-package"></a>package |  <p align="center"> - </p>   |  none |


<a id="#npm_roots"></a>

## npm_roots

<pre>
npm_roots(<a href="#npm_roots-name">name</a>, <a href="#npm_roots-roots">roots</a>)
</pre>



**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="npm_roots-name"></a>name |  <p align="center"> - </p>   |  none |
| <a id="npm_roots-roots"></a>roots |  <p align="center"> - </p>   |  none |


<a id="#package_repo_name"></a>

## package_repo_name

<pre>
package_repo_name(<a href="#package_repo_name-name">name</a>)
</pre>



**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="package_repo_name-name"></a>name |  <p align="center"> - </p>   |  none |


<a id="#repositories"></a>

## repositories

<pre>
repositories()
</pre>





