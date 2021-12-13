#!/bin/sh -e
cd jest/test/bazel
unset RUNFILES_DIR
unset TEST_TMPDIR
bazel info output_path
bazel test basic:test
! bazel test basic:test_fail
