const {
  Resolver,
} = require("@better_rules_javascript/rules/javascript/resolver");

exports.default = function (options) {
  const resolver = new Resolver();
  Resolver.readManifest(resolver, options.manifest, (path) => path);

  return {
    name: "rules-javascript-resolve",
    resolveId(source, importer) {
      if (importer == null) {
        return resolver.resolveById("", source);
      }
      return resolver.resolve(source, importer);
    },
  };
};
