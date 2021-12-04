import * as path from "path";
import { PackageTree } from ".";
import { Trie } from "./collection";

export interface ResolverPackage {
  id: string;
  deps: Trie<string, string>;
}

function moduleParts(path_: string) {
  return path_ ? path_.split("/") : [];
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

  resolve(parent: string, request: string): Resolution {
    if (request.startsWith(".") || request.startsWith("/")) {
      throw new Error(`Specifier "${request}" is not for a package`);
    }

    const { value: package_ } = this.packages.getClosest(pathParts(parent));
    if (!package_) {
      throw new Error(`File "${parent}" is not part of any known package`);
    }

    const { rest: depRest, value: dep } = package_.deps.getClosest(
      moduleParts(request),
    );
    if (!dep) {
      throw new Error(
        `Package "${package_.id}" does not have any dependency for "${request}"`,
      );
    }

    return { package: dep, inner: depRest.join("/") };
  }

  static create(packageTree: PackageTree, runfiles: boolean): Resolver {
    const resolve = (path_: string) =>
      path.resolve(
        runfiles
          ? `${process.env.RUNFILES_DIR}/${process.env.BAZEL_WORKSPACE}/${path_}`
          : path_,
      );
    const packages = new Trie<string, ResolverPackage>();
    for (const [id, package_] of packageTree.entries()) {
      const path_ = pathParts(resolve(package_.path));
      const deps = new Trie<string, string>();
      for (const [name, dep] of package_.deps.entries()) {
        const package_ = packageTree.get(dep);
        if (!package_) {
          throw new Error(
            `Package "${package_}" referenced by "${id}" does not exist`,
          );
        }
        const path_ = resolve(package_.path);
        deps.put(moduleParts(name), path_);
      }
      packages.put(path_, { id: id, deps });
    }
    return new Resolver(packages);
  }
}
