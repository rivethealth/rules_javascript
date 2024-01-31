async function load() {
  const { load } = await import("./import.mjs");
  return Reflect.apply(load, this, arguments);
}

async function resolve() {
  const { resolve } = await import("./import.mjs");
  return Reflect.apply(resolve, this, arguments);
}

module.exports = { load, resolve };
