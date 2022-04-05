#!/usr/bin/env sh
set -e

if [ -z "$RUNFILES_DIR" ]; then
  export RUNFILES_DIR="$0".runfiles
fi

abs_runfiles_dir="$(realpath -s "$RUNFILES_DIR")"

cd "$RUNFILES_DIR"/%{dir}

exec "$abs_runfiles_dir"/better_rules_javascript/npm/yarn npm audit
