#!/bin/sh -e
export RUNFILES_DIR="$0.runfiles"

cd "$BUILD_WORKSPACE_DIRECTORY"

"$RUNFILES_DIR/better_rules_javascript/npm/yarn-gen/bin" \
    --refresh \
    rules/npm_data.bzl
