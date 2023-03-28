import { workerMain } from "@better-rules-javascript/bazel-worker";
import { ArgumentParser } from "argparse";
import prettier from "prettier";

workerMain(async (a) => {
  const parser = new ArgumentParser();
  parser.add_argument("--config");
  const args = parser.parse_args(a);

  const { PrettierWorker } = await import("./worker");

  const options =
    args.config &&
    prettier.resolveConfig.sync(args.config, { config: args.config });
  const worker = new PrettierWorker(options);

  return async (a) => {
    try {
      worker.run(a);
    } catch (error) {
      return {
        exitCode: 1,
        output: error instanceof Error ? error.stack : String(error),
      };
    }
    return { exitCode: 0, output: "" };
  };
});
