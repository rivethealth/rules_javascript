import type { RollupOptions } from "rollup";

const config: RollupOptions = {
  input: "src/index.js",
  output: { file: "index.js" },
};

export = config;
