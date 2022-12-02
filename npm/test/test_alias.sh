#!/bin/sh -e
cd npm/test/bazel
unset RUNFILES_DIR
unset TEST_TMPDIR
bazel run alias:bin
