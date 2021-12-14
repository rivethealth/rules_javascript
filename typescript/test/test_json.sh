#!/bin/sh -e
cd typescript/test/bazel
unset RUNFILES_DIR
unset TEST_TMPDIR
bazel info output_base
bazel build json:lib
