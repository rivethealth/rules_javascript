#!/bin/sh -e
cd "$(dirname "$0")/.."

RUNFILES_DIR="$0.runfiles"

cd "$BUILD_WORKSPACE_DIRECTORY"

# external deps
rm -fr node_modules
mkdir node_modules
tar xf "$RUNFILES_DIR/better_rules_javascript/nodejs_archive.tar" -C node_modules

# fix Angular language service
mkdir -p node_modules/@angular
rm -fr node_modules/@angular/core
mv node_modules/_better_rules_javascript_npm_angular_core_13.1.1-dc3fc578 node_modules/@angular/core
ln -rs node_modules/@angular/core node_modules/_better_rules_javascript_npm_angular_core_13.1.1-dc3fc578
rm -r node_modules/@angular/core/node_modules
mkdir -p node_modules/@angular/core/node_modules
ln -rs node_modules/_better_rules_javascript_npm_rxjs_7.4.0 node_modules/@angular/core/node_modules/rxjs
ln -rs node_modules/_better_rules_javascript_npm_tslib_2.3.1 node_modules/@angular/core/node_modules/tslib
ln -rs node_modules/_better_rules_javascript_npm_zone.js_0.11.4 node_modules/@angular/core/node_modules/zone.js

# local deps
mkdir -p node_modules/@better-rules-javascript
ln -rs commonjs/package node_modules/@better-rules-javascript/commonjs-package
ln -rs ibazel/notification node_modules/@better-rules-javascript/ibazel-notification
ln -rs nodejs/fs-linker node_modules/@better-rules-javascript/nodejs-fs-linker
ln -rs rules node_modules/@better-rules-javascript/rules
ln -rs webpack/config node_modules/@better-rules-javascript/webpack-config
ln -rs bazel/runfiles node_modules/@better-rules-javascript/bazel-runfiles
ln -rs bazel/worker node_modules/@better-rules-javascript/bazel-worker
ln -rs angular/fs-resource node_modules/@better-rules-javascript/angular-fs-resource
ln -rs util/json node_modules/@better-rules-javascript/util-json
