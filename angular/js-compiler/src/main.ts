import { workerMain } from "@better-rules-javascript/bazel-worker";
import { patchFs } from "@better-rules-javascript/nodejs-fs-linker/fs";
import { patchFsPromises } from "@better-rules-javascript/nodejs-fs-linker/fs-promises";
import { WrapperVfs } from "@better-rules-javascript/nodejs-fs-linker/vfs";

workerMain(async () => {
  const vfs = new WrapperVfs();
  patchFs(vfs, require("node:fs"));
  patchFsPromises(vfs, require("node:fs").promises);

  const { AngularWorker, AngularWorkerError } = await import("./worker");

  const worker = new AngularWorker(vfs);
  return async (a) => {
    try {
      await worker.run(a);
    } catch (e) {
      if (e instanceof AngularWorkerError) {
        return { exitCode: 2, output: e.message };
      }
      return { exitCode: 1, output: String(e?.stack || e) };
    }
    return { exitCode: 0, output: "" };
  };
});
