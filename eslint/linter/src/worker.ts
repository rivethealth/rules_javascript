import { ArgumentParser } from "argparse";
import { ESLint, Linter } from "eslint";
import * as fs from "node:fs";

export class EslintWorker {
  constructor(private eslint: ESLint) {}

  async run(a: string[]) {
    const parser = new ArgumentParser();
    parser.add_argument("input");
    parser.add_argument("output");
    const args = parser.parse_args(a);
    const input = await fs.promises.readFile(args.input, "utf8");

    const [report] = await this.eslint.lintText(input, {
      filePath: args.input,
    });

    await fs.promises.writeFile(args.output, report.output || input, "utf8");
    return report.messages.map((message) => ({
      content: messageString(args.input, message),
      type: ["info", "warning", "error"][message.severity],
    }));
  }
}

function messageString(file: string, message: Linter.LintMessage) {
  return `${file} ${message.line}:${message.column}: ${message.ruleId} ${message.message}`;
}
