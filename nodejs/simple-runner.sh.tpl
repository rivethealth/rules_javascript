#!/usr/bin/env bash

# For additional options to the Node.js runtime, use the
# NODE_OPTIONS environment variable.

# See https://github.com/bazelbuild/bazel/blob/master/tools/bash/runfiles/runfiles.bash
# --- begin runfiles.bash initialization v2 ---
# Copy-pasted from the Bazel Bash runfiles library v2.
set -uo pipefail; f=bazel_tools/tools/bash/runfiles/runfiles.bash
source "${RUNFILES_DIR:-/dev/null}/$f" 2>/dev/null || \
  source "$(grep -sm1 "^$f " "${RUNFILES_MANIFEST_FILE:-/dev/null}" | cut -f2- -d' ')" 2>/dev/null || \
  source "$0.runfiles/$f" 2>/dev/null || \
  source "$(grep -sm1 "^$f " "$0.runfiles_manifest" | cut -f2- -d' ')" 2>/dev/null || \
  source "$(grep -sm1 "^$f " "$0.exe.runfiles_manifest" | cut -f2- -d' ')" 2>/dev/null || \
  { echo>&2 "ERROR: cannot find $f"; exit 1; }; f=; set -e
# --- end runfiles.bash initialization v2 ---

if ! [ -z "${BUILD_WORKING_DIRECTORY:-}" ]; then
  cd "$BUILD_WORKING_DIRECTORY"
  unset BUILD_WORKING_DIRECTORY
fi

exec "$(rlocation %{node})" \
  "$(rlocation %{module})" \
  "$@"
