import * as fs from "fs";
import * as path from "path";
const Module = require("module");
import { Resolver } from "@better_rules_javascript/rules/javascript/resolver";

const BAZEL_WORKSPACE = process.env["BAZEL_WORKSPACE"];
const PACKAGES_MANIFEST = process.env["NODEJS_PACKAGES_MANIFEST"];
const NODEJS_PACKAGES_RUNFILES = process.env["NODEJS_PACKAGES_RUNFILES"];
const RUNFILES_DIR = process.env["RUNFILES_DIR"];
const RUNFILES_MANIFEST = process.env["RUNFILES_MANIFEST_FILE"];
const TRACE = process.env["NODEJS_LOADER_TRACE"];

class Runfiles {
  #pathByName = new Map();

  addRunfile(name, path) {
    this.#pathByName.set(name, path);
  }

  getPath(name) {
    if (name.startsWith("../")) {
      name = `${name.slice("../".length)}`;
    } else {
      name = `${BAZEL_WORKSPACE}/${name}`;
    }

    if (RUNFILES_MANIFEST) {
      const path = this.#pathByName.get(name);
      if (!path) {
        throw new Error(`No runfile for ${name}`);
      }
      return path;
    }
    return `${RUNFILES_DIR}/${name}`;
  }

  static readManifest(runfiles, path) {
    const items = fs
      .readFileSync(path, "utf8")
      .split("\n")
      .filter(Boolean)
      .map((line) => {
        const [name, path] = line.split(" ");
        return { name, path };
      });
    for (const { name, path } of items) {
      runfiles.addRunfile(name, path);
    }
  }
}

const runfiles = new Runfiles();
if (RUNFILES_MANIFEST) {
  Runfiles.readManifest(runfiles, RUNFILES_MANIFEST);
}

const getRunfile = name => runfiles.getPath(name);
(<any>global).getRunfile = getRunfile;

const resolver = new Resolver(TRACE, request => [
  request,
  `${request}.js`,
  request ? `${request}/index.js` : "index.js",
]);
Resolver.readManifest(
  resolver,
  PACKAGES_MANIFEST,
  NODEJS_PACKAGES_RUNFILES == "true" ? getRunfile : (path) => path,
);
(<any>global).readResolverManifest = (path) =>
  Resolver.readManifest(resolver, path, (path) => path);
(<any>global).resolveById = (id, request) => resolver.resolveById(id, request);

const builtinModules = new Set(Module.builtinModules);

const cwd = process.cwd();

(<any>Module)._resolveFilename = ((delegate) =>
  function (request, parent, isMain) {
    if (isMain) {
      request = request.slice(cwd.length + 1);
      return resolver.resolveById("", request);
    }

    if (request.startsWith("/")) {
      request = `./${path.relative(path.dirname(parent.filename), request)}`;
    }

    let parentPath;
    if (parent) {
      parentPath = parent.filename;
      if (parentPath.startsWith(cwd + '/')) {
        parentPath = parentPath.slice(cwd.length + 1);
      }
    } else {
      parentPath = null;
    }

    try {
      const result = resolver.resolve(request, parentPath);
      return `${cwd}/${result}`
    } catch (e) {
      if (builtinModules.has(request)) {
        return delegate.apply(this, arguments);
      }
      throw e;
    }
  })((<any>Module)._resolveFilename);
