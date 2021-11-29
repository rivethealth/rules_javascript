#!/bin/sh -e
cd nodejs/test/bazel
unset RUNFILES_DIR
bazel run dep:bin | grep -q 'Hello world'
