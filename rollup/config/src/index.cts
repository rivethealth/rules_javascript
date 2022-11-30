import { configure } from "./config";
import * as path from "path";

const configPath = process.env.ROLLUP_CONFIG!;

const baseConfig = require(path.resolve(configPath));

export = configure(baseConfig);
