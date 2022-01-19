import { Config } from "@jest/types";
import { findFiles } from "./fs";
import { DEFAULT_TEST_REGEX } from "./jest";
import * as path from "path";
import { escapeRegex } from "./regex";

export class Configuration {
  constructor(private readonly runfilesDir: string) {}

  configureFs(config: Config.InitialOptions) {
    if (!config.haste) {
      config.haste = {};
    }

    config.haste.hasteMapModulePath = path.join(__dirname, "./haste-map.js");
    config.haste.forceNodeFilesystemAPI = true;
  }

  configureJunit(config: Config.InitialOptions) {
    // JUnit
    if (!config.reporters) {
      config.reporters = ["default"];
    }
    config.reporters.push([
      "jest-junit",
      {
        suiteName: process.env.TEST_TARGET,
        includeConsoleOutput: true,
        classNameTemplate: "{classname}",
        titleTemplate: "{title}",
        outputFile: process.env.XML_OUTPUT_FILE,
      },
    ]);
  }

  configureTests(
    config: Config.InitialOptions,
    roots: string[],
    shardIndex: number,
    totalShards: number,
  ) {
    // test sharding
    if (config.testMatch) {
      console.error("testMatch not supported");
    }

    const testRegexTexts: string[] =
      typeof config.testRegex === "string"
        ? [config.testRegex]
        : config.testRegex instanceof Array
        ? config.testRegex
        : [DEFAULT_TEST_REGEX];
    const testRegexes = testRegexTexts.map((text) => new RegExp(text));

    const filePaths: string[] = [];
    for (const root of roots) {
      for (const { path: path_, entry } of findFiles(
        path.resolve(this.runfilesDir, root),
      )) {
        if (entry.isFile() && testRegexes.some((regex) => regex.test(path_))) {
          filePaths.push(path_);
        }
      }
    }
    config.roots = roots.map((root) => `${this.runfilesDir}/${root}`);

    config.testRegex = filePaths
      .filter((_, i) => i % totalShards === shardIndex)
      .map((path) => `${escapeRegex(path)}$`);

    config.testPathIgnorePatterns = [];
  }
}
