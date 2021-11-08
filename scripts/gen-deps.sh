#!/bin/sh -e
cd "$(dirname "$0")/.."

bazel run @better_rules_javascript//npm/yarn-gen:bin -- \
    --refresh \
    rules/npm_data.bzl
