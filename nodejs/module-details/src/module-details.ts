import { memo } from "@better-rules-javascript/util/cache";
import { readFileSync } from "node:fs";
import Module from "node:module";
import { dirname, join, sep } from "node:path";

interface PackageRoot {
  directory: string;
  name: string;
}

function moduleDetailsFn(): (
  path: string,
) => { name: string; basedir: string; path: string } | undefined {
  const packageRoot = memo((path: string): PackageRoot | undefined => {
    let packageContent;
    try {
      packageContent = readFileSync(join(path, "package.json"), "utf8");
    } catch {
      const parent = dirname(path);
      if (parent === path) {
        return;
      }
      return packageRoot(parent);
    }

    let packageJson;
    try {
      packageJson = JSON.parse(packageContent);
    } catch {
      return;
    }
    if (!packageJson.name) {
      return;
    }
    return {
      directory: path,
      name: packageJson.name,
    };
  });

  return (path) => {
    const root = packageRoot(dirname(path));
    if (!root) {
      return;
    }
    return {
      name: root.name,
      basedir: root.directory,
      path: path.slice(root.directory.length + sep.length),
    };
  };
}

const MODULE_NAME = "module-details-from-path";

export function patchModuleDetails(delegate: typeof Module) {
  const originalRequire = delegate.prototype.require;
  const moduleDetails = moduleDetailsFn();
  delegate.prototype.require = <any>function (this: any, id: string) {
    if (id === MODULE_NAME) {
      return moduleDetails;
    }
    return originalRequire.apply(this, <any>arguments);
  };
}
