import { Resolver } from "@better-rules-javascript/commonjs-package/resolve";
import { PackageTree } from "@better-rules-javascript/commonjs-package";
import { JsonFormat } from "@better-rules-javascript/util-json";
import Module from "module";
import * as fs from "fs";
import * as path from "path";
import * as url from "url";

const manifestPath = process.env.NODE_PACKAGE_MANIFEST;
if (!manifestPath) {
  throw new Error("NODE_PACKAGE_MANIFEST is not set");
}
const packageTree = JsonFormat.parse(
  PackageTree.json(),
  fs.readFileSync(manifestPath, "utf8"),
);

const resolver = Resolver.create(packageTree, process.env.RUNFILES_DIR);

export function resolve(
  specifier: string,
  context: any,
  defaultResolve: Function,
) {
  if (!context.parentURL && path.extname(specifier) == "") {
    return { format: "commonjs", url: specifier };
  }

  const parent =
    context.parentURL !== undefined ? new URL(context.parentURL) : undefined;

  if (
    Module.builtinModules.includes(specifier) ||
    parent?.protocol !== "file:" ||
    specifier == "." ||
    specifier == ".." ||
    specifier.startsWith("./") ||
    specifier.startsWith("../") ||
    specifier.startsWith("/") ||
    specifier.startsWith("file://")
  ) {
    return defaultResolve(specifier, context, defaultResolve);
  }

  const resolved = resolver.resolve(parent.pathname, specifier);
  const [base, packageName] = resolved.package.split("/node_modules/", 2);
  specifier = packageName;
  if (resolved.inner) {
    specifier = `${specifier}/${resolved.inner}`;
  }

  return defaultResolve(
    specifier,
    { ...context, parentURL: url.pathToFileURL(`${base}/_`) },
    defaultResolve,
  );
}
