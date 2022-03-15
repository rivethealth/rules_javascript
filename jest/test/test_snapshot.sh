#!/bin/sh -e
cd jest/test/bazel
unset RUNFILES_DIR
unset TEST_TMPDIR
bazel info output_path
rm -f snapshot/__snapshots__/example.spec.js.snap
bazel run snapshot:test -- -u
[ -f snapshot/__snapshots__/example.spec.js.snap ]
rm snapshot/__snapshots__/example.spec.js.snap
