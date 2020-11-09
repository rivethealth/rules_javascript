#!/bin/sh -ex
cd "$(dirname "$0")/.."

if [ "$1" = check ]; then
    TARGET=buildifier_check
else
    TARGET=buildifier
fi

bazel run $TARGET

bazel query 'kind("js_library", //...)' 2> /dev/null \
    | xargs -r bazel build --aspects //tools/bzl:aspects.bzl%format --output_groups=formatted

if [ "$1" = check ]; then
    ARG=
else
    ARG=write
fi

BAZEL_BIN="$(bazel info bazel-bin)"
bazel query 'kind("js_library", //...)' --output package 2> /dev/null | while IFS= read -r package; do
    "$BAZEL_BIN/$package/_format/bin" "$ARG"
done
