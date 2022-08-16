import * as Module from "node:module";

function load(delegate: Function): Function {
  return function (path: string) {
    const args = [...arguments];
    if (path === "graceful-fs") {
      args[0] = "fs";
    }
    return delegate.apply(this, args);
  };
}

export function patchModule(delegate: typeof Module) {
  (<any>delegate)._load = load((<any>delegate)._load);
}
