import {
  Resolver,
} from "@better_rules_javascript/rules/javascript/resolver";

export default function (options) {
  const resolver = new Resolver(false, (request) => [
    request,
    `${request}.js`,
    request ? `${request}/index.js` : "index.js",
  ]);
  Resolver.readManifest(resolver, options.manifest, (path) => path);

  return {
    name: "rules-javascript-resolve",
    resolveId(source, importer) {
      try {
        if (importer == null) {
            return resolver.resolveById("", source);
        }
        return resolver.resolve(source, importer);
    } catch (e) {
    }
    return null;
    },
  };
};
