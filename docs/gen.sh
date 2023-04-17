#!/bin/sh -e
cd "$(dirname "$0")/.."
set -x
export RUNFILES_DIR="$0.runfiles"

cd "$BUILD_WORKSPACE_DIRECTORY"

bazel build docs
tar x -m -f "$RUNFILES_DIR/better_rules_javascript/docs/docs.tar" -C docs

find docs -name '*.md' -not -name index.md -not -name default.md | xargs "$RUNFILES_DIR/better_rules_javascript/docs/doctoc" --maxlevel 2 --notitle README.md
