#!/usr/bin/env bash
set -euo pipefail
# For additional options to the Node.js runtime, use the
# NODE_OPTIONS environment variable.

if [ -z "${RUNFILES_DIR:-}" ]; then
  if [ ! -z "${RUNFILES_MANIFEST_FILE:-}" ]; then
    export RUNFILES_DIR="$(realpath "${RUNFILES_MANIFEST_FILE%.runfiles_manifest}.runfiles")"
  else
    export RUNFILES_DIR="$(realpath "$0.runfiles")"
  fi
fi

export COMPILATION_MODE=%{compilation_mode}
export NODE_FS_PACKAGE_MANIFEST="$RUNFILES_DIR"/%{package_manifest}
export NODE_OPTIONS_APPEND="-r $RUNFILES_DIR/%{skip_package_check}"
export WEBPACK_CLIENT_ROOT="$RUNFILES_DIR"/%{client_root}
export WEBPACK_CONFIG=%{config}
export WEBPACK_INPUT_ROOT="$RUNFILES_DIR"/%{input_root}
export WEBPACK_OUTPUT="$RUNFILES_DIR"/%{output}

exec "$RUNFILES_DIR"/%{bin} --packages-manifest "$RUNFILES_DIR"/%{webpack_package_manifest}
