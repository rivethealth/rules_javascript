#!/usr/bin/env sh
set -ex
cd "$(dirname "$0")/.."

bazel build rules/nodejs/shim:bundle
rm -fr rules/nodejs/shim.js
chmod +w rules/nodejs/shim/dist/bundle.js
cp "$(bazel info bazel-bin)/rules/nodejs/shim/bundle/bundle.js" rules/nodejs/shim/dist/bundle.js
chmod +w rules/nodejs/shim/dist/bundle.js

bazel build rules/nodejs/fs-gen:bundle
rm -fr rules/rollup/resolve-js
chmod +w rules/nodejs/fs-gen/dist/bundle.js
cp -r "$(bazel info bazel-bin)/rules/nodejs/fs-gen/bundle/bundle.js" rules/nodejs/fs-gen/dist/bundle.js
chmod +w rules/nodejs/fs-gen/dist/bundle.js
