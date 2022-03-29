#!/bin/sh -e
cd angular/test/bazel
unset RUNFILES_DIR
unset TEST_TMPDIR
bazel info output_path
bazel build basic:lib
bazel build --compilation_mode=opt basic:lib
