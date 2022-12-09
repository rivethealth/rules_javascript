import * as path from "node:path";

/**
 * @file Snapshot resolver that when `bazel run` is invoked, resolves to
 *     workspace sources, rather than inside the runfiles tree.
 * @see https://github.com/facebook/jest/blob/a20bd2c31e126fc998c2407cfc6c1ecf39ead709/packages/jest-snapshot/src/SnapshotResolver.ts
 */

const workspacePath = process.env.BUILD_WORKSPACE_DIRECTORY;

const cwd = process.cwd(); // workspace directory, inside runfiles tree

function resolveSnapshotPath(testPath: string, extension: string) {
  if (workspacePath !== undefined) {
    testPath = path.resolve(workspacePath, path.relative(cwd, testPath));
  }
  return path.join(
    path.join(path.dirname(testPath), "__snapshots__"),
    path.basename(testPath) + extension,
  );
}

function resolveTestPath(snapshotPath: string, extension: string) {
  if (workspacePath !== undefined) {
    snapshotPath = path.resolve(
      cwd,
      path.relative(workspacePath, snapshotPath),
    );
  }
  return path.resolve(
    path.dirname(snapshotPath),
    "..",
    path.basename(snapshotPath, extension),
  );
}

const testPathForConsistencyCheck = path.posix.join(
  cwd,
  "consistency_check",
  "__tests__",
  "example.test.js",
);

export default {
  resolveSnapshotPath,
  resolveTestPath,
  testPathForConsistencyCheck,
};
