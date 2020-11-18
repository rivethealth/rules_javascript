"use strict";
var _trace, _variations, _globals, _pathToModule, _packageById;
Object.defineProperty(exports, "__esModule", { value: true });
exports.Resolver = void 0;
const tslib_1 = require("tslib");
const fs = require("fs");
const path = require("path");
/**
 * Resolve modules
 */
class Resolver {
    constructor(trace, variations) {
        _trace.set(this, void 0);
        _variations.set(this, void 0);
        _globals.set(this, new Set());
        _pathToModule.set(this, new Map());
        _packageById.set(this, new Map());
        tslib_1.__classPrivateFieldSet(this, _trace, trace);
        tslib_1.__classPrivateFieldSet(this, _variations, variations);
    }
    /**
     * Set package ID to be globally available.
     * Module must already be added.
     */
    addGlobal(id) {
        tslib_1.__classPrivateFieldGet(this, _globals).add(id);
    }
    /**
     * Add package
     */
    addPackage(id, package_) {
        package_.deps.splice(0, 0, { name: package_.name, id });
        tslib_1.__classPrivateFieldGet(this, _packageById).set(id, package_);
        for (const [name, file] of package_.runfileByName.entries()) {
            tslib_1.__classPrivateFieldGet(this, _pathToModule).set(file, { name, package: package_ });
        }
    }
    /**
     * Resolve path to module.
     */
    resolveById(id, request) {
        const package_ = tslib_1.__classPrivateFieldGet(this, _packageById).get(id);
        if (!package_) {
            throw new Error(`Package ${id} does not exist`);
        }
        const result = this._resolveDeps(package_.deps, request, []);
        if (!result) {
            throw new Error(`Could not resolve "${request}" in ${id}.`);
        }
        return result;
    }
    /**
     * Resolve path to module.
     */
    resolve(request, parent) {
        const packageModule = tslib_1.__classPrivateFieldGet(this, _pathToModule).get(parent);
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
            throw new Error(`Could not resolve "${request}" from ${parent}. Matching packages: ${attempts.join(" ")}`);
        }
        return result;
    }
    _resolveDeps(deps, request, attempts) {
        for (const dep of deps) {
            const package_ = tslib_1.__classPrivateFieldGet(this, _packageById).get(dep.id);
            if (!package_) {
                throw new Error(`Dependency ${dep.id} does not exist`);
            }
            const path = this._resolveDep(request, dep.id, package_, dep.name, attempts);
            if (path) {
                return path;
            }
        }
        for (const id of tslib_1.__classPrivateFieldGet(this, _globals)) {
            const package_ = tslib_1.__classPrivateFieldGet(this, _packageById).get(id);
            if (!package_) {
                throw new Error(`Dependency ${id} does not exist`);
            }
            const path = this._resolveDep(request, id, package_, package_.name, attempts);
            if (path) {
                return path;
            }
        }
    }
    _resolveDep(request, id, package_, name, attempts) {
        let requestPart;
        if (request === name) {
            requestPart = package_.main;
        }
        else if (request.startsWith(`${name}/`)) {
            requestPart = request.slice(`${name}/`.length);
        }
        else {
            return;
        }
        attempts.push(id);
        for (const name of tslib_1.__classPrivateFieldGet(this, _variations).call(this, requestPart)) {
            let path = package_.runfileByName.get(name);
            if (!path) {
                continue;
            }
            if (tslib_1.__classPrivateFieldGet(this, _trace) === "true") {
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
            const runfileByName = new Map(data.modules.map(({ name, file }) => [name, runfile(file)]));
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
_trace = new WeakMap(), _variations = new WeakMap(), _globals = new WeakMap(), _pathToModule = new WeakMap(), _packageById = new WeakMap();
//# sourceMappingURL=index.js.map