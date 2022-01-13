#!/bin/sh -e
cd javascript/test/bazel
unset RUNFILES_DIR
unset TEST_TMPDIR
bazel build directory:lib
