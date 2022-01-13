#!/bin/sh -e
cd commonjs/test/bazel
unset RUNFILES_DIR
unset TEST_TMPDIR
bazel run directory:bin | grep -q 'Hello world'
