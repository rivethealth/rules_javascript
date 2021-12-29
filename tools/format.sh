#!/bin/bash -e
export RUNFILES_DIR="$0.runfiles"

cd "$BUILD_WORKSPACE_DIRECTORY"

if [ "$1" = check ]; then
    arg=
else
    arg=write
fi

"$RUNFILES_DIR/better_rules_javascript/tools/buildifier_format/bin" "$arg"
"$RUNFILES_DIR/better_rules_javascript/tools/prettier_format/bin" "$arg"
