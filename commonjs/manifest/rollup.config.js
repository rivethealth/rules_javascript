const commonjs = require("@rollup/plugin-commonjs");
const { nodeResolve } = require("@rollup/plugin-node-resolve");

module.exports = {
  inlineDynamicImports: true,
  input: "src/main.js",
  output: { file: "bundle.js" },
  plugins: [commonjs(), nodeResolve()],
};
