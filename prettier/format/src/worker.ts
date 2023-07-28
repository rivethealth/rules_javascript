import { ArgumentParser } from "argparse";
import { readFile, writeFile } from "node:fs/promises";
import prettier from "prettier";

export class PrettierWorker {
  constructor(private readonly options: any) {}

  async run(a: string[]) {
    const parser = new ArgumentParser();
    parser.add_argument("input");
    parser.add_argument("output");
    const args = parser.parse_args(a);
    const input = await readFile(args.input, "utf8");
    const output = await prettier.format(input, {
      ...this.options,
      filepath: args.input,
    });
    await writeFile(args.output, output, "utf8");
  }
}
