import { workerMain } from "@better-rules-javascript/bazel-worker";
import { ArgumentParser } from "argparse";

interface Args {
  config?: string;
}

workerMain(async (a) => {
  const parser = new ArgumentParser({ prog: "prettier-format" });
  parser.add_argument("--config", { help: "Configuration path" });
  const args: Args = parser.parse_args(a);

  const { PrettierWorker } = await import("./worker");
  const worker = new PrettierWorker(args.config);

  return async (a) => {
    try {
      await worker.run(a);
    } catch (error) {
      return {
        exitCode: 1,
        output: (error instanceof Error && error.stack) || String(error),
      };
    }
    return { exitCode: 0, output: "" };
  };
});
