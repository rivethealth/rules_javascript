import { Resolver } from "@better-rules-javascript/commonjs-package/resolve";
import module from "module";
import * as path from "path";

function resolveFilename(resolver: Resolver, delegate: Function): Function {
  return function (request, parent) {
    if (
      module.builtinModules.includes(request) ||
      (parent && parent.path === "internal")
    ) {
      return delegate.apply(this, arguments);
    }
    try {
      request = resolver.resolve(
        parent ? parent.path || path.dirname(parent.filename) : "/",
        request,
      );
    } catch (e) {}
    const args = [...arguments];
    if (args[0] !== request) {
      args[0] = request;
    }
    if (args[2]) {
      args[2] = false;
    }
    return delegate.apply(this, args);
  };
}

export function patchModule(resolver: Resolver, delegate: typeof module) {
  (<any>delegate.Module)._resolveFilename = resolveFilename(
    resolver,
    (<any>delegate.Module)._resolveFilename,
  );
}
