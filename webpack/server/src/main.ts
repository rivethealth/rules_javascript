import { ArgumentParser } from "argparse";
import { JsonFormat } from "@better-rules-javascript/util-json";
import { PackageTree } from "@better-rules-javascript/commonjs-package";
import { createVfs } from "@better-rules-javascript/nodejs-fs-linker/package";
import * as fs from "fs";
import { WrapperVfs } from "@better-rules-javascript/nodejs-fs-linker/vfs";
import { patchFs } from "@better-rules-javascript/nodejs-fs-linker/fs";
import { patchFsPromises } from "@better-rules-javascript/nodejs-fs-linker/fs-promises";

interface Args {
  packagesManifest: string;
}

const packageManifestPath = process.env.NODE_FS_PACKAGE_MANIFEST;

const parser = new ArgumentParser({ prog: "webpack-server" });
parser.add_argument("--packages-manifest", {
  dest: "packagesManifest",
  required: true,
});
const args: Args = parser.parse_args();

const packageTree = JsonFormat.parse(
  PackageTree.json(),
  fs.readFileSync(packageManifestPath, "utf8"),
);
const vfs = createVfs(packageTree, true);
patchFs(vfs, require("fs"));
patchFsPromises(vfs, require("fs").promises);

const webpackVfs = new WrapperVfs();
patchFs(webpackVfs, require("fs"));
patchFsPromises(webpackVfs, require("fs").promises);

(async () => {
  const { startServer } = await import("./server");
  await startServer(webpackVfs, args.packagesManifest);
})();
