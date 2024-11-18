import { Config } from "@jest/types";
import { relative } from "node:path";

export class Configuration {
  configure(config: Config.InitialOptions) {
    this._configureFs(config);
    this._configureReporters(config);
    this._configureSnapshots(config);
  }

  private _configureFs(config: Config.InitialOptions) {
    if (!config.haste) {
      config.haste = {};
    }

    config.haste.forceNodeFilesystemAPI = true;
  }

  private _configureReporters(config: Config.InitialOptions) {
    if (!config.reporters) {
      config.reporters = ["default"];
    }
    if (config.reporters.some(([name]) => name === "jest-junit")) {
      return;
    }
    config.reporters.push([
      "jest-junit",
      {
        classNameTemplate: ({ classname }: any) => classname || "-",
        includeShortConsoleOutput: "true",
        outputFile: process.env.XML_OUTPUT_FILE,
        suiteName: process.env.TEST_TARGET,
        suiteNameTemplate: ({ filepath }: any) =>
          relative(process.env.JEST_ROOT!, filepath),
        titleTemplate: "{title}",
      },
    ]);
  }

  private _configureSnapshots(config: Config.InitialOptions) {
    config.snapshotResolver = require.resolve("./snapshot-resolver");
  }
}
