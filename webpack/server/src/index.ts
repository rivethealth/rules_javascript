import { PackageTree } from "@better-rules-javascript/commonjs-package";
import { patchFs } from "@better-rules-javascript/nodejs-fs-linker/fs";
import { patchFsPromises } from "@better-rules-javascript/nodejs-fs-linker/fs-promises";
import { createVfs } from "@better-rules-javascript/nodejs-fs-linker/package";
import { WrapperVfs } from "@better-rules-javascript/nodejs-fs-linker/vfs";
import { JsonFormat } from "@better-rules-javascript/util-json";
import * as fs from "node:fs";
import { isMainThread } from "node:worker_threads";
import { Subject } from "rxjs";
import { run } from "./run";
import { clearTimeout_, setTimeout_ } from "./timeout";

const packageManifestPath = process.env.NODE_PACKAGE_MANIFEST!;
const webackPackageManifestPath = process.env.WEBPACK_PACKAGE_MANIFEST!;
const webpackDigestPath = process.env.WEBPACK_DIGEST!;
const webpackRunfiles = process.env.RUNFILES_DIR!;
const watchpackPolling = +process.env.WATCHPACK_POLLING!;

const packageTree = JsonFormat.parse(
  PackageTree.json(),
  fs.readFileSync(packageManifestPath, "utf8"),
);
const vfs = createVfs(packageTree, process.env.RUNFILES_DIR);
patchFs(vfs, require("node:fs"));
patchFsPromises(vfs, require("node:fs").promises);

const webpackVfs = new WrapperVfs();
patchFs(webpackVfs, require("node:fs"));
patchFsPromises(webpackVfs, require("node:fs").promises);

const refresh = new Subject<void>();
// eslint-disable-next-line no-global-assign
(<any>setTimeout) = setTimeout_(setTimeout, watchpackPolling, refresh);
// eslint-disable-next-line no-global-assign
(<any>clearTimeout) = clearTimeout_(clearTimeout);

if (isMainThread) {
  run(
    webpackVfs,
    webackPackageManifestPath,
    webpackRunfiles,
    webpackDigestPath,
    refresh,
  ).catch((error) => {
    console.error(error.stack);
    process.exit(1);
  });
}
