import { Config } from "@jest/types";
import { findFiles } from "./fs";
import { DEFAULT_TEST_REGEX } from "./jest";
import * as path from "path";
import { escapeRegex } from "./regex";

export interface ConfigureOptions {
  root: string;
  shardIndex: number;
  totalShards: number;
  target: string;
  junitOutput: string;
}

export class Configuration {
  constructor(private readonly runfilesDir: string) {}

  configure(config: Config.InitialOptions, options: ConfigureOptions) {
    this._configureFs(config);
    this._configureJunit(config, options.target, options.junitOutput);
    this._configureSnapshots(config);
    this._configureTests(
      config,
      options.root,
      options.shardIndex,
      options.totalShards,
    );
  }

  private _configureFs(config: Config.InitialOptions) {
    if (!config.haste) {
      config.haste = {};
    }

    config.haste.forceNodeFilesystemAPI = true;
  }

  private _configureJunit(
    config: Config.InitialOptions,
    target: string,
    junitOutput: string,
  ) {
    // JUnit
    if (!config.reporters) {
      config.reporters = ["default"];
    }
    config.reporters.push([
      require.resolve("jest-junit"),
      {
        suiteName: target,
        includeConsoleOutput: true,
        classNameTemplate: "{classname}",
        titleTemplate: "{title}",
        outputFile: junitOutput,
      },
    ]);
  }

  private _configureSnapshots(config: Config.InitialOptions) {
    config.snapshotResolver = require.resolve("./snapshot-resolver");
  }

  private _configureTests(
    config: Config.InitialOptions,
    root: string,
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
    for (const { path: path_, entry } of findFiles(
      path.resolve(this.runfilesDir, root),
    )) {
      if (entry.isFile() && testRegexes.some((regex) => regex.test(path_))) {
        filePaths.push(path_);
      }
    }

    config.testRegex = filePaths
      .filter((_, i) => i % totalShards === shardIndex)
      .map((path) => `${escapeRegex(path)}$`);
  }
}
