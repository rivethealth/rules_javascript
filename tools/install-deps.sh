#!/bin/sh -e
cd "$(dirname "$0")/.."

RUNFILES_DIR="$0.runfiles"

cd "$BUILD_WORKSPACE_DIRECTORY"

rm -fr .node_modules node_modules
mkdir .node_modules
tar xf "$RUNFILES_DIR/better_rules_javascript/nodejs_archive/modules.tar" -C .node_modules
ln -s .node_modules/_ node_modules
mkdir -p node_modules/@better-rules-javascript
ln -rs commonjs/package node_modules/@better-rules-javascript/commonjs-package
ln -rs rules node_modules/@better-rules-javascript/rules
ln -rs worker/lib node_modules/@better-rules-javascript/worker
ln -rs nodejs/fs-linker node_modules/@better-rules-javascript/nodejs-fs-linker
