const commonjs = require("@rollup/plugin-commonjs");
const { nodeResolve } = require("@rollup/plugin-node-resolve");

module.exports = {
  input: "src/main.js",
  external: ["argparse"],
  inlineDynamicImports: true,
  output: { file: "bundle.js" },
  plugins: [commonjs(), nodeResolve()],
};
