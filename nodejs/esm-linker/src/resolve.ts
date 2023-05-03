import {
  Resolution,
  Resolver,
} from "@better-rules-javascript/commonjs-package/resolve";
import { lazy } from "@better-rules-javascript/util/cache";
import { rmSync } from "node:fs";
import { mkdir, mkdtemp, symlink } from "node:fs/promises";
import Module from "node:module";
import { tmpdir } from "node:os";
import { extname, join, relative } from "node:path";
import { fileURLToPath, pathToFileURL } from "node:url";

export function resolveFn(resolver: Resolver) {
  const specifierClassifier = new SpecifierClassifier();
  const moduleResolver = new LinkModuleResolver();

  return async (specifier: string, context: any, defaultResolve: Function) => {
    if (!context.parentURL && extname(specifier) == "") {
      return { format: "commonjs", url: specifier, shortCircuit: true };
    }

    let parentPath: string | undefined;
    try {
      parentPath = fileURLToPath(context.parentURL);
    } catch {}

    if (
      parentPath === undefined ||
      !specifierClassifier.isPackage(specifier) ||
      specifierClassifier.isBuiltin(specifier)
    ) {
      return defaultResolve(specifier, context, defaultResolve);
    }

    const resolved = resolver.resolve(parentPath, specifier);

    return await moduleResolver.resolve(
      resolved,
      parentPath,
      (specifier, requester) =>
        defaultResolve(
          specifier,
          { ...context, parentURL: pathToFileURL(requester!) },
          defaultResolve,
        ),
    );
  };
}

class SpecifierClassifier {
  private readonly builtins = new Set(Module.builtinModules);

  isBuiltin(specifier: string) {
    return this.builtins.has(specifier);
  }

  isPackage(specifier: string) {
    return (
      !specifier.startsWith("file:") &&
      !specifier.startsWith("node:") &&
      specifier !== "." &&
      specifier !== ".." &&
      !specifier.startsWith("./") &&
      !specifier.startsWith("../") &&
      !specifier.startsWith("/") &&
      !specifier.startsWith("#")
    );
  }
}

async function createTempDir() {
  const dir = await mkdtemp(join(tmpdir(), "nodejs-"));
  await mkdir(join(dir, "node_modules"));
  process.once("exit", () => rmSync(dir, { recursive: true }));
  return dir;
}

class LinkModuleResolver {
  private readonly packages = new Map<string, Promise<void>>();

  private readonly directory = lazy(createTempDir);

  async resolve(
    resolved: Resolution,
    requester: string,
    delegate: (specifier: string, requester: string) => Promise<any>,
  ) {
    const directory = await this.directory();
    const packageName_ = LinkModuleResolver.packageName(resolved.package);
    const linkPath = join(directory, "node_modules", packageName_);
    let packageInit = this.packages.get(resolved.package);
    if (packageInit === undefined) {
      packageInit = (async () => {
        await symlink(resolved.package, linkPath);
      })();
      this.packages.set(resolved.package, packageInit);
    }
    await packageInit;

    let specifier = packageName_;
    if (resolved.inner) {
      specifier = `${specifier}/${resolved.inner}`;
    }

    const nodeResolved = await delegate(
      specifier,
      join(directory, LinkModuleResolver.packageName(requester)),
    );
    const resolvedPath = join(
      resolved.package,
      relative(linkPath, fileURLToPath(nodeResolved.url)),
    );
    nodeResolved.url = pathToFileURL(resolvedPath).toString();
    return nodeResolved;
  }

  static packageName(path_: string) {
    const relative_ = relative(process.env.RUNFILES_DIR!, path_);
    return `_${relative_.replace(/\//g, "_")}`;
  }
}
