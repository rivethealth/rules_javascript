# Module Resolution

Module resolution is a common challenge of JavaScript tooling. This is
especially true when working with Bazel which is opinionated about file layout
and access.

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Solution](#solution)
- [Background](#background)
- [Approaches](#approaches)
- [File layout](#file-layout)
- [Resolution APIs](#resolution-apis)
- [Package managers](#package-managers)
- [Virtual file system](#virtual-file-system)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Solution

better_rules_javascript adopts a different approach depending on the
runtime/tool.

- Node.js CommonJS: Override Module.\_resolveFilename
- Node.js ES: Use the experimental
  [ESM loader hooks](https://nodejs.org/api/esm.html#loaders)
- Other Node.js-based tools: shims the `fs` module, synthesizing a node_modules
  directory with symlinks and dereferencing other symlinks.

This provides flexibility, performance, and consistency for a reasonable
overhead of complexity.

## Background

Module resolution is difficult:

1. Resolution is relative to the current module. I.e. the same specifier
   resolves differently from different modules.
2. There are a variety of algorithms: Node.js CommonJS, Node.js ES, Webpack,
   Bable, TypeScript.
3. Package resolution algorithms are complex, and often involve interpreting
   package.json imports, exports, etc.
4. Often, the number input files is very large; tens of thousands of files is
   common.

## Approaches

## File layout

Layout files to match the Node.js module resolution algorithm.

### Symlinks

The simplest, most consistent Node.js package layout is described in
[Node.js Package manager tips](https://nodejs.org/api/modules.html#modules_package_manager_tips).
Packages are arranged arbitrarily, and each has a `node_modules` directory with
symlinks to dependencies.

```
# bar@2.1.5 depends on foo@2.0.1
/
    foo_2_0_1/
        package.json
        index.js
    bar_2_1_5/
        package.json
        index.js
        node_modules/
            foo -> ../../foo_2_0_1
```

This runs into several problems:

1. Bazel uses symlinks for runfiles, so Node.js will be resolving file locations
   outside the runfile tree, damaging hermeticity.
2. Global dependencies (like plugins) are awkward to support. NODE_PATH can
   help, but doesn't work for ESM modules.
3. "Dangling" symlinks are
   [not well supported](https://github.com/bazelbuild/bazel/issues/10298) in
   Bazel.

### Directories

Dangling symlinks can be avoided by building a directory for an entire package.
However, this limits the flexibility of package construction.

For example, you may want tests in the same package, but downstream dependencies
shouldn't need to actually build those tests.

### Hoisting

Alternatively, prevent Node.js from resolving symlinks with
`--preserve-symlinks`. Packages would be hoisted to the various levels within
the nested node_modules tree. This is the approach followed by npm and yarn.
However, hoisting is notoriously difficult.

## Resolution APIs

Override module resolution.

### Yarn PnP

Plug'n'Play is a populate package resolution API. To be precise, it does not
itself resolve module, but rather resolves "packages" to directories. It has
broad support, natively or via tool plugins.

Unfortunately, Yarn plugins currently have several issues, and generally do not
use `findPnpApi`, for multi-root dependency trees (e.g. a compiler with a
different dependency tree than the inputs).

Additionally, the Node.js support relies on PnP internals, not the API.

### Custom resolution

Most tools have APIs to customize module resolution. However, supporting each
one complex and error-prone.

## Package managers

Package managers (npm, Yarn) can install files. (This is the approach
`rules_nodejs` takes.) However, these aren't well positioned to take part in the
Bazel ecosystem and create an odd internal-vs-external library distinction that
isn't composable like other Bazel rulesets are.

## Virtual file system

A virtual file system can transparently locate files without interfering with
symlink usage.

This requires postprocessing source maps, error messages, etc. if actual file
names are desired.

### DDL interception

This is platform specific and difficult.

### Monkey-patching

Shim the `fs` module (or `process.binding('fs')`). However, a lot of Node.js
module loading internals are
[deliberately](https://github.com/nodejs/node/pull/39513#pullrequestreview-714334718)
written in such a way they cannot be monkey-patched.
