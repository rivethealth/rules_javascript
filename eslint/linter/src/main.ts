import { workerMain } from "@better-rules-javascript/bazel-worker";
import { ArgumentParser } from "argparse";
import { ESLint } from "eslint";
import { EslintWorker } from "./worker";

async function createEslint(file: string) {
  return new ESLint({
    fix: true,
    overrideConfigFile: file,
    useEslintrc: false,
  });
}

workerMain(async (a) => {
  const parser = new ArgumentParser();
  parser.add_argument("--config", { required: true });
  const args = parser.parse_args(a);

  const worker = new EslintWorker(eslint);

  return async (a) => {
    try {
      const errors = await worker.run(a);
      if (errors.length > 0) {
        return { exitCode: 2, output: errors.join("\n") };
      }
    } catch (error) {
      return {
        exitCode: 1,
        output: error instanceof Error ? error.stack! : String(error),
      };
    }
    return { exitCode: 0, output: "" };
  };
});
