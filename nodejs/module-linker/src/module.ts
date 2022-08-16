import { Resolver } from "@better-rules-javascript/commonjs-package/resolve";
import Module from "node:module";
import * as path from "node:path";
import { NodeLinks } from "./link";

function resolveFilename(
  resolver: Resolver,
  links: NodeLinks,
  delegate: Function,
): Function {
  return function (request: string, parent: Module, isMain: boolean) {
    if (
      (<any>Module).isBuiltin(request) ||
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

    const resolved = resolver.resolve(parent.path, request);

    request = path.basename(resolved.package);
    let parentPath = path.dirname(resolved.package);
    if ((<any>Module).isBuiltin(request)) {
      const linkPackage = links.package(resolved.package);
      request = linkPackage.name;
      parentPath = linkPackage.context;
    }

    if (resolved.inner) {
      request = `${request}/${resolved.inner}`;
    }

    parent.paths = [parentPath];

    // ignore options, because paths interferes with resolution
    return delegate.call(this, request, parent, isMain);
  };
}
export function patchModule(
  resolver: Resolver,
  links: NodeLinks,
  delegate: typeof Module,
) {
  (<any>delegate)._resolveFilename = resolveFilename(
    resolver,
    links,
    (<any>delegate)._resolveFilename,
  );
}
