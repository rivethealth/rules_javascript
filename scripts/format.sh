#!/bin/bash -e
cd "$(dirname "$0")/.."

if [ "$1" = check ]; then
    ARG=
else
    ARG=write
fi

bazel run :buildifier_format -- $ARG
bazel run :prettier_format -- $ARG
