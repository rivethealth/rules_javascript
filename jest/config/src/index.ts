import { Config } from "@jest/types";
import * as path from "path";
import { Configuration } from "./config";
import { touch } from "./fs";

const configRunfile = process.env.JEST_CONFIG;
const runfilesDir = process.env.RUNFILES_DIR!;
const testShardStatusPath = process.env.TEST_SHARD_STATUS_FILE;

if (testShardStatusPath) {
  touch(testShardStatusPath);
}

let config: Config.InitialOptions;
if (configRunfile) {
  const configPath = path.resolve(runfilesDir, configRunfile);
  config = require(configPath);
  config.rootDir = path.dirname(configPath);
} else {
  config = <any>{};
}

const configuration = new Configuration();
configuration.configure(config);

module.exports = config;
