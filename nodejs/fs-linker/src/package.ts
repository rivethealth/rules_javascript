import { PackageTree } from "@better-rules-javascript/commonjs-package";
import * as path from "path";
import { VfsImpl, VfsNode } from "./vfs";

class DependencyConflictError extends Error {}

function addPackageNode(root: VfsNode.Path, path: string) {
  const parts = path.split("/").slice(1);
  for (let i = 0; i < parts.length; i++) {
    let newRoot = root.extraChildren.get(parts[i]);
    if (!newRoot) {
      newRoot = {
        type: VfsNode.PATH,
        hardenSymlinks: false,
        extraChildren: new Map(),
        path: "/" + parts.slice(0, i + 1).join("/"),
      };
      root.extraChildren.set(parts[i], newRoot);
    }
    root = <VfsNode.Path>newRoot;
  }
  root.hardenSymlinks = true;
  return root;
}

function addDep(root: VfsNode.Path, name: string, path: string) {
  const parts = name.split("/");
  for (let i = 0; i < parts.length - 1; i++) {
    let newRoot = root.extraChildren.get(parts[i]);
    if (!newRoot) {
      newRoot = {
        type: VfsNode.PATH,
        hardenSymlinks: false,
        extraChildren: new Map(),
        path: undefined,
      };
      root.extraChildren.set(parts[i], newRoot);
    } else if (newRoot.type !== VfsNode.PATH) {
      throw new DependencyConflictError();
    }
    root = newRoot;
  }
  root.extraChildren.set(parts[parts.length - 1], {
    type: VfsNode.SYMLINK,
    path,
  });
}

export function createVfs(
  packageTree: PackageTree,
  runfiles: boolean,
): VfsImpl {
  const resolve = (path_: string) =>
    runfiles
      ? path.resolve(process.env.RUNFILES_DIR, path_)
      : path.resolve(path_);

  const root: VfsNode = {
    type: VfsNode.PATH,
    hardenSymlinks: false,
    extraChildren: new Map(),
    path: "/",
  };

  for (const [id, package_] of packageTree.entries()) {
    const packageNode = addPackageNode(root, resolve(package_.path));
    const nodeModules: VfsNode.Path = {
      type: VfsNode.PATH,
      hardenSymlinks: false,
      extraChildren: new Map(),
      path: undefined,
    };
    packageNode.extraChildren.set("node_modules", nodeModules);
    for (const [name, dep] of package_.deps) {
      const packageDep = packageTree.get(dep);
      if (!packageDep) {
        throw new Error(`Package ${dep} required by ${id} does not exist`);
      }
      try {
        addDep(nodeModules, name, resolve(packageDep.path));
      } catch (e) {
        if (!(e instanceof DependencyConflictError)) {
          throw e;
        }
        throw new Error(
          `Dependency "${name}" of "${id}" conflicts with another`,
        );
      }
    }
  }
  return new VfsImpl(root);
}
