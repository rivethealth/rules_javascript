import { ArgumentParser } from "argparse";
import { run } from "@better-rules-javascript/bazel-worker";
import * as ts from "typescript";

class DtsWorker {
  run(a) {
    const parser = new ArgumentParser();
    parser.add_argument("--lib", { action: "append" });
    parser.add_argument("--manifest", { required: true });
    parser.add_argument("--dts", { action: "append" });
    parser.add_argument("--src", { action: "append", nargs: 2 });
    const args = parser.parse_args(a);

    const host = ts.createCompilerHost({});
    const libs = [
      "lib.d.ts",
      ...(args.lib || []).map((name) => `lib.${name}.d.ts`),
    ];
    const options: ts.CompilerOptions = {
      emitDeclarationOnly: true,
      declaration: true,
      lib: libs,
      module: ts.ModuleKind.ESNext,
      noEmitOnError: true,
      target: ts.ScriptTarget.ESNext,
    };
    const program = ts.createProgram(
      [...(args.dts || []), ...args.src.map(([source]) => source)],
      options,
      host,
    );

    const result = program.emit();

    const diagnostics = ts
      .getPreEmitDiagnostics(program)
      .concat(result.diagnostics);

    if (!diagnostics.length) {
      return;
    }

    for (const diagnostic of diagnostics) {
      if (diagnostic.file) {
        const { line, character } =
          diagnostic.file.getLineAndCharacterOfPosition(diagnostic.start);
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

    process.exit(1);
  }
}

run(async () => {
  const worker = new DtsWorker();

  return async (a) => {
    try {
      worker.run(a);
    } catch (e) {
      return { exitCode: 1, output: String(e?.stack || e) };
    }
    return { exitCode: 0, output: "" };
  };
});
