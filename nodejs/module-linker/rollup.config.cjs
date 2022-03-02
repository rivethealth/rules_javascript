const commonjs = require("@rollup/plugin-commonjs");
const { nodeResolve } = require("@rollup/plugin-node-resolve");

module.exports = {
  input: `${process.env.ROLLUP_INPUT_ROOT}/src/index.js`,
  output: {
    compact: true,
    file: process.env.ROLLUP_OUTPUT,
    sourcemap: true,
    format: "cjs",
  },
  plugins: [commonjs(), nodeResolve()],
};
