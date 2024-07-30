import { ArgumentParser } from "argparse";
import { readFile, writeFile } from "node:fs/promises";
import { dirname } from "node:path";
import { pathToFileURL } from "node:url";
import { Options, format, resolveConfig } from "prettier";
import { load, resolve } from "./import";

export class PrettierWorker {
  constructor(private readonly configPath: string | undefined) {}

  async resolveConfig(path: string): Promise<Options | undefined> {
    if (this.configPath === undefined) {
      return;
    }
    const options = (await resolveConfig(path, { config: this.configPath }))!;
    if (options.plugins) {
      const contextUrl = pathToFileURL(dirname(this.configPath));
      options.plugins = await Promise.all(
        options.plugins.map(async (plugin) => {
          // in theory, should be able to just resolve the path, but for some reason
          // that dereferences symlinks
          if (typeof plugin === "string") {
            const path = await resolve(plugin, contextUrl.toString());
            const p = await load(path);
            plugin = p.default ?? p;
          }
          return plugin;
        }),
      );
    }
    return options;
  }

  async run(a: string[]) {
    const parser = new ArgumentParser();
    parser.add_argument("input");
    parser.add_argument("output");
    const args = parser.parse_args(a);
    const options = await this.resolveConfig(args.input);
    const input = await readFile(args.input, "utf8");
    const output = await format(input, { ...options, filepath: args.input });
    await writeFile(args.output, output, "utf8");
  }
}
