const commonjs = require("@rollup/plugin-commonjs");
const { nodeResolve } = require("@rollup/plugin-node-resolve");
const { terser } = require("rollup-plugin-terser");

module.exports = {
  input: `${process.env.ROLLUP_INPUT_ROOT}/index.js`,
  output: { compact: true, file: process.env.ROLLUP_OUTPUT, format: "cjs" },
  plugins: [
    commonjs(),
    nodeResolve(),
    terser({ format: { max_line_len: 120 } }),
  ],
};
