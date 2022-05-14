'use strict';

Object.defineProperty(exports, '__esModule', { value: true });

var path = require('path');
var fs = require('fs');
var Module = require('module');
var os = require('os');
var url = require('url');

function _interopDefaultLegacy (e) { return e && typeof e === 'object' && 'default' in e ? e : { 'default': e }; }

function _interopNamespace(e) {
    if (e && e.__esModule) return e;
    var n = Object.create(null);
    if (e) {
        Object.keys(e).forEach(function (k) {
            if (k !== 'default') {
                var d = Object.getOwnPropertyDescriptor(e, k);
                Object.defineProperty(n, k, d.get ? d : {
                    enumerable: true,
                    get: function () { return e[k]; }
                });
            }
        });
    }
    n["default"] = e;
    return Object.freeze(n);
}

var path__namespace = /*#__PURE__*/_interopNamespace(path);
var fs__namespace = /*#__PURE__*/_interopNamespace(fs);
var Module__default = /*#__PURE__*/_interopDefaultLegacy(Module);
var os__namespace = /*#__PURE__*/_interopNamespace(os);
var url__namespace = /*#__PURE__*/_interopNamespace(url);

var JsonFormat;
(function (JsonFormat) {
    function parse(format, string) {
        return format.fromJson(JSON.parse(string));
    }
    JsonFormat.parse = parse;
    function stringify(format, value) {
        return JSON.stringify(format.toJson(value));
    }
    JsonFormat.stringify = stringify;
})(JsonFormat || (JsonFormat = {}));
(function (JsonFormat) {
    function array(elementFormat) {
        return new ArrayJsonFormat(elementFormat);
    }
    JsonFormat.array = array;
    function map(keyFormat, valueFormat) {
        return new MapJsonFormat(keyFormat, valueFormat);
    }
    JsonFormat.map = map;
    function object(format) {
        return new ObjectJsonFormat(format);
    }
    JsonFormat.object = object;
    function defer(format) {
        return {
            fromJson(json) {
                return format().fromJson(json);
            },
            toJson(value) {
                return format().toJson(value);
            },
        };
    }
    JsonFormat.defer = defer;
    function any() {
        return new AnyJsonFormat();
    }
    JsonFormat.any = any;
    function boolean() {
        return new IdentityJsonFormat();
    }
    JsonFormat.boolean = boolean;
    function identity() {
        return new IdentityJsonFormat();
    }
    JsonFormat.identity = identity;
    function nullable(format) {
        return new NullableJsonFormat(format);
    }
    JsonFormat.nullable = nullable;
    function number() {
        return new IdentityJsonFormat();
    }
    JsonFormat.number = number;
    function set(format) {
        return new SetJsonFormat(format);
    }
    JsonFormat.set = set;
    function string() {
        return new IdentityJsonFormat();
    }
    JsonFormat.string = string;
})(JsonFormat || (JsonFormat = {}));
class AnyJsonFormat {
    fromJson(json) {
        return json;
    }
    toJson(value) {
        if (typeof value !== "object" || value === null || value instanceof Array) {
            return value;
        }
        const json = {};
        for (const key of Object.keys(value).sort()) {
            json[key] = this.toJson(value[key]);
        }
        return json;
    }
}
class ArrayJsonFormat {
    constructor(elementFormat) {
        this.elementFormat = elementFormat;
    }
    fromJson(json) {
        return json.map((element) => this.elementFormat.fromJson(element));
    }
    toJson(json) {
        return json.map((element) => this.elementFormat.toJson(element));
    }
}
class IdentityJsonFormat {
    fromJson(json) {
        return json;
    }
    toJson(value) {
        return value;
    }
}
class ObjectJsonFormat {
    constructor(format) {
        this.properties = (Object.entries(format)).sort(([a], [b]) => (a < b ? -1 : b > a ? 1 : 0));
    }
    fromJson(json) {
        const result = {};
        for (const [key, format] of this.properties) {
            if (key in json) {
                result[key] = format.fromJson(json[key]);
            }
        }
        return result;
    }
    toJson(value) {
        const json = {};
        for (const [key, format] of this.properties) {
            if (key in value) {
                json[key] = format.toJson(value[key]);
            }
        }
        return json;
    }
}
class MapJsonFormat {
    constructor(keyFormat, valueFormat) {
        this.keyFormat = keyFormat;
        this.valueFormat = valueFormat;
    }
    fromJson(json) {
        return new Map(json.map(({ key, value }) => [
            this.keyFormat.fromJson(key),
            this.valueFormat.fromJson(value),
        ]));
    }
    toJson(value) {
        return [...value.entries()].map(([key, value]) => ({
            key: this.keyFormat.toJson(key),
            value: this.valueFormat.toJson(value),
        }));
    }
}
class NullableJsonFormat {
    constructor(format) {
        this.format = format;
    }
    fromJson(json) {
        if (json === null) {
            return null;
        }
        return this.format.fromJson(json);
    }
    toJson(value) {
        if (value === null) {
            return null;
        }
        return this.format.toJson(value);
    }
}
class SetJsonFormat {
    constructor(format) {
        this.format = format;
    }
    fromJson(json) {
        return new Set(json.map((element) => this.format.fromJson(element)));
    }
    toJson(value) {
        return [...value].map((element) => this.format.toJson(element));
    }
}

var PackageDeps;
(function (PackageDeps) {
    function json() {
        return JsonFormat.map(JsonFormat.string(), JsonFormat.string());
    }
    PackageDeps.json = json;
})(PackageDeps || (PackageDeps = {}));
/**
 * Package
 */
