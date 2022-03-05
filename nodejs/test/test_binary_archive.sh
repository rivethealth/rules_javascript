#!/bin/sh -e
cd nodejs/test/bazel
unset RUNFILES_DIR
unset TEST_TMPDIR
bazel build binary-archive:archive
