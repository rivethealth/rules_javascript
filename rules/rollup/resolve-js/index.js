"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const resolver_1 = require("@better_rules_javascript/rules/javascript/resolver");
function default_1(options) {
    const resolver = new resolver_1.Resolver(false, (request) => [
        request,
        `${request}.js`,
        request ? `${request}/index.js` : "index.js",
    ]);
    resolver_1.Resolver.readManifest(resolver, options.manifest, (path) => path);
    return {
        name: "rules-javascript-resolve",
        resolveId(source, importer) {
            try {
                if (importer == null) {
                    return resolver.resolveById("", source);
                }
                return resolver.resolve(source, importer);
            }
            catch (e) {
            }
            return null;
        },
    };
}
exports.default = default_1;
;
//# sourceMappingURL=index.js.map