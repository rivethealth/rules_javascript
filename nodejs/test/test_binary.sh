#!/bin/sh -e
cd tests/nodejs/bazel
env -i bazel run binary:bin | grep -q 'Hello world'
