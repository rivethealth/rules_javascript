#!/bin/sh -e
cd nodejs/test/bazel
env -i bazel run binary:bin | grep -q 'Hello world'
