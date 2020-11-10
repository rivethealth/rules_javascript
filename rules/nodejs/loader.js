const fs = require("fs");
const { Module } = require("module");
const path = require("path");

const BAZEL_WORKSPACE = process.env["BAZEL_WORKSPACE"];
const PACKAGES_MANIFEST = process.env["NODEJS_PACKAGES_MANIFEST"];
const RUNFILES_DIR = process.env["RUNFILES_DIR"];
const RUNFILES_MANIFEST = process.env["RUNFILES_MANIFEST_FILE"];
const MAIN_PACKAGE = process.env["NODEJS_MAIN_PACKAGE"];
const TRACE = process.env["NODEJS_LOADER_TRACE"];

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

class Resolver {
  constructor() {
    const packages = fs
      .readFileSync(PACKAGES_MANIFEST, "utf8")
      .split("\n")
      .filter(Boolean)
      .map((line) => {
        const data = JSON.parse(line);
        const runfileByName = new Map();
        for (const { name, file } of data.modules) {
          runfileByName.set(name, shortPathToRunfile(file));
        }
        return {
          id: data.id,
          name: data.name,
          main: data.main,
          runfileByName,
          deps: data.deps,
        };
      });

    this.#packageById = new Map(packages.map((p) => [p.id, p]));
  }

  #pathToModule = new Map();
  #packageById;

  resolve(request, parent) {
    let deps = [];
    if (parent) {
      const packageModule = this.#pathToModule.get(parent);
      if (!packageModule) {
        throw new Error(`File ${parent} is not a module`);
      }
      const { name, package: package_ } = packageModule;

      if (request.startsWith("./") || request.startsWith("../")) {
        request = path
          .join("/", package_.name, path.dirname(name), request)
          .slice(1);
      }

      deps.push({ name: package_.name, id: package_.id });
      deps.push(...package_.deps);
    } else {
      deps.push({ name: "<main>", id: MAIN_PACKAGE });
    }

    for (const dep of deps) {
      const package_ = this.#packageById.get(dep.id);
      if (!package_) {
        throw new Error(`Dependency ${dep.id} does not exist`);
      }

      let requestPart;
      if (request === dep.name) {
        requestPart = package_.main;
      } else if (request.startsWith(`${dep.name}/`)) {
        requestPart = request.slice(`${dep.name}/`.length);
      } else {
        continue;
      }

      const names = [];
      names.push(requestPart);
      names.push(`${requestPart}.js`);
      names.push(requestPart ? `${requestPart}/index.js` : "index.js");

      for (const name of names) {
        const moduleRunfile = package_.runfileByName.get(name);
        if (moduleRunfile) {
          const path = getRunfile(moduleRunfile);
          this.#pathToModule.set(path, { name, package: package_ });
          if (TRACE === "true") {
            console.error(`Resolved "${request}" from ${parent} to be ${path}`);
          }
          return path;
        }
      }
    }

    throw new Error(`Could not resolve "${request}" from ${parent}`);
  }
}

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
