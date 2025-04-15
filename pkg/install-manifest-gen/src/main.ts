import { workerMain } from "@better-rules-javascript/bazel-worker";
import { ArgumentParser } from "argparse";
import { InstallManifestGenWorker } from "./worker";

workerMain(async (a) => {
  const parser = new ArgumentParser();
  parser.parse_args(a);

  const worker = new InstallManifestGenWorker();

  return async (a) => {
    try {
      await worker.run(a);
    } catch (error) {
      return {
        exitCode: 1,
        output: error instanceof Error ? error.stack! : String(error),
      };
    }
    return { exitCode: 0, output: "" };
  };
});
