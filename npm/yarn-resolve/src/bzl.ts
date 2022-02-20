import {
  StarlarkArray,
  StarlarkDict,
  StarlarkEqualStatement,
  StarlarkFile,
  StarlarkString,
  StarlarkValue,
  StarlarkVariable,
} from "./starlark";

export interface BzlPackage {
  deps: BzlDeps;
  extraDeps: Map<string, BzlDeps>;
  integrity: string;
  name: string;
  url: string;
}

export namespace BzlPackage {
  export function toStarlark(value: BzlPackage): StarlarkValue {
    const extraDepsEntries: [StarlarkValue, StarlarkValue][] = [];
    for (const [id, deps] of value.extraDeps.entries()) {
      extraDepsEntries.push([new StarlarkString(id), BzlDeps.toStarlark(deps)]);
    }

    return new StarlarkDict([
      [new StarlarkString("deps"), BzlDeps.toStarlark(value.deps)],
      [new StarlarkString("extra_deps"), new StarlarkDict(extraDepsEntries)],
      [new StarlarkString("integrity"), new StarlarkString(value.integrity)],
      [new StarlarkString("name"), new StarlarkString(value.name)],
      [new StarlarkString("url"), new StarlarkString(value.url)],
    ]);
  }
}

export interface BzlPackages extends Map<string, BzlPackage> {}

export namespace BzlPackages {
  export function toStarlark(value: BzlPackages) {
    const entries = [...value.entries()].sort(
      (a, b) => +(b[0] < a[0]) - +(a[0] < b[0]),
    );
    return new StarlarkDict(
      entries.map(([id, value]) => [
        new StarlarkString(id),
        BzlPackage.toStarlark(value),
      ]),
    );
  }
}

export type BzlDeps = { name: string | null; id: string }[];

export namespace BzlDeps {
  export function toStarlark(value: BzlDeps): StarlarkValue {
    const entries = [...value].sort((a, b) => +(b.id < a.id) - +(a.id < b.id));
    return new StarlarkArray(
      entries.map((dep) => {
        const entries: [StarlarkValue, StarlarkValue][] = [];
        entries.push([new StarlarkString("id"), new StarlarkString(dep.id)]);
        if (dep.name !== null) {
          entries.push([
            new StarlarkString("name"),
            new StarlarkString(dep.name),
          ]);
        }
        return new StarlarkDict(entries);
      }),
    );
  }
}

export function toStarlarkFile(packages: BzlPackages, roots: BzlDeps) {
  const packagesStatement = new StarlarkEqualStatement(
    new StarlarkVariable("PACKAGES"),
    BzlPackages.toStarlark(packages),
  );

  const rootsStatement = new StarlarkEqualStatement(
    new StarlarkVariable("ROOTS"),
    BzlDeps.toStarlark(roots),
  );

  return new StarlarkFile([packagesStatement, rootsStatement]);
}
