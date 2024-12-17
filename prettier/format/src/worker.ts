import { ArgumentParser } from "argparse";
import { readFile, writeFile } from "node:fs/promises";
import { resolve } from "node:path";
import { Options, format, resolveConfig } from "prettier";

export class PrettierWorker {
  constructor(
    readonly configPath: string | undefined,
    readonly plugins: any[] | undefined,
  ) {}

  async run(a: string[]) {
    const parser = new ArgumentParser();
    parser.add_argument("input");
    parser.add_argument("output");
    const args = parser.parse_args(a);

    const resolvedConfig = await resolveConfig(resolve(args.input), {
      config: this.configPath,
    });
    const options: Options = {
      ...resolvedConfig,
      plugins: this.plugins,
    };

    const input = await readFile(args.input, "utf8");
    const output = await format(input, {
      ...options,
      filepath: args.input,
    });
    await writeFile(args.output, output, "utf8");
  }
}
