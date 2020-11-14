const fs = require("fs");
const { Module } = require("module");
const { Resolver } = require(process.env["NODEJS_RESOLVER"]);

const BAZEL_WORKSPACE = process.env["BAZEL_WORKSPACE"];
const MAIN_PACKAGE = process.env["NODEJS_MAIN_PACKAGE"];
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

global.getRunfile = (name) => runfiles.getPath(name);

const resolver = new Resolver(TRACE);
Resolver.readManifest(
  resolver,
  PACKAGES_MANIFEST,
  NODEJS_PACKAGES_RUNFILES == "true" ? getRunfile : (path) => path,
);
global.readResolverManifest = (path) =>
  Resolver.readManifest(resolver, path, (path) => path);
global.resolveById = (id, request) => resolver.resolveById(id, request);

const builtinModules = new Set(Module.builtinModules);

Module._resolveFilename = ((delegate) =>
  function (request, parent, isMain) {
    if (isMain) {
      request = request.slice(process.cwd().length + 1);
      return resolver.resolveById(MAIN_PACKAGE, request);
    }

    if (request.startsWith("/")) {
      return request;
    }

    try {
      return resolver.resolve(request, parent && parent.filename);
    } catch (e) {
      if (builtinModules.has(request)) {
        return delegate.apply(this, arguments);
      }
      throw e;
    }
  })(Module._resolveFilename);
