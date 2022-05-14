import * as path from "path";
import { PackageTree } from ".";
import { Trie } from "./collection";

export interface ResolverPackage {
  id: string;
  deps: Map<string, string>;
}

function pathParts(path_: string): string[] {
  path_ = path.resolve(path_);
  return path_.split("/").slice(1);
}

export interface Resolution {
  package: string;
  inner: string;
}

export class Resolver {
  private constructor(
    private readonly packages: Trie<string, ResolverPackage>,
  ) {}

  root(path: string) {
    const { value: package_ } = this.packages.getClosest(pathParts(path));
    if (!package_) {
      throw new Error(`File "${path}" is not part of any known package`);
    }

    return package_.id;
  }

  resolve(parent: string, request: string): Resolution {
    if (request.startsWith(".") || request.startsWith("/")) {
      throw new Error(`Specifier "${request}" is not for a package`);
    }

    const { value: package_ } = this.packages.getClosest(pathParts(parent));
    if (!package_) {
      throw new Error(`File "${parent}" is not part of any known package`);
    }

    const parts = request.split("/");
    const i = request.startsWith("@") ? 2 : 1;
    const dep = package_.deps.get(parts.slice(0, i).join("/"));
    if (!dep) {
      throw new Error(
        `Package "${package_.id}" does not have any dependency for "${request}", requested by ${parent}`,
      );
    }

    return { package: dep, inner: parts.slice(i).join("/") };
  }

  static create(packageTree: PackageTree, baseDir: string = "/"): Resolver {
    const resolve = (path_: string) => path.resolve(baseDir, path_);
    const packages = new Trie<string, ResolverPackage>();
    for (const [path, package_] of packageTree.packages.entries()) {
      const resolvedPath = pathParts(resolve(path));
      const deps = new Map<string, string>();
      for (const [name, dep] of package_.deps.entries()) {
        deps.set(name, resolve(dep));
      }
      for (const [name, dep] of packageTree.globals.entries()) {
        if (!package_.deps.has(name)) {
          deps.set(name, resolve(dep));
        }
      }
      packages.put(resolvedPath, { id: path, deps });
    }
    return new Resolver(packages);
  }
}
