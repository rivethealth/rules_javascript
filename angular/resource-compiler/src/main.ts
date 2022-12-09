import { workerMain } from "@better-rules-javascript/bazel-worker";

workerMain(async () => {
  const { ResourceWorker, ResourceWorkerError } = await import("./worker");

  const worker = new ResourceWorker();
  return async (a) => {
    try {
      worker.run(a);
    } catch (error) {
      if (error instanceof ResourceWorkerError) {
        return { exitCode: 2, output: error.message };
      }
      return { exitCode: 1, output: String(error?.stack || error) };
    }
    return { exitCode: 0, output: "" };
  };
});
