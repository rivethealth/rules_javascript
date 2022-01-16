import { BzlDep, BzlPackage } from "./bzl";
import { NpmSpecifier, npmUrl } from "./npm";
import {
  YarnDependencyInfo,
  YarnLocator,
  YarnPackageInfo,
  YarnVersion,
} from "./yarn";

export function resolvePackages(packageInfos: YarnPackageInfo[]) {
  const packageInfosById = new Map<string, YarnPackageInfo>(
    packageInfos.map((package_) => [
      YarnLocator.serialize(package_.value),
      package_,
    ]),
  );

  const bzlPackages: BzlPackage[] = [];
  let bzlRoots: BzlDep[] | undefined;

  for (const packageInfo of packageInfos) {
    const yarnDeps: YarnDependencyInfo[] = [];
    if (packageInfo.value.version.type === YarnVersion.VIRTUAL) {
      const id = YarnLocator.serialize({
        name: packageInfo.value.name,
        version: packageInfo.value.version.version,
      });
      const resolvedPackageInfo = packageInfosById.get(id);
      if (!resolvedPackageInfo) {
        throw new Error(`Cannot find package ${id}`);
      }
      yarnDeps.push(...(resolvedPackageInfo.children.Dependencies || []));
      yarnDeps.push(
        ...(resolvedPackageInfo.children["Peer dependencies"] || []),
      );
    }
    yarnDeps.push(...(packageInfo.children.Dependencies || []));
    yarnDeps.push(...(packageInfo.children["Peer dependencies"] || []));
    const deps = bzlDeps(yarnDeps);
    const id = bzlId(packageInfo.value);
    const specifier = npmSpecifier(packageInfo.value);
    if (id && specifier) {
      bzlPackages.push({
        deps,
        extra_deps: {},
        id,
        name: packageInfo.value.name,
        url: npmUrl(specifier),
      });
    } else if (
      packageInfo.value.version.type === YarnVersion.WORKSPACE &&
      packageInfo.value.version.path === "."
    ) {
      bzlRoots = deps;
    }
  }
  if (!bzlRoots) {
    throw new Error("Could not find root workspace");
  }

  fixCycles(bzlPackages);

  return { roots: bzlRoots, packages: bzlPackages };
}

function npmSpecifier(locator: YarnLocator): NpmSpecifier | undefined {
  switch (locator.version.type) {
    case YarnVersion.PATCH:
      return npmSpecifier(locator.version.locator);
    case YarnVersion.VIRTUAL:
      if (locator.version.version.type !== YarnVersion.NPM) {
        return;
      }
      return {
        name: locator.name,
        version: `${
          locator.version.version.version
        }-${locator.version.digest.slice(0, 8)}`,
      };
    case YarnVersion.NPM:
      return { name: locator.name, version: locator.version.version };
  }
}

function bzlId(locator: YarnLocator): string | undefined {
  const specifier = npmSpecifier(locator);
  if (specifier) {
    return `${specifier.name}@${specifier.version}`;
  }
}

function bzlDeps(yarnDependencies: YarnDependencyInfo[]) {
  const result: BzlDep[] = [];
  for (const yarnDependency of yarnDependencies) {
    if (!yarnDependency.locator) {
      continue;
    }
    const id = bzlId(yarnDependency.locator);
    if (id) {
      result.push({ dep: id, name: yarnDependency.descriptor.name });
    }
  }
  return result;
}

function fixCycles(bzlPackages: BzlPackage[]) {
  const bzlPackagesById = new Map<string, BzlPackage>(
    bzlPackages.map((package_) => [package_.id, package_]),
  );
  const visited = new Set<string>();
  const visit = (id: string) => {
    const package_ = bzlPackagesById.get(id);
    if (!package_) {
      throw new Error(`Missing package ${id}`);
    }
    visited.add(id);
    package_.deps = package_.deps.filter((dep) => {
      if (!visited.has(dep.dep)) {
        visit(dep.dep);
        return true;
      }
      package_.extra_deps[dep.name] = dep.dep;
    });
    visited.delete(id);
  };
  for (const id of bzlPackagesById.keys()) {
    visit(id);
  }
}
