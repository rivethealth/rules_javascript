import { PackageTree } from "@better-rules-javascript/commonjs-package";
import { Resolver } from "@better-rules-javascript/commonjs-package/resolve";
import { JsonFormat } from "@better-rules-javascript/util-json";
import { lazy } from "@better-rules-javascript/util/cache";
import * as fs from "node:fs";
import Module from "node:module";
import * as os from "node:os";
import * as path from "node:path";
import * as url from "node:url";

const manifestPath = process.env.NODE_PACKAGE_MANIFEST;
if (!manifestPath) {
  throw new Error("NODE_PACKAGE_MANIFEST is not set");
}
const packageTree = JsonFormat.parse(
  PackageTree.json(),
  fs.readFileSync(manifestPath, "utf8"),
);

const linkDirectory = lazy(async () => {
  const dir = await fs.promises.mkdtemp(path.join(os.tmpdir(), "nodejs-"));
  process.once("exit", () => {
    fs.rmSync(dir, { recursive: true });
  });
  await fs.promises.mkdir(path.join(dir, "node_modules"));
  return dir;
});

const linkedPackages = new Map<string, Promise<void>>();

const resolver = Resolver.create(packageTree, process.env.RUNFILES_DIR);

export async function resolve(
  specifier: string,
  context: any,
  defaultResolve: Function,
) {
  if (!context.parentURL && path.extname(specifier) == "") {
    return { format: "commonjs", url: specifier, shortCircuit: true };
  }

  let parentPath: string | undefined;
  try {
    parentPath = url.fileURLToPath(context.parentURL);
  } catch {}

  if (
    parentPath === undefined ||
    Module.builtinModules.includes(specifier) ||
    specifier.startsWith("node:") ||
    specifier == "." ||
    specifier == ".." ||
    specifier.startsWith("./") ||
    specifier.startsWith("../") ||
    specifier.startsWith("/") ||
    specifier.startsWith("#") ||
    specifier.startsWith("file://")
  ) {
    return defaultResolve(specifier, context, defaultResolve);
  }

  const resolved = resolver.resolve(parentPath, specifier);

  const directory = await linkDirectory();
  const packageName = path
    .relative(process.env.RUNFILES_DIR!, resolved.package)
    .replace(/\//g, "_");
  const linkPath = path.join(directory, "node_modules", packageName);
  if (!linkedPackages.has(resolved.package)) {
    linkedPackages.set(
      resolved.package,
      fs.promises.symlink(resolved.package, linkPath),
    );
  }
  await linkedPackages.get(resolved.package);

  specifier = packageName;
  if (resolved.inner) {
    specifier = `${specifier}/${resolved.inner}`;
  }

  parentPath = path.join(
    directory,
    path.relative(process.env.RUNFILES_DIR!, parentPath).replace(/\//g, "_"),
  );
  const nodeResolved = await defaultResolve(
    specifier,
    { ...context, parentURL: url.pathToFileURL(parentPath) },
    defaultResolve,
  );

  const nodeResolvedPath = url.fileURLToPath(nodeResolved.url);
  const resolvedPath = path.join(
    resolved.package,
    path.relative(linkPath, nodeResolvedPath),
  );
  nodeResolved.url = url.pathToFileURL(resolvedPath).toString();
  return nodeResolved;
}
