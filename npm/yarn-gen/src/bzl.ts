export interface BzlPackage {
  deps: BzlDep[];
  name: string;
  id: string;
  url: string;
}

export type BzlPackages = BzlPackage[];

export namespace BzlPackages {
  export function serialize(bzlPackages: BzlPackages) {
    return JSON.stringify(bzlPackages, undefined, 4);
  }
}

export type BzlRoots = BzlDep[];

export namespace BzlRoots {
  export function serialize(bzlRoots: BzlRoots) {
    return JSON.stringify(bzlRoots, undefined, 4);
  }
}

export interface BzlDep {
  name: string;
  dep: string;
}

export function bzlId(resolution: string) {
  return resolution.replace("@npm:", "@");
}
