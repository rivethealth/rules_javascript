#!/bin/sh -e
cd "$(dirname "$0")/.."
set -x
export RUNFILES_DIR="$0.runfiles"

cd "$BUILD_WORKSPACE_DIRECTORY"

tar x -m -f "$RUNFILES_DIR/better_rules_javascript/tools/doc/docs.tar" -C docs

find docs -name '*.md' -not -name index.md -not -name default.md | xargs "$RUNFILES_DIR/better_rules_javascript/tools/doc/doctoc" --maxlevel 2 --notitle README.md
