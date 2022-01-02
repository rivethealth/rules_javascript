#!/bin/sh -e
cd angular/test/bazel
unset RUNFILES_DIR
unset TEST_TMPDIR
bazel build material:bundle
bazel build --compilation_mode=opt material:bundle
