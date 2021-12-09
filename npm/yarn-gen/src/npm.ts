// name
// @scope/name
export function parsePackage(package_: string) {
  const [first, second] = package_.split("/");
  if (second) {
    return { scope: first, name: second };
  }
  return { scope: null, name: first };
}

export function npmUrl(name: string, version: string) {
  const baseName = parsePackage(name).name;
  return `https://registry.npmjs.org/${name}/-/${baseName}-${version}.tgz`;
}
