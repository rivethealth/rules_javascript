#!/bin/sh -e
cd "$(dirname "$0")/.."
set -x

rm -fr docs/stardoc
mkdir -p docs/stardoc
bazel build docs
tar x --touch -f "$(bazel info bazel-bin)/docs/docs.tar" -C docs/stardoc

bazel run :doctoc -- --maxlevel 2 --notitle README.md docs/*.md
