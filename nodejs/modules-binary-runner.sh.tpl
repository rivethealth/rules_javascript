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

function abspath () {
  if [[ "$1" == /* ]]; then
    echo "$1"
  else
    echo "$PWD"/"$1"
  fi
}

%{env} \
  exec -a "$0" "$RUNFILES_DIR"/%{node} \
  %{node_options} \
  "$(abspath "$RUNFILES_DIR"/%{main_module})" \
  "$@"
