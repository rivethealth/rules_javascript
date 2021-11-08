const PKG_INPUT = /^(.?[^@]+)(?:@(.+))?$/;

export function parsePackageName(input) {
  const [, name, version] = PKG_INPUT.exec(input);
  return { name, version };
}

function normalizeVersion(version: string) {
  if (version.includes(":")) {
    return version;
  }
  return `npm:${version}`;
}

export function specifierV1(name: string, version: string) {
  return `${name}@${version}`;
}

export function specifierV2(name: string, version: string) {
  return `${name}@${normalizeVersion(version)}`;
}
