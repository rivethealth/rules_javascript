import commonjs from "@rollup/plugin-commonjs";
import { nodeResolve } from "@rollup/plugin-node-resolve";

export default {
  input: `${process.env.ROLLUP_INPUT_ROOT}/main.js`,
  output: { file: process.env.ROLLUP_OUTPUT, format: "cjs" },
  plugins: [commonjs(), nodeResolve()],
};
