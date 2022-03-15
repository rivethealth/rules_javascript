#!/usr/bin/env sh
set -e

if [ -z "$RUNFILES_DIR" ]; then
  export RUNFILES_DIR="$0".runfiles
fi

cd "$BUILD_WORKSPACE_DIRECTORY"

exec "$RUNFILES_DIR"/better_rules_javascript/npm/yarn-resolve/bin %{options} --dir %{directory} %{output}
