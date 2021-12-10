import { ArgumentParser } from "argparse";
import * as fs from "fs";
import * as path from "path";
import * as ts from "typescript";
import { run } from "@better_rules_javascript/worker";

function printError(error: ts.Diagnostic): void {
  if (!error) {
    return;
  }
  console.log(`${error.file && error.file.fileName}: ${error.messageText}`);
}

class JsWorker {
  run(a: string[]) {
    const parser = new ArgumentParser();
    parser.add_argument("--config", { required: true });
    parser.add_argument("--map", { required: true });
    parser.add_argument("--js", { required: true });
    parser.add_argument("src");
    const args = parser.parse_args(a);

    const input = fs.readFileSync(args.src, "utf8");
    const { config, error } = ts.parseConfigFileTextToJson(
      args.config,
      fs.readFileSync(args.config, "utf8"),
    );
    if (error) {
      printError(error);
      process.exitCode = 1;
      return;
    }
    const settings = ts.convertCompilerOptionsFromJson(
      config.compilerOptions,
      path.dirname(args.config),
    );
    for (const err of settings.errors) {
      printError(err);
    }
    if (!settings.options) {
      process.exitCode = 1;
      return;
    }
    const result = ts.transpileModule(input, {
      fileName: args.src,
      compilerOptions: settings.options,
    });
    for (const diagnostic of result.diagnostics) {
      if (diagnostic.file) {
        const { line, character } =
          diagnostic.file.getLineAndCharacterOfPosition(diagnostic.start!);
        const message = ts.flattenDiagnosticMessageText(
          diagnostic.messageText,
          "\n",
        );
        console.log(
          `${diagnostic.file.fileName} (${line + 1},${
            character + 1
          }): ${message}`,
        );
      } else {
        console.log(
          ts.flattenDiagnosticMessageText(diagnostic.messageText, "\n"),
        );
      }
    }

    fs.mkdirSync(path.dirname(args.js), { recursive: true });
    fs.writeFileSync(args.js, result.outputText, "utf8");

    fs.mkdirSync(path.dirname(args.map), { recursive: true });
    fs.writeFileSync(args.map, result.sourceMapText, "utf8");
  }
}

run(async () => {
  const worker = new JsWorker();
  return async (a) => {
    try {
      worker.run(a);
    } catch (e) {
      return { exitCode: 1, output: String(e?.stack || e) };
    }
    return { exitCode: 0, output: "" };
  };
});
