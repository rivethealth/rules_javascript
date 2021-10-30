#!/bin/bash -ex
cd "$(dirname "$0")/.."

if [ "$1" = check ]; then
    TARGET=buildifier_check
else
    TARGET=buildifier
fi

bazel run $TARGET

bazel query 'kind("prettier_format", //...)' | xargs -r bazel build
(bazel query 'kind("js_library", //...) + kind("ts_library", //...) - //rules:tsc_ts') \
    | xargs -r bazel build --aspects //tools:aspects.bzl%format --output_groups=formatted

if [ "$1" = check ]; then
    ARG=
else
    ARG=write
fi

bazel run :prettier_format $ARG
bazel run :prettier_aspect_format $ARG
