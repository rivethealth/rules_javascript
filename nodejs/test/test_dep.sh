#!/bin/sh -e
cd tests/nodejs/bazel
env -i bazel run dep:bin | grep -q 'Hello world'
