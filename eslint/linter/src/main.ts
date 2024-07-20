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

  const eslint = await createEslint(args.config);
  const worker = new EslintWorker(eslint);

  return async (a) => {
    try {
      const messages = await worker.run(a);
      return {
        exitCode: messages.some(({ type }) => type === "error") ? 2 : 0,
        output: messages.map(({ content }) => content).join("\n"),
      };
    } catch (error) {
      return {
        exitCode: 1,
        output: error instanceof Error ? error.stack! : String(error),
      };
    }
  };
});
