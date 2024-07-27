# TypeScript ESLint

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [//typescript-eslint:rules.bzl](#typescript-eslintrulesbzl)
  - [ts_eslint](#ts_eslint)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# //typescript-eslint:rules.bzl

<!-- Generated with Stardoc: http://skydoc.bazel.build -->

<a id="ts_eslint"></a>

## ts_eslint

<pre>
ts_eslint(<a href="#ts_eslint-name">name</a>, <a href="#ts_eslint-bin">bin</a>, <a href="#ts_eslint-config">config</a>, <a href="#ts_eslint-config_dep">config_dep</a>, <a href="#ts_eslint-srcs">srcs</a>, <a href="#ts_eslint-ts">ts</a>)
</pre>

TypeScript ESLint

**ATTRIBUTES**

| Name                                        | Description                    | Type                                                                | Mandatory | Default           |
| :------------------------------------------ | :----------------------------- | :------------------------------------------------------------------ | :-------- | :---------------- |
| <a id="ts_eslint-name"></a>name             | A unique name for this target. | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required  |                   |
| <a id="ts_eslint-bin"></a>bin               | eslint                         | <a href="https://bazel.build/concepts/labels">Label</a>             | required  |                   |
| <a id="ts_eslint-config"></a>config         | -                              | String                                                              | required  |                   |
| <a id="ts_eslint-config_dep"></a>config_dep | Configuration file             | <a href="https://bazel.build/concepts/labels">Label</a>             | required  |                   |
| <a id="ts_eslint-srcs"></a>srcs             | Sources                        | <a href="https://bazel.build/concepts/labels">Label</a>             | optional  | <code>None</code> |
| <a id="ts_eslint-ts"></a>ts                 | TypeScript compilation         | <a href="https://bazel.build/concepts/labels">Label</a>             | required  |                   |
