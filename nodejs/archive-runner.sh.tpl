#!/usr/bin/env bash
set -euo pipefail
# For additional options to the Node.js runtime, use the
# NODE_OPTIONS environment variable.

cd "$(dirname "$0")"

# TODO: %{env}
exec node \
  %{node_options} \
  ./%{main_module} \
  "$@"
