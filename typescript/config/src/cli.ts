export function booleanType(str: string) {
  switch (str) {
    case "true":
      return true;
    case "false":
      return false;
  }
  throw new TypeError(`Could not covert string to boolean: ${str}`);
}
