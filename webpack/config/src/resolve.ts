import { Resolver } from "enhanced-resolve";
import { createRequire } from "node:module";

/**
 * Plugin using Node.js require
 */
export class RequirePlugin {
  private readonly require: NodeRequire;

  constructor(path: string) {
    this.require = createRequire(path);
  }

  apply(resolver: Resolver) {
    const target = resolver.ensureHook("resolved");
    resolver
      .getHook("raw-module") // same as PnpPlugin
      .tapAsync("RequirePlugin", (request, resolveContext, callback) => {
        if (!request.request) {
          return callback();
        }
        let path: string;
        try {
          path = this.require.resolve(request.request);
        } catch (e) {
          return callback(e instanceof Error ? e : new Error(String(e)));
        }
        resolver.doResolve(
          target,
          { ...request, path },
          `require resolved to: ${path}`,
          resolveContext,
          callback,
        );
      });
  }
}
