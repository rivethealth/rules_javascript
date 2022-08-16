import { patchFs } from "@better-rules-javascript/nodejs-fs-linker/fs";
import { patchFsPromises } from "@better-rules-javascript/nodejs-fs-linker/fs-promises";
import { WrapperVfs } from "@better-rules-javascript/nodejs-fs-linker/vfs";
import { workerMain } from "@better-rules-javascript/bazel-worker";

workerMain(async () => {
  const vfs = new WrapperVfs();
  patchFs(vfs, require("node:fs"));
  patchFsPromises(vfs, require("node:fs").promises);

  const { JsWorker, JsWorkerError } = await import("./worker");
  const worker = new JsWorker(vfs);
  return async (a) => {
    try {
      await worker.run(a);
    } catch (e) {
      if (e instanceof JsWorkerError) {
        return { exitCode: 2, output: e.message };
      }
      return { exitCode: 1, output: String(e?.stack || e) };
    }
    return { exitCode: 0, output: "" };
  };
});
