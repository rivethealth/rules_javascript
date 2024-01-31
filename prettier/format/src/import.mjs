export function load(specifier) {
  return import(specifier);
}

export function resolve(specifier, parent) {
  return import.meta.resolve(specifier, parent);
}
