'use strict';

Object.defineProperty(exports, '__esModule', { value: true });

var path = require('node:path');
var promises = require('node:fs/promises');
var node_fs = require('node:fs');
var Module = require('node:module');
var node_os = require('node:os');
var node_url = require('node:url');

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
var Module__default = /*#__PURE__*/_interopDefaultLegacy(Module);

async function resolve$1() {
    const { resolve } = await Promise.resolve().then(function () { return loader; });
    return await Reflect.apply(await resolve(), this, arguments);
}

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
    function stringMap(valueFormat) {
        return new StringMapJsonFormat(valueFormat);
    }
    JsonFormat.stringMap = stringMap;
    function object(format) {
        return new ObjectJsonFormat(format);
    }
    JsonFormat.object = object;
    function defer(format) {
        let cached;
        return {
            fromJson(json) {
                if (!cached) {
                    cached = format();
                }
                return cached.fromJson(json);
            },
            toJson(value) {
                if (!cached) {
                    cached = format();
                }
                return cached.toJson(value);
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
    function buffer() {
        return new BufferJsonFormat();
    }
    JsonFormat.buffer = buffer;
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
    function symbolConstant(symbol) {
        return new SymbolJsonFormat(symbol);
    }
    JsonFormat.symbolConstant = symbolConstant;
})(JsonFormat || (JsonFormat = {}));
class AnyJsonFormat {
    fromJson(json) {
        return json;
    }
    toJson(value) {
        if (typeof value !== "object" || value === null || Array.isArray(value)) {
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
class BufferJsonFormat {
    fromJson(json) {
        return Buffer.from(json, "base64");
    }
    toJson(value) {
        return value.toString("base64");
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
        return [...value.keys()].sort().map((key) => ({
            key: this.keyFormat.toJson(key),
            value: this.valueFormat.toJson(value.get(key)),
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
class StringMapJsonFormat {
    constructor(valueFormat) {
        this.valueFormat = valueFormat;
    }
    fromJson(json) {
        return new Map(Object.entries(json).map(([key, value]) => [
            key,
            this.valueFormat.fromJson(value),
        ]));
    }
    toJson(value) {
        return Object.fromEntries([...value.keys()]
            .sort()
            .map((key) => [key, this.valueFormat.toJson(value.get(key))]));
    }
}
class SymbolJsonFormat {
    constructor(symbol) {
        this.symbol = symbol;
        if (this.symbol.description === undefined) {
            throw new Error("Symbol has no description");
        }
    }
    fromJson() {
        return this.symbol;
    }
    toJson() {
        return this.symbol.description;
    }
}

var PackageDeps;
(function (PackageDeps) {
    function json() {
        return JsonFormat.map(JsonFormat.string(), JsonFormat.string());
    }
    PackageDeps.json = json;
})(PackageDeps || (PackageDeps = {}));
var Package;
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
            // make error similar to Node.jsv implementation, for optional-require
            const error = new Error(`Cannot find module '${request}', requested by ${parent} in package '${package_.id}'`);
            error.code = "MODULE_NOT_FOUND";
            throw error;
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

function resolveFn(resolver) {
    const specifierClassifier = new SpecifierClassifier();
    const moduleResolver = new LinkModuleResolver();
    return async (specifier, context, defaultResolve) => {
        if (!context.parentURL && path.extname(specifier) == "") {
            return { format: "commonjs", url: specifier, shortCircuit: true };
        }
        let parentPath;
        try {
            parentPath = node_url.fileURLToPath(context.parentURL);
        }
        catch { }
        if (parentPath === undefined ||
            !specifierClassifier.isPackage(specifier) ||
            specifierClassifier.isBuiltin(specifier)) {
            return defaultResolve(specifier, context, defaultResolve);
        }
        const resolved = resolver.resolve(parentPath, specifier);
        return await moduleResolver.resolve(resolved, parentPath, (specifier, requester) => defaultResolve(specifier, { ...context, parentURL: node_url.pathToFileURL(requester) }, defaultResolve));
    };
}
class SpecifierClassifier {
    constructor() {
        this.builtins = new Set(Module__default["default"].builtinModules);
    }
    isBuiltin(specifier) {
        return this.builtins.has(specifier);
    }
    isPackage(specifier) {
        return (!specifier.startsWith("file:") &&
            !specifier.startsWith("node:") &&
            specifier !== "." &&
            specifier !== ".." &&
            !specifier.startsWith("./") &&
            !specifier.startsWith("../") &&
            !specifier.startsWith("/") &&
            !specifier.startsWith("#"));
    }
}
async function createTempDir() {
    const dir = await promises.mkdtemp(path.join(node_os.tmpdir(), "nodejs-"));
    await promises.mkdir(path.join(dir, "node_modules"));
    process.once("exit", () => node_fs.rmSync(dir, { recursive: true }));
    return dir;
}
class LinkModuleResolver {
    constructor() {
        this.packages = new Map();
        this.directory = lazy(createTempDir);
    }
    async resolve(resolved, requester, delegate) {
        const directory = await this.directory();
        const packageName_ = LinkModuleResolver.packageName(resolved.package);
        const linkPath = path.join(directory, "node_modules", packageName_);
        let packageInit = this.packages.get(resolved.package);
        if (packageInit === undefined) {
            packageInit = (async () => {
                await promises.symlink(resolved.package, linkPath);
            })();
            this.packages.set(resolved.package, packageInit);
        }
        await packageInit;
        let specifier = packageName_;
        if (resolved.inner) {
            specifier = `${specifier}/${resolved.inner}`;
        }
        const nodeResolved = await delegate(specifier, path.join(directory, LinkModuleResolver.packageName(requester)));
        const resolvedPath = path.join(resolved.package, path.relative(linkPath, node_url.fileURLToPath(nodeResolved.url)));
        nodeResolved.url = node_url.pathToFileURL(resolvedPath).toString();
        return nodeResolved;
    }
    static packageName(path_) {
        const relative_ = path.relative(process.env.RUNFILES_DIR, path_);
        return `_${relative_.replace(/\//g, "_")}`;
    }
}

const resolve = lazy(async () => {
    const manifestPath = process.env.NODE_PACKAGE_MANIFEST;
    if (!manifestPath) {
        throw new Error("NODE_PACKAGE_MANIFEST is not set");
    }
    const packageTree = JsonFormat.parse(PackageTree.json(), await promises.readFile(manifestPath, "utf8"));
    const resolver = Resolver.create(packageTree, process.env.RUNFILES_DIR);
    return resolveFn(resolver);
});

var loader = /*#__PURE__*/Object.freeze({
    __proto__: null,
    resolve: resolve
});

exports.resolve = resolve$1;
