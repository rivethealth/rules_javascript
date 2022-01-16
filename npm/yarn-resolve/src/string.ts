export function splitOnce(value: string, delimeter: string): [string, string] {
  const i = value.indexOf(delimeter);
  if (i < 0) {
    throw new Error(`Delimiter ${delimeter} not found`);
  }
  return [value.slice(0, i), value.slice(i + delimeter.length)];
}
