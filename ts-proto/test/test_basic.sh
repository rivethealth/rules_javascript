#!/bin/sh -ex
cd ts-proto/test/bazel
unset RUNFILES_DIR
unset TEST_TMPDIR
bazel info output_path
bazel build basic:lib
[ "$(bazel run basic:bin)" = 'First Middle Last' ]
