#!/usr/bin/env bash

# If manifest is used, resolve items in manifest.
#
# If symlinks are being used, preserve the symlinks.

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

NODEJS_PACKAGES_MANIFEST="$(rlocation %{packages_manifest})" \
  BAZEL_WORKSPACE=%{workspace} \
  NODEJS_MAIN_PACKAGE=%{main_package} \
  exec "$(rlocation %{node})" \
  -r "$(realpath "$(rlocation %{loader})")" \
  %{main_module} \
  "$@"
