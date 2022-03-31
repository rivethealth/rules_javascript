import { Config } from "@jest/types";

export class Configuration {
  configure(config: Config.InitialOptions) {
    this._configureFs(config);
    this._configureSnapshots(config);
  }

  private _configureFs(config: Config.InitialOptions) {
    if (!config.haste) {
      config.haste = {};
    }

    config.haste.forceNodeFilesystemAPI = true;
  }

  private _configureSnapshots(config: Config.InitialOptions) {
    config.snapshotResolver = require.resolve("./snapshot-resolver");
  }
}
