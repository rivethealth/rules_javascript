import { ArgumentParser } from "argparse";
import * as fs from "fs";
import * as prettier from "prettier";
import { run } from "@better_rules_javascript/worker";

class PrettierWorker {
  constructor(private readonly options: any) {}

  run(a: string[]) {
    console.error("here");
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
    console.error("there");
  }
}

run(async (a) => {
  const parser = new ArgumentParser();
  parser.add_argument("--config");
  const args = parser.parse_args(a);

  const options =
    args.config &&
    prettier.resolveConfig.sync(args.config, { config: args.config });
  const worker = new PrettierWorker(options);

  return async (a) => {
    try {
      worker.run(a);
    } catch (e) {
      return { exitCode: 1, output: String(e?.stack || e) };
    }
    return { exitCode: 0, output: "" };
  };
});
