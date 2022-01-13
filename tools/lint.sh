#!/usr/bin/env bash
set -e
if [ -z "$RUNFILES_DIR" ]; then
  export RUNFILES_DIR="$0.runfiles"
fi

cd "$BUILD_WORKSPACE_DIRECTORY"

if [ "$1" = check ]; then
    arg=
else
    arg=write
fi

exec "$RUNFILES_DIR/better_rules_javascript/tools/eslint_lint" "$arg"
