import { PackageTree } from "@better-rules-javascript/commonjs-package";
import { JsonFormat } from "@better-rules-javascript/util-json";
import * as fs from "node:fs";
import { patchFs } from "./fs";
import { patchFsPromises } from "./fs-promises";
import { patchModule } from "./module";
import { createVfs } from "./package";

const manifestPath = process.env.NODE_FS_PACKAGE_MANIFEST;
if (!manifestPath) {
  throw new Error("NODE_FS_PACKAGE_MANIFEST is not set");
}
const packageTree = JsonFormat.parse(
  PackageTree.json(),
  fs.readFileSync(manifestPath, "utf8"),
);

const vfs = createVfs(
  packageTree,
  process.env.NODE_FS_RUNFILES === "true"
    ? process.env.RUNFILES_DIR
    : undefined,
);
if (process.env.NODE_FS_TRACE === "true") {
  process.stderr.write(vfs.print());
}

patchFs(vfs, require("node:fs"));
patchFsPromises(vfs, require("node:fs").promises);
patchModule(require("node:module"));
