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

export NODE_PACKAGE_MANIFEST="$RUNFILES_DIR"/%{package_manifest}
export NODE_FS_PACKAGE_MANIFEST="$RUNFILES_DIR"/%{package_manifest}
export NODE_FS_RUNFILES=true

args=("$@")

if [ ! -z "${TESTBRIDGE_TEST_ONLY-}" ]; then
  args+=("$TESTBRIDGE_TEST_ONLY")
fi

%{env} \
  exec "$RUNFILES_DIR"/%{node} \
  -r "$RUNFILES_DIR"/%{module_linker} \
  -r "$RUNFILES_DIR"/%{fs_linker} \
  --preserve-symlinks \
  --preserve-symlinks-main \
  "$RUNFILES_DIR"/%{main_module} \
  %{node_options} \
  --config="$RUNFILES_DIR"/%{config} \
  --no-cache \
  --no-watchman \
  --runInBand \
  "${args[@]}"
