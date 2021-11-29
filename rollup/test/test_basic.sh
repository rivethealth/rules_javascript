#!/bin/sh -e
cd rollup/test/bazel
unset RUNFILES_DIR
bazel build basic:bundle
