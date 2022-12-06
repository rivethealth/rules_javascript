# Developing

## Format

To format, run `bazel run :format`.

To lint, run `bazel run :lint`.

## NPM

After updating `package.json`, run `bazel run tools/npm:resolve` to resolve the
packages.

## Bazel Pacakges

After creating or deleting Bazel packages, run `bazel run :bazelrc_gen` to
update `--deleted_packages`, necessary for formatting and integration testing.

## Bootstrapped JS

Some JS build products need to be boostrapped. They are checking into version
control.

To refresh these, run `bazel run :js_gen`, which re-builds and copies them to
source tree. If that breaks, you'll have to rollback to the last good state of
the generated files.
