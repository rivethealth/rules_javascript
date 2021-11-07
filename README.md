# rules_javascript

Bazel rules for JavaScript, prioritzing, performance, and flexibility.

- [rules_javascript](#rules_javascript)
  - [Features](#features)
  - [Install](#install)
  - [Usage](#usage)
    - [Basic](#basic)
    - [External dependencies](#external-dependencies)
    - [Rollup](#rollup)
    - [Prettier](#prettier)
    - [Protobuf](#protobuf)
  - [Stardoc](#stardoc)
  - [Module resolution](#module-resolution)

## Priorities

* Bazel idioms
* Performance
* Extensibility
* Clear factorization

## Features

- [ ] library
  - [x] files
  - [ ] directories
  - [x] multiple versions
- [ ] bundle
  - [x] rollup
  - [ ] webpack
  - [ ] unused deps
- [ ] runtime
  - [x] nodejs_binary
  - [ ] docker
- [ ] test
  - [ ] mocha
  - [ ] jasmine
  - [ ] jest
  - [ ] sharding
  - [ ] JUnit output
- [ ] serialization
  - [ ] protobuf
- [ ] external dependencies
  - [ ] npm
  - [x] yarn
  - [ ] node-gyp
- [ ] lint
  - [ ] prettier
  - [ ] eslint (TODO: config file, plugins)
- [ ] dev
  - [ ] Stardoc
  - [ ] CI

## Install

**WORKSPACE.bazel**

```bzl
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

# skylib

SKYLIB_VERSION = "16de038c484145363340eeaf0e97a0c9889a931b"
http_archive(
    name = "bazel_skylib",
    sha256 = "96e0cd3f731f0caef9e9919aa119ecc6dace36b149c2f47e40aa50587790402b",
    strip_prefix = "bazel-skylib-%s" % SKYLIB_VERSION,
    urls = ["https://github.com/bazelbuild/bazel-skylib/archive/%s.tar.gz" % SKYLIB_VERSION],
)

# better_rules_javascript

JAVACRIPT_VERSION = "..."
http_archive(
    name = "better_rules_javascript",
    strip_prefix = "rules_javascript-%s" % JAVASCRIPT_VERSION,
    urls = ["https://github.com/rivethealth/rules_javascript/archive/%s.tar.gz" % JAVACRIPT_VERSION],
)

load("@better_rules_javascript//rules:workspace.bzl", javascript_repositories = "respositories")
javascript_respositories()
```

## Example

**package.json**

```json
{}
```

**lib.js**

```js
exports.text = "Hello world";
```

**main.js**

```js
const lib = require("./lib");
console.log(lib.text);
```

**BUILD.bazel**

```bzl
load("@better_rules_javascript//commonjs:rules.bzl", "cjs_root")
load("@better_rules_javascript//javascript:rules.bzl", "js_library")
load("@better_rules_javascript//nodejs:rules.bzl", "nodejs_binary")

cjs_root(
  name = "root",
  descriptor = "package.json",
  package_name = "example",
)

js_library(
    name = "lib",
    root = ":root",
    srcs = ["lib.js"],
)

js_library(
    name = "main",
    root = ":root",
    srcs = ["main.js"],
    deps = [":lib"],
)

nodejs_binary(
    name = "bin",
    dep = ":main",
    main = "main.js",
)
```

Running

```sh
bazel run //:bin
```

outputs

```txt
Hello world
```

## Documentation

[Npm](docs/npm.md)

[Prettier](docs/prettier.md)

[Protobuf](docs/protobuf.md)

[Protobuf.js](docs/protobufjs.md)

[Rollup](docs/rollup.md)

## Stardoc

Auto-generated [Stardoc documentation](docs/stardoc).

## Differences with rules_javascrizpt

See [docs/rules_javascript.md](docs/rules_javascript.md).

## Developing

Some JS build products need to be boostrapped.

To refresh these, run scripts/gen-js.sh, which re-builds and copies them to
source tree. If that breaks, you'll have to rollback to the last good state of
the generated files.
