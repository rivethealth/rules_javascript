import { ArgumentParser } from "argparse";
import * as fs from "node:fs";
import prettier from "prettier";

export class PrettierWorker {
  constructor(private readonly options: any) {}

  run(a: string[]) {
    const parser = new ArgumentParser();
    parser.add_argument("input");
    parser.add_argument("output");
    const args = parser.parse_args(a);
    const input = fs.readFileSync(args.input, "utf8");
    const output = prettier.format(input, {
      ...this.options,
      filepath: args.input,
    });
    fs.writeFileSync(args.output, output, "utf8");
  }
}
