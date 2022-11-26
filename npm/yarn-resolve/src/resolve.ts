import { JsonFormat } from "@better-rules-javascript/util-json";
import { Locator, structUtils } from "@yarnpkg/core";
import { patchUtils } from "@yarnpkg/plugin-patch";
import { BzlDeps, BzlPackages } from "./bzl";
import { getOrSet } from "@better-rules-javascript/util/collection";
import { NpmRegistryClient } from "./npm";
import { YarnDependencies, YarnPackageInfos } from "./yarn";

export interface ResolvedNpmPackage {
  contentIntegrity: string;
  contentUrl: string;
}

export namespace ResolvedNpmPackage {
  export function json(): JsonFormat<ResolvedNpmPackage> {
    return JsonFormat.object({
      contentIntegrity: JsonFormat.string(),
      contentUrl: JsonFormat.string(),
    });
  }
}

export async function getPackage(
  client: NpmRegistryClient,
  npmLocator: Locator,
): Promise<ResolvedNpmPackage> {
  const package_ = await client.getPackage(npmLocator);
  let integrity: string;
  if (package_.dist.integrity) {
    integrity = package_.dist.integrity;
  } else {
    throw new Error("Missing integrity");
  }

  return {
    contentIntegrity: integrity,
    contentUrl: package_.dist.tarball,
  };
}

export async function resolvePackages(
  yarnPackages: YarnPackageInfos,
  getPackage: (npmSpecifier: Locator) => Promise<ResolvedNpmPackage>,
  progress: (message: string) => void,
): Promise<{ packages: BzlPackages; roots: BzlDeps }> {
  const bzlPackages: BzlPackages = new Map();
  let bzlRoots: BzlDeps | undefined;

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
    [...yarnPackages.values()].map(async (yarnPackage) => {
      const deps = bzlDeps(yarnPackages, yarnPackage.dependencies);
      const id = bzlId(yarnPackage.locator);
      const specifier = npmLocator(yarnPackage.locator);
      if (id && specifier) {
        const npmPackage = await getPackage(specifier);
        bzlPackages.set(id, {
          deps,
          extraDeps: new Map(),
          integrity: npmPackage.contentIntegrity,
          name: structUtils.stringifyIdent(yarnPackage.locator),
          url: npmPackage.contentUrl,
        });
        finished++;
      } else if (yarnPackage.locator.reference === "workspace:.") {
        bzlRoots = deps;
      }
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

  garbageCollect(bzlPackages, bzlRoots);
  removeNames(bzlPackages);
  fixCycles(bzlPackages);

  return { roots: bzlRoots, packages: bzlPackages };
}

function npmLocator(locator: Locator): Locator | undefined {
  if (locator.reference.startsWith("patch:")) {
    const parsed = patchUtils.parseLocator(locator);
    return npmLocator(parsed.sourceLocator);
  }
  if (structUtils.isVirtualLocator(locator)) {
    locator = structUtils.devirtualizeLocator(locator);
    return npmLocator(locator);
  }
  if (locator.reference.startsWith("npm:")) {
    return structUtils.makeLocator(
      locator,
      locator.reference.replace(/^npm:/, ""),
    );
  }
}

function bzlId(locator: Locator): string | undefined {
  if (locator.reference.startsWith("patch:")) {
    const parsed = patchUtils.parseLocator(locator);
    return `${bzlId(parsed.sourceLocator)}-${locator.locatorHash.slice(0, 8)}`;
  }
  if (structUtils.isVirtualLocator(locator)) {
    const entropy = locator.reference.slice(
      "virtual:".length,
      "virtual:".length + 8,
    );
    locator = structUtils.devirtualizeLocator(locator);
    return `${bzlId(locator)}-${entropy}`;
  }
  if (locator.reference.startsWith("npm:")) {
    const version = locator.reference.replace(/^npm:/, "");
    return `${structUtils.stringifyIdent(locator)}@${version}`;
  }
}

function bzlDeps(
  yarnPackages: YarnPackageInfos,
  yarnDependencies: YarnDependencies,
): BzlDeps {
  const result: BzlDeps = [];
  for (const [depName, depId] of yarnDependencies.entries()) {
    const id = bzlId(yarnPackages.get(depId)!.locator);
    if (id) {
      result.push({ name: depName, id });
    }
  }
  return result;
}

function garbageCollect(bzlPackages: BzlPackages, roots: BzlDeps) {
  const references = new Map<string, number>();
  const addDeps = (deps: BzlDeps) => {
    for (const dep of deps) {
      references.set(dep.id, (references.get(dep.id) || 0) + 1);
    }
  };
  addDeps(roots);
  for (const bzlPackage of bzlPackages.values()) {
    addDeps(bzlPackage.deps);
  }
  const checkId = (id: string) => {
    if (references.get(id)) {
      return;
    }
    const bzlPackage = bzlPackages.get(id)!;
    for (const dep of bzlPackage.deps) {
      references.set(dep.id, references.get(dep.id)! - 1);
      checkId(dep.id);
    }
    bzlPackages.delete(id);
  };
  for (const id of bzlPackages.keys()) {
    checkId(id);
  }
}

function removeNames(bzlPackages: BzlPackages) {
  for (const package_ of bzlPackages.values()) {
    for (const dep of package_.deps) {
      const depPackage = bzlPackages.get(dep.id)!;
      if (dep.name === depPackage.name) {
        dep.name = null;
      }
    }
  }
}

function fixCycles(bzlPackages: BzlPackages) {
  const current = new Set<string>();
  const visited = new Set<string>();
  const visit = (id: string) => {
    if (visited.has(id)) {
      return;
    }
    const package_ = bzlPackages.get(id)!;
    if (current.has(id)) {
      const idList = [...current];
      idList.splice(0, idList.indexOf(id));
      const ids = new Set(idList);
      for (const id of ids) {
        const package_ = bzlPackages.get(id)!;
        for (const dep of package_.deps) {
          if (!ids.has(dep.id)) {
            continue;
          }
          for (const packageId of ids) {
            const package_ = bzlPackages.get(packageId)!;
            const deps = getOrSet(package_.extraDeps, id, () => []);
            if (!deps.some((d) => d.id === dep.id && d.name == dep.name)) {
              deps.push(dep);
            }
          }
        }
      }
      return;
    }
    current.add(id);
    for (const dep of package_.deps) {
      visit(dep.id);
    }
    current.delete(id);
    visited.add(id);
  };
  for (const id of bzlPackages.keys()) {
    visit(id);
  }
  for (const package_ of bzlPackages.values()) {
    const extraIds = new Set();
    for (const deps of package_.extraDeps.values()) {
      for (const dep of deps) {
        extraIds.add(dep.id);
      }
    }
    package_.deps = package_.deps.filter((dep) => !extraIds.has(dep.id));
  }
}
