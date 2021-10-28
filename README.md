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

## Usage

### Basic

**package.json**

```json
{}
```

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
load("@better_rules_javascript//rules/commonjs:rules.bzl", "cjs_root")
load("@better_rules_javascript//rules/javascript:rules.bzl", "js_library")
load("@better_rules_javascript//rules/nodejs:rules.bzl", "nodejs_binary")

cjs_root(
  name = "root",
  descriptor = "package.json",
  package_name = "example",
)

js_library(
    name = "a",
    root = ":root",
    srcs = ["a.js"],
)

js_library(
    name = "b",
    root = ":root",
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

**package.json**

```json
{
  "dependencies": {
    "@org/package": "1.0.0"
  }
}
```

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
load("@better_rules_javascript//rules/npm:workspace.bzl", "npm")
load(":npm_data.bzl", NPM_PACKAGES = "PACKAGES", NPM_ROOTS = "ROOTS")
npm("npm", NPM_PACKAGES, NPM_ROOTS)
```

NPM packages are available as `@npm//<package_name>:lib`, e.g.

**BUILD.bazel**

```bzl
js_library(
    name = "example",
    deps = ["@npm//org_package:lib"],
)
```

Native dependencies (node-gyp) are not currently supported.

For IDE use, run `yarn install` separately to install dependencies node_modules.

### Rollup

#### Install

Add rollup as an [external dependency](#external_dependencies).

#### Configure

**BUILD.bzl**

```bzl
load("@better_rules_javascript//rules/rollup:rules.bzl", "configure_rollup")

configure_rollup(
    name = "rollup",
    dep = "@npm//rollup:lib",
)
```

#### Use

**example/package.json**

```json
{}
```

**example/a.js**

```
export const a = 'apple';
```

**example/b.js**

```
import { a } from './a';

console.log(a);
```

**example/rollup.config.js**

```
export default {
  input: `${process.env.ROLLUP_INPUT_ROOT}/index.js`,
  output: { file: process.env.ROLLUP_OUTPUT, format: 'cjs' },
};
```

**example/BUILD.bzl**

```bzl
load("@better_rules_javascript//rules/javascript:rules.bzl", "js_library")
load("@better_rules_javascript//rules/rollup:rules.bzl", "rollup_bundle")

cjs_root(
  name = "root",
  descriptor = "package.json"
)

js_library(
    name = "js",
    root = ":root",
    srcs = ["a.js", "b.js"],
)

js_library(
    name = "rollup_config",
    root = ":root",
    srcs = ["rollup.config.js"]
)

rollup_bundle(
    name = "bundle",
    dep = ":b",
    config_dep = ":rollup_config",
    config_path = "rollup.config.js",
    rollup = "//:rollup",
)
```

### Prettier

#### Install

Add prettier as an [external dependency](#external_dependencies).

#### Configure

**tools/BUILD.bzl**

```bzl
load("@better_rules_javascript//rules/prettier:rules.bzl", "prettier")

package(default_visibility = ["//visibility:public"])

prettier(
    name = "prettier",
    config = "//:prettierrc.yml", # optional
    prettier = "@npm//prettier:lib",
)
```

**tools/aspects.bzl**

```bzl
load("@better_rules_javascript//rules/prettier:aspects.bzl", "format_aspect")

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
load("@better_rules_javascript//rules/protobuf:rules.bzl", "js_protoc")

package(default_visibility = ["//visibility:public"])

cjs_root(
    descriptor = "proto.package.json",
    name = "proto_root",
    package_name = "@better_rules_javascript_test/proto"
)

js_protoc(
    name = "js_protoc",
    root = ":proto_root",
    runtime = "@npm//google_protobuf:lib",
)
```

**package.json**

```json
{}
```

**rules.bzl**

```bzl
load("@better_rules_javascript//rules/protobuf:aspects.bzl", "js_proto_aspect")
load("@better_rules_javascript//rules/protobuf:rules.bzl", "js_proto_library_rule")

js_proto = js_proto_aspect("@better_rules_javascript_test//:lib_protoc")

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

### Protobuf.js

#### Install

Add protobufjs as an [external dependency](#external-dependencies).

#### Configure

**BUILD.bazel**

```bzl
load("@better_rules_javascript//rules/protobufjs:rules.bzl", configure_js_proto)

configure_js_proto(
    name = "js_proto",
    dep = "@npm//protobufjs:lib",
)
```

#### Use

```bzl
load("@better_rules_javascript//rules/commonjs:rules.bzl", "cjs_root")
load("@better_rules_javascript//rules/protobufjs:rules.bzl", "js_proto_library")
load("@rules_proto//proto:defs.bzl", "proto_library")

cjs_root(
    descriptor = "package.json",
    name = "root",
)

proto_library(
    name = "proto",
    srcs = glob(["**/*.proto"]),
)

js_proto_library(
    module_name = "pb.js",
    name = "proto_js",
    root = ":root",
    js_proto = "//:js_protojs",
    deps = [":proto"],
)
```

## Stardoc

Auto-generated [Stardoc documentation](docs/stardoc).

### Differences with rules_javascrizpt

See [docs/rules_javascript.md](docs/rules_javascript.md).

## Developing

Some JS build products need to be boostrapped.

To refresh these, run scripts/gen-js.sh, which re-builds and copies them to
source tree. If that breaks, you'll have to rollback to the last good state of
the generated files.
