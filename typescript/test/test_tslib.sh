#!/bin/sh -ex
cd typescript/test/bazel
unset RUNFILES_DIR
unset TEST_TMPDIR
bazel info output_path
bazel build tslib:lib tslib:nolib
grep -q 'require("tslib")' "$(bazel info bazel-bin)/tslib/root_lib/example.js"
! grep -q 'require("tslib")' "$(bazel info bazel-bin)/tslib/root_nolib/example.js"
