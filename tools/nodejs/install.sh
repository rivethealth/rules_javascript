#!/bin/sh -e
export RUNFILES_DIR="$0.runfiles"

"$RUNFILES_DIR/better_rules_javascript/tools/nodejs/install0"

cd "$BUILD_WORKSPACE_DIRECTORY"

# fix Angular language service
rm -fr node_modules/@angular/core
mv node_modules/.content/npm_angular_core_13.1.1-dc3fc578/files node_modules/@angular/core
ln -s ../../@angular/core node_modules/.content/npm_angular_core_13.1.1-dc3fc578/files
rm -r node_modules/@angular/core/node_modules
mkdir -p node_modules/@angular/core/node_modules
ln -s ../../../.content/npm_rxjs_7.4.0/files node_modules/@angular/core/node_modules/rxjs
ln -s ../../../.content/npm_tslib_2.3.1/files node_modules/@angular/core/node_modules/tslib
ln -s ../../../.content/npm_zone.js_0.11.4/files node_modules/@angular/core/node_modules/zone.js
