import { Config } from "@jest/types";
import * as path from "path";
import { Configuration } from "./config";
import { touch } from "./fs";

const configRunfile = "%{config}";
const roots = JSON.parse("%{roots}");

const runfilesDir = process.env.RUNFILES_DIR!;
const totalShards = +(process.env.TEST_TOTAL_SHARDS || "1");
const shardIndex = +(process.env.TEST_SHARD_INDEX || "0");
const testShardStatus = process.env.TEST_SHARD_STATUS_FILE;

if (testShardStatus) {
  touch(testShardStatus);
}

let config: Config.InitialOptions;
if (configRunfile) {
  const configPath = `${runfilesDir}/${configRunfile}`;
  config = require(configPath);
  config.rootDir = path.dirname(configPath);
} else {
  config = <any>{};
}

const configuration = new Configuration(runfilesDir);
configuration.configureFs(config);
configuration.configureTests(config, roots, shardIndex, totalShards);
configuration.configureJunit(config);

module.exports = config;
