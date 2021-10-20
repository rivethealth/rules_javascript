const PKG_INPUT = /^(.?[^@]+)(?:@(.+))?$/;

export function parsePackageName(input) {
  const [, name, version] = PKG_INPUT.exec(input);
  return { name, version };
};
