#!/bin/sh -e
ROOT="$(realpath "$(dirname "$0")")/.."

cd "$ROOT"
yarn install
bazel run @better_rules_javascript//rules/npm/gen:bin -- \
    yarn \
    --package "$(pwd)/package.json" \
    --lock "$(pwd)/yarn.lock" \
    "$(pwd)/rules/bzl/npm_data.bzl"

cd "$ROOT/tests"
yarn install
bazel run @better_rules_javascript//rules/npm/gen:bin -- \
    yarn \
    --package "$(pwd)/package.json" \
    --lock "$(pwd)/yarn.lock" \
    "$(pwd)/npm_data.bzl"
