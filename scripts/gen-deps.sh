#!/bin/sh -e
cd "$(dirname "$0")/.."

bazel run npm/yarn-gen:bin -- \
    --refresh \
    rules/npm_data.bzl
