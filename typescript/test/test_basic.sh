#!/bin/sh -e
cd typescript/test/bazel
unset RUNFILES_DIR
unset TEST_TMPDIR
bazel build basic:lib
