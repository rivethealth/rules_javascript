#!/bin/sh -e
echo start
cd rollup/test/bazel
unset RUNFILES_DIR
unset TEST_TMPDIR
bazel build basic:bundle
