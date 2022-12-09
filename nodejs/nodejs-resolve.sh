#!/usr/bin/env bash
set -euo pipefail

if [ -z "${RUNFILES_DIR-}" ]; then
  if [ ! -z "${RUNFILES_MANIFEST_FILE-}" ]; then
    export RUNFILES_DIR="${RUNFILES_MANIFEST_FILE%.runfiles_manifest}.runfiles"
  else
    export RUNFILES_DIR="$0.runfiles"
  fi
fi

tmp="$(mktemp)"
"$RUNFILES_DIR"/better_rules_javascript/nodejs/resolve/bin --min-version=14 > "$tmp"
mv "$tmp" "$BUILD_WORKSPACE_DIRECTORY"/nodejs/default/nodejs.bzl
