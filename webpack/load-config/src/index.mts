import * as configure from "@better-rules-javascript/webpack-config";
import * as path from "node:path";
import type { Configuration } from "webpack";

const runfilesDir = process.env.RUNFILES_DIR!;
const configRunfilePath = process.env.WEBPACK_CONFIG!;

const configPath = path.resolve(runfilesDir, configRunfilePath);
const { default: baseConfig } = await import(configPath);

const result: Promise<Configuration> = configure.configure(
  configPath,
  baseConfig,
);

export default result;
