#!/bin/sh -e
cd nodejs/test/bazel
unset RUNFILES_DIR
bazel run binary:bin | grep -q 'Hello world'
