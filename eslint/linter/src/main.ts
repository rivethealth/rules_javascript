import { ArgumentParser } from "argparse";
import * as fs from "fs";
import { ESLint, Linter } from "eslint";
import { run } from "@better-rules-javascript/bazel-worker";

class EslintWorker {
  constructor(private linter: Linter, private readonly options: any) {}

  async run(a: string[]) {
    const parser = new ArgumentParser();
    parser.add_argument("--config");
    parser.add_argument("input");
    parser.add_argument("output");
    const args = parser.parse_args(a);
    const input = fs.readFileSync(args.input, "utf8");

    const report = this.linter.verifyAndFix(input, this.options, args.input);

    fs.writeFileSync(args.output, report.output, "utf8");
    return report.messages.map((message) => messageString(args.input, message));
  }
}

function messageString(file: string, message: Linter.LintMessage) {
  return `${file} ${message.line}:${message.column}: ${message.ruleId} ${message.message}`;
}

function pluginPackage(name: string) {
  if (name.includes("/")) {
    const [scope, package_] = name.split("/", 2);
    return `${scope}/eslint-plugin-${package_}`;
  }
  if (name.startsWith("@")) {
    return `${name}/eslint-plugin`;
  }
  return `eslint-plugin-${name}`;
}

async function resolveOptions(file: string) {
  const esLint = new ESLint({ overrideConfigFile: file, useEslintrc: false });
  return await esLint.calculateConfigForFile("_dummy");
}

async function createLinter(options: any) {
  const linter = new Linter();
  if (options.parser) {
    linter.defineParser(options.parser, await import(options.parser));
  }
  linter.defineRules(options);
  for (const plugin of options.plugins) {
    const module = await import(pluginPackage(plugin));
    if (module.rules) {
      for (const name in module.rules) {
        linter.defineRule(`${plugin}/${name}`, module.rules[name]);
      }
    }
  }
  return linter;
}

run(async (a) => {
  const parser = new ArgumentParser();
  parser.add_argument("--config", { required: true });
  const args = parser.parse_args(a);

  const options = await resolveOptions(args.config);
  const linter = await createLinter(options);
  const worker = new EslintWorker(linter, options);

  return async (a) => {
    try {
      const errors = await worker.run(a);
      if (errors.length) {
        return { exitCode: 2, output: errors.join("\n") };
      }
    } catch (e) {
      return { exitCode: 1, output: String(e?.stack || e) };
    }
    return { exitCode: 0, output: "" };
  };
});
