#!/bin/sh -e
cd "$(dirname "$0")/.."

bazel build :archive
rm -fr .node_modules node_modules
mkdir .node_modules
tar xf bazel-bin/archive/modules.tar -C .node_modules
ln -s .node_modules/_ node_modules
mkdir -p node_modules/@better-rules-javascript
ln -rs commonjs/package/src node_modules/@better-rules-javascript/commonjs-package
ln -rs rules node_modules/@better-rules-javascript/rules
ln -rs worker/lib/src node_modules/@better-rules-javascript/worker
