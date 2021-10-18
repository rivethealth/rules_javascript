# Module resolution

## Background

Perhaps the most difficult part of JavaScript tooling is resolving modules. Module resolution is difficult:

1. Resolution is relative to the current module.
2. There are a variety of algorithms: Node.js CommonJS, Node.js ES, Webpack, Bable, TypeScript.
3. Package resolutions are complex, and often involve interpreting package.json imports, exports, etc.
4. Often, the number input files is very large, on the order of tens of thousands.

## File layout

### Symlinks

The simplest way to arrange Node.js modules is as described in [Node.js Package manager tips](https://nodejs.org/api/modules.html#modules_package_manager_tips) so that each package as siblings, with symlinks to dependencies.

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

However, this approach gives important meaning to symlinks, thus precluding the abililty to use symlinks for transparent file layout.

### Hoisting

Alternatively `--preserve-symlinks` could remove symlinks from module resolution. Packages would be hoisted to the various levels within the nested node_modules tree. However, hoisting is a difficult problem to solve.

## Resolution APIs

### Yarn PnP

Support for PnP is fairly broad, though some complexities of package.json resolutions are lost. Also, Node.js ESM support is lacking.

Also, this oddly only supports an extensionless "module specifier", which is odd and requires that files of different extensions be co-located.

### Custom resolution

There are a variety of algorithms, including complex resolutions depending on package.json contents. Modifying or reimplement the resolution algorithms of tools would be complex and error-prone.

## Package managers

Package managers (npm, Yarn) could install files. (This is the approach `rules_nodejs` takes.) However, these aren't well positioned to take part in the Bazel ecosystem and create an odd internal-vs-external library distinction that isn't flexible in the way that other Bazel rulesets are.

## Virtual file system

A virtual file system could transparently locate files without interfering with symlink usage.

This requires postprocessing source maps, etc. if original file names are desired.

### DDL interception

This is platform specific and difficult.

### Monkey-patching (current approach)

Shim the `fs` module (or `process.binding('fs')`). However, a lot of Node.js internals are written in such a way they cannot be monkey-patched.

Adding the `path` module improves the situation, however, it is a fragile approach.
