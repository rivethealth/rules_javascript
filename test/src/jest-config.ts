export function jestConfig() {
  return {
    modulePathIgnorePatterns: [`${process.env.JEST_ROOT}/bazel/`],
    testPathIgnorePatterns: [`${process.env.JEST_ROOT}/bazel/`],
    testTimeout: 60 * 1000,
  };
}
