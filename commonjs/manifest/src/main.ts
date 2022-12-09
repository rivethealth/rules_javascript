import { workerMain } from "@better-rules-javascript/bazel-worker";

workerMain(async () => {
  const { ManifestWorker, ManifestWorkerError } = await import("./worker");

  const worker = new ManifestWorker();
  return async (a) => {
    try {
      await worker.run(a);
    } catch (error) {
      if (error instanceof ManifestWorkerError) {
        return { exitCode: 2, output: error.message };
      }
      return {
        exitCode: 1,
        output: String(error instanceof Error ? error.stack : error),
      };
    }
    return { exitCode: 0, output: "" };
  };
});
