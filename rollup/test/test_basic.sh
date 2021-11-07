#!/bin/sh -e
cd tests/rollup/bazel
env -i bazel build basic:bundle
