#!/bin/sh -e
cd "$(dirname "$0")/.."

if [ "$1" = check ]; then
    TARGET=buildifier_check
else
    TARGET=buildifier
fi

bazel run $TARGET
