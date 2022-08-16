import { PackageTree } from "@better-rules-javascript/commonjs-package";
import { Resolver } from "@better-rules-javascript/commonjs-package/resolve";
import { JsonFormat } from "@better-rules-javascript/util-json";
import * as fs from "fs";
import * as path from "path";
import { NodeModuleLinks } from "./link";
import { Loader } from "./load";

const manifestPath = process.env.NODE_PACKAGE_MANIFEST;
if (!manifestPath) {
  throw new Error("NODE_PACKAGE_MANIFEST is not set");
}

const runfilesDir = process.env.RUNFILES_DIR;
if (!runfilesDir) {
  throw new Error("RUNFILES_DIR is not set");
}

const links = new NodeModuleLinks((packagePath) =>
  path.relative(runfilesDir, packagePath).replace(/\//g, "_"),
);
process.on("exit", () => links.destroy());

const packageTree = JsonFormat.parse(
  PackageTree.json(),
  fs.readFileSync(manifestPath, "utf8"),
);

const resolver = Resolver.create(packageTree, runfilesDir);

const loader = new Loader(resolver, links);

export const resolve = loader.resolve.bind(loader);
