#!/bin/sh -ex
cd webpack/test/bazel
unset RUNFILES_DIR
unset TEST_TMPDIR
bazel build basic:bundle
grep -q eval "$(bazel info bazel-bin)"/basic/bundle/main.js
bazel build --compilation_mode=opt basic:bundle
! grep -q eval "$(bazel info --compilation_mode=opt bazel-bin)"/basic/bundle/main.js
