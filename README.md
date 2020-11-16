# rules_javascript

Rules for JavaScript, with an emphasis on idiomatic Bazel APIs.

- [rules_javascript](#rules_javascript)
  - [Features](#features)
  - [Install](#install)
  - [Usage](#usage)
    - [Basic](#basic)
    - [External dependencies](#external-dependencies)
    - [Format](#format)
  - [Stardoc](#stardoc)
  - [Implementation](#implementation)

## Features

- [ ] library
  - [x] files
  - [ ] directories
  - [x] multiple versions
- [ ] bundle
  - [ ] rollup
  - [ ] webpack
  - [ ] unused deps
- [ ] runtime
  - [x] nodejs_binary
  - [ ] docker
- [ ] test
  - [ ] jest
- [x] serialization
  - [x] protobuf
- [ ] external dependencies
- [ ] npm
- [x] yarn
- [ ] node-gyp
- [ ] lint
  - [x] prettier (TODO: plugins)
  - [ ] eslint (TODO: config file, plugins)
- [ ] dev
  - [x] Stardoc
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

load("@better_rules_javascript//rules/bzl:workspace.bzl", javascript_repositories = "respositories")
javascript_respositories()
```

## Usage

### Basic

**a.js**

```js
exports.example = "apple";
```

**b.js**

```js
const a = require("./a");
console.log(a.example);
```

**BUILD.bazel**

```bzl
load("@better_rules_javascript//rules/javascript/bzl:rules.bzl", "js_library")
load("@better_rules_javascript//rules/nodejs/bzl:rules.bzl", "nodejs_binary")

js_library(
    name = "a",
    srcs = ["a.js"],
)

js_library(
    name = "b",
    srcs = ["b.js"],
    deps = [":a"],
)

nodejs_binary(
    name = "bin",
    dep = ":b",
    main = "b.js",
)
```

### External dependencies

#### Resolve external dependency graph

```sh
yarn install
```

#### Convert data to Bazel representation

```sh
bazel run @better_rules_javascript//rules/npm/gen:bin -- \
    yarn --package "$(pwd)/package.json" --lock "$(pwd)/yarn.lock" "$(pwd)/npm_data.bzl"
```

#### Create external repositories

**WORKSPACE.bazel**

```bzl
load("@better_rules_javascript//rules/npm/bzl:workspace.bzl", "npm")
load(":npm_data.bzl", NPM_PACKAGES = "PACKAGES", NPM_ROOTS = "ROOTS")
npm("npm", NPM_PACKAGES, NPM_ROOTS)
```

NPM packages are accessible as

```bzl
js_library(
    name = "example",
    srcs = ["example.js"],
    deps = ["@npm//org_package:js"],
)
```

Native dependencies (node-gyp) are not currently supported.

For IDE use, run `yarn install` separately to install dependencies node_modules.

### Prettier

#### Install

Add prettier as an [external dependency](#external-dependencies).

#### Configure

**tools/BUILD.bzl**

```bzl
load("@better_rules_javascript//rules/prettier/bzl:rules.bzl", "prettier")

package(default_visibility = ["//visibility:public"])

prettier(
    name = "prettier",
    config = "//:prettierrc.yml", # optional
    prettier = "@npm//prettier:js",
)
```

**tools/aspects.bzl**

```bzl
load("@better_rules_javascript//rules/prettier/bzl:aspects.bzl", "format_aspect")

format = format_aspect("@example_repo//tools:prettier")
```

#### Run

```sh
bazel query 'kind("js_library", //...)' \
    | xargs -r bazel build --aspects //tools:aspects.bzl%format --output_groups=formatted

BAZEL_BIN="$(bazel info bazel-bin)"
bazel query 'kind("js_library", //...)' --output package | while IFS= read -r package; do
    "$BAZEL_BIN/$package/_format/bin" write # to check only, omit "write"
done
```

### Protobuf

#### Install

**WORKSPACE.bazel**

```bzl
PROTO_VERSION = "7e4afce6fe62dbff0a4a03450143146f9f2d7488"
http_archive(
    name = "rules_proto",
    sha256 = "8e7d59a5b12b233be5652e3d29f42fba01c7cbab09f6b3a8d0a57ed6d1e9a0da",
    strip_prefix = "rules_proto-%s" % PROTO_VERSION,
    urls = ["https://github.com/bazelbuild/rules_proto/archive/%s.tar.gz" % PROTO_VERSION],
)
load("@rules_proto//proto:repositories.bzl", "rules_proto_dependencies", "rules_proto_toolchains")
rules_proto_dependencies()
rules_proto_toolchains()

PROTO_GRPC_VERSION = "2.0.0"
http_archive(
    name = "rules_proto_grpc",
    urls = ["https://github.com/rules-proto-grpc/rules_proto_grpc/archive/%s.tar.gz" % PROTO_GRPC_VERSION],
    sha256 = "d771584bbff98698e7cb3cb31c132ee206a972569f4dc8b65acbdd934d156b33",
    strip_prefix = "rules_proto_grpc-%s" % PROTO_GRPC_VERSION,
)
load("@rules_proto_grpc//:repositories.bzl", "rules_proto_grpc_toolchains", "rules_proto_grpc_repos")
rules_proto_grpc_toolchains()
rules_proto_grpc_repos()
```

Add google-protobuf as an [external dependency](#external-dependencies).

#### Configure

**BUILD.bazel**

```bzl
load("@better_rules_javascript//rules/protobuf/bzl:rules.bzl", "js_protoc")

package(default_visibility = ["//visibility:public"])

js_protoc(
    name = "js_protoc",
    runtime = "@npm//google-protobuf:js",
)
```

**rules.bzl**

```bzl
load("@better_rules_javascript//rules/protobuf/bzl:aspects.bzl", "js_proto_aspect")
load("@better_rules_javascript//rules/protobuf/bzl:rules.bzl", "js_proto_library_rule")

js_proto = js_proto_aspect("@better_rules_javascript_test//:js_protoc")

js_proto_library = js_proto_library_rule(js_proto)
```

#### Use

```bzl
load("@rules_proto//proto:defs.bzl", "proto_library")
load("//:rules.bzl", "js_proto_library")

proto_library(
    name = "proto",
    srcs = glob(["**/*.proto"]),
)

js_proto_library(
    name = "js",
    dep = ":proto",
)
```

## Stardoc

Auto-generated [Stardoc documentation](docs/stardoc).

## Module resolution

Perhaps the most difficult part of JavaScript tooling is resolving modules.

rules_javascript implements custom resolvers for good performance and Bazel
integration.

This design choice requries implementing modules resolution for tools, but is an
acceptable tradeoff for the flexibility it grants. Good Bazel tooling requires
shims anyway to support features like workers.

JavaScript is organized by "packages" which have a name (not necessarily
unique), named modules, named dependencies, and (optionally) an entry point.
Relative imports are constructed relative to package_name/module_name. By
default, the package name is @bazel_workspace/bazel_package, and the module name
is relative to the package.

Packages are listed in packages-manifest.txt and then processed by
[rules/javascript/resolver.js](rules/javascript/resolver.js).

These units are different from NPM "packages." For example a.js could belong to
one package and a.spec.js could belong to a second, but the second can import
the first with `'./a'`. Files must belong to only one package.

Dependencies are naturally strict: each package must explicity list its direct
dependencies.
