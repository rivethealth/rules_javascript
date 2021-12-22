#!/usr/bin/env sh
set -e
cd "$(dirname "$0")/.."

bazel build commonjs/manifest:bundle nodejs/esm-linker:bundle nodejs/fs-linker:bundle nodejs/module-linker:bundle nodejs/runtime:bundle
rm -fr commonjs/manifest/dist nodejs/esm-linker/dist nodejs/fs-linker/dist nodejs/module-linker/dist nodejs/runtime/dist
mkdir commonjs/manifest/dist nodejs/esm-linker/dist nodejs/fs-linker/dist nodejs/module-linker/dist nodejs/runtime/dist
cp -r "$(bazel info bazel-bin)/commonjs/manifest/bundle/bundle.js" commonjs/manifest/dist/bundle.js
cp -r "$(bazel info bazel-bin)/nodejs/esm-linker/bundle/bundle.js" nodejs/esm-linker/dist/bundle.js
cp -r "$(bazel info bazel-bin)/nodejs/fs-linker/bundle/bundle.js" nodejs/fs-linker/dist/bundle.js
cp -r "$(bazel info bazel-bin)/nodejs/module-linker/bundle/bundle.js" nodejs/module-linker/dist/bundle.js
cp -r "$(bazel info bazel-bin)/nodejs/runtime/bundle/bundle.js" nodejs/runtime/dist/bundle.js
chmod +w commonjs/manifest/dist/* nodejs/esm-linker/dist/* nodejs/fs-linker/dist/* nodejs/module-linker/dist/* nodejs/runtime/dist/*
