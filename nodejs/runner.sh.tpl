#!/usr/bin/env bash
set -euo pipefail

# For additional options to the Node.js runtime, use the
# NODE_OPTIONS environment variable.

if [ -z "${RUNFILES_DIR-}" ]; then
  if [ ! -z "${RUNFILES_MANIFEST_FILE-}" ]; then
    export RUNFILES_DIR="${RUNFILES_MANIFEST_FILE%.runfiles_manifest}.runfiles"
  else
    export RUNFILES_DIR="$0.runfiles"
  fi
fi

# if ! [ -z "${BUILD_WORKING_DIRECTORY:-}" ]; then
#   cd "$BUILD_WORKING_DIRECTORY"
#   unset BUILD_WORKING_DIRECTORY
# fi

function abspath () {
  if [[ "$1" == /* ]]; then
    echo "$1"
  else
    echo "$PWD"/"$1"
  fi
}

export NODE_PACKAGE_MANIFEST="$RUNFILES_DIR"/%{package_manifest}

%{env} \
  exec -a "$0" "$RUNFILES_DIR"/%{node} \
  -r "$(abspath "$RUNFILES_DIR"/%{runtime})" \
  -r "$(abspath "$RUNFILES_DIR"/%{module_linker})" \
  --experimental-loader "$(abspath "$RUNFILES_DIR"/%{esm_loader})" \
  --experimental-specifier-resolution=node \
  --preserve-symlinks \
  --preserve-symlinks-main \
  %{node_options} \
  ${NODE_OPTIONS_APPEND:-} \
  "$(abspath "$RUNFILES_DIR"/%{main_module})" \
  "$@"
