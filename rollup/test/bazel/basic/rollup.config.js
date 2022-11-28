const commonjs = require("@rollup/plugin-commonjs");
const { nodeResolve } = require("@rollup/plugin-node-resolve");

module.exports = {
  input: "index.js",
  output: { file: "bundle.js" },
  plugins: [commonjs(), nodeResolve()],
};
