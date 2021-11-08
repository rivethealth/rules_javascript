#!/bin/sh -e
cd rollup/test/bazel
env -i bazel build basic:bundle
