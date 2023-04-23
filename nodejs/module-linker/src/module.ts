import {
  Resolution,
  Resolver,
} from "@better-rules-javascript/commonjs-package/resolve";
import { lazy } from "@better-rules-javascript/util/cache";
import { mkdtempSync, rmSync, symlinkSync } from "node:fs";
import Module from "node:module";
import { tmpdir } from "node:os";
import { basename, dirname, join, relative } from "node:path";

function resolveFilename(resolver: Resolver, delegate: Function): Function {
  const moduleRequestClassifier = new ModuleRequestClassifier();
  const linkResolver = new LinkModuleResolver();
  const requiredResolver = new RequireModuleResolver();

  return function (
    this: any,
    request: string,
    parent: Module,
    isMain: boolean,
  ) {
    if (
      !parent ||
      parent.path === "internal" ||
      !moduleRequestClassifier.isPackage(request) ||
      moduleRequestClassifier.isBuiltin(request)
    ) {
      return Reflect.apply(delegate, this, arguments);
    }

    const resolved = resolver.resolve(parent.path, request);

    const moduleResolver: ModuleResolver = moduleRequestClassifier.isBuiltin(
      basename(resolved.package),
    )
      ? linkResolver
      : requiredResolver;

    return moduleResolver.resolve(resolved, parent, (request, requester) =>
      // ignore options, because paths interferes with resolution
      delegate.call(this, request, requester, isMain),
    );
  };
}

class ModuleRequestClassifier {
  private readonly builtinModules = new Set(Module.builtinModules);

  isBuiltin(request: string) {
    return this.builtinModules.has(request);
  }

  isPackage(request: string) {
    return (
      !request.startsWith("node:") &&
      request !== "." &&
      request !== ".." &&
      !request.startsWith("./") &&
      !request.startsWith("../") &&
      !request.startsWith("/") &&
      !request.startsWith("#")
    );
  }
}

export function patchModule(resolver: Resolver, delegate: typeof Module) {
  (<any>delegate)._resolveFilename = resolveFilename(
    resolver,
    (<any>delegate)._resolveFilename,
  );
}

interface ModuleResolver {
  resolve(
    resolved: Resolution,
    requester: Module,
    delegate: (request: string, requester: Module) => string,
  ): string;
}

class LinkModuleResolver implements ModuleResolver {
  private readonly packages = new Set<string>();

  private readonly directory = lazy(() => {
    const dir = mkdtempSync(join(tmpdir(), "nodejs-"));
    process.once("exit", () => rmSync(dir, { recursive: true }));
    return dir;
  });

  resolve(
    resolved: Resolution,
    requester: Module,
    delegate: (request: string, requester: Module) => string,
  ) {
    const directory = this.directory();
    const packageName_ = LinkModuleResolver.packageName(resolved.package);
    const linkPath = join(directory, packageName_);
    if (!this.packages.has(resolved.package)) {
      this.packages.add(resolved.package);
      symlinkSync(resolved.package, linkPath);
    }

    let request = packageName_;
    if (resolved.inner) {
      request = `${request}/${resolved.inner}`;
    }

    const parent = new Module(requester.id);
    parent.paths = [directory];
    const nodeResolved = delegate(request, parent);

    return join(resolved.package, relative(linkPath, nodeResolved));
  }

  static packageName(path_: string) {
    const relative_ = relative(process.env.RUNFILES_DIR!, path_);
    return `_${relative_.replace(/\//g, "_")}`;
  }
}

class RequireModuleResolver implements ModuleResolver {
  resolve(
    resolved: Resolution,
    requester: Module,
    delegate: (request: string, requester: Module) => string,
  ) {
    let request = basename(resolved.package);
    if (resolved.inner) {
      request = `${request}/${resolved.inner}`;
    }

    requester.paths = [dirname(resolved.package)];

    return delegate(request, requester);
  }
}
