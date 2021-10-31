#!/bin/bash -e
cd "$(dirname "$0")/.."

if [ "$1" = check ]; then
    ARG=
else
    ARG=write
fi

packages="$( \
    find . -not \( -path ./tests -prune \) \( -name BUILD -o -name BUILD.bazel \) \
    | sed -e 's:/[^/]*$::' -e 's:^\./::' -e 's:^:@better_rules_javascript_files//files/:' -e 's:/.$::' \
    | tr '\n' , \
    | sed 's/,$//' \
)"

bazel run "--deleted_packages=$packages" @better_rules_javascript//:buildifier_format -- $ARG
bazel run "--deleted_packages=$packages" @better_rules_javascript//:prettier_format -- $ARG
