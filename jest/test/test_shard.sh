#!/bin/sh -e
cd jest/test/bazel
unset RUNFILES_DIR
unset TEST_TMPDIR
bazel info output_base
bazel test shard:test
