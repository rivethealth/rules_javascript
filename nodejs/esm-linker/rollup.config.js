const { nodeResolve } = require("@rollup/plugin-node-resolve");

module.exports = {
  input: "src/index.js",
  output: { file: "bundle.js" },
  plugins: [nodeResolve()],
};
