export function jestConfig() {
  return {
    testPathIgnorePatterns: [`${process.env.JEST_ROOT}/bazel/`],
    testTimeout: 60 * 1000,
  };
}
