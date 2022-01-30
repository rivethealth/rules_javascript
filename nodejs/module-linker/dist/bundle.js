'use strict';var path=require('path'),fs=require('fs'),Module=require('module');function _interopDefaultLegacy(e){return e&&typeof e==='object'&&'default'in e?e:{'default':e}}function _interopNamespace(e){if(e&&e.__esModule)return e;var n=Object.create(null);if(e){Object.keys(e).forEach(function(k){if(k!=='default'){var d=Object.getOwnPropertyDescriptor(e,k);Object.defineProperty(n,k,d.get?d:{enumerable:true,get:function(){return e[k]}});}})}n["default"]=e;return Object.freeze(n)}var path__namespace=/*#__PURE__*/_interopNamespace(path);var fs__namespace=/*#__PURE__*/_interopNamespace(fs);var Module__default=/*#__PURE__*/_interopDefaultLegacy(Module);class Trie {
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
}function moduleParts(path_) {
    return path_ ? path_.split("/") : [];
}
function pathParts(path_) {
    path_ = path__namespace.resolve(path_);
    return path_.split("/").slice(1);
}
class Resolver {
    constructor(packages) {
        this.packages = packages;
    }
    resolve(parent, request) {
        if (request.startsWith(".") || request.startsWith("/")) {
            throw new Error(`Specifier "${request}" is not for a package`);
        }
        const { value: package_ } = this.packages.getClosest(pathParts(parent));
        if (!package_) {
            throw new Error(`File "${parent}" is not part of any known package`);
        }
        const { rest: depRest, value: dep } = package_.deps.getClosest(moduleParts(request));
        if (!dep) {
            throw new Error(`Package "${package_.id}" does not have any dependency for "${request}"`);
        }
        return { package: dep, inner: depRest.join("/") };
    }
    static create(packageTree, runfiles) {
        const resolve = (path_) => runfiles
            ? path__namespace.resolve(process.env.RUNFILES_DIR, path_)
            : path__namespace.resolve(path_);
        const packages = new Trie();
        for (const [id, package_] of packageTree.entries()) {
            const path_ = pathParts(resolve(package_.path));
            const deps = new Trie();
            for (const [name, dep] of package_.deps.entries()) {
                const package_ = packageTree.get(dep);
                if (!package_) {
                    throw new Error(`Package "${dep}" referenced by "${id}" does not exist`);
                }
                const path_ = resolve(package_.path);
                deps.put(moduleParts(name), path_);
            }
            packages.put(path_, { id: id, deps });
        }
        return new Resolver(packages);
    }
}var JsonFormat;
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
        this.format = format;
    }
    fromJson(json) {
        const result = {};
        for (const key in this.format) {
            if (key in json) {
                result[key] = this.format[key].fromJson(json[key]);
            }
        }
        return result;
    }
    toJson(value) {
        const json = {};
        for (const key in this.format) {
            if (key in value) {
                json[key] = this.format[key].toJson(value[key]);
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
}class Package {
}
(function (Package) {
    function json() {
        return JsonFormat.object({
            id: JsonFormat.string(),
            deps: JsonFormat.map(JsonFormat.string(), JsonFormat.string()),
            path: JsonFormat.string(),
        });
    }
    Package.json = json;
})(Package || (Package = {}));
var PackageTree;
(function (PackageTree) {
    function json() {
        return JsonFormat.map(JsonFormat.string(), Package.json());
    }
    PackageTree.json = json;
})(PackageTree || (PackageTree = {}));function resolveFilename(resolver, delegate) {
    return function (request, parent, isMain) {
        if (Module__default["default"].builtinModules.includes(request) ||
            !parent ||
            parent.path === "internal" ||
            request == "." ||
            request == ".." ||
            request.startsWith("./") ||
            request.startsWith("../") ||
            request.startsWith("/")) {
            return delegate.apply(this, arguments);
        }
        const resolved = resolver.resolve(parent.path, request);
        const [base, packageName] = resolved.package.split("/node_modules/", 2);
        request = packageName;
        if (resolved.inner) {
            request = `${request}/${resolved.inner}`;
        }
        const newParent = new Module__default["default"](`${base}/_`, parent);
        newParent.filename = newParent.id;
        newParent.paths = [`${base}/node_modules`];
        // ignore options, because paths interferes with resolution
        return delegate.call(this, request, newParent, isMain);
    };
}
function patchModule(resolver, delegate) {
    delegate._resolveFilename = resolveFilename(resolver, delegate._resolveFilename);
}const manifestPath = process.env.NODE_PACKAGE_MANIFEST;
if (!manifestPath) {
    throw new Error("NODE_PACKAGE_MANIFEST is not set");
}
const packageTree = JsonFormat.parse(PackageTree.json(), fs__namespace.readFileSync(manifestPath, "utf8"));
const resolver = Resolver.create(packageTree, true);
patchModule(resolver, require("module"));