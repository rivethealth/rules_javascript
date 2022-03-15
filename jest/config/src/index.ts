import { Config } from "@jest/types";
import * as path from "path";
import { Configuration } from "./config";
import { touch } from "./fs";

const configRunfile = process.env.JEST_CONFIG;
const root = process.env.JEST_ROOT;
const runfilesDir = process.env.RUNFILES_DIR!;
const shardIndex = +(process.env.TEST_SHARD_INDEX || "0");
const testShardStatusPath = process.env.TEST_SHARD_STATUS_FILE;
const testTarget = process.env.TEST_TARGET!;
const totalShards = +(process.env.TEST_TOTAL_SHARDS || "1");
const xmlOutputFile = process.env.XML_OUTPUT_FILE!;

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
configuration.configure(config, {
  junitOutput: xmlOutputFile,
  root,
  shardIndex,
  target: testTarget,
  totalShards,
});

module.exports = config;
