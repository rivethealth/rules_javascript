#!/bin/sh -ex
cd ts-proto/test/bazel
unset RUNFILES_DIR
unset TEST_TMPDIR
bazel build basic:lib
[ "$(bazel run basic:bin)" = 'First Middle Last' ]
