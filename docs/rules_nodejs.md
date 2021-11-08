# Differences with rules_nodejs

<!-- DOCTOC SKIP -->

rules_nodejs are commonly used Bazel rules for Javascript. There are a number of
non-trivial difference between that project and this one.

- The npm dependency graph is still resolved by an external package manager, but
  downloaded and managed entirely by Bazel. This is an idiomatic Bazel approach,
  e.g. rules_jvm_external.
- There is no special treatment of node module dependencies. Rather, everything
  uses the same rules (e.g. js_library).
- Typescript support is separate, in rules_javascript.
