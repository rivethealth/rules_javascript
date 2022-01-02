#!/bin/sh -e
cd "$(dirname "$0")/.."
set -x
export RUNFILES_DIR="$0.runfiles"

cd "$BUILD_WORKSPACE_DIRECTORY"

rm -fr docs/stardoc
mkdir -p docs/stardoc
bazel build docs
tar x --touch -f "$RUNFILES_DIR/better_rules_javascript/docs/docs.tar" -C docs/stardoc

"$RUNFILES_DIR/better_rules_javascript/docs/doctoc/bin" --maxlevel 2 --notitle README.md docs/*.md
