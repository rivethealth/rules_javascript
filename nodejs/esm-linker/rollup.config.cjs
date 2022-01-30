const { nodeResolve } = require("@rollup/plugin-node-resolve");

module.exports = {
  input: `${process.env.ROLLUP_INPUT_ROOT}/index.js`,
  output: { compact: true, file: process.env.ROLLUP_OUTPUT, format: "cjs" },
  plugins: [nodeResolve()],
};
