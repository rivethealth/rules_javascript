#!/usr/bin/env bash
set -euo pipefail

if [ -z "${RUNFILES_DIR-}" ]; then
  if [ ! -z "${RUNFILES_MANIFEST_FILE-}" ]; then
    export RUNFILES_DIR="${RUNFILES_MANIFEST_FILE%.runfiles_manifest}.runfiles"
  else
    export RUNFILES_DIR="$0.runfiles"
  fi
fi

if [ %{refresh} = true ]; then
  echo 'Refreshing lockfile' >&2
  "$RUNFILES_DIR"/%{yarn} install --cwd="$BUILD_WORKSPACE_DIRECTORY"/%{path} --mode update-lockfile
fi

exec "$RUNFILES_DIR"/%{yarn_resolve} --dir="$BUILD_WORKSPACE_DIRECTORY"/%{path} "$BUILD_WORKSPACE_DIRECTORY"/%{output}
