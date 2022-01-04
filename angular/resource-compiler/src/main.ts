import { run } from "@better-rules-javascript/bazel-worker";

run(async () => {
  const { ResourceWorker, ResourceWorkerError } = await import("./worker");

  const worker = new ResourceWorker();
  return async (a) => {
    try {
      worker.run(a);
    } catch (e) {
      if (e instanceof ResourceWorkerError) {
        return { exitCode: 2, output: e.message };
      }
      return { exitCode: 1, output: String(e?.stack || e) };
    }
    return { exitCode: 0, output: "" };
  };
});
