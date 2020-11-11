const fs = require("fs");
const path = require("path");

/**
 * Resolve modules
 */
class Resolver {
  constructor(trace) {
    this.#trace = trace;
  }

  #trace;
  #globals = new Set();
  #pathToModule = new Map();
  #packageById = new Map();

  /**
   * Set package ID to be globally available.
   * Module must already be added.
   */
  addGlobal(id) {
    this.#globals.add(id);
  }

  /**
   * Add package
   */
  addPackage(id, package_) {
    package_.deps.splice(0, 0, { name: package_.name, id });
    this.#packageById.set(id, package_);
  }

  /**
   * Resolve path to module.
   */
  resolveById(id, request) {
    const package_ = this.#packageById.get(id);
    if (!package_) {
      throw new Error(`Package ${package_} does not exist`);
    }

    const deps = [{ id, name: package_.name }];

    const result = this._resolveDeps(deps, request, []);
    if (!result) {
      throw new Error(`Could not resolve "${request}" in ${id}.`);
    }
    return result;
  }

  /**
   * Resolve path to module.
   */
  resolve(request, parent) {
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

    const attempts = [];
    const result = this._resolveDeps(package_.deps, request, attempts);
    if (!result) {
      throw new Error(
        `Could not resolve "${request}" from ${parent}. Matching packages: ${attempts.join(
          " "
        )}`
      );
    }
    return result;
  }

  _resolveDeps(deps, request, attempts) {
    for (const dep of deps) {
      const package_ = this.#packageById.get(dep.id);
      if (!package_) {
        throw new Error(`Dependency ${dep.id} does not exist`);
      }
      const path = this._resolveDep(
        request,
        dep.id,
        package_,
        dep.name,
        attempts
      );
      if (path) {
        return path;
      }
    }

    for (const id of this.#globals) {
      const package_ = this.#packageById.get(id);
      if (!package_) {
        throw new Error(`Dependency ${id} does not exist`);
      }
      const path = this._resolveDep(
        request,
        id,
        package_,
        package_.name,
        attempts
      );
      if (path) {
        return path;
      }
    }
  }

  _resolveDep(request, id, package_, name, attempts) {
    let requestPart;
    if (request === name) {
      requestPart = package_.main;
    } else if (request.startsWith(`${name}/`)) {
      requestPart = request.slice(`${name}/`.length);
    } else {
      return;
    }

    attempts.push(id);

    const names = [
      requestPart,
      `${requestPart}.js`,
      requestPart ? `${requestPart}/index.js` : "index.js",
    ];

    for (const name of names) {
      let path = package_.runfileByName.get(name);
      if (!path) {
        continue;
      }

      path = fs.realpathSync(path);
      this.#pathToModule.set(path, { name, package: package_ });
      if (this.#trace === "true") {
        console.error(`Resolved "${request}" from ${parent} to be ${path}`);
      }
      return path;
    }
  }

  /**
   * Read and add items from manifest
   */
  static readManifest(resolver, path, runfile) {
    const items = fs
      .readFileSync(path, "utf8")
      .split("\n")
      .filter(Boolean)
      .map((line) => JSON.parse(line));

    for (const item of items) {
      if (item.type !== "PACKAGE") {
        continue;
      }
      const data = item.value;
      const runfileByName = new Map(
        data.modules.map(({ name, file }) => [name, runfile(file)])
      );
      const package_ = {
        name: data.name,
        main: data.main,
        runfileByName,
        deps: data.deps,
      };
      resolver.addPackage(data.id, package_);
    }

    for (const item of items) {
      if (item.type !== "GLOBAL") {
        continue;
      }
      const data = item.value;
      resolver.addGlobal(data);
    }
  }
}

exports.Resolver = Resolver;
