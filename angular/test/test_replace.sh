#!/bin/sh -e
cd angular/test/bazel
unset RUNFILES_DIR
unset TEST_TMPDIR
bazel info output_path
bazel build replace:lib
bazel build --compilation_mode=opt replace:lib
