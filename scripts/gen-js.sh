#!/usr/bin/env sh
set -e
cd "$(dirname "$0")/.."

bazel build commonjs/manifest:bundle
rm -fr commonjs/manifest/dist
mkdir commonjs/manifest/dist
cp -r "$(bazel info bazel-bin)/commonjs/manifest/bundle/bundle.js" commonjs/manifest/dist/bundle.js
chmod +w commonjs/manifest/dist/bundle.js

bazel build nodejs/fs-linker:bundle
rm -fr nodejs/fs-linker/dist
mkdir nodejs/fs-linker/dist
cp -r "$(bazel info bazel-bin)/nodejs/fs-linker/bundle/bundle.js" nodejs/fs-linker/dist/bundle.js
chmod +w nodejs/fs-linker/dist/bundle.js

bazel build nodejs/module-linker:bundle
rm -fr nodejs/module-linker/dist
mkdir nodejs/module-linker/dist
cp -r "$(bazel info bazel-bin)/nodejs/module-linker/bundle/bundle.js" nodejs/module-linker/dist/bundle.js
chmod +w nodejs/module-linker/dist/bundle.js
