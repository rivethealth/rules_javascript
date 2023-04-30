import commonjs from "@rollup/plugin-commonjs";
import { nodeResolve } from "@rollup/plugin-node-resolve";
import type { RollupOptions } from "rollup";

const config: RollupOptions = {
  input: "src/index.js",
  output: { file: "index.js" },
  plugins: [commonjs(), nodeResolve()],
};

export = config;
