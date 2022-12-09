import { PackageTree } from "@better-rules-javascript/commonjs-package";
import { Resolver } from "@better-rules-javascript/commonjs-package/resolve";
import { JsonFormat } from "@better-rules-javascript/util-json";
import * as fs from "node:fs";
import { patchModule } from "./module";
import { patchModuleDetails } from "./module-details";

const manifestPath = process.env.NODE_PACKAGE_MANIFEST;
if (!manifestPath) {
  throw new Error("NODE_PACKAGE_MANIFEST is not set");
}
const packageTree = JsonFormat.parse(
  PackageTree.json(),
  fs.readFileSync(manifestPath, "utf8"),
);

const resolver = Resolver.create(packageTree, process.env.RUNFILES_DIR);
patchModule(resolver, require("node:module"));
patchModuleDetails(resolver, require("node:module"));
