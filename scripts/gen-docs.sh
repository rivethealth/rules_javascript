#!/bin/sh -e
cd "$(dirname "$0")/.."
set -x

rm -fr docs/stardoc
mkdir -p docs/stardoc

(cd rules; bazel build :docs)
tar xf "$(cd rules; bazel info bazel-bin)/docs.tar" -C docs/stardoc
find docs/stardoc -size 0 -print0 | while read path; do
    rm $path
done
