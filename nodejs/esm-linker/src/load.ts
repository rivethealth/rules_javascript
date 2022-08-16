import { Resolver } from "@better-rules-javascript/commonjs-package/resolve";
import Module from "node:module";
import * as path from "node:path";
import * as url from "node:url";
import { NodeModuleLinks } from "./link";

export class Loader {
  constructor(
    private readonly resolver: Resolver,
    private readonly links: NodeModuleLinks,
  ) {}

  async resolve(specifier: string, context: any, nextResolve: Function) {
    if (!context.parentURL && path.extname(specifier) == "") {
      return { format: "commonjs", url: specifier, shortCircuit: true };
    }

    let parentPath: string | undefined;
    try {
      parentPath = url.fileURLToPath(context.parentURL);
    } catch (e) {}

    if (
      parentPath === undefined ||
      (<any>Module).isBuiltin(specifier) ||
      specifier == "." ||
      specifier == ".." ||
      specifier.startsWith("./") ||
      specifier.startsWith("../") ||
      specifier.startsWith("/") ||
      specifier.startsWith("file://")
    ) {
      return nextResolve(specifier, context);
    }

    const resolved = this.resolver.resolve(parentPath, specifier);

    const linkPackage = await this.links.package(resolved.package);
    specifier = linkPackage.name;
    if (resolved.inner) {
      specifier = `${specifier}/${resolved.inner}`;
    }

    const nodeResolved = await nextResolve(specifier, {
      ...context,
      parentURL: url.pathToFileURL(linkPackage.context),
    });

    const nodeResolvedPath = url.fileURLToPath(nodeResolved.url);
    nodeResolved.url = url.pathToFileURL(nodeResolvedPath).toString();
    return nodeResolved;
  }
}
