import {
  StarlarkArray,
  StarlarkBoolean,
  StarlarkDict,
  StarlarkEqualStatement,
  StarlarkFile,
  StarlarkString,
  StarlarkValue,
  StarlarkVariable,
} from "@better-rules-javascript/util-starlark";

export interface BzlPackage {
  arch: string[] | undefined;
  deps: BzlDeps;
  extraDeps: Map<string, BzlDeps>;
  integrity: string;
  libc: string[] | undefined;
  name: string;
  os: string[] | undefined;
  url: string;
}

export namespace BzlPackage {
  export function toStarlark(value: BzlPackage): StarlarkValue {
    const extraDepsEntries: [StarlarkValue, StarlarkValue][] = [];
    const extraDeps = [...value.extraDeps.entries()].sort(
      (a, b) => +(b[0] < a[0]) - +(a[0] < b[0]),
    );
    for (const [id, deps] of extraDeps) {
      extraDepsEntries.push([new StarlarkString(id), BzlDeps.toStarlark(deps)]);
    }

    const entries: [StarlarkValue, StarlarkValue][] = [];
    if (value.arch) {
      entries.push([
        new StarlarkString("arch"),
        new StarlarkArray(value.arch.map((arch) => new StarlarkString(arch))),
      ]);
    }
    if (value.libc) {
      entries.push([
        new StarlarkString("libc"),
        new StarlarkArray(value.libc.map((libc) => new StarlarkString(libc))),
      ]);
    }
    if (value.os) {
      entries.push([
        new StarlarkString("os"),
        new StarlarkArray(value.os.map((os) => new StarlarkString(os))),
      ]);
    }
    if (value.deps.length > 0) {
      entries.push([
        new StarlarkString("deps"),
        BzlDeps.toStarlark(value.deps),
      ]);
    }
    if (extraDepsEntries.length > 0) {
      entries.push([
        new StarlarkString("extra_deps"),
        new StarlarkDict(extraDepsEntries),
      ]);
    }
    entries.push(
      [new StarlarkString("integrity"), new StarlarkString(value.integrity)],
      [new StarlarkString("name"), new StarlarkString(value.name)],
      [new StarlarkString("url"), new StarlarkString(value.url)],
    );
    return new StarlarkDict(entries);
  }
}

export type BzlPackages = Map<string, BzlPackage>;

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

export interface BzlDep {
  name: string | null;
  id: string;
}

export type BzlDeps = BzlDep[];

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
        if (dep.optional) {
          entries.push([
            new StarlarkString("optional"),
            new StarlarkBoolean(dep.optional),
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
