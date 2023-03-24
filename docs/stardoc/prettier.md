# Contents

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [//prettier:rules.bzl](#prettierrulesbzl)
  - [prettier](#prettier)
  - [configure_prettier](#configure_prettier)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# //prettier:rules.bzl

<!-- Generated with Stardoc: http://skydoc.bazel.build -->

<a id="prettier"></a>

## prettier

<pre>
prettier(<a href="#prettier-name">name</a>, <a href="#prettier-bin">bin</a>, <a href="#prettier-config">config</a>, <a href="#prettier-config_dep">config_dep</a>)
</pre>

**ATTRIBUTES**

| Name                                       | Description                    | Type                                                                | Mandatory | Default |
| :----------------------------------------- | :----------------------------- | :------------------------------------------------------------------ | :-------- | :------ |
| <a id="prettier-name"></a>name             | A unique name for this target. | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required  |         |
| <a id="prettier-bin"></a>bin               | Prettier                       | <a href="https://bazel.build/concepts/labels">Label</a>             | required  |         |
| <a id="prettier-config"></a>config         | -                              | String                                                              | required  |         |
| <a id="prettier-config_dep"></a>config_dep | Configuration file             | <a href="https://bazel.build/concepts/labels">Label</a>             | required  |         |

<a id="configure_prettier"></a>

## configure_prettier

<pre>
configure_prettier(<a href="#configure_prettier-name">name</a>, <a href="#configure_prettier-config">config</a>, <a href="#configure_prettier-config_dep">config_dep</a>, <a href="#configure_prettier-dep">dep</a>, <a href="#configure_prettier-plugins">plugins</a>, <a href="#configure_prettier-visibility">visibility</a>)
</pre>

**PARAMETERS**

| Name                                                 | Description               | Default Value                                                  |
| :--------------------------------------------------- | :------------------------ | :------------------------------------------------------------- |
| <a id="configure_prettier-name"></a>name             | <p align="center"> - </p> | none                                                           |
| <a id="configure_prettier-config"></a>config         | <p align="center"> - </p> | none                                                           |
| <a id="configure_prettier-config_dep"></a>config_dep | <p align="center"> - </p> | none                                                           |
| <a id="configure_prettier-dep"></a>dep               | <p align="center"> - </p> | <code>"@better_rules_javascript//prettier:prettier_lib"</code> |
| <a id="configure_prettier-plugins"></a>plugins       | <p align="center"> - </p> | <code>[]</code>                                                |
| <a id="configure_prettier-visibility"></a>visibility | <p align="center"> - </p> | <code>None</code>                                              |
