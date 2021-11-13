#!/bin/bash -e
cd "$(dirname "$0")/.."

if [ "$1" = check ]; then
    ARG=
else
    ARG=write
fi

bazel run @better_rules_javascript//:eslint_lint -- $ARG
