import { workerMain } from "@better-rules-javascript/bazel-worker";

workerMain(async () => {
  const { ManifestWorker, ManifestWorkerError } = await import("./worker");

  const worker = new ManifestWorker();
  return async (a) => {
    try {
      await worker.run(a);
    } catch (e) {
      if (e instanceof ManifestWorkerError) {
        return { exitCode: 2, output: e.message };
      }
      return { exitCode: 1, output: String(e instanceof Error ? e.stack : e) };
    }
    return { exitCode: 0, output: "" };
  };
});
