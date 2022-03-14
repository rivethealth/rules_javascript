import { Config } from "@jest/types";
import * as path from "path";
import { Configuration } from "./config";
import { touch } from "./fs";

const configRunfile = process.env.JEST_CONFIG;
const root = process.env.JEST_ROOT;

const runfilesDir = process.env.RUNFILES_DIR!;
const totalShards = +(process.env.TEST_TOTAL_SHARDS || "1");
const shardIndex = +(process.env.TEST_SHARD_INDEX || "0");
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

const configuration = new Configuration(runfilesDir);
configuration.configureFs(config);
configuration.configureTests(config, root, shardIndex, totalShards);
configuration.configureJunit(config);

module.exports = config;
