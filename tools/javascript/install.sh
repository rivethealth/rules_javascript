#!/bin/sh -e
export RUNFILES_DIR="$0.runfiles"

"$RUNFILES_DIR/better_rules_javascript/tools/javascript/install0"

cd "$BUILD_WORKSPACE_DIRECTORY"

# fix Angular language service
rm -fr node_modules/@angular/core
mv node_modules/.content/npm_angular_core_13.1.1-dc3fc578/npm node_modules/@angular/core
ln -rs node_modules/@angular/core node_modules/.content/npm_angular_core_13.1.1-dc3fc578/npm
rm -r node_modules/@angular/core/node_modules
mkdir -p node_modules/@angular/core/node_modules
ln -rs node_modules/.content/npm_rxjs_7.4.0/npm node_modules/@angular/core/node_modules/rxjs
ln -rs node_modules/.content/npm_tslib_2.3.1/npm node_modules/@angular/core/node_modules/tslib
ln -rs node_modules/.content/npm_zone.js_0.11.4/npm node_modules/@angular/core/node_modules/zone.js
