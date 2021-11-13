import module from "module";
import * as path from "path";

export function load(resolve: any, delegate: Function): Function {
  const resolver = resolve.create.sync({ conditionNames: ["require", "node"] });
  return function (request, parent) {
    if (
      module.builtinModules.includes(request) ||
      (parent && parent.path === "internal")
    ) {
      return delegate.apply(this, arguments);
    } else {
      return resolver(
        parent ? parent.path || path.dirname(parent.filename) : "/",
        request,
      );
    }
  };
}

export function patchModule(resolve: any, delegate: any) {
  (<any>delegate.Module)._resolveFilename = load(
    resolve,
    (<any>delegate.Module)._resolveFilename,
  );
}
