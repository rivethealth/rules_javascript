#!/bin/sh -e
cd nodejs/test/bazel
unset RUNFILES_DIR
unset TEST_TMPDIR
bazel run binary:bin | grep -q 'Hello world'
