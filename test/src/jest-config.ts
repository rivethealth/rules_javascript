export function jestConfig() {
  return {
    moduleFileExtensions: ["js", "json"],
    modulePathIgnorePatterns: [`${process.env.JEST_ROOT}/bazel/`],
    testPathIgnorePatterns: [`${process.env.JEST_ROOT}/bazel/`],
    testTimeout: 60 * 1000,
  };
}
