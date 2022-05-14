#!/bin/bash -e
cd nodejs/test/bazel
unset RUNFILES_DIR
unset TEST_TMPDIR
[ "$(bazel run module-details:bin)" == $'@better-rules-javascript-test/module-details\nmain.js' ]
