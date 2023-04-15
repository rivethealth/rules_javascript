import { Resolver } from "enhanced-resolve";

/**
 * Plugin using Node.js require
 */
export class RequirePlugin {
  constructor(private readonly paths?: string[]) {
    this.paths = paths;
  }

  apply(resolver: Resolver) {
    const target = resolver.ensureHook("resolved");
    resolver
      .getHook("raw-module")
      .tapAsync("RequirePlugin", (request, resolveContext, callback) => {
        if (!request.request) {
          return callback();
        }
        let path: string;
        try {
          path = require.resolve(request.request, { paths: this.paths });
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
