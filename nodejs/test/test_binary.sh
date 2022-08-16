#!/bin/sh -e
cd nodejs/test/bazel
unset RUNFILES_DIR
unset TEST_TMPDIR
bazel run binary:bin | grep -q 'Hello world'
bazel run binary:bin_16 | grep -q 'Hello world'
