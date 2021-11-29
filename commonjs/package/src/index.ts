import { JsonFormat } from "./json";

export class Package {
  /** Dependencies */
  deps: Map<string, string>;
  /** Path */
  path: string;
}

export namespace Package {
  export function json(): JsonFormat<Package> {
    return JsonFormat.object({
      id: JsonFormat.string(),
      deps: JsonFormat.map(JsonFormat.string(), JsonFormat.string()),
      path: JsonFormat.string(),
    });
  }
}

export type PackageTree = Map<string, Package>;

export namespace PackageTree {
  export function json(): JsonFormat<PackageTree> {
    return JsonFormat.map(JsonFormat.string(), Package.json());
  }
}
