import { configure } from "@better-rules-javascript/webpack-config";
import * as path from "path";

const runfilesDir = process.env.RUNFILES_DIR;
const configRunfilePath = process.env.WEBPACK_CONFIG;

const configPath = path.resolve(runfilesDir, configRunfilePath);
const { default: baseConfig } = await import(configPath);

export default configure(configPath, baseConfig);
