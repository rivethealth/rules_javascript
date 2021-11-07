import commonjs from "@rollup/plugin-commonjs";
import { nodeResolve } from "@rollup/plugin-node-resolve";
import hypothetical from "rollup-plugin-hypothetical";
// import ignore from "rollup-plugin-ignore"
// import { terser } from "rollup-plugin-terser";

export default {
  input: `${process.env.ROLLUP_INPUT_ROOT}/index.js`,
  output: { file: process.env.ROLLUP_OUTPUT, format: "cjs" },
  plugins: [
    hypothetical({
      allowFallthrough: true,
      files: { pnpapi: "" },
      leaveIdsAlone: true,
    }),
    /*terser(),*/ commonjs(),
    /*ignore(['graceful-fs']),*/ nodeResolve(),
  ],
};
