# ESLint

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [//eslint:rules.bzl](#eslintrulesbzl)
  - [eslint](#eslint)
  - [configure_eslint](#configure_eslint)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# //eslint:rules.bzl

<!-- Generated with Stardoc: http://skydoc.bazel.build -->

<a id="eslint"></a>

## eslint

<pre>
eslint(<a href="#eslint-name">name</a>, <a href="#eslint-bin">bin</a>, <a href="#eslint-config">config</a>, <a href="#eslint-config_dep">config_dep</a>)
</pre>

**ATTRIBUTES**

| Name                                     | Description                    | Type                                                                | Mandatory | Default |
| :--------------------------------------- | :----------------------------- | :------------------------------------------------------------------ | :-------- | :------ |
| <a id="eslint-name"></a>name             | A unique name for this target. | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required  |         |
| <a id="eslint-bin"></a>bin               | eslint                         | <a href="https://bazel.build/concepts/labels">Label</a>             | required  |         |
| <a id="eslint-config"></a>config         | -                              | String                                                              | required  |         |
| <a id="eslint-config_dep"></a>config_dep | Configuration file             | <a href="https://bazel.build/concepts/labels">Label</a>             | required  |         |

<a id="configure_eslint"></a>

## configure_eslint

<pre>
configure_eslint(<a href="#configure_eslint-name">name</a>, <a href="#configure_eslint-config">config</a>, <a href="#configure_eslint-config_dep">config_dep</a>, <a href="#configure_eslint-dep">dep</a>, <a href="#configure_eslint-plugins">plugins</a>, <a href="#configure_eslint-visibility">visibility</a>)
</pre>

**PARAMETERS**

| Name                                               | Description               | Default Value                                              |
| :------------------------------------------------- | :------------------------ | :--------------------------------------------------------- |
| <a id="configure_eslint-name"></a>name             | <p align="center"> - </p> | none                                                       |
| <a id="configure_eslint-config"></a>config         | <p align="center"> - </p> | none                                                       |
| <a id="configure_eslint-config_dep"></a>config_dep | <p align="center"> - </p> | none                                                       |
| <a id="configure_eslint-dep"></a>dep               | <p align="center"> - </p> | <code>"@better_rules_javascript//eslint:eslint_lib"</code> |
| <a id="configure_eslint-plugins"></a>plugins       | <p align="center"> - </p> | <code>[]</code>                                            |
| <a id="configure_eslint-visibility"></a>visibility | <p align="center"> - </p> | <code>None</code>                                          |
