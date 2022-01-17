import { BzlDep, BzlPackage } from "./bzl";
import { NpmSpecifier, NpmRegistryClient, NpmPackage } from "./npm";
import {
  YarnDependencyInfo,
  YarnLocator,
  YarnPackageInfo,
  YarnVersion,
} from "./yarn";

export async function resolvePackages(
  packageInfos: YarnPackageInfo[],
  getPackage: (specifier: NpmSpecifier) => Promise<NpmPackage>,
  progress: (message: string) => void,
) {
  progress(`Resolving ${packageInfos.length} packages`);

  const bzlPackages: BzlPackage[] = [];
  let bzlRoots: BzlDep[] | undefined;

  let finished = 0;
  let lastReported = 0;
  const report = () => {
    if (lastReported !== finished) {
      lastReported = finished;
      progress(`Resolved ${finished} packages`);
    }
  };

  let reported = process.hrtime.bigint();
  await Promise.all(
    packageInfos.map(async (packageInfo) => {
      const deps = bzlDeps(packageInfo.children.Dependencies || []);
      const id = bzlId(packageInfo.value);
      const specifier = npmSpecifier(packageInfo.value);
      if (id && specifier) {
        const npmPackage = await getPackage(specifier);
        bzlPackages.push({
          deps,
          extra_deps: {},
          id,
          integrity: npmPackage.dist.integrity,
          name: packageInfo.value.name,
          url: npmPackage.dist.tarball,
        });
      } else if (
        packageInfo.value.version.type === YarnVersion.WORKSPACE &&
        packageInfo.value.version.path === "."
      ) {
        bzlRoots = deps;
      }
      finished++;
      const now = process.hrtime.bigint();
      if (reported + BigInt(2 * 1e9) < now) {
        reported = now;
        report();
      }
    }),
  );
  report();

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
        version: locator.version.version.version,
      };
    case YarnVersion.NPM:
      return { name: locator.name, version: locator.version.version };
  }
}

function bzlId(locator: YarnLocator): string | undefined {
  switch (locator.version.type) {
    case YarnVersion.PATCH:
      return bzlId(locator.version.locator);
    case YarnVersion.VIRTUAL:
      if (locator.version.version.type !== YarnVersion.NPM) {
        return;
      }
      return `${locator.name}@${
        locator.version.version.version
      }-${locator.version.digest.slice(0, 8)}`;
    case YarnVersion.NPM:
      return `${locator.name}@${locator.version.version}`;
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
