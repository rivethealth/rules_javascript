import linkerPlugin from '@angular/compiler-cli/linker/babel';
import webpack from "webpack";

const compilationMode = process.env.COMPILATION_MODE;

const plugins = [
  new webpack.DefinePlugin({
    ngDevMode: process.env.COMPILATION_MODE == "opt" ? JSON.stringify(false) : undefined,
    ngJitMode: process.env.COMPILATION_MODE == "opt" ? JSON.stringify(false) : undefined,
    "process.env.NODE_ENV": JSON.stringify(
      compilationMode == "opt" ? "production" : "development",
    ),
  })
];

const rules = [];
if (compilationMode === "opt") {
  rules.push(
    {
      test: /\.[cm]?js$/,
      use: {
        loader: 'babel-loader',
        options: { plugins: [linkerPlugin] },
      },
    });
}

export default {
  entry: `main.${compilationMode === "opt" ? "prod" : "dev"}.js`,
  module: { rules },
  plugins,
};
