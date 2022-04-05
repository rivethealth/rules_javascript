#!/bin/sh -e
cd npm/test/bazel
cat .bazelrc
unset RUNFILES_DIR
unset TEST_TMPDIR
bazel test --test_output=streamed audit
