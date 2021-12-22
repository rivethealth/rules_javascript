# Module resolution

Perhaps the most difficult part of JavaScript tooling is resolving modules.

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Background](#background)
- [File layout](#file-layout)
- [Resolution APIs](#resolution-apis)
- [Package managers](#package-managers)
- [Virtual file system](#virtual-file-system)
- [Solution](#solution)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

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

## File layout

### Symlinks

The simplest way to arrange Node.js modules is as described in
[Node.js Package manager tips](https://nodejs.org/api/modules.html#modules_package_manager_tips)
so that each package as siblings, with symlinks to dependencies.

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

However, this approach gives important meaning to symlinks, thus precluding the
abililty to use symlinks for transparent file layout.

A minor concern Node.js would resolve the realpath and "escape" the runfile
tree, which -- without sandboxing (e.g. `bazel run`) -- could lead to pulling in
old files.

### Hoisting

Alternatively `--preserve-symlinks` could remove symlinks from module
resolution. Packages would be hoisted to the various levels within the nested
node_modules tree. However, hoisting is a notoriously difficult problem.

### Assemble packages

Instead of attempting to use files in their existing locations, move the files
to their package structure, and create node_modules symlinks.

Creating arbitrary symlinks requires `--experimental_allow_unresolved_symlinks`
and has outstanding bugs
[bazelbuild/bazel#10298](https://github.com/bazelbuild/bazel/issues/10298).

Symlinks must be created for the entire package. Assuming a package can consist
of multiple rules (e.g. TypeScript library plus TypeScript tests), that involves
duplication of dependency information: package dependencies and module
dependencies.

There is additional difficulty in managing "global" dependencies...dynamically
required modules (noteably tool plugins), that aren't explicit dependencies of
the package itself. NODE_PATH can help here, but it is not supported for ESM
modules.

### Realpath

The propensity of tools to resolve symlinks allows extraneous files to "leak" in
module/asset loading. Note that Bazel does not clean up old outputs. Sandboxing
solves this issue, however it is sometimes unavailable (Windows) or unused
(bazel run).

## Resolution APIs

### Yarn PnP

Plug'n'Play is a package resolution API. To be precise, it does not itself
resolve module, but rather resolves "packages" to directories. It has broad
support, natively or via tool plugins. With this approach, rules would arrange
files with their package structure, and use PnP to describe the relationships
between packages.

Unfortunately, Yarn plugins currently have several issues, and generally fail to
use findPnpApi, for multi-root dependency trees (namely tools with a different
dependency tree).

### Custom resolution

Most tools have APIs to customize module resolution. However, adapting or
reimplementing the algorithms would be complex and error-prone.

## Package managers

Package managers (npm, Yarn) could install files. (This is the approach
`rules_nodejs` takes.) However, these aren't well positioned to take part in the
Bazel ecosystem and create an odd internal-vs-external library distinction that
isn't flexible in the way that other Bazel rulesets are.

## Virtual file system

A virtual file system could transparently locate files without interfering with
symlink usage.

This requires postprocessing source maps, error messages, etc. if actual file
names are desired.

### DDL interception

This is platform specific and difficult.

### Monkey-patching (current approach)

Shim the `fs` module (or `process.binding('fs')`). However, a lot of Node.js
module loading internals are
[deliberately](https://github.com/nodejs/node/pull/39513#pullrequestreview-714334718)
written in such a way they cannot be monkey-patched.

Adding the `path` module improves the situation, however, it is a fragile
approach.

## Solution

better_rules_javascript adopts different approach depending on the runtime/tool.

The underlying concept is packages. A package is directory of files. Files are
generated or symlinked to be in this directory. better_rules_javascript tracks
dependencies between packages, and uses that in module resolution. Much of
module resolution: extensions, package.json exports, etc. are delegated to the
underlying resolver. better_rules_javascript just tells what packages are
related to which other ones.

This is an approach similar to Yarn PnP, though it does not use PnP.

- Node.js CommonJS: Override Module.\_resolveFilename
- Node.js ES: Use the experimental
  [ESM loader hooks](https://nodejs.org/api/esm.html#loaders)
- Other Node.js-based tools: shims the `fs` module, synthesizing a node_modules
  directory with symlinks and dereferencing other symlinks.
