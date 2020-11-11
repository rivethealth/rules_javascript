const fs = require("fs");
const { Module } = require("module");
const { Resolver } = require(process.env["NODEJS_RESOLVER"]);

const BAZEL_WORKSPACE = process.env["BAZEL_WORKSPACE"];
const RUNFILES_DIR = process.env["RUNFILES_DIR"];
const RUNFILES_MANIFEST = process.env["RUNFILES_MANIFEST_FILE"];

function shortPathToRunfile(path) {
  return path.startsWith("../")
    ? path.slice("../".length)
    : `${BAZEL_WORKSPACE}/${path}`;
}

class Runfiles {
  constructor() {
    if (!RUNFILES_MANIFEST) {
      return;
    }
    const runfiles = fs
      .readFileSync(RUNFILES_MANIFEST, "utf8")
      .split("\n")
      .filter(Boolean)
      .map((line) => {
        const [name, path] = line.split(" ");
        return { name, path };
      });
    this.#pathByName = new Map();
    for (const { name, path } of runfiles) {
      this.#pathByName.set(name, path);
    }
  }

  #pathByName;

  getPath(name) {
    if (!this.#pathByName) {
      return `${RUNFILES_DIR}/${name}`;
    }
    const path = this.#pathByName.get(name);
    if (!path) {
      throw new Error(`There is no runfile ${name}`);
    }
    return path;
  }
}

const runfiles = new Runfiles();

global.getRunfile = (name) => runfiles.getPath(name);
global.shortPathToRunfile = shortPathToRunfile;

const resolver = new Resolver();

const builtinModules = new Set(
  Module.builtinModules || Object.keys(process.binding("natives"))
);

Module._resolveFilename = ((delegate) =>
  function (request, parent, isMain) {
    if (isMain) {
      request = request.slice(process.cwd().length + 1);
    }

    if (builtinModules.has(request)) {
      return delegate.apply(this, arguments);
    }

    return resolver.resolve(request, parent && parent.filename);
  })(Module._resolveFilename);
