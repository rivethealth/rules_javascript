#!/bin/bash -e
export RUNFILES_DIR="$0.runfiles"

cd "$BUILD_WORKSPACE_DIRECTORY"

if [ "$1" = check ]; then
    arg=
else
    arg=write
fi

"$RUNFILES_DIR/better_rules_javascript/tools/eslint_lint/bin" -- $ARG
