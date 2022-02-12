#!/bin/sh -e
export RUNFILES_DIR="$0.runfiles"

"$RUNFILES_DIR/better_rules_javascript/tools/install_node_modules0"

cd "$BUILD_WORKSPACE_DIRECTORY"

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
