import * as path from "node:path";
import type { Configuration } from "webpack";
import { RequirePlugin } from "./resolve";

function getEnv(name: string): string {
  const value = process.env[name];
  if (value === undefined) {
    throw new Error(`Missing ${name}`);
  }
  return value;
}

const compilationMode = getEnv("COMPILATION_MODE");
const jsSourceMap = getEnv("JS_SOURCE_MAP");
const inputRoot = getEnv("WEBPACK_INPUT_ROOT");
const output = getEnv("WEBPACK_OUTPUT");

export async function configure(
  configPath: string,
  baseConfig: Configuration,
): Promise<Configuration> {
  const config: Configuration = { ...baseConfig };

  // use compilation_mode as default devtool
  if (config.devtool === undefined && jsSourceMap === "true") {
    config.devtool =
      compilationMode === "opt" ? "source-map" : "eval-source-map";
  }

  // use compilation_mode as default mode
  if (config.mode === undefined) {
    config.mode = compilationMode === "opt" ? "production" : "development";
  }

  config.output = config.output ? { ...config.output } : {};
  // use output
  config.output.path = path.resolve(output);

  // use input root as default context
  if (config.context === undefined) {
    config.context = path.resolve(inputRoot);
  }

  // use compilation_mode as default optimization
  config.optimization = config.optimization ? { ...config.optimization } : {};
  if (config.optimization.minimize === undefined) {
    config.optimization.minimize = compilationMode === "opt";
  }

  config.resolveLoader = config.resolveLoader
    ? { ...config.resolveLoader }
    : {};
  if (!config.resolveLoader.plugins) {
    config.resolveLoader.plugins = [];
  }
  // webpack resolves loaders itself...but really we just need it to use the
  // Node.js runtime
  config.resolveLoader.plugins = [
    ...config.resolveLoader.plugins,
    new RequirePlugin(),
  ];
  // don't escape symlink tree
  config.resolveLoader.symlinks = false;

  return config;
}
