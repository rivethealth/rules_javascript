import { Resolver } from "@better-rules-javascript/commonjs-package/resolve";
import Module from "module";

function resolveFilename(resolver: Resolver, delegate: Function): Function {
  return function (
    request: string,
    parent: Module,
    isMain: boolean,
    options: any,
  ) {
    if (
      Module.builtinModules.includes(request) ||
      !parent ||
      parent.path === "internal" ||
      request == "." ||
      request.startsWith("./") ||
      request.startsWith("../") ||
      request.startsWith("/")
    ) {
      return delegate.apply(this, arguments);
    }

    const resolved = (request = resolver.resolve(parent.path, request));
    let newRequest = resolved.package.split("/").slice(-1)[0];
    if (resolved.inner) {
      newRequest = `${newRequest}/${resolved.inner}`;
    }

    const resolvedLookupPaths = (<any>Module)._resolveLookupPaths;
    (<any>Module)._resolveLookupPaths = () => [
      resolved.package.split("/").slice(0, -1).join("/"),
    ];
    try {
      return delegate.call(this, newRequest, parent, isMain, options);
    } finally {
      (<any>Module)._resolveLookupPaths = resolvedLookupPaths;
    }
  };
}
export function patchModule(resolver: Resolver, delegate: typeof Module) {
  (<any>delegate)._resolveFilename = resolveFilename(
    resolver,
    (<any>delegate)._resolveFilename,
  );
}
