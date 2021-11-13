#!/usr/bin/env sh
set -e
cd "$(dirname "$0")/.."

bazel build nodejs/shim:bundle
rm -fr nodejs/shim.js
chmod +w nodejs/shim/dist/bundle.js
cp "$(bazel info bazel-bin)/nodejs/shim/bundle/bundle.js" nodejs/shim/dist/bundle.js
chmod +w nodejs/shim/dist/bundle.js

bazel build nodejs/fs-gen:bundle
rm -fr rollup/resolve-js
chmod +w nodejs/fs-gen/dist/bundle.js
cp -r "$(bazel info bazel-bin)/nodejs/fs-gen/bundle/bundle.js" nodejs/fs-gen/dist/bundle.js
chmod +w nodejs/fs-gen/dist/bundle.js
