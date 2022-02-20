const commonjs = require("@rollup/plugin-commonjs");
const { nodeResolve } = require("@rollup/plugin-node-resolve");

module.exports = {
  input: `${process.env.ROLLUP_INPUT_ROOT}/src/main.js`,
  external: [
    "argparse",
    "protobufjs",
    "protobufjs/minimal",
    "long",
    "tslib",
    "typescript",
  ],
  inlineDynamicImports: true,
  output: { file: process.env.ROLLUP_OUTPUT, format: "cjs" },
  plugins: [commonjs(), nodeResolve()],
};
