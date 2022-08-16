import * as Module from "node:module";
const { emit } = process;

// shim module.isBuiltin, added in v18.6.0
const moduleModule = require("node:module");
if (!moduleModule.isBuiltin) {
  const builtins = new Set(Module.builtinModules);
  moduleModule.isBuiltin = (name: string) =>
    name.startsWith("node:") || builtins.has(name);
}

/**
 * @file
 * @see https://github.com/nodejs/node/issues/30810
 */

process.emit = <any>function (name: string, data: any) {
  if (name === "warning" && data?.name === "ExperimentalWarning") {
    return;
  }

  return emit.apply(this, arguments);
};
