#!/usr/bin/env bash
set -euo pipefail
# For additional options to the Node.js runtime, use the
# NODE_OPTIONS environment variable.

%{env} exec node \
  %{node_options} \
  "$(dirname "$0")"/%{main_module} \
  "$@"
