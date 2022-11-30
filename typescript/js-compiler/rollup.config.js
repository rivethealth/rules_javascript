const commonjs = require("@rollup/plugin-commonjs");
const { nodeResolve } = require("@rollup/plugin-node-resolve");

module.exports = {
  input: "src/main.js",
  external: [
    "argparse",
    "protobufjs",
    "protobufjs/minimal",
    "long",
    "tslib",
    "typescript",
  ],
  inlineDynamicImports: true,
  output: { file: "bundle.js" },
  plugins: [commonjs(), nodeResolve()],
};
