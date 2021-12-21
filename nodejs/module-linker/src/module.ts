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
      request == ".." ||
      request.startsWith("./") ||
      request.startsWith("../") ||
      request.startsWith("/")
    ) {
      return delegate.apply(this, arguments);
    }

    const resolved = (request = resolver.resolve(parent.path, request));
    const [base, packageName] = resolved.package.split("/node_modules/", 2);
    request = packageName;
    if (resolved.inner) {
      request = `${request}/${resolved.inner}`;
    }

    const newParent = new Module(`${base}/_`, parent);
    newParent.filename = newParent.id;
    newParent.paths = [`${base}/node_modules`];

    return delegate.call(this, request, newParent, isMain, options);
  };
}
export function patchModule(resolver: Resolver, delegate: typeof Module) {
  (<any>delegate)._resolveFilename = resolveFilename(
    resolver,
    (<any>delegate)._resolveFilename,
  );
}
