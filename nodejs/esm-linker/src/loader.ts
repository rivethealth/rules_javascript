import { PackageTree } from "@better-rules-javascript/commonjs-package";
import { Resolver } from "@better-rules-javascript/commonjs-package/resolve";
import { JsonFormat } from "@better-rules-javascript/util-json";
import { lazy } from "@better-rules-javascript/util/cache";
import { readFile } from "node:fs/promises";
import { resolveFn } from "./resolve";

export const resolve = lazy(async () => {
  const manifestPath = process.env.NODE_PACKAGE_MANIFEST;
  if (!manifestPath) {
    throw new Error("NODE_PACKAGE_MANIFEST is not set");
  }
  const packageTree = JsonFormat.parse(
    PackageTree.json(),
    await readFile(manifestPath, "utf8"),
  );
  const resolver = Resolver.create(packageTree, process.env.RUNFILES_DIR);

  return resolveFn(resolver);
});
