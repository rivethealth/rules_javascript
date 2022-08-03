import { PackageTree } from "@better-rules-javascript/commonjs-package";

export interface DepArg {
  dep: string;
  label: string;
  name: string;
  id: string | null;
}

export interface PackageArg {
  id: string;
  label: string;
  name: string;
  path: string;
}

export type DetailedDeps = Map<string, { label: string; path: string }>;

export interface DetailedPackage {
  deps: DetailedDeps;
  label: string;
  path: string;
  name: string;
}

export function getPackages(
  packageArgs: PackageArg[],
): Map<string, DetailedPackage> {
  const packages = new Map<string, DetailedPackage>();
  const packageIdByPath = new Map<string, string>();

  for (const packageArg of packageArgs) {
    const existingPackage = packages.get(packageArg.id);

    if (existingPackage) {
      throw new Error(
        `Multiple instances of package ID ${packageArg.id} from ${existingPackage.label} and ${packageArg.label}`,
      );
    }
    packages.set(packageArg.id, {
      label: packageArg.label,
      name: packageArg.name,
      deps: new Map(),
      path: packageArg.path,
    });

    const existingId = packageIdByPath.get(packageArg.path);
    if (existingId) {
      const existingPackage = packages.get(existingId)!;
      throw new Error(
        `Multiple instances of package path ${packageArg.id} from ${existingPackage.label} and ${packageArg.label}`,
      );
    }
  }

  return packages;
}

export function addDeps(
  depArgs: DepArg[],
  packages: Map<string, DetailedPackage>,
  globals: DetailedDeps,
) {
  for (const depArg of depArgs) {
    if (depArg.id == null) {
      const depPackage = packages.get(depArg.dep);
      if (!depPackage) {
        throw new Error(
          `Package ${depArg.dep} does not exist, but is referenced globally (${depArg.label})`,
        );
      }
      const existingDep = globals.get(depArg.name);
      if (!existingDep) {
        globals.set(depArg.name, {
          label: depArg.label,
          path: depPackage.path,
        });
      } else if (existingDep.path !== depArg.dep) {
        throw new Error(
          `Multiple globals for ${depArg.name}: ${existingDep.path} (via ${existingDep.label}) and ${depArg.dep} (via ${depArg.label})`,
        );
      }
      continue;
    }

    const package_ = packages.get(depArg.id);
    if (!package_) {
      throw new Error(
        `Package ${depArg.id} does not exist, but is referenced (${depArg.label})`,
      );
    }

    const depPackage = packages.get(depArg.dep);
    if (!depPackage) {
      throw new Error(
        `Package ${depArg.dep} does not exist, but is referenced by ${depArg.id} (${depArg.label})`,
      );
    }

    const existingDep = depPackage.deps.get(depArg.name);
    if (existingDep && existingDep.path !== depPackage.path) {
      throw new Error(
        `Package ${depArg.id} has multiple dependencies for ${depArg.name}: ${existingDep.path} (via ${existingDep.label}) and ${depPackage.path} (via ${depArg.label})`,
      );
    }

    package_.deps.set(depArg.name, {
      label: depArg.label,
      path: depPackage.path,
    });
  }
}

export function getPackageTree(
  packages: Map<string, DetailedPackage>,
  globals: DetailedDeps,
): PackageTree {
  const resultGlobals = new Map(
    [...globals.entries()].map(([name, dep]) => [name, dep.path]),
  );
  const resultPackages = new Map(
    [...packages.values()].map((package_) => [
      package_.path,
      {
        name: package_.name,
        deps: new Map(
          [...package_.deps.entries()].map(([name, dep]) => [name, dep.path]),
        ),
      },
    ]),
  );

  return { globals: resultGlobals, packages: resultPackages };
}
