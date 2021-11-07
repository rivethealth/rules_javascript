import commonjs from "@rollup/plugin-commonjs";
import { nodeResolve } from "@rollup/plugin-node-resolve";

export default {
  input: "fs-gen-js/main.js",
  output: {
    file: "fs-gen.js",
    format: "cjs",
  },
  plugins: [commonjs(), nodeResolve()],
};
