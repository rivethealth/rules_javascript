#!/bin/sh -ex
cd "$(dirname "$0")/.."

if [ "$1" = check ]; then
    TARGET=buildifier_check
else
    TARGET=buildifier
fi

bazel run $TARGET

bazel query 'kind("js_library", //...)' \
    | xargs -r bazel build --aspects //tools/bzl:aspects.bzl%format --output_groups=formatted
bazel query 'kind("prettier_format", //...)' | xargs -r bazel build

if [ "$1" = check ]; then
    ARG=
else
    ARG=write
fi

BAZEL_BIN="$(bazel info bazel-bin)"
bazel query 'kind("js_library", //...) + kind("prettier_format", //...)' --output package | while IFS= read -r package; do
    "$BAZEL_BIN/$package/_format/bin" "$ARG"
done
