#!/bin/sh -e
echo start
cd webpack/test/bazel
unset RUNFILES_DIR
unset TEST_TMPDIR
bazel info output_path
bazel build basic:bundle
[ "$(bazel run basic:bin)" = Example ]
