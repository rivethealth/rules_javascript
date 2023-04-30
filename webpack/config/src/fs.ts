import CachedInputFileSystem = require("enhanced-resolve/lib/CachedInputFileSystem");
import * as fs from "node:fs";
import { Compiler } from "webpack";

export class FsPlugin {
  apply(compiler: Compiler) {
    compiler.hooks.afterPlugins.tap("FsPlugin", () => {
      // don't use graceful-fs
      compiler.inputFileSystem = <any>new CachedInputFileSystem(fs);
      compiler.intermediateFileSystem = fs;
      compiler.outputFileSystem = fs;
    });
  }
}
