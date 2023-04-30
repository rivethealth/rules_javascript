#!/usr/bin/env bash
set -euo pipefail
# For additional options to the Node.js runtime, use the
# NODE_OPTIONS environment variable.

if [ -z "${RUNFILES_DIR:-}" ]; then
  if [ ! -z "${RUNFILES_MANIFEST_FILE:-}" ]; then
    export RUNFILES_DIR="${RUNFILES_MANIFEST_FILE%.runfiles_manifest}".runfiles
  else
    export RUNFILES_DIR="$0".runfiles
  fi
fi

function abspath () {
  if [[ "$1" == /* ]]; then
    echo "$1"
  else
    echo "$PWD"/"$1"
  fi
}

export COMPILATION_MODE=%{compilation_mode}
export NODE_OPTIONS_APPEND="-r $(abspath "$RUNFILES_DIR"/%{runtime}/index.js) -r $(abspath "$RUNFILES_DIR"/%{shim}/index.js)"
export JS_SOURCE_MAP=%{js_source_map}
export WATCHPACK_POLLING=130929
export WEBPACK_CONFIG="$RUNFILES_DIR"/%{config}
export WEBPACK_DIGEST="$RUNFILES_DIR"/%{digest}
export WEBPACK_INPUT_ROOT="$RUNFILES_DIR"/%{input_root}
export WEBPACK_OUTPUT="$RUNFILES_DIR"/tmp/bundle.js
export WEBPACK_PACKAGE_MANIFEST="$RUNFILES_DIR"/%{package_manifest}

exec "$RUNFILES_DIR"/%{bin} --config="$RUNFILES_DIR"/%{webpack_config} "$@"
