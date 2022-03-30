import * as path from "path";
import type { Configuration } from "webpack";

const compilationMode = process.env.COMPILATION_MODE;
const jsSourceMap = process.env.JS_SOURCE_MAP;
const inputRoot = process.env.WEBPACK_INPUT_ROOT;
const output = process.env.WEBPACK_OUTPUT;

if (!compilationMode) {
  throw new Error("Missing COMPILATION_MODE");
}

if (!jsSourceMap) {
  throw new Error("Missing JS_SOURCE_MAP");
}

if (!inputRoot) {
  throw new Error("Missing WEBPACK_INPUT_ROOT");
}

export async function configure(
  configPath: string,
  baseConfig: Configuration,
): Promise<Configuration> {
  const config: Configuration = { ...baseConfig };

  if (config.devtool === undefined && jsSourceMap === "true") {
    config.devtool =
      compilationMode === "opt" ? "source-map" : "eval-source-map";
  }

  if (config.mode === undefined) {
    config.mode = compilationMode === "opt" ? "production" : "development";
  }

  config.output = config.output ? { ...config.output } : {};
  config.output.path = path.resolve(output);
  if (typeof config.entry === "string") {
    config.entry = path.resolve(inputRoot, config.entry);
  } else if (config.entry) {
    config.entry = Object.fromEntries(
      Object.entries(config.entry).map(([name, path_]) => [
        name,
        path.resolve(inputRoot, path_),
      ]),
    );
  }

  config.optimization = config.optimization ? { ...config.optimization } : {};
  if (config.optimization.minimize === undefined) {
    config.optimization.minimize = compilationMode === "opt";
  }

  config.resolveLoader = config.resolveLoader
    ? { ...config.resolveLoader }
    : {};
  config.resolveLoader.symlinks = false;

  return config;
}
