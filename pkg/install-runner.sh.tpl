#!/usr/bin/env bash

if [ -z "${RUNFILES_DIR-}" ]; then
  if [ ! -z "${RUNFILES_MANIFEST_FILE-}" ]; then
    export RUNFILES_DIR="${RUNFILES_MANIFEST_FILE%.runfiles_manifest}.runfiles"
  else
    export RUNFILES_DIR="$0.runfiles"
  fi
fi

exec "$RUNFILES_DIR"/%{install} "$RUNFILES_DIR"/%{manifest} "${BUILD_WORKSPACE_DIRECTORY-.}"/%{path}
