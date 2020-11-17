#!/usr/bin/env sh
set -ex
cd "$(dirname "$0")/.."

bazel build --output_groups js rules/javascript/resolver:ts
rm -fr rules/javascript/resolver-js
cp -r "$(bazel info bazel-bin)/rules/javascript/resolver/ts" rules/javascript/resolver-js
find rules/javascript/resolver-js -type f -name '*.d.ts' -delete

bazel build rules/nodejs/shim:bundle
rm -fr rules/nodejs/shim.js
cp "$(bazel info bazel-bin)/rules/nodejs/shim/bundle/bundle.js" rules/nodejs/shim.js

bazel build --output_groups js rules/rollup/resolve:ts
rm -fr rules/rollup/resolve-js
cp -r "$(bazel info bazel-bin)/rules/rollup/resolve/ts" rules/rollup/resolve-js
find rules/rollup/resolve-js -type f -name '*.d.ts' -delete
