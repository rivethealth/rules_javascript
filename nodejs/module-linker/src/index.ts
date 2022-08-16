import { Resolver } from "@better-rules-javascript/commonjs-package/resolve";
import { PackageTree } from "@better-rules-javascript/commonjs-package";
import { JsonFormat } from "@better-rules-javascript/util-json";
import * as fs from "fs";
import { patchModule } from "./module";
import { patchModuleDetails } from "./module-details";
import { NodeLinks } from "./link";
import * as path from "path";

const manifestPath = process.env.NODE_PACKAGE_MANIFEST;
if (!manifestPath) {
  throw new Error("NODE_PACKAGE_MANIFEST is not set");
}

const runfilesDir = process.env.RUNFILES_DIR;
if (!runfilesDir) {
  throw new Error("RUNFILES_DIR is not set");
}

const packageTree = JsonFormat.parse(
  PackageTree.json(),
  fs.readFileSync(manifestPath, "utf8"),
);

const links = new NodeLinks((packagePath) =>
  path.relative(runfilesDir, packagePath).replace(/\//g, "_"),
);
process.on("exit", () => links.destroy());

const resolver = Resolver.create(packageTree, process.env.RUNFILES_DIR);
patchModule(resolver, links, require("module"));
patchModuleDetails(resolver, require("module"));
