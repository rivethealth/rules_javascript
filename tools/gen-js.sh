#!/usr/bin/env sh
set -e
RUNFILES_DIR="$0.runfiles"

cd "$BUILD_WORKSPACE_DIRECTORY"

rm -fr commonjs/manifest/dist nodejs/esm-linker/dist nodejs/fs-linker/dist nodejs/module-linker/dist nodejs/runtime/dist
mkdir commonjs/manifest/dist nodejs/esm-linker/dist nodejs/fs-linker/dist nodejs/module-linker/dist nodejs/runtime/dist
cp -Lr "$RUNFILES_DIR/better_rules_javascript/commonjs/manifest/bundle/bundle.js" commonjs/manifest/dist/bundle.js
cp -Lr "$RUNFILES_DIR/better_rules_javascript/nodejs/esm-linker/bundle/bundle.js" nodejs/esm-linker/dist/bundle.js
cp -Lr "$RUNFILES_DIR/better_rules_javascript/nodejs/fs-linker/bundle/bundle.js" nodejs/fs-linker/dist/bundle.js
cp -Lr "$RUNFILES_DIR/better_rules_javascript/nodejs/module-linker/bundle/bundle.js" nodejs/module-linker/dist/bundle.js
cp -Lr "$RUNFILES_DIR/better_rules_javascript/nodejs/runtime/bundle/bundle.js" nodejs/runtime/dist/bundle.js
chmod +w commonjs/manifest/dist/* nodejs/esm-linker/dist/* nodejs/fs-linker/dist/* nodejs/module-linker/dist/* nodejs/runtime/dist/*
