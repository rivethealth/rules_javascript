import { ArgumentParser } from "argparse";
import * as fs from "fs";
import * as path from "path";
import * as ts from "typescript";
import { run } from "@better_rules_javascript/worker";
import { formatDiagnostics } from "./diagnostic";

interface Args {
  config: string;
  map: string;
  js: string;
  src: string;
}

class WorkerError extends Error {}

class JsWorker {
  run(a: string[]) {
    const parser = new ArgumentParser();
    parser.add_argument("--config", { required: true });
    parser.add_argument("--map", { required: true });
    parser.add_argument("--js", { required: true });
    parser.add_argument("src");
    const args: Args = parser.parse_args(a);

    const input = fs.readFileSync(args.src, "utf8");
    const parsed = ts.getParsedCommandLineOfConfigFile(
      args.config,
      {},
      {
        ...ts.sys,
        onUnRecoverableConfigFileDiagnostic: (error) => {
          throw new WorkerError(formatDiagnostics([error]));
        },
      },
    )!;
    const errors = parsed.errors.filter(
      (diagnostic) => diagnostic.code !== 18002,
    );
    if (errors.length) {
      throw new WorkerError(formatDiagnostics(errors));
    }
    const result = ts.transpileModule(input, {
      fileName: args.src,
      compilerOptions: parsed.options,
    });
    if (result.diagnostics.length) {
      throw new WorkerError(formatDiagnostics(result.diagnostics));
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
      if (e instanceof WorkerError) {
        return { exitCode: 2, output: e.message };
      }
      return { exitCode: 1, output: String(e?.stack || e) };
    }
    return { exitCode: 0, output: "" };
  };
});
