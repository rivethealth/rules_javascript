const path = require("path");
const { nodeResolve } = require("@rollup/plugin-node-resolve");

module.exports = {
  external: ["%{config}"],
  input: path.resolve(process.env.ROLLUP_INPUT_ROOT, "src/index.mjs"),
  output: { file: process.env.ROLLUP_OUTPUT, format: "es" },
  plugins: [nodeResolve()],
};
