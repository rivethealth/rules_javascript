import { JsonFormat } from "@better-rules-javascript/util-json";

export type PackageDeps = Map<string, string>;

export namespace PackageDeps {
  export function json(): JsonFormat<PackageDeps> {
    return JsonFormat.map(JsonFormat.string(), JsonFormat.string());
  }
}

/**
 * Package
 */
export interface Package {
  /** Dependencies */
  deps: PackageDeps;
  /** Name */
  name: string;
}

export namespace Package {
  export function json(): JsonFormat<Package> {
    return JsonFormat.object({
      deps: PackageDeps.json(),
      name: JsonFormat.string(),
    });
  }
}

/**
 * Package tree
 */
export interface PackageTree {
  /** Globals */
  globals: PackageDeps;
  /** Packages */
  packages: Map<string, Package>;
}

export namespace PackageTree {
  export function json(): JsonFormat<PackageTree> {
    return JsonFormat.object({
      globals: PackageDeps.json(),
      packages: JsonFormat.map(JsonFormat.string(), Package.json()),
    });
  }
}
