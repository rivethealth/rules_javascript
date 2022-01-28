import { PackageTree } from "@better-rules-javascript/commonjs-package";
import { JsonFormat } from "@better-rules-javascript/util-json";
import * as fs from "fs";
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

const vfs = createVfs(packageTree, process.env.NODE_FS_RUNFILES === "true");
if (process.env.NODE_FS_TRACE === "true") {
  process.stderr.write(vfs.print());
}

patchFs(vfs, require("fs"));
patchFsPromises(vfs, require("fs").promises);
patchModule(require("module"));
