#!/bin/sh -e
cd nodejs/test/bazel
unset RUNFILES_DIR
unset TEST_TMPDIR
bazel run dep:bin | grep -q 'Hello world'
bazel run dep:bin_16 | grep -q 'Hello world'
