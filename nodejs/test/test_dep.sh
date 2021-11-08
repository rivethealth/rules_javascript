#!/bin/sh -e
cd nodejs/test/bazel
env -i bazel run dep:bin | grep -q 'Hello world'
