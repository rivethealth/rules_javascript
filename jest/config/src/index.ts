import { Config } from "@jest/types";
import { Configuration } from "./config";
import { touch } from "./fs";

const configPath = process.env.JEST_CONFIG;
const rootPath = process.env.JEST_ROOT!;
const testShardStatusPath = process.env.TEST_SHARD_STATUS_FILE;

if (testShardStatusPath) {
  touch(testShardStatusPath);
}

const config: Config.InitialOptions = configPath ? require(configPath) : {};
config.rootDir = rootPath;

const configuration = new Configuration();
configuration.configure(config);

module.exports = config;
