#!/bin/sh -e
cd "$(dirname "$0")/.."

RUNFILES_DIR="$0.runfiles"

cd "$BUILD_WORKSPACE_DIRECTORY"

# external deps
rm -fr .node_modules node_modules
mkdir .node_modules
tar xf "$RUNFILES_DIR/better_rules_javascript/nodejs_archive.tar" -C .node_modules
ln -s .node_modules/_ node_modules

# fix Angular language service
mkdir -p .node_modules/@angular
mv .node_modules/better_rules_javascript_npm_angular_core13.1.1___root .node_modules/@angular/core
ln -rs .node_modules/@angular/core .node_modules/better_rules_javascript_npm_angular_core13.1.1___root
rm -r .node_modules/@angular/core/node_modules
mkdir -p .node_modules/@angular/core/node_modules
ln -rs .node_modules/better_rules_javascript_npm_rxjs7.4.0___root .node_modules/@angular/core/node_modules/rxjs
ln -rs .node_modules/better_rules_javascript_npm_tslib2.3.1___root .node_modules/@angular/core/node_modules/tslib
ln -rs .node_modules/better_rules_javascript_npm_zone.js0.11.4___root .node_modules/@angular/core/node_modules/tslib

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
