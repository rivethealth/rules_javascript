export interface NpmSpecifier {
  name: string;
  version: string;
}

// name
// @scope/name
export function parsePackage(package_: string) {
  const [first, second] = package_.split("/");
  if (second) {
    return { scope: first, name: second };
  }
  return { scope: null, name: first };
}

export function npmUrl(specifier: NpmSpecifier) {
  const baseName = parsePackage(specifier.name).name;
  return `https://registry.npmjs.org/${specifier.name}/-/${baseName}-${specifier.version}.tgz`;
}