class Package {
}
(function (Package) {
    function json() {
        return JsonFormat.object({
            deps: PackageDeps.json(),
            name: JsonFormat.string(),
        });
    }
    Package.json = json;
})(Package || (Package = {}));
var PackageTree;
(function (PackageTree) {
    function json() {
        return JsonFormat.object({
            globals: PackageDeps.json(),
            packages: JsonFormat.map(JsonFormat.string(), Package.json()),
        });
    }
    PackageTree.json = json;
})(PackageTree || (PackageTree = {}));

class Trie {
    constructor() {
        this.data = { children: new Map() };
    }
    getClosest(key) {
        let data = this.data;
        let i;
        for (i = 0; i < key.length && data; i++) {
            const k = key[i];
            const newData = data.children.get(k);
            if (!newData) {
                break;
            }
            data = newData;
        }
        return { rest: key.slice(i), value: data.value };
    }
    put(key, value) {
        let data = this.data;
        for (const k of key) {
            let newData = data.children.get(k);
            if (!newData) {
                newData = { children: new Map() };
                data.children.set(k, newData);
            }
            data = newData;
        }
        data.value = value;
    }
}

function pathParts(path_) {
    path_ = path__namespace.resolve(path_);
    return path_.split("/").slice(1);
}
class Resolver {
    constructor(packages) {
        this.packages = packages;
    }
    root(path) {
        const { value: package_ } = this.packages.getClosest(pathParts(path));
        if (!package_) {
            throw new Error(`File "${path}" is not part of any known package`);
        }
        return package_.id;
    }
    resolve(parent, request) {
        if (request.startsWith(".") || request.startsWith("/")) {
            throw new Error(`Specifier "${request}" is not for a package`);
        }
        const { value: package_ } = this.packages.getClosest(pathParts(parent));
        if (!package_) {
            throw new Error(`File "${parent}" is not part of any known package`);
        }
        const parts = request.split("/");
        const i = request.startsWith("@") ? 2 : 1;
        const dep = package_.deps.get(parts.slice(0, i).join("/"));
        if (!dep) {
            throw new Error(`Package "${package_.id}" does not have any dependency for "${request}", requested by ${parent}`);
        }
        return { package: dep, inner: parts.slice(i).join("/") };
    }
    static create(packageTree, baseDir = "/") {
        const resolve = (path_) => path__namespace.resolve(baseDir, path_);
        const packages = new Trie();
        for (const [path, package_] of packageTree.packages.entries()) {
            const resolvedPath = pathParts(resolve(path));
            const deps = new Map();
            for (const [name, dep] of package_.deps.entries()) {
                deps.set(name, resolve(dep));
            }
            for (const [name, dep] of packageTree.globals.entries()) {
                if (!package_.deps.has(name)) {
                    deps.set(name, resolve(dep));
                }
            }
            packages.put(resolvedPath, { id: path, deps });
        }
        return new Resolver(packages);
    }
}

function lazy(f) {
    let result;
    return () => {
        if (f) {
            result = f();
            f = undefined;
        }
        return result;
    };
}

const manifestPath = process.env.NODE_PACKAGE_MANIFEST;
if (!manifestPath) {
    throw new Error("NODE_PACKAGE_MANIFEST is not set");
}
const packageTree = JsonFormat.parse(PackageTree.json(), fs__namespace.readFileSync(manifestPath, "utf8"));
const linkDirectory = lazy(async () => {
    const dir = await fs__namespace.promises.mkdtemp(path__namespace.join(os__namespace.tmpdir(), "nodejs-"));
    process.once("exit", () => {
        fs__namespace.rmSync(dir, { recursive: true });
    });
    await fs__namespace.promises.mkdir(path__namespace.join(dir, "node_modules"));
    return dir;
});
const linkedPackages = new Set();
const resolver = Resolver.create(packageTree, process.env.RUNFILES_DIR);
async function resolve(specifier, context, defaultResolve) {
    if (!context.parentURL && path__namespace.extname(specifier) == "") {
        return { format: "commonjs", url: specifier };
    }
    let parentPath;
    try {
        parentPath = url__namespace.fileURLToPath(context.parentURL);
    }
    catch (e) { }
    if (parentPath === undefined ||
        Module__default["default"].builtinModules.includes(specifier) ||
        specifier.startsWith("node:") ||
        specifier == "." ||
        specifier == ".." ||
        specifier.startsWith("./") ||
        specifier.startsWith("../") ||
        specifier.startsWith("/") ||
        specifier.startsWith("file://")) {
        return defaultResolve(specifier, context, defaultResolve);
    }
    const resolved = resolver.resolve(parentPath, specifier);
    const directory = await linkDirectory();
    const packageName = path__namespace
        .relative(process.env.RUNFILES_DIR, resolved.package)
        .replace(/\//g, "_");
    const linkPath = path__namespace.join(directory, "node_modules", packageName);
    if (!linkedPackages.has(resolved.package)) {
        linkedPackages.add(resolved.package);
        await fs__namespace.promises.symlink(resolved.package, linkPath);
    }
    specifier = packageName;
    if (resolved.inner) {
        specifier = `${specifier}/${resolved.inner}`;
    }
    parentPath = path__namespace.join(directory, path__namespace.relative(process.env.RUNFILES_DIR, parentPath).replace(/\//g, "_"));
    const nodeResolved = defaultResolve(specifier, { ...context, parentURL: url__namespace.pathToFileURL(parentPath) }, defaultResolve);
    const nodeResolvedPath = url__namespace.fileURLToPath(nodeResolved.url);
    const resolvedPath = path__namespace.join(resolved.package, path__namespace.relative(linkPath, nodeResolvedPath));
    nodeResolved.url = url__namespace.pathToFileURL(resolvedPath).toString();
    return nodeResolved;
}

exports.resolve = resolve;
//# sourceMappingURL=bundle.js.map
