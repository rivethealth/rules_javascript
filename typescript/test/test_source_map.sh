#!/bin/bash -ex
cd typescript/test/bazel
unset RUNFILES_DIR
unset TEST_TMPDIR
bazel run source-map:bin |& grep -q 'lib\.ts:2:9'
