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

if ! [ -z "${BUILD_WORKING_DIRECTORY:-}" ]; then
  cd "$BUILD_WORKING_DIRECTORY"
  unset BUILD_WORKING_DIRECTORY
fi

BAZEL_WORKSPACE=%{workspace} \
  NODE_PACKAGE_MANIFEST="$RUNFILES_DIR"/%{package_manifest} \
  %{env} \
  exec "$RUNFILES_DIR"/%{node} \
  -r "$RUNFILES_DIR"/%{module_linker} \
  --enable-source-maps \
  --preserve-symlinks \
  --preserve-symlinks-main \
  %{node_options} \
  ${NODE_OPTIONS_APPEND:-} \
  "$RUNFILES_DIR"/%{main_module} \
  "$@"
