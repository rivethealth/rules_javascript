#!/bin/bash -e
if [ -z "$BUILD_WORKSPACE_DIRECTORY" ]; then
    cd "$(bazel info workspace)"
else
    cd "$BUILD_WORKSPACE_DIRECTORY"
fi

bazel query %{query} | xargs -r bazel build

bazel_bin="$(bazel info bazel-bin)"
bazel query %{query} | while IFS= read -r target; do
    target="${target#//}"
    target="${target//://}"
    "$bazel_bin/$target/"%{path} "$@"
done
