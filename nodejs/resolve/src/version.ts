export type Version = number[];

export namespace Version {
  export function compare(a: Version, b: Version): number {
    for (let i = 0; i < Math.min(a.length, b.length); i++) {
      if (a[i] !== b[i]) {
        return a[i] - b[i];
      }
    }
    return a.length - b.length;
  }

  export function parse(string: string): Version {
    return string.split(".").map((part) => +part);
  }

  export function serialize(version: Version): string {
    return version.join(".");
  }
}
