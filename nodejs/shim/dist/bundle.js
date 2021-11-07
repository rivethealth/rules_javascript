'use strict';

var fs = require('fs');
var path = require('path');
var url_1 = require('url');
var stream_1 = require('stream');
var constants = require('constants');
var util = require('util');
var require$$0 = require('assert');
var require$$0$1 = require('process');
var require$$0$2 = require('module');

function _interopDefaultLegacy (e) { return e && typeof e === 'object' && 'default' in e ? e : { 'default': e }; }

var fs__default = /*#__PURE__*/_interopDefaultLegacy(fs);
var path__default = /*#__PURE__*/_interopDefaultLegacy(path);
var url_1__default = /*#__PURE__*/_interopDefaultLegacy(url_1);
var stream_1__default = /*#__PURE__*/_interopDefaultLegacy(stream_1);
var constants__default = /*#__PURE__*/_interopDefaultLegacy(constants);
var util__default = /*#__PURE__*/_interopDefaultLegacy(util);
var require$$0__default = /*#__PURE__*/_interopDefaultLegacy(require$$0);
var require$$0__default$1 = /*#__PURE__*/_interopDefaultLegacy(require$$0$1);
var require$$0__default$2 = /*#__PURE__*/_interopDefaultLegacy(require$$0$2);

var commonjsGlobal = typeof globalThis !== 'undefined' ? globalThis : typeof window !== 'undefined' ? window : typeof global !== 'undefined' ? global : typeof self !== 'undefined' ? self : {};

function getDefaultExportFromCjs (x) {
	return x && x.__esModule && Object.prototype.hasOwnProperty.call(x, 'default') ? x['default'] : x;
}

function createCommonjsModule(fn, basedir, module) {
	return module = {
		path: basedir,
		exports: {},
		require: function (path, base) {
			return commonjsRequire(path, (base === undefined || base === null) ? module.path : base);
		}
	}, fn(module, module.exports), module.exports;
}

function getAugmentedNamespace(n) {
	if (n.__esModule) return n;
	var a = Object.defineProperty({}, '__esModule', {value: true});
	Object.keys(n).forEach(function (k) {
		var d = Object.getOwnPropertyDescriptor(n, k);
		Object.defineProperty(a, k, d.get ? d : {
			enumerable: true,
			get: function () {
				return n[k];
			}
		});
	});
	return a;
}

function commonjsRequire () {
	throw new Error('Dynamic requires are not currently supported by @rollup/plugin-commonjs');
}

/*! *****************************************************************************
Copyright (c) Microsoft Corporation.

Permission to use, copy, modify, and/or distribute this software for any
purpose with or without fee is hereby granted.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
PERFORMANCE OF THIS SOFTWARE.
***************************************************************************** */
/* global Reflect, Promise */

var extendStatics = function(d, b) {
    extendStatics = Object.setPrototypeOf ||
        ({ __proto__: [] } instanceof Array && function (d, b) { d.__proto__ = b; }) ||
        function (d, b) { for (var p in b) if (Object.prototype.hasOwnProperty.call(b, p)) d[p] = b[p]; };
    return extendStatics(d, b);
};

function __extends(d, b) {
    extendStatics(d, b);
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
}

var __assign = function() {
    __assign = Object.assign || function __assign(t) {
        for (var s, i = 1, n = arguments.length; i < n; i++) {
            s = arguments[i];
            for (var p in s) if (Object.prototype.hasOwnProperty.call(s, p)) t[p] = s[p];
        }
        return t;
    };
    return __assign.apply(this, arguments);
};

function __rest(s, e) {
    var t = {};
    for (var p in s) if (Object.prototype.hasOwnProperty.call(s, p) && e.indexOf(p) < 0)
        t[p] = s[p];
    if (s != null && typeof Object.getOwnPropertySymbols === "function")
        for (var i = 0, p = Object.getOwnPropertySymbols(s); i < p.length; i++) {
            if (e.indexOf(p[i]) < 0 && Object.prototype.propertyIsEnumerable.call(s, p[i]))
                t[p[i]] = s[p[i]];
        }
    return t;
}

function __decorate(decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
}

function __param(paramIndex, decorator) {
    return function (target, key) { decorator(target, key, paramIndex); }
}

function __metadata(metadataKey, metadataValue) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(metadataKey, metadataValue);
}

function __awaiter(thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
}

function __generator(thisArg, body) {
    var _ = { label: 0, sent: function() { if (t[0] & 1) throw t[1]; return t[1]; }, trys: [], ops: [] }, f, y, t, g;
    return g = { next: verb(0), "throw": verb(1), "return": verb(2) }, typeof Symbol === "function" && (g[Symbol.iterator] = function() { return this; }), g;
    function verb(n) { return function (v) { return step([n, v]); }; }
    function step(op) {
        if (f) throw new TypeError("Generator is already executing.");
        while (_) try {
            if (f = 1, y && (t = op[0] & 2 ? y["return"] : op[0] ? y["throw"] || ((t = y["return"]) && t.call(y), 0) : y.next) && !(t = t.call(y, op[1])).done) return t;
            if (y = 0, t) op = [op[0] & 2, t.value];
            switch (op[0]) {
                case 0: case 1: t = op; break;
                case 4: _.label++; return { value: op[1], done: false };
                case 5: _.label++; y = op[1]; op = [0]; continue;
                case 7: op = _.ops.pop(); _.trys.pop(); continue;
                default:
                    if (!(t = _.trys, t = t.length > 0 && t[t.length - 1]) && (op[0] === 6 || op[0] === 2)) { _ = 0; continue; }
                    if (op[0] === 3 && (!t || (op[1] > t[0] && op[1] < t[3]))) { _.label = op[1]; break; }
                    if (op[0] === 6 && _.label < t[1]) { _.label = t[1]; t = op; break; }
                    if (t && _.label < t[2]) { _.label = t[2]; _.ops.push(op); break; }
                    if (t[2]) _.ops.pop();
                    _.trys.pop(); continue;
            }
            op = body.call(thisArg, _);
        } catch (e) { op = [6, e]; y = 0; } finally { f = t = 0; }
        if (op[0] & 5) throw op[1]; return { value: op[0] ? op[1] : void 0, done: true };
    }
}

var __createBinding = Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    Object.defineProperty(o, k2, { enumerable: true, get: function() { return m[k]; } });
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
});

function __exportStar(m, o) {
    for (var p in m) if (p !== "default" && !Object.prototype.hasOwnProperty.call(o, p)) __createBinding(o, m, p);
}

function __values(o) {
    var s = typeof Symbol === "function" && Symbol.iterator, m = s && o[s], i = 0;
    if (m) return m.call(o);
    if (o && typeof o.length === "number") return {
        next: function () {
            if (o && i >= o.length) o = void 0;
            return { value: o && o[i++], done: !o };
        }
    };
    throw new TypeError(s ? "Object is not iterable." : "Symbol.iterator is not defined.");
}

function __read(o, n) {
    var m = typeof Symbol === "function" && o[Symbol.iterator];
    if (!m) return o;
    var i = m.call(o), r, ar = [], e;
    try {
        while ((n === void 0 || n-- > 0) && !(r = i.next()).done) ar.push(r.value);
    }
    catch (error) { e = { error: error }; }
    finally {
        try {
            if (r && !r.done && (m = i["return"])) m.call(i);
        }
        finally { if (e) throw e.error; }
    }
    return ar;
}

function __spread() {
    for (var ar = [], i = 0; i < arguments.length; i++)
        ar = ar.concat(__read(arguments[i]));
    return ar;
}

function __spreadArrays() {
    for (var s = 0, i = 0, il = arguments.length; i < il; i++) s += arguments[i].length;
    for (var r = Array(s), k = 0, i = 0; i < il; i++)
        for (var a = arguments[i], j = 0, jl = a.length; j < jl; j++, k++)
            r[k] = a[j];
    return r;
}
function __await(v) {
    return this instanceof __await ? (this.v = v, this) : new __await(v);
}

function __asyncGenerator(thisArg, _arguments, generator) {
    if (!Symbol.asyncIterator) throw new TypeError("Symbol.asyncIterator is not defined.");
    var g = generator.apply(thisArg, _arguments || []), i, q = [];
    return i = {}, verb("next"), verb("throw"), verb("return"), i[Symbol.asyncIterator] = function () { return this; }, i;
    function verb(n) { if (g[n]) i[n] = function (v) { return new Promise(function (a, b) { q.push([n, v, a, b]) > 1 || resume(n, v); }); }; }
    function resume(n, v) { try { step(g[n](v)); } catch (e) { settle(q[0][3], e); } }
    function step(r) { r.value instanceof __await ? Promise.resolve(r.value.v).then(fulfill, reject) : settle(q[0][2], r); }
    function fulfill(value) { resume("next", value); }
    function reject(value) { resume("throw", value); }
    function settle(f, v) { if (f(v), q.shift(), q.length) resume(q[0][0], q[0][1]); }
}

function __asyncDelegator(o) {
    var i, p;
    return i = {}, verb("next"), verb("throw", function (e) { throw e; }), verb("return"), i[Symbol.iterator] = function () { return this; }, i;
    function verb(n, f) { i[n] = o[n] ? function (v) { return (p = !p) ? { value: __await(o[n](v)), done: n === "return" } : f ? f(v) : v; } : f; }
}

function __asyncValues(o) {
    if (!Symbol.asyncIterator) throw new TypeError("Symbol.asyncIterator is not defined.");
    var m = o[Symbol.asyncIterator], i;
    return m ? m.call(o) : (o = typeof __values === "function" ? __values(o) : o[Symbol.iterator](), i = {}, verb("next"), verb("throw"), verb("return"), i[Symbol.asyncIterator] = function () { return this; }, i);
    function verb(n) { i[n] = o[n] && function (v) { return new Promise(function (resolve, reject) { v = o[n](v), settle(resolve, reject, v.done, v.value); }); }; }
    function settle(resolve, reject, d, v) { Promise.resolve(v).then(function(v) { resolve({ value: v, done: d }); }, reject); }
}

function __makeTemplateObject(cooked, raw) {
    if (Object.defineProperty) { Object.defineProperty(cooked, "raw", { value: raw }); } else { cooked.raw = raw; }
    return cooked;
}
var __setModuleDefault = Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
};

function __importStar(mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (k !== "default" && Object.prototype.hasOwnProperty.call(mod, k)) __createBinding(result, mod, k);
    __setModuleDefault(result, mod);
    return result;
}

function __importDefault(mod) {
    return (mod && mod.__esModule) ? mod : { default: mod };
}

function __classPrivateFieldGet(receiver, privateMap) {
    if (!privateMap.has(receiver)) {
        throw new TypeError("attempted to get private field on non-instance");
    }
    return privateMap.get(receiver);
}

function __classPrivateFieldSet(receiver, privateMap, value) {
    if (!privateMap.has(receiver)) {
        throw new TypeError("attempted to set private field on non-instance");
    }
    privateMap.set(receiver, value);
    return value;
}

var tslib_es6 = /*#__PURE__*/Object.freeze({
	__proto__: null,
	__extends: __extends,
	get __assign () { return __assign; },
	__rest: __rest,
	__decorate: __decorate,
	__param: __param,
	__metadata: __metadata,
	__awaiter: __awaiter,
	__generator: __generator,
	__createBinding: __createBinding,
	__exportStar: __exportStar,
	__values: __values,
	__read: __read,
	__spread: __spread,
	__spreadArrays: __spreadArrays,
	__await: __await,
	__asyncGenerator: __asyncGenerator,
	__asyncDelegator: __asyncDelegator,
	__asyncValues: __asyncValues,
	__makeTemplateObject: __makeTemplateObject,
	__importStar: __importStar,
	__importDefault: __importDefault,
	__classPrivateFieldGet: __classPrivateFieldGet,
	__classPrivateFieldSet: __classPrivateFieldSet
});

var tslib_1 = /*@__PURE__*/getAugmentedNamespace(tslib_es6);

createCommonjsModule(function (module, exports) {
Object.defineProperty(exports, "__esModule", { value: true });

const fs = tslib_1.__importStar(fs__default["default"]);
const BAZEL_WORKSPACE = process.env["BAZEL_WORKSPACE"];
const RUNFILES_DIR = process.env["RUNFILES_DIR"];
const RUNFILES_MANIFEST = process.env["RUNFILES_MANIFEST_FILE"];
function log(str) {
    if (process.env.BAZEL_TRACE_RUNFILES === "true") {
        console.debug(str);
    }
}
/**
 * Bazel has symlinks
 */
class SymlinkRunfiles {
    constructor(runfilesDir, workspace) {
        this.runfilesDir = runfilesDir;
        this.workspace = workspace;
    }
    getPath(name) {
        if (name.startsWith("../")) {
            name = `${name.slice("../".length)}`;
        }
        else {
            name = `${this.workspace}/${name}`;
        }
        return `${this.runfilesDir}/${name}`;
    }
}
/**
 * Uses a manifest
 */
class ManifestRunfiles {
    constructor(workspace) {
        this.workspace = workspace;
        this.pathByName = new Map();
    }
    addRunfile(name, path) {
        this.pathByName.set(name, path);
    }
    getPath(name) {
        if (name.startsWith("../")) {
            name = `${name.slice("../".length)}`;
        }
        else {
            name = `${this.workspace}/${name}`;
        }
        return this.pathByName.get(name);
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
log(`Workspace: ${BAZEL_WORKSPACE}`);
let runfiles;
if (RUNFILES_MANIFEST) {
    log(`Runfiles manifest: ${RUNFILES_MANIFEST}`);
    runfiles = new ManifestRunfiles(BAZEL_WORKSPACE);
    ManifestRunfiles.readManifest(runfiles, RUNFILES_MANIFEST);
}
else {
    log(`Runfiles directory: ${RUNFILES_DIR}`);
    runfiles = new SymlinkRunfiles(RUNFILES_DIR, BAZEL_WORKSPACE);
}
commonjsGlobal.runfilePath = (name) => runfiles.getPath(name);

});

var json = createCommonjsModule(function (module, exports) {
Object.defineProperty(exports, "__esModule", { value: true });
exports.JsonFormat = void 0;
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
    function string() {
        return new StringJsonFormat();
    }
    JsonFormat.string = string;
})(exports.JsonFormat || (exports.JsonFormat = {}));
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
class ObjectJsonFormat {
    constructor(format) {
        this.format = format;
    }
    fromJson(json) {
        const result = {};
        for (const key in this.format) {
            result[key] = this.format[key].fromJson(json[key]);
        }
        return result;
    }
    toJson(value) {
        const json = {};
        for (const key in this.format) {
            json[key] = this.format[key].toJson(value[key]);
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
class StringJsonFormat {
    fromJson(json) {
        return json;
    }
    toJson(value) {
        return value;
    }
}

});

var __rules_commonjs_fs_root = createCommonjsModule(function (module, exports) {
Object.defineProperty(exports, "__esModule", { value: true });
exports.Vfs = exports.FsResult = exports.VfsMount = exports.VfsPath = exports.VfsEntry = void 0;

const path = tslib_1.__importStar(path__default["default"]);

var VfsEntry;
(function (VfsEntry) {
    VfsEntry.DIRECTORY = Symbol("DIRECTORY");
    VfsEntry.LINK = Symbol("LINK");
    VfsEntry.PATH = Symbol("PATH");
    function json$1() {
        let children;
        const result = {
            fromJson(json$1) {
                switch (json$1.type) {
                    case "LINK":
                        return { type: VfsEntry.LINK, path: VfsPath.parse(json$1.path) };
                    case "DIRECTORY":
                        return {
                            type: VfsEntry.DIRECTORY,
                            children: children.fromJson(json$1.children),
                        };
                    case "PATH":
                        return {
                            type: VfsEntry.PATH,
                            path: json.JsonFormat.string().fromJson(json$1.path),
                        };
                }
            },
            toJson(entry) {
                switch (entry.type) {
                    case VfsEntry.LINK:
                        return { type: "LINK", path: VfsPath.text(entry.path) };
                    case VfsEntry.PATH:
                        return { type: "PATH", path: entry.path };
                    case VfsEntry.DIRECTORY:
                        return {
                            type: "DIRECTORY",
                            children: children.toJson(entry.children),
                        };
                }
            },
        };
        children = json.JsonFormat.map(json.JsonFormat.string(), json.JsonFormat.defer(() => result));
        return result;
    }
    VfsEntry.json = json$1;
})(VfsEntry = exports.VfsEntry || (exports.VfsEntry = {}));
var VfsPath;
(function (VfsPath) {
    /**
     * Parse path from text
     */
    function parse(path) {
        if (!path) {
            return [];
        }
        return path.split("/");
    }
    VfsPath.parse = parse;
    /**
     * Convert path to text
     */
    function text(path) {
        return path.join("/");
    }
    VfsPath.text = text;
})(VfsPath = exports.VfsPath || (exports.VfsPath = {}));
/**
 * Mounted part of link file system
 */
class VfsMount {
    constructor(root) {
        this.root = root;
    }
    lookup(path) {
        let entry = this.root;
        for (let i = 0; i < path.length;) {
            switch (entry.type) {
                case VfsEntry.DIRECTORY: {
                    const newEntry = entry.children.get(path[i]);
                    if (!newEntry) {
                        return;
                    }
                    entry = newEntry;
                    i++;
                    break;
                }
                case VfsEntry.LINK:
                    path = [...entry.path, ...path.slice(i)];
                    entry = this.root;
                    i = 0;
                    break;
                case VfsEntry.PATH:
                    return {
                        type: VfsEntry.PATH,
                        path: [entry.path, ...path.slice(i)].join("/"),
                    };
            }
        }
        return entry;
    }
    realpath(path) {
        let realpath = [];
        for (let i = 0, entry = this.root; i < path.length;) {
            switch (entry.type) {
                case VfsEntry.DIRECTORY: {
                    const newEntry = entry.children.get(path[i]);
                    if (!newEntry) {
                        return;
                    }
                    realpath.push(path[i]);
                    entry = newEntry;
                    i++;
                    break;
                }
                case VfsEntry.LINK:
                    realpath.length = 0;
                    path = [...entry.path, ...path.slice(i)];
                    entry = this.root;
                    i = 0;
                    break;
                case VfsEntry.PATH:
                    return [entry.path, ...path.slice(i)].join("/");
            }
        }
        return realpath.join("/");
    }
    *tree() {
        yield* (function* f(entry) {
            switch (entry.type) {
                case VfsEntry.LINK:
                    yield `-> ${entry.path.join("/")}`;
                    break;
                case VfsEntry.PATH:
                    yield entry.path;
                    break;
                case VfsEntry.DIRECTORY:
                    for (const [name, child] of entry.children) {
                        yield `${name}/`;
                        for (const line of f(child)) {
                            yield `  ${line}`;
                        }
                    }
                    break;
            }
        })(this.root);
    }
}
exports.VfsMount = VfsMount;
var FsResult;
(function (FsResult) {
    FsResult.LINK = Symbol("LINK");
    FsResult.PATH = Symbol("PATH");
    FsResult.DIRECTORY = Symbol("DIRECTORY");
    FsResult.NOT_FOUND = Symbol("NOT_FOUND");
    FsResult.NotFound = { type: FsResult.NOT_FOUND };
})(FsResult = exports.FsResult || (exports.FsResult = {}));
/**
 * Link file system.
 * First path component is the mount point.
 */
class Vfs {
    constructor() {
        this._mountPoints = [];
    }
    _resolvePath(path_) {
        path_ = path.resolve(path_);
        const mount = this._mountPoints.find(({ path }) => path === path_ || path_.startsWith(`${path}/`));
        if (!mount) {
            return;
        }
        return {
            mountPoint: mount,
            path: VfsPath.parse(path_.slice(mount.path.length + 1)),
        };
    }
    _prepend(mountPoint, path) {
        if (!path) {
            return mountPoint.path;
        }
        else {
            return `${mountPoint.path}/${path}`;
        }
    }
    /**
     * Add mount
     */
    mount(path_, mount) {
        path_ = path.resolve(path_);
        this._mountPoints.push({ path: path_, mount });
    }
    /**
     * Get entry
     */
    entry(path) {
        const resolvePath = this._resolvePath(path);
        if (!resolvePath) {
            return;
        }
        const { mountPoint, path: remainder } = resolvePath;
        const resolved = mountPoint.mount.lookup(remainder);
        if (resolved === undefined) {
            return FsResult.NotFound;
        }
        switch (resolved.type) {
            case VfsEntry.LINK:
                return {
                    type: FsResult.LINK,
                    path: this._prepend(mountPoint, VfsPath.text(resolved.path)),
                };
            case VfsEntry.PATH:
                return { type: FsResult.PATH, path: resolved.path };
            case VfsEntry.DIRECTORY:
                return { type: FsResult.DIRECTORY, children: resolved.children.keys() };
        }
    }
    realpath(path) {
        const resolved = this._resolvePath(path);
        if (!resolved) {
            return;
        }
        const { mountPoint, path: remainder } = resolved;
        const realpath = mountPoint.mount.realpath(remainder);
        if (realpath === undefined) {
            return FsResult.NotFound;
        }
        return { type: FsResult.PATH, path: this._prepend(mountPoint, realpath) };
    }
    /**
     * Resolve entry
     * @return path or directory, null if does not exist, or undefined if not part of
     *   the virtual file system
     */
    resolve(path) {
        const resolved = this._resolvePath(path);
        if (!resolved) {
            return;
        }
        let { mountPoint, path: remainder } = resolved;
        while (true) {
            const entry = mountPoint.mount.lookup(remainder);
            if (entry === undefined) {
                return FsResult.NotFound;
            }
            switch (entry.type) {
                case VfsEntry.DIRECTORY:
                    return { type: FsResult.DIRECTORY, children: entry.children.keys() };
                case VfsEntry.LINK:
                    remainder = entry.path;
                    break;
                case VfsEntry.PATH:
                    return { type: FsResult.PATH, path: entry.path };
            }
        }
    }
}
exports.Vfs = Vfs;

});

var fs_1 = createCommonjsModule(function (module, exports) {
Object.defineProperty(exports, "__esModule", { value: true });
exports.patchFs = void 0;


const fs = tslib_1.__importStar(fs__default["default"]);


/**
 * @filedescription Node.js fs implementation of LinkFs
 */
const { fs: fsConstants } = process.binding("fs");
class AccessError extends Error {
    constructor(path, syscall) {
        super(`EACCES: permission denied, ${syscall} '${path}'`);
        this.path = path;
        this.syscall = syscall;
        this.code = "EACCES";
        this.errno = -13;
    }
}
class InvalidError extends Error {
    constructor(path, syscall) {
        super(`EINVAL: invalid argument, ${syscall}, ${path}`);
        this.path = path;
        this.syscall = syscall;
        this.code = "EINVAL";
        this.errno = -22;
    }
}
class IsDirError extends Error {
    constructor(path, syscall) {
        super(`EISDIR: illegal operation on a directory, ${syscall}, ${path}`);
        this.syscall = syscall;
        this.code = "EISDIR";
        this.errno = -21;
    }
}
class NotFoundError extends Error {
    constructor(path, syscall) {
        super(`ENOENT: no such file or directory, ${syscall} '${path}'`);
        this.path = path;
        this.syscall = syscall;
        this.code = "ENOENT";
        this.errno = -2;
    }
}
class NoopReadStream extends stream_1__default["default"].Readable {
    constructor(path) {
        super();
        this.path = path;
    }
    get bytesRead() {
        return 0;
    }
    _read() { }
    close() { }
}
class LinkBigintStat {
    constructor(entry) {
        this.entry = entry;
        this.atime = new Date(0);
        this.atimeMs = 0n;
        this.atimeNs = 0n;
        this.birthtime = new Date(0);
        this.birthtimeMs = 0n;
        this.birthtimeNs = 0n;
        this.blksize = 1024n;
        this.blocks = 1n;
        this.ctime = new Date(0);
        this.ctimeMs = 0n;
        this.ctimeNs = 0n;
        this.dev = 0n;
        this.gid = 0n;
        this.ino = 0n;
        this.mode = 493n;
        this.mtime = new Date(0);
        this.mtimeMs = 0n;
        this.mtimeNs = 0n;
        this.nlink = 1n;
        this.rdev = 0n;
        this.size = 1024n;
        this.uid = 0n;
    }
    isFile() {
        return false;
    }
    isDirectory() {
        return this.entry.type === __rules_commonjs_fs_root.FsResult.DIRECTORY;
    }
    isBlockDevice() {
        return false;
    }
    isCharacterDevice() {
        return false;
    }
    isSymbolicLink() {
        return this.entry.type === __rules_commonjs_fs_root.FsResult.LINK;
    }
    isFIFO() {
        return false;
    }
    isSocket() {
        return false;
    }
}
class LinkStat {
    constructor(entry) {
        this.entry = entry;
        this.atime = new Date(0);
        this.atimeMs = 0;
        this.birthtime = new Date(0);
        this.birthtimeMs = 0;
        this.blksize = 1024;
        this.blocks = 1;
        this.ctime = new Date(0);
        this.ctimeMs = 0;
        this.dev = 0;
        this.gid = 0;
        this.ino = 0;
        this.mode = 0o755;
        this.mtime = new Date(0);
        this.mtimeMs = 0;
        this.nlink = 1;
        this.rdev = 0;
        this.size = 1024;
        this.uid = 0;
    }
    isFile() {
        return false;
    }
    isDirectory() {
        return this.entry.type === __rules_commonjs_fs_root.FsResult.DIRECTORY;
    }
    isBlockDevice() {
        return false;
    }
    isCharacterDevice() {
        return false;
    }
    isSymbolicLink() {
        return this.entry.type === __rules_commonjs_fs_root.FsResult.LINK;
    }
    isFIFO() {
        return false;
    }
    isSocket() {
        return false;
    }
}
class LinkDir {
    constructor(dir) {
        this.dir = dir;
        this.iterator = this.dir.children[Symbol.iterator]();
    }
    [Symbol.asyncIterator]() {
        return {
            next: async () => {
                const value = await this.read();
                return { done: !value, value };
            },
            [Symbol.asyncIterator]() {
                return this;
            },
        };
    }
    close(cb) {
        if (cb) {
            setImmediate(cb);
        }
        else {
            return Promise.resolve();
        }
    }
    closeSync() { }
    read(cb) {
        const result = this.readSync();
        if (cb) {
            setImmediate(() => cb(null, result));
            return;
        }
        return Promise.resolve(result);
    }
    readSync() {
        const entry = this.iterator.next();
        if (entry.done) {
            return null;
        }
        return dirEntry(entry.value[0], entry.value[1]);
    }
}
function errorReadStream(path, error) {
    const readStream = new NoopReadStream(path);
    setImmediate(() => readStream.destroy(error));
}
function addPromisify(f) {
    return f;
}
function stringPath(value) {
    if (value instanceof Buffer) {
        value = value.toString();
    }
    if (value instanceof url_1__default["default"].URL) {
        if (value.protocol !== "file:") {
            throw new Error(`Invalid protocol: ${value.protocol}`);
        }
        value = url_1__default["default"].fileURLToPath(value);
    }
    return value;
}
function access(linkFs, delegate) {
    function access(path, mode, callback) {
        const fsPath = stringPath(path);
        if (typeof mode === "function") {
            callback = mode;
            mode = fs.constants.F_OK;
        }
        const resolved = linkFs.resolve(fsPath);
        if (resolved === undefined) {
            return delegate.apply(this, arguments);
        }
        switch (resolved.type) {
            case __rules_commonjs_fs_root.FsResult.DIRECTORY:
                if (mode & fs.constants.W_OK) {
                    callback(new AccessError(stringPath(path), "access"));
                }
                else {
                    callback(null);
                }
                break;
            case __rules_commonjs_fs_root.FsResult.NOT_FOUND:
                callback(new NotFoundError(stringPath(path), "access"));
                break;
            case __rules_commonjs_fs_root.FsResult.PATH:
                const args = [...arguments];
                args[0] = resolved.path;
                return delegate.apply(this, args);
        }
    }
    return addPromisify(access);
}
function accessSync(linkFs, delegate) {
    return function (path, mode) {
        const fsPath = stringPath(path);
        mode = mode || fs.constants.F_OK;
        const resolved = linkFs.resolve(fsPath);
        if (resolved === undefined) {
            return delegate.apply(this, arguments);
        }
        switch (resolved.type) {
            case __rules_commonjs_fs_root.FsResult.DIRECTORY:
                if (mode & fs.constants.W_OK) {
                    throw new AccessError(stringPath(path), "access");
                }
                break;
            case __rules_commonjs_fs_root.FsResult.NOT_FOUND:
                throw new NotFoundError(stringPath(path), "access");
            case __rules_commonjs_fs_root.FsResult.PATH:
                const args = [...arguments];
                args[0] = resolved.path;
                return delegate.apply(this, args);
        }
    };
}
function appendFile(linkFs, delegate) {
    function appendFile(file, data, options, callback) {
        if (typeof file === "number") {
            return delegate.apply(this, arguments);
        }
        const filePath = stringPath(file);
        const resolved = linkFs.resolve(filePath);
        if (resolved === undefined) {
            return delegate.apply(this, arguments);
        }
        if (typeof options === "function") {
            callback = options;
        }
        switch (resolved.type) {
            case __rules_commonjs_fs_root.FsResult.NOT_FOUND:
                callback(null);
                break;
            default:
                callback(new AccessError(stringPath(file), "appendfile"));
        }
    }
    return addPromisify(appendFile);
}
function appendFileSync(linkFs, delegate) {
    return function (file) {
        if (typeof file === "number") {
            return delegate.apply(this, arguments);
        }
        const path = stringPath(file);
        const resolved = linkFs.resolve(path);
        if (resolved == undefined) {
            return delegate.apply(this, arguments);
        }
        switch (resolved.type) {
            case __rules_commonjs_fs_root.FsResult.NOT_FOUND:
                throw new NotFoundError(stringPath(file), "appendfile");
            default:
                throw new AccessError(stringPath(file), "appendfile");
        }
    };
}
function chmod(linkFs, delegate) {
    function chmod(path, mode, callback) {
        const fsPath = stringPath(path);
        const resolved = linkFs.resolve(fsPath);
        if (resolved === undefined) {
            return delegate.apply(this, arguments);
        }
        if (resolved === null) {
            callback(new NotFoundError(stringPath(path), "chmod"));
        }
        else {
            callback(new AccessError(stringPath(path), "chmod"));
        }
    }
    return addPromisify(chmod);
}
function chmodSync(linkFs, delegate) {
    return function (path) {
        const fsPath = stringPath(path);
        const resolved = linkFs.resolve(fsPath);
        if (resolved === undefined) {
            return delegate.apply(this, arguments);
        }
        if (resolved !== undefined) {
            throw new AccessError(stringPath(path), "chmod");
        }
        return delegate.apply(this, arguments);
    };
}
function chown(linkFs, delegate) {
    function chown(path, uid, gid, callback) {
        const fsPath = stringPath(path);
        const resolved = linkFs.resolve(fsPath);
        if (resolved === undefined) {
            return delegate.apply(this, arguments);
        }
        if (resolved === null) {
            callback(new NotFoundError(stringPath(path), "chown"));
        }
        else {
            callback(new AccessError(stringPath(path), "chown"));
        }
    }
    return addPromisify(chown);
}
function chownSync(linkFs, delegate) {
    return function (path) {
        const fsPath = stringPath(path);
        const resolved = linkFs.entry(fsPath);
        if (resolved !== undefined) {
            throw new AccessError(stringPath(path), "chown");
        }
        return delegate.apply(this, arguments);
    };
}
function copyFile(linkFs, delegate) {
    function copyFile(src, dest, flags, callback) {
        const destPath = stringPath(dest);
        const srcPath = stringPath(src);
        const resolvedSrc = linkFs.resolve(srcPath);
        const resolvedDest = linkFs.resolve(destPath);
        if (resolvedSrc === undefined && resolvedDest === undefined) {
            return delegate.apply(this, arguments);
        }
        if (typeof flags === "function") {
            callback = flags;
        }
        if (resolvedDest !== undefined) {
            callback(new AccessError(stringPath(dest), "copyfile"));
            return;
        }
        switch (resolvedSrc.type) {
            case __rules_commonjs_fs_root.FsResult.DIRECTORY:
                callback(new IsDirError(stringPath(src), "copyfile"));
                break;
            case __rules_commonjs_fs_root.FsResult.NOT_FOUND:
                callback(new NotFoundError(stringPath(src), "copyfile"));
                break;
            case __rules_commonjs_fs_root.FsResult.PATH:
                const args = [...arguments];
                args[0] = resolvedSrc.path;
                return delegate.apply(this, args);
        }
    }
    return addPromisify(copyFile);
}
function createReadStream(linkFs, delegate) {
    return function (path) {
        const filePath = stringPath(path);
        const resolved = linkFs.resolve(filePath);
        if (resolved === undefined) {
            return delegate.apply(this, arguments);
        }
        if (resolved == null) {
            return errorReadStream(stringPath(path), new NotFoundError(stringPath(path), "read"));
        }
        switch (resolved.type) {
            case __rules_commonjs_fs_root.FsResult.DIRECTORY: {
                return errorReadStream(stringPath(path), new IsDirError(stringPath(path), "read"));
            }
            case __rules_commonjs_fs_root.FsResult.PATH: {
                const args = [...arguments];
                args[0] = resolved.path;
                return delegate.apply(this, args);
            }
        }
    };
}
function createWriteStream(linkFs, delegate) {
    return function (path) {
        const filePath = stringPath(path);
        const resolved = linkFs.resolve(filePath);
        if (resolved === undefined) {
            return delegate.apply(this, arguments);
        }
        return errorReadStream(stringPath(path), new AccessError(stringPath(path), "read"));
    };
}
function copyFileSync(linkFs, delegate) {
    return function (src, dest, flags) {
        const srcPath = stringPath(src);
        const destPath = stringPath(dest);
        const resolvedSrc = linkFs.resolve(srcPath);
        const resolvedDest = linkFs.resolve(destPath);
        if (resolvedSrc === undefined && resolvedDest === undefined) {
            return delegate.apply(this, arguments);
        }
        if (resolvedDest !== undefined) {
            throw new AccessError(stringPath(dest), "copyfile");
        }
        switch (resolvedSrc.type) {
            case __rules_commonjs_fs_root.FsResult.DIRECTORY:
                throw new IsDirError(stringPath(src), "copyfile");
            case __rules_commonjs_fs_root.FsResult.NOT_FOUND:
                throw new NotFoundError(stringPath(src), "copyfile");
            case __rules_commonjs_fs_root.FsResult.PATH:
                const args = [...arguments];
                args[0] = resolvedSrc.path;
                return delegate.apply(this, args);
        }
    };
}
function exists(linkFs, delegate) {
    function exists(path, callback) {
        const filePath = stringPath(path);
        const resolved = linkFs.resolve(filePath);
        if (resolved === undefined) {
            return delegate.apply(this, arguments);
        }
        if (resolved === undefined) {
            return delegate.apply(this, arguments);
        }
        if (resolved === null) {
            callback(false);
        }
        switch (resolved.type) {
            case __rules_commonjs_fs_root.FsResult.DIRECTORY:
                callback(true);
                break;
            case __rules_commonjs_fs_root.FsResult.PATH:
                const args = [...arguments];
                args[0] = resolved.path;
                return delegate.apply(this, args);
        }
    }
    return addPromisify(exists);
}
function dirEntry(name, entry) {
    switch (entry.type) {
        case __rules_commonjs_fs_root.FsResult.DIRECTORY:
            return new fs.Dir(name, fsConstants.UV_DIRENT_DIR);
        case __rules_commonjs_fs_root.FsResult.LINK:
            return new fs.Dir(name, fsConstants.UV_DIRENT_LINK);
        case __rules_commonjs_fs_root.FsResult.DIRECTORY:
            return new fs.Dir(name, fsConstants.UV_DIRENT_FILE);
    }
}
function existsSync(linkFs, delegate) {
    return function (path) {
        const filePath = stringPath(path);
        const resolved = linkFs.resolve(filePath);
        if (resolved === undefined) {
            return delegate.apply(this, arguments);
        }
        switch (resolved.type) {
            case __rules_commonjs_fs_root.FsResult.DIRECTORY:
                return true;
            case __rules_commonjs_fs_root.FsResult.NOT_FOUND:
                return false;
            case __rules_commonjs_fs_root.FsResult.PATH:
                const args = [...arguments];
                args[0] = resolved.path;
                return delegate.apply(this, args);
        }
    };
}
function mkdir(linkFs, delegate) {
    function mkdir(path, options, callback) {
        const filePath = stringPath(path);
        const resolved = linkFs.resolve(filePath);
        if (resolved === undefined) {
            return delegate.apply(this, arguments);
        }
        if (typeof options === "function") {
            callback = options;
        }
        callback(new AccessError(stringPath(path), "mkdir"));
    }
    return addPromisify(mkdir);
}
function mkdirSync(linkFs, delegate) {
    return function (path) {
        const filePath = stringPath(path);
        const resolved = linkFs.resolve(filePath);
        if (resolved === undefined) {
            return delegate.apply(this, arguments);
        }
        throw new AccessError(stringPath(path), "mkdir");
    };
}
function mkdtemp(linkFs, delegate) {
    function mkdtemp(path, options, callback) {
        const filePath = stringPath(path);
        const resolved = linkFs.resolve(filePath);
        if (resolved === undefined) {
            return delegate.apply(this, arguments);
        }
        if (typeof options === "function") {
            callback = options;
        }
        callback(new AccessError(stringPath(path), "mkdtemp"), null);
    }
    return addPromisify(mkdtemp);
}
function mkdtempSync(linkFs, delegate) {
    return function (path) {
        const filePath = stringPath(path);
        const resolved = linkFs.resolve(filePath);
        if (resolved === undefined) {
            return delegate.apply(this, arguments);
        }
        throw new AccessError(stringPath(path), "mkdtemp");
    };
}
function open(linkFs, delegate) {
    function open(path, flags, mode, callback) {
        const filePath = stringPath(path);
        const resolved = linkFs.resolve(filePath);
        if (resolved === undefined) {
            return delegate.apply(this, arguments);
        }
        if (typeof mode === "function") {
            callback = mode;
        }
        switch (resolved.type) {
            case __rules_commonjs_fs_root.FsResult.DIRECTORY: {
                const args = [...arguments];
                args[0] = "/";
                return delegate.apply(this, args);
            }
            case __rules_commonjs_fs_root.FsResult.NOT_FOUND:
                throw new NotFoundError(stringPath(path), "open");
            case __rules_commonjs_fs_root.FsResult.PATH: {
                const args = [...arguments];
                args[0] = resolved.path;
                return delegate.apply(this, args);
            }
        }
    }
    return addPromisify(open);
}
function openSync(linkFs, delegate) {
    return function (path) {
        const filePath = stringPath(path);
        const resolved = linkFs.resolve(filePath);
        if (resolved === undefined) {
            return delegate.apply(this, arguments);
        }
        switch (resolved.type) {
            case __rules_commonjs_fs_root.FsResult.DIRECTORY: {
                const args = [...arguments];
                args[0] = "/";
                return delegate.apply(this, args);
            }
            case __rules_commonjs_fs_root.FsResult.NOT_FOUND:
                throw new NotFoundError(stringPath(path), "open");
            case __rules_commonjs_fs_root.FsResult.PATH: {
                const args = [...arguments];
                args[0] = resolved.path;
                return delegate.apply(this, args);
            }
        }
    };
}
function opendir(linkFs, delegate) {
    function opendir(path, options, callback) {
        const filePath = stringPath(path);
        const resolved = linkFs.resolve(filePath);
        if (resolved === undefined) {
            return delegate.apply(this, arguments);
        }
        if (typeof options === "function") {
            callback = options;
        }
        switch (resolved.type) {
            case __rules_commonjs_fs_root.FsResult.DIRECTORY:
                callback(null, new LinkDir(resolved));
                return;
            case __rules_commonjs_fs_root.FsResult.PATH:
                callback(new InvalidError(path, "opendir"), null);
                return;
        }
    }
    return addPromisify(opendir);
}
function opendirSync(linkFs, delegate) {
    return function (path) {
        const filePath = stringPath(path);
        const resolved = linkFs.resolve(filePath);
        if (resolved === undefined) {
            return delegate.apply(this, arguments);
        }
        switch (resolved.type) {
            case __rules_commonjs_fs_root.FsResult.DIRECTORY:
                return new LinkDir(resolved);
            case __rules_commonjs_fs_root.FsResult.PATH:
                throw new InvalidError(path, "opendir");
        }
    };
}
function readdir(linkFs, delegate) {
    function readdir(path, options, callback) {
        const filePath = stringPath(path);
        const resolved = linkFs.resolve(filePath);
        if (resolved === undefined) {
            return delegate.apply(this, arguments);
        }
        if (typeof options === "function") {
            callback = options;
        }
        switch (resolved.type) {
            case __rules_commonjs_fs_root.FsResult.DIRECTORY:
                callback(undefined, [...resolved.children]);
                break;
            case __rules_commonjs_fs_root.FsResult.NOT_FOUND:
                callback(new NotFoundError(stringPath(path), "readdir"), undefined);
                break;
            case __rules_commonjs_fs_root.FsResult.PATH:
                callback(new InvalidError(stringPath(path), "readdir"), undefined);
                break;
        }
    }
    return addPromisify(readdir);
}
function readdirSync(linkFs, delegate) {
    return function (path, options) {
        const filePath = stringPath(path);
        const resolved = linkFs.resolve(filePath);
        if (resolved === undefined) {
            return delegate.apply(this, arguments);
        }
        switch (resolved.type) {
            case __rules_commonjs_fs_root.FsResult.DIRECTORY:
                return [...resolved.children];
            case __rules_commonjs_fs_root.FsResult.NOT_FOUND:
                throw new NotFoundError(stringPath(path), "readdir");
            case __rules_commonjs_fs_root.FsResult.PATH:
                throw new InvalidError(stringPath(path), "readdir");
        }
    };
}
function readFile(linkFs, delegate) {
    function readFile(path, options, callback) {
        if (typeof path === "number") {
            return delegate.apply(this, arguments);
        }
        const filePath = stringPath(path);
        const resolved = linkFs.resolve(filePath);
        if (resolved === undefined) {
            return delegate.apply(this, arguments);
        }
        if (typeof options === "function") {
            callback = options;
        }
        switch (resolved.type) {
            case __rules_commonjs_fs_root.FsResult.DIRECTORY:
                callback(new InvalidError(stringPath(path), "readfile"), undefined);
                break;
            case __rules_commonjs_fs_root.FsResult.NOT_FOUND:
                callback(new NotFoundError(stringPath(path), "readfile"), undefined);
                break;
            case __rules_commonjs_fs_root.FsResult.PATH:
                const args = [...arguments];
                args[0] = resolved.path;
                delegate.apply(this, args);
                break;
        }
    }
    return addPromisify(readFile);
}
function readFileSync(linkFs, delegate) {
    return function (path, options) {
        if (typeof path === "number") {
            return delegate.apply(this, arguments);
        }
        const filePath = stringPath(path);
        const resolved = linkFs.resolve(filePath);
        if (resolved === undefined) {
            return delegate.apply(this, arguments);
        }
        switch (resolved.type) {
            case __rules_commonjs_fs_root.FsResult.DIRECTORY:
                throw new InvalidError(stringPath(path), "readfile");
            case __rules_commonjs_fs_root.FsResult.NOT_FOUND:
                throw new NotFoundError(stringPath(path), "readfile");
            case __rules_commonjs_fs_root.FsResult.PATH:
                const args = [...arguments];
                args[0] = resolved.path;
                return delegate.apply(this, args);
        }
    };
}
function readlink(linkFs, delegate) {
    function readlink(path, options, callback) {
        const filePath = stringPath(path);
        const entry = linkFs.entry(filePath);
        if (entry === undefined) {
            return delegate.apply(this, arguments);
        }
        if (typeof options === "function") {
            callback = options;
        }
        switch (entry.type) {
            case __rules_commonjs_fs_root.FsResult.DIRECTORY:
            case __rules_commonjs_fs_root.FsResult.PATH:
                callback(new InvalidError(stringPath(path), "readlink"), undefined);
                return;
            case __rules_commonjs_fs_root.FsResult.NOT_FOUND:
                callback(new NotFoundError(stringPath(path), "readlink"), undefined);
                break;
            case __rules_commonjs_fs_root.FsResult.LINK:
                callback(null, entry.path);
                return;
        }
    }
    return addPromisify(readlink);
}
function readlinkSync(linkFs, delegate) {
    return function (path, options) {
        const filePath = stringPath(path);
        const resolved = linkFs.entry(filePath);
        if (resolved === undefined) {
            return delegate.apply(this, arguments);
        }
        switch (resolved.type) {
            case __rules_commonjs_fs_root.FsResult.DIRECTORY:
            case __rules_commonjs_fs_root.FsResult.PATH:
                throw new InvalidError(stringPath(path), "readlink");
            case __rules_commonjs_fs_root.FsResult.NOT_FOUND:
                throw new NotFoundError(stringPath(path), "readlink");
            case __rules_commonjs_fs_root.FsResult.LINK:
                return resolved.path;
        }
    };
}
function realpath(linkFs, delegate) {
    function realpath(path, options, callback) {
        const filePath = stringPath(path);
        if (typeof options === "function") {
            callback = options;
        }
        const resolved = linkFs.realpath(filePath);
        if (resolved === undefined) {
            return delegate.apply(this, arguments);
        }
        switch (resolved.type) {
            case __rules_commonjs_fs_root.FsResult.NOT_FOUND:
                callback(new NotFoundError(stringPath(path), "lstat"), undefined);
                break;
            case __rules_commonjs_fs_root.FsResult.PATH:
                callback(null, resolved.path);
                break;
        }
    }
    realpath.native = delegate.native;
    return addPromisify(realpath);
}
function realpathSync(linkFs, delegate) {
    function realpathSync(path) {
        const filePath = stringPath(path);
        const resolved = linkFs.realpath(filePath);
        if (resolved === undefined) {
            return delegate.apply(this, arguments);
        }
        switch (resolved.type) {
            case __rules_commonjs_fs_root.FsResult.NOT_FOUND:
                throw new NotFoundError(stringPath(path), "realpath");
            case __rules_commonjs_fs_root.FsResult.PATH:
                return resolved.path;
        }
    }
    realpathSync.native = delegate.native;
    return realpathSync;
}
function rename(linkFs, delegate) {
    function rename(oldPath, newPath, callback) {
        const oldFilePath = stringPath(oldPath);
        const newFilePath = stringPath(newPath);
        const oldResolved = linkFs.entry(oldFilePath);
        const newResolved = linkFs.entry(newFilePath);
        if (oldResolved === undefined && newResolved === undefined) {
            return delegate.apply(this, arguments);
        }
        callback(new AccessError(stringPath(oldPath), "rename"));
    }
    return addPromisify(rename);
}
function renameSync(linkFs, delegate) {
    return function (oldPath, newPath) {
        const oldFilePath = stringPath(oldPath);
        const newFilePath = stringPath(newPath);
        const oldResolved = linkFs.entry(oldFilePath);
        const newResolved = linkFs.entry(newFilePath);
        if (oldResolved === undefined && newResolved === undefined) {
            return delegate.apply(this, arguments);
        }
        throw new AccessError(stringPath(oldPath), "rename");
    };
}
function rmdir(linkFs, delegate) {
    function rmdir(path, options, callback) {
        const filePath = stringPath(path);
        const resolved = linkFs.resolve(filePath);
        if (resolved === undefined) {
            return delegate.apply(this, arguments);
        }
        if (typeof options === "function") {
            callback = options;
        }
        switch (resolved.type) {
            case __rules_commonjs_fs_root.FsResult.NOT_FOUND:
                callback(new NotFoundError(stringPath(path), "rmdir"));
                break;
            default:
                callback(new AccessError(stringPath(path), "rmdir"));
        }
    }
    return addPromisify(rmdir);
}
function rmdirSync(linkFs, delegate) {
    return function (path) {
        const filePath = stringPath(path);
        const resolved = linkFs.resolve(filePath);
        if (resolved === undefined) {
            return delegate.apply(this, arguments);
        }
        switch (resolved.type) {
            case __rules_commonjs_fs_root.FsResult.NOT_FOUND:
                throw new NotFoundError(stringPath(path), "rmdir");
            default:
                throw new AccessError(stringPath(path), "rmdir");
        }
    };
}
function stat(linkFs, delegate) {
    function stat(path, options, callback) {
        const filePath = stringPath(path);
        const resolved = linkFs.resolve(filePath);
        if (resolved === undefined) {
            return delegate.apply(this, arguments);
        }
        if (typeof options === "function") {
            callback = options;
            options = undefined;
        }
        const bigint = options && options.bigint;
        switch (resolved.type) {
            case __rules_commonjs_fs_root.FsResult.DIRECTORY:
                callback(null, (bigint ? new LinkBigintStat(resolved) : new LinkStat(resolved)));
                break;
            case __rules_commonjs_fs_root.FsResult.NOT_FOUND:
                callback(new NotFoundError(stringPath(path), "stat"), null);
                break;
            case __rules_commonjs_fs_root.FsResult.PATH:
                const args = [...arguments];
                args[0] = resolved.path;
                return delegate.apply(this, args);
        }
    }
    return addPromisify(stat);
}
function statSync(linkFs, delegate) {
    function statSync(path, options) {
        const filePath = stringPath(path);
        const resolved = linkFs.resolve(filePath);
        if (resolved === undefined) {
            return delegate.apply(this, arguments);
        }
        const bigint = options && options.bigint;
        switch (resolved.type) {
            case __rules_commonjs_fs_root.FsResult.DIRECTORY:
                return bigint ? new LinkBigintStat(resolved) : new LinkStat(resolved);
            case __rules_commonjs_fs_root.FsResult.NOT_FOUND:
                throw new NotFoundError(stringPath(path), "stat");
            case __rules_commonjs_fs_root.FsResult.PATH:
                const args = [...arguments];
                args[0] = resolved.path;
                return delegate.apply(this, args);
        }
    }
    return statSync;
}
function symlink(linkFs, delegate) {
    function symlink(target, path, type, callback) {
        const tarstringPath = stringPath(target);
        const filePath = stringPath(path);
        const targetResolved = linkFs.resolve(tarstringPath);
        const pathResolved = linkFs.resolve(filePath);
        if (targetResolved === undefined && pathResolved === undefined) {
            return delegate.apply(this, arguments);
        }
        if (typeof type === "function") {
            callback = type;
        }
        if (pathResolved !== undefined) {
            return callback(new AccessError(stringPath(path), "symlink"));
        }
        return callback(new AccessError(stringPath(target), "symlink"));
    }
    return addPromisify(symlink);
}
function symlinkSync(linkFs, delegate) {
    return function (target, path) {
        const tarstringPath = stringPath(target);
        const filePath = stringPath(path);
        const targetResolved = linkFs.resolve(tarstringPath);
        const pathResolved = linkFs.resolve(filePath);
        if (targetResolved === undefined && pathResolved === undefined) {
            return delegate.apply(this, arguments);
        }
        if (pathResolved !== undefined) {
            throw new AccessError(stringPath(path), "symlink");
        }
        throw new AccessError(stringPath(target), "symlink");
    };
}
function truncate(linkFs, delegate) {
    function truncate(path, len, callback) {
        const filePath = stringPath(path);
        const resolved = linkFs.resolve(filePath);
        if (resolved === undefined) {
            return delegate.apply(this, arguments);
        }
        callback(new AccessError(stringPath(path), "truncate"));
    }
    return addPromisify(truncate);
}
function truncateSync(linkFs, delegate) {
    return function (path) {
        const filePath = stringPath(path);
        const resolved = linkFs.resolve(filePath);
        if (resolved === undefined) {
            return delegate.apply(this, arguments);
        }
        throw new AccessError(stringPath(path), "truncate");
    };
}
function unlink(linkFs, delegate) {
    function unlink(path, callback) {
        const filePath = stringPath(path);
        const resolved = linkFs.resolve(filePath);
        if (resolved === undefined) {
            return delegate.apply(this, arguments);
        }
        callback(new AccessError(stringPath(path), "unlink"));
    }
    return addPromisify(unlink);
}
function unlinkSync(linkFs, delegate) {
    return function (path) {
        const filePath = stringPath(path);
        const resolved = linkFs.resolve(filePath);
        if (resolved === undefined) {
            return delegate.apply(this, arguments);
        }
        throw new AccessError(stringPath(path), "unlink");
    };
}
function utimes(linkFs, delegate) {
    function utimes(path, atime, mtime, callback) {
        const filePath = stringPath(path);
        const resolved = linkFs.resolve(filePath);
        if (resolved === undefined) {
            return delegate.apply(this, arguments);
        }
        callback(new AccessError(stringPath(path), "utimes"));
    }
    return addPromisify(utimes);
}
function utimesSync(linkFs, delegate) {
    return function (path) {
        const filePath = stringPath(path);
        const resolved = linkFs.resolve(filePath);
        if (resolved === undefined) {
            return delegate.apply(this, arguments);
        }
        throw new AccessError(stringPath(path), "utimes");
    };
}
function writeFile(linkFs, delegate) {
    function writeFile(path, data, options, callback) {
        if (typeof path === "number") {
            return delegate.apply(this, arguments);
        }
        const filePath = stringPath(path);
        const resolved = linkFs.resolve(filePath);
        if (resolved === undefined) {
            return delegate.apply(this, arguments);
        }
        if (typeof options === "function") {
            callback = options;
        }
        callback(new AccessError(stringPath(path), "writeFile"));
    }
    return addPromisify(writeFile);
}
function writeFileSync(linkFs, delegate) {
    return function (path) {
        if (typeof path === "number") {
            return delegate.apply(this, arguments);
        }
        const filePath = stringPath(path);
        const resolved = linkFs.resolve(filePath);
        if (resolved === undefined) {
            return delegate.apply(this, arguments);
        }
        throw new AccessError(stringPath(path), "writeFile");
    };
}
function patchFs(linkFs, delegate) {
    delegate.access = access(linkFs, delegate.access);
    delegate.accessSync = accessSync(linkFs, delegate.accessSync);
    delegate.appendFile = appendFile(linkFs, delegate.appendFile);
    delegate.appendFileSync = appendFileSync(linkFs, delegate.appendFileSync);
    delegate.chmod = chmod(linkFs, delegate.chmod);
    delegate.chmodSync = chmodSync(linkFs, delegate.chmodSync);
    delegate.chown = chown(linkFs, delegate.chown);
    delegate.chownSync = chownSync(linkFs, delegate.chownSync);
    delegate.copyFile = copyFile(linkFs, delegate.copyFile);
    delegate.copyFileSync = copyFileSync(linkFs, delegate.copyFileSync);
    delegate.createReadStream = createReadStream(linkFs, delegate.createReadStream);
    delegate.createWriteStream = createWriteStream(linkFs, delegate.createWriteStream);
    delegate.exists = exists(linkFs, delegate.exists);
    delegate.existsSync = existsSync(linkFs, delegate.existsSync);
    // delegate.lchmod;
    // delegate.lchmodSync;
    // delegate.lchown;
    // delegate.lchownSync;
    // delegate.lutimes;
    // delegate.lutimesSync;
    delegate.link;
    delegate.linkSync;
    delegate.lstat = stat(linkFs, delegate.stat);
    delegate.lstatSync = statSync(linkFs, delegate.statSync);
    delegate.mkdir = mkdir(linkFs, delegate.mkdir);
    delegate.mkdirSync = mkdirSync(linkFs, delegate.mkdirSync);
    delegate.mkdtemp = mkdtemp(linkFs, delegate.mkdtemp);
    delegate.mkdtempSync = mkdtempSync(linkFs, delegate.mkdtempSync);
    delegate.open = open(linkFs, delegate.open);
    delegate.openSync = openSync(linkFs, delegate.openSync);
    delegate.opendir = opendir(linkFs, delegate.opendir);
    delegate.opendirSync = opendirSync(linkFs, delegate.opendirSync);
    delegate.readdir = readdir(linkFs, delegate.readdir);
    delegate.readdirSync = readdirSync(linkFs, delegate.readdirSync);
    delegate.readFile = readFile(linkFs, delegate.readFile);
    delegate.readFileSync = readFileSync(linkFs, delegate.readFileSync);
    delegate.readlink = readlink(linkFs, delegate.readlink);
    delegate.readlinkSync = readlinkSync(linkFs, delegate.readlinkSync);
    delegate.realpath = realpath(linkFs, delegate.realpath);
    delegate.realpathSync = realpathSync(linkFs, delegate.realpathSync);
    delegate.rename = rename(linkFs, delegate.rename);
    delegate.renameSync = renameSync(linkFs, delegate.renameSync);
    delegate.rmdir = rmdir(linkFs, delegate.rmdir);
    delegate.rmdirSync = rmdirSync(linkFs, delegate.rmdirSync);
    // delegate.rm;
    // delegate.rmSync;
    delegate.stat = stat(linkFs, delegate.stat);
    delegate.statSync = statSync(linkFs, delegate.statSync);
    delegate.symlink = symlink(linkFs, delegate.symlink);
    delegate.symlinkSync = symlinkSync(linkFs, delegate.symlinkSync);
    delegate.truncate = truncate(linkFs, delegate.truncate);
    delegate.truncateSync = truncateSync(linkFs, delegate.truncateSync);
    delegate.unlink = unlink(linkFs, delegate.unlink);
    delegate.unlinkSync = unlinkSync(linkFs, delegate.unlinkSync);
    delegate.utimes = utimes(linkFs, delegate.utimes);
    delegate.utimesSync = utimesSync(linkFs, delegate.unlinkSync);
    delegate.writeFile = writeFile(linkFs, delegate.writeFile);
    delegate.writeFileSync = writeFileSync(linkFs, delegate.writeFileSync);
}
exports.patchFs = patchFs;

});

var traceFs_1 = createCommonjsModule(function (module, exports) {
Object.defineProperty(exports, "__esModule", { value: true });
exports.traceFs = void 0;
function toString(arg) {
    if (arg instanceof Error) {
        return arg.message;
    }
    if (typeof arg === "object" && arg !== null) {
        return arg.constructor.name;
    }
    return String(arg).split("\n")[0];
}
function trace(name, delegate) {
    return function (...args) {
        for (let i = 0; i < args.length; i++) {
            if (args[i] instanceof Function) {
                const f = args[i];
                args[i] = function (...args) {
                    console.error(name, "callback", ...args.map(toString));
                    return f.apply(this, args);
                };
            }
        }
        try {
            const result = delegate.apply(this, args);
            console.error(name, ...args.map(toString), toString(result));
            return result;
        }
        catch (e) {
            console.error(name, ...args.map(toString), toString(e));
            throw e;
        }
    };
}
function traceFs(delegate) {
    delegate.access = trace("access", delegate.access);
    delegate.accessSync = trace("accessSync", delegate.accessSync);
    delegate.appendFile = trace("appendFile", delegate.appendFile);
    delegate.appendFileSync = trace("appendFileSync", delegate.appendFileSync);
    delegate.chmod = trace("chmod", delegate.chmod);
    delegate.chmodSync = trace("chmodSync", delegate.chmodSync);
    delegate.chown = trace("chown", delegate.chown);
    delegate.chownSync = trace("chownSync", delegate.chownSync);
    delegate.copyFile = trace("copyFile", delegate.copyFile);
    delegate.copyFileSync = trace("copyFileSync", delegate.copyFileSync);
    delegate.createReadStream = trace("createReadStream", delegate.createReadStream);
    delegate.createWriteStream = trace("createWriteStream", delegate.createWriteStream);
    delegate.exists = trace("exists", delegate.exists);
    delegate.existsSync = trace("existsSync", delegate.existsSync);
    delegate.lchmod = trace("lchmod", delegate.lchmod);
    delegate.lchmodSync = trace("lchmodSync", delegate.lchmodSync);
    delegate.lchown = trace("lchown", delegate.lchown);
    delegate.lchownSync = trace("lchownSync", delegate.lchownSync);
    delegate.lutimes = trace("lutimes", delegate.lutimes);
    delegate.lutimesSync = trace("lutimesSync", delegate.lutimesSync);
    delegate.link = trace("link", delegate.link);
    delegate.linkSync = trace("linkSync", delegate.linkSync);
    delegate.lstat = trace("lstat", delegate.lstat);
    delegate.lstatSync = trace("lstatSync", delegate.lstatSync);
    delegate.mkdir = trace("mkdir", delegate.mkdir);
    delegate.mkdirSync = trace("mkdirSync", delegate.mkdirSync);
    delegate.mkdtemp = trace("mkdtemp", delegate.mkdtemp);
    delegate.mkdtempSync = trace("mkdtempSync", delegate.mkdtempSync);
    delegate.open = trace("open", delegate.open);
    delegate.openSync = trace("openSync", delegate.openSync);
    delegate.opendir = trace("opendir", delegate.opendir);
    delegate.opendirSync = trace("opendirSync", delegate.opendirSync);
    delegate.readdir = trace("readdir", delegate.readdir);
    delegate.readdirSync = trace("readdirSync", delegate.readdirSync);
    delegate.readFile = trace("readFile", delegate.readFile);
    delegate.readFileSync = trace("readFileSync", delegate.readFileSync);
    delegate.readlink = trace("readlink", delegate.readlink);
    delegate.readlinkSync = trace("readlinkSync", delegate.readlinkSync);
    delegate.realpath = trace("realpath", delegate.realpath);
    delegate.realpathSync = trace("realpathSync", delegate.realpathSync);
    delegate.rename = trace("rename", delegate.rename);
    delegate.renameSync = trace("renameSync", delegate.renameSync);
    delegate.rmdir = trace("rmdir", delegate.rmdir);
    delegate.rmdirSync = trace("rmdirSync`", delegate.rmdirSync);
    // delegate.rm;
    // delegate.rmSync;
    delegate.stat = trace("stat", delegate.stat);
    delegate.statSync = trace("statSync", delegate.statSync);
    delegate.symlink = trace("symlink", delegate.symlink);
    delegate.symlinkSync = trace("symlinkSync", delegate.symlinkSync);
    delegate.truncate = trace("truncate", delegate.truncate);
    delegate.truncateSync = trace("truncateSync", delegate.truncateSync);
    delegate.unlink = trace("unlink", delegate.unlink);
    delegate.unlinkSync = trace("unlinkSync", delegate.unlinkSync);
    delegate.utimes = trace("utimes", delegate.utimes);
    delegate.utimesSync = trace("utimesSync", delegate.unlinkSync);
    delegate.writeFile = trace("writeFile", delegate.writeFile);
    delegate.writeFileSync = trace("writeFileSync", delegate.writeFileSync);
}
exports.traceFs = traceFs;

});

createCommonjsModule(function (module, exports) {
Object.defineProperty(exports, "__esModule", { value: true });



if (process.env.NODE_TRACE_FS === "true") {
    console.error("Shimming Node.js FS");
}
const linkFs = new __rules_commonjs_fs_root.Vfs();
fs_1.patchFs(linkFs, fs__default["default"]);
if (process.env.NODE_TRACE_FS === "true") {
    traceFs_1.traceFs(fs__default["default"]);
}
commonjsGlobal.linkFsMount = (name, config, isRunfiles) => {
    if (process.env.NODE_TRACE_FS === "true") {
        console.error(`Mounting FS ${name}`);
    }
    const entry = __rules_commonjs_fs_root.VfsEntry.json().fromJson(config);
    if (isRunfiles) {
        (function f(entry) {
            switch (entry.type) {
                case __rules_commonjs_fs_root.VfsEntry.DIRECTORY:
                    for (const child of entry.children.values()) {
                        f(child);
                    }
                    break;
                case __rules_commonjs_fs_root.VfsEntry.LINK:
                    break;
                case __rules_commonjs_fs_root.VfsEntry.PATH:
                    entry.path = commonjsGlobal.runfilePath(entry.path) || entry.path;
                    break;
            }
        })(entry);
    }
    const mount = new __rules_commonjs_fs_root.VfsMount(entry);
    if (process.env.NODE_TRACE_FS === "true") {
        for (const line of mount.tree()) {
            console.error(`  ${line}`);
        }
    }
    linkFs.mount(name, mount);
};

});

var origCwd = process.cwd;
var cwd = null;

var platform = process.env.GRACEFUL_FS_PLATFORM || process.platform;

process.cwd = function() {
  if (!cwd)
    cwd = origCwd.call(process);
  return cwd
};
try {
  process.cwd();
} catch (er) {}

// This check is needed until node.js 12 is required
if (typeof process.chdir === 'function') {
  var chdir = process.chdir;
  process.chdir = function (d) {
    cwd = null;
    chdir.call(process, d);
  };
  if (Object.setPrototypeOf) Object.setPrototypeOf(process.chdir, chdir);
}

var polyfills = patch;

function patch (fs) {
  // (re-)implement some things that are known busted or missing.

  // lchmod, broken prior to 0.6.2
  // back-port the fix here.
  if (constants__default["default"].hasOwnProperty('O_SYMLINK') &&
      process.version.match(/^v0\.6\.[0-2]|^v0\.5\./)) {
    patchLchmod(fs);
  }

  // lutimes implementation, or no-op
  if (!fs.lutimes) {
    patchLutimes(fs);
  }

  // https://github.com/isaacs/node-graceful-fs/issues/4
  // Chown should not fail on einval or eperm if non-root.
  // It should not fail on enosys ever, as this just indicates
  // that a fs doesn't support the intended operation.

  fs.chown = chownFix(fs.chown);
  fs.fchown = chownFix(fs.fchown);
  fs.lchown = chownFix(fs.lchown);

  fs.chmod = chmodFix(fs.chmod);
  fs.fchmod = chmodFix(fs.fchmod);
  fs.lchmod = chmodFix(fs.lchmod);

  fs.chownSync = chownFixSync(fs.chownSync);
  fs.fchownSync = chownFixSync(fs.fchownSync);
  fs.lchownSync = chownFixSync(fs.lchownSync);

  fs.chmodSync = chmodFixSync(fs.chmodSync);
  fs.fchmodSync = chmodFixSync(fs.fchmodSync);
  fs.lchmodSync = chmodFixSync(fs.lchmodSync);

  fs.stat = statFix(fs.stat);
  fs.fstat = statFix(fs.fstat);
  fs.lstat = statFix(fs.lstat);

  fs.statSync = statFixSync(fs.statSync);
  fs.fstatSync = statFixSync(fs.fstatSync);
  fs.lstatSync = statFixSync(fs.lstatSync);

  // if lchmod/lchown do not exist, then make them no-ops
  if (!fs.lchmod) {
    fs.lchmod = function (path, mode, cb) {
      if (cb) process.nextTick(cb);
    };
    fs.lchmodSync = function () {};
  }
  if (!fs.lchown) {
    fs.lchown = function (path, uid, gid, cb) {
      if (cb) process.nextTick(cb);
    };
    fs.lchownSync = function () {};
  }

  // on Windows, A/V software can lock the directory, causing this
  // to fail with an EACCES or EPERM if the directory contains newly
  // created files.  Try again on failure, for up to 60 seconds.

  // Set the timeout this long because some Windows Anti-Virus, such as Parity
  // bit9, may lock files for up to a minute, causing npm package install
  // failures. Also, take care to yield the scheduler. Windows scheduling gives
  // CPU to a busy looping process, which can cause the program causing the lock
  // contention to be starved of CPU by node, so the contention doesn't resolve.
  if (platform === "win32") {
    fs.rename = (function (fs$rename) { return function (from, to, cb) {
      var start = Date.now();
      var backoff = 0;
      fs$rename(from, to, function CB (er) {
        if (er
            && (er.code === "EACCES" || er.code === "EPERM")
            && Date.now() - start < 60000) {
          setTimeout(function() {
            fs.stat(to, function (stater, st) {
              if (stater && stater.code === "ENOENT")
                fs$rename(from, to, CB);
              else
                cb(er);
            });
          }, backoff);
          if (backoff < 100)
            backoff += 10;
          return;
        }
        if (cb) cb(er);
      });
    }})(fs.rename);
  }

  // if read() returns EAGAIN, then just try it again.
  fs.read = (function (fs$read) {
    function read (fd, buffer, offset, length, position, callback_) {
      var callback;
      if (callback_ && typeof callback_ === 'function') {
        var eagCounter = 0;
        callback = function (er, _, __) {
          if (er && er.code === 'EAGAIN' && eagCounter < 10) {
            eagCounter ++;
            return fs$read.call(fs, fd, buffer, offset, length, position, callback)
          }
          callback_.apply(this, arguments);
        };
      }
      return fs$read.call(fs, fd, buffer, offset, length, position, callback)
    }

    // This ensures `util.promisify` works as it does for native `fs.read`.
    if (Object.setPrototypeOf) Object.setPrototypeOf(read, fs$read);
    return read
  })(fs.read);

  fs.readSync = (function (fs$readSync) { return function (fd, buffer, offset, length, position) {
    var eagCounter = 0;
    while (true) {
      try {
        return fs$readSync.call(fs, fd, buffer, offset, length, position)
      } catch (er) {
        if (er.code === 'EAGAIN' && eagCounter < 10) {
          eagCounter ++;
          continue
        }
        throw er
      }
    }
  }})(fs.readSync);

  function patchLchmod (fs) {
    fs.lchmod = function (path, mode, callback) {
      fs.open( path
             , constants__default["default"].O_WRONLY | constants__default["default"].O_SYMLINK
             , mode
             , function (err, fd) {
        if (err) {
          if (callback) callback(err);
          return
        }
        // prefer to return the chmod error, if one occurs,
        // but still try to close, and report closing errors if they occur.
        fs.fchmod(fd, mode, function (err) {
          fs.close(fd, function(err2) {
            if (callback) callback(err || err2);
          });
        });
      });
    };

    fs.lchmodSync = function (path, mode) {
      var fd = fs.openSync(path, constants__default["default"].O_WRONLY | constants__default["default"].O_SYMLINK, mode);

      // prefer to return the chmod error, if one occurs,
      // but still try to close, and report closing errors if they occur.
      var threw = true;
      var ret;
      try {
        ret = fs.fchmodSync(fd, mode);
        threw = false;
      } finally {
        if (threw) {
          try {
            fs.closeSync(fd);
          } catch (er) {}
        } else {
          fs.closeSync(fd);
        }
      }
      return ret
    };
  }

  function patchLutimes (fs) {
    if (constants__default["default"].hasOwnProperty("O_SYMLINK")) {
      fs.lutimes = function (path, at, mt, cb) {
        fs.open(path, constants__default["default"].O_SYMLINK, function (er, fd) {
          if (er) {
            if (cb) cb(er);
            return
          }
          fs.futimes(fd, at, mt, function (er) {
            fs.close(fd, function (er2) {
              if (cb) cb(er || er2);
            });
          });
        });
      };

      fs.lutimesSync = function (path, at, mt) {
        var fd = fs.openSync(path, constants__default["default"].O_SYMLINK);
        var ret;
        var threw = true;
        try {
          ret = fs.futimesSync(fd, at, mt);
          threw = false;
        } finally {
          if (threw) {
            try {
              fs.closeSync(fd);
            } catch (er) {}
          } else {
            fs.closeSync(fd);
          }
        }
        return ret
      };

    } else {
      fs.lutimes = function (_a, _b, _c, cb) { if (cb) process.nextTick(cb); };
      fs.lutimesSync = function () {};
    }
  }

  function chmodFix (orig) {
    if (!orig) return orig
    return function (target, mode, cb) {
      return orig.call(fs, target, mode, function (er) {
        if (chownErOk(er)) er = null;
        if (cb) cb.apply(this, arguments);
      })
    }
  }

  function chmodFixSync (orig) {
    if (!orig) return orig
    return function (target, mode) {
      try {
        return orig.call(fs, target, mode)
      } catch (er) {
        if (!chownErOk(er)) throw er
      }
    }
  }


  function chownFix (orig) {
    if (!orig) return orig
    return function (target, uid, gid, cb) {
      return orig.call(fs, target, uid, gid, function (er) {
        if (chownErOk(er)) er = null;
        if (cb) cb.apply(this, arguments);
      })
    }
  }

  function chownFixSync (orig) {
    if (!orig) return orig
    return function (target, uid, gid) {
      try {
        return orig.call(fs, target, uid, gid)
      } catch (er) {
        if (!chownErOk(er)) throw er
      }
    }
  }

  function statFix (orig) {
    if (!orig) return orig
    // Older versions of Node erroneously returned signed integers for
    // uid + gid.
    return function (target, options, cb) {
      if (typeof options === 'function') {
        cb = options;
        options = null;
      }
      function callback (er, stats) {
        if (stats) {
          if (stats.uid < 0) stats.uid += 0x100000000;
          if (stats.gid < 0) stats.gid += 0x100000000;
        }
        if (cb) cb.apply(this, arguments);
      }
      return options ? orig.call(fs, target, options, callback)
        : orig.call(fs, target, callback)
    }
  }

  function statFixSync (orig) {
    if (!orig) return orig
    // Older versions of Node erroneously returned signed integers for
    // uid + gid.
    return function (target, options) {
      var stats = options ? orig.call(fs, target, options)
        : orig.call(fs, target);
      if (stats.uid < 0) stats.uid += 0x100000000;
      if (stats.gid < 0) stats.gid += 0x100000000;
      return stats;
    }
  }

  // ENOSYS means that the fs doesn't support the op. Just ignore
  // that, because it doesn't matter.
  //
  // if there's no getuid, or if getuid() is something other
  // than 0, and the error is EINVAL or EPERM, then just ignore
  // it.
  //
  // This specific case is a silent failure in cp, install, tar,
  // and most other unix tools that manage permissions.
  //
  // When running as root, or if other types of errors are
  // encountered, then it's strict.
  function chownErOk (er) {
    if (!er)
      return true

    if (er.code === "ENOSYS")
      return true

    var nonroot = !process.getuid || process.getuid() !== 0;
    if (nonroot) {
      if (er.code === "EINVAL" || er.code === "EPERM")
        return true
    }

    return false
  }
}

var Stream = stream_1__default["default"].Stream;

var legacyStreams = legacy;

function legacy (fs) {
  return {
    ReadStream: ReadStream,
    WriteStream: WriteStream
  }

  function ReadStream (path, options) {
    if (!(this instanceof ReadStream)) return new ReadStream(path, options);

    Stream.call(this);

    var self = this;

    this.path = path;
    this.fd = null;
    this.readable = true;
    this.paused = false;

    this.flags = 'r';
    this.mode = 438; /*=0666*/
    this.bufferSize = 64 * 1024;

    options = options || {};

    // Mixin options into this
    var keys = Object.keys(options);
    for (var index = 0, length = keys.length; index < length; index++) {
      var key = keys[index];
      this[key] = options[key];
    }

    if (this.encoding) this.setEncoding(this.encoding);

    if (this.start !== undefined) {
      if ('number' !== typeof this.start) {
        throw TypeError('start must be a Number');
      }
      if (this.end === undefined) {
        this.end = Infinity;
      } else if ('number' !== typeof this.end) {
        throw TypeError('end must be a Number');
      }

      if (this.start > this.end) {
        throw new Error('start must be <= end');
      }

      this.pos = this.start;
    }

    if (this.fd !== null) {
      process.nextTick(function() {
        self._read();
      });
      return;
    }

    fs.open(this.path, this.flags, this.mode, function (err, fd) {
      if (err) {
        self.emit('error', err);
        self.readable = false;
        return;
      }

      self.fd = fd;
      self.emit('open', fd);
      self._read();
    });
  }

  function WriteStream (path, options) {
    if (!(this instanceof WriteStream)) return new WriteStream(path, options);

    Stream.call(this);

    this.path = path;
    this.fd = null;
    this.writable = true;

    this.flags = 'w';
    this.encoding = 'binary';
    this.mode = 438; /*=0666*/
    this.bytesWritten = 0;

    options = options || {};

    // Mixin options into this
    var keys = Object.keys(options);
    for (var index = 0, length = keys.length; index < length; index++) {
      var key = keys[index];
      this[key] = options[key];
    }

    if (this.start !== undefined) {
      if ('number' !== typeof this.start) {
        throw TypeError('start must be a Number');
      }
      if (this.start < 0) {
        throw new Error('start must be >= zero');
      }

      this.pos = this.start;
    }

    this.busy = false;
    this._queue = [];

    if (this.fd === null) {
      this._open = fs.open;
      this._queue.push([this._open, this.path, this.flags, this.mode, undefined]);
      this.flush();
    }
  }
}

var clone_1 = clone;

var getPrototypeOf = Object.getPrototypeOf || function (obj) {
  return obj.__proto__
};

function clone (obj) {
  if (obj === null || typeof obj !== 'object')
    return obj

  if (obj instanceof Object)
    var copy = { __proto__: getPrototypeOf(obj) };
  else
    var copy = Object.create(null);

  Object.getOwnPropertyNames(obj).forEach(function (key) {
    Object.defineProperty(copy, key, Object.getOwnPropertyDescriptor(obj, key));
  });

  return copy
}

var gracefulFs = createCommonjsModule(function (module) {
/* istanbul ignore next - node 0.x polyfill */
var gracefulQueue;
var previousSymbol;

/* istanbul ignore else - node 0.x polyfill */
if (typeof Symbol === 'function' && typeof Symbol.for === 'function') {
  gracefulQueue = Symbol.for('graceful-fs.queue');
  // This is used in testing by future versions
  previousSymbol = Symbol.for('graceful-fs.previous');
} else {
  gracefulQueue = '___graceful-fs.queue';
  previousSymbol = '___graceful-fs.previous';
}

function noop () {}

function publishQueue(context, queue) {
  Object.defineProperty(context, gracefulQueue, {
    get: function() {
      return queue
    }
  });
}

var debug = noop;
if (util__default["default"].debuglog)
  debug = util__default["default"].debuglog('gfs4');
else if (/\bgfs4\b/i.test(process.env.NODE_DEBUG || ''))
  debug = function() {
    var m = util__default["default"].format.apply(util__default["default"], arguments);
    m = 'GFS4: ' + m.split(/\n/).join('\nGFS4: ');
    console.error(m);
  };

// Once time initialization
if (!fs__default["default"][gracefulQueue]) {
  // This queue can be shared by multiple loaded instances
  var queue = commonjsGlobal[gracefulQueue] || [];
  publishQueue(fs__default["default"], queue);

  // Patch fs.close/closeSync to shared queue version, because we need
  // to retry() whenever a close happens *anywhere* in the program.
  // This is essential when multiple graceful-fs instances are
  // in play at the same time.
  fs__default["default"].close = (function (fs$close) {
    function close (fd, cb) {
      return fs$close.call(fs__default["default"], fd, function (err) {
        // This function uses the graceful-fs shared queue
        if (!err) {
          resetQueue();
        }

        if (typeof cb === 'function')
          cb.apply(this, arguments);
      })
    }

    Object.defineProperty(close, previousSymbol, {
      value: fs$close
    });
    return close
  })(fs__default["default"].close);

  fs__default["default"].closeSync = (function (fs$closeSync) {
    function closeSync (fd) {
      // This function uses the graceful-fs shared queue
      fs$closeSync.apply(fs__default["default"], arguments);
      resetQueue();
    }

    Object.defineProperty(closeSync, previousSymbol, {
      value: fs$closeSync
    });
    return closeSync
  })(fs__default["default"].closeSync);

  if (/\bgfs4\b/i.test(process.env.NODE_DEBUG || '')) {
    process.on('exit', function() {
      debug(fs__default["default"][gracefulQueue]);
      require$$0__default["default"].equal(fs__default["default"][gracefulQueue].length, 0);
    });
  }
}

if (!commonjsGlobal[gracefulQueue]) {
  publishQueue(commonjsGlobal, fs__default["default"][gracefulQueue]);
}

module.exports = patch(clone_1(fs__default["default"]));
if (process.env.TEST_GRACEFUL_FS_GLOBAL_PATCH && !fs__default["default"].__patched) {
    module.exports = patch(fs__default["default"]);
    fs__default["default"].__patched = true;
}

function patch (fs) {
  // Everything that references the open() function needs to be in here
  polyfills(fs);
  fs.gracefulify = patch;

  fs.createReadStream = createReadStream;
  fs.createWriteStream = createWriteStream;
  var fs$readFile = fs.readFile;
  fs.readFile = readFile;
  function readFile (path, options, cb) {
    if (typeof options === 'function')
      cb = options, options = null;

    return go$readFile(path, options, cb)

    function go$readFile (path, options, cb, startTime) {
      return fs$readFile(path, options, function (err) {
        if (err && (err.code === 'EMFILE' || err.code === 'ENFILE'))
          enqueue([go$readFile, [path, options, cb], err, startTime || Date.now(), Date.now()]);
        else {
          if (typeof cb === 'function')
            cb.apply(this, arguments);
        }
      })
    }
  }

  var fs$writeFile = fs.writeFile;
  fs.writeFile = writeFile;
  function writeFile (path, data, options, cb) {
    if (typeof options === 'function')
      cb = options, options = null;

    return go$writeFile(path, data, options, cb)

    function go$writeFile (path, data, options, cb, startTime) {
      return fs$writeFile(path, data, options, function (err) {
        if (err && (err.code === 'EMFILE' || err.code === 'ENFILE'))
          enqueue([go$writeFile, [path, data, options, cb], err, startTime || Date.now(), Date.now()]);
        else {
          if (typeof cb === 'function')
            cb.apply(this, arguments);
        }
      })
    }
  }

  var fs$appendFile = fs.appendFile;
  if (fs$appendFile)
    fs.appendFile = appendFile;
  function appendFile (path, data, options, cb) {
    if (typeof options === 'function')
      cb = options, options = null;

    return go$appendFile(path, data, options, cb)

    function go$appendFile (path, data, options, cb, startTime) {
      return fs$appendFile(path, data, options, function (err) {
        if (err && (err.code === 'EMFILE' || err.code === 'ENFILE'))
          enqueue([go$appendFile, [path, data, options, cb], err, startTime || Date.now(), Date.now()]);
        else {
          if (typeof cb === 'function')
            cb.apply(this, arguments);
        }
      })
    }
  }

  var fs$copyFile = fs.copyFile;
  if (fs$copyFile)
    fs.copyFile = copyFile;
  function copyFile (src, dest, flags, cb) {
    if (typeof flags === 'function') {
      cb = flags;
      flags = 0;
    }
    return go$copyFile(src, dest, flags, cb)

    function go$copyFile (src, dest, flags, cb, startTime) {
      return fs$copyFile(src, dest, flags, function (err) {
        if (err && (err.code === 'EMFILE' || err.code === 'ENFILE'))
          enqueue([go$copyFile, [src, dest, flags, cb], err, startTime || Date.now(), Date.now()]);
        else {
          if (typeof cb === 'function')
            cb.apply(this, arguments);
        }
      })
    }
  }

  var fs$readdir = fs.readdir;
  fs.readdir = readdir;
  function readdir (path, options, cb) {
    if (typeof options === 'function')
      cb = options, options = null;

    return go$readdir(path, options, cb)

    function go$readdir (path, options, cb, startTime) {
      return fs$readdir(path, options, function (err, files) {
        if (err && (err.code === 'EMFILE' || err.code === 'ENFILE'))
          enqueue([go$readdir, [path, options, cb], err, startTime || Date.now(), Date.now()]);
        else {
          if (files && files.sort)
            files.sort();

          if (typeof cb === 'function')
            cb.call(this, err, files);
        }
      })
    }
  }

  if (process.version.substr(0, 4) === 'v0.8') {
    var legStreams = legacyStreams(fs);
    ReadStream = legStreams.ReadStream;
    WriteStream = legStreams.WriteStream;
  }

  var fs$ReadStream = fs.ReadStream;
  if (fs$ReadStream) {
    ReadStream.prototype = Object.create(fs$ReadStream.prototype);
    ReadStream.prototype.open = ReadStream$open;
  }

  var fs$WriteStream = fs.WriteStream;
  if (fs$WriteStream) {
    WriteStream.prototype = Object.create(fs$WriteStream.prototype);
    WriteStream.prototype.open = WriteStream$open;
  }

  Object.defineProperty(fs, 'ReadStream', {
    get: function () {
      return ReadStream
    },
    set: function (val) {
      ReadStream = val;
    },
    enumerable: true,
    configurable: true
  });
  Object.defineProperty(fs, 'WriteStream', {
    get: function () {
      return WriteStream
    },
    set: function (val) {
      WriteStream = val;
    },
    enumerable: true,
    configurable: true
  });

  // legacy names
  var FileReadStream = ReadStream;
  Object.defineProperty(fs, 'FileReadStream', {
    get: function () {
      return FileReadStream
    },
    set: function (val) {
      FileReadStream = val;
    },
    enumerable: true,
    configurable: true
  });
  var FileWriteStream = WriteStream;
  Object.defineProperty(fs, 'FileWriteStream', {
    get: function () {
      return FileWriteStream
    },
    set: function (val) {
      FileWriteStream = val;
    },
    enumerable: true,
    configurable: true
  });

  function ReadStream (path, options) {
    if (this instanceof ReadStream)
      return fs$ReadStream.apply(this, arguments), this
    else
      return ReadStream.apply(Object.create(ReadStream.prototype), arguments)
  }

  function ReadStream$open () {
    var that = this;
    open(that.path, that.flags, that.mode, function (err, fd) {
      if (err) {
        if (that.autoClose)
          that.destroy();

        that.emit('error', err);
      } else {
        that.fd = fd;
        that.emit('open', fd);
        that.read();
      }
    });
  }

  function WriteStream (path, options) {
    if (this instanceof WriteStream)
      return fs$WriteStream.apply(this, arguments), this
    else
      return WriteStream.apply(Object.create(WriteStream.prototype), arguments)
  }

  function WriteStream$open () {
    var that = this;
    open(that.path, that.flags, that.mode, function (err, fd) {
      if (err) {
        that.destroy();
        that.emit('error', err);
      } else {
        that.fd = fd;
        that.emit('open', fd);
      }
    });
  }

  function createReadStream (path, options) {
    return new fs.ReadStream(path, options)
  }

  function createWriteStream (path, options) {
    return new fs.WriteStream(path, options)
  }

  var fs$open = fs.open;
  fs.open = open;
  function open (path, flags, mode, cb) {
    if (typeof mode === 'function')
      cb = mode, mode = null;

    return go$open(path, flags, mode, cb)

    function go$open (path, flags, mode, cb, startTime) {
      return fs$open(path, flags, mode, function (err, fd) {
        if (err && (err.code === 'EMFILE' || err.code === 'ENFILE'))
          enqueue([go$open, [path, flags, mode, cb], err, startTime || Date.now(), Date.now()]);
        else {
          if (typeof cb === 'function')
            cb.apply(this, arguments);
        }
      })
    }
  }

  return fs
}

function enqueue (elem) {
  debug('ENQUEUE', elem[0].name, elem[1]);
  fs__default["default"][gracefulQueue].push(elem);
  retry();
}

// keep track of the timeout between retry() calls
var retryTimer;

// reset the startTime and lastTime to now
// this resets the start of the 60 second overall timeout as well as the
// delay between attempts so that we'll retry these jobs sooner
function resetQueue () {
  var now = Date.now();
  for (var i = 0; i < fs__default["default"][gracefulQueue].length; ++i) {
    // entries that are only a length of 2 are from an older version, don't
    // bother modifying those since they'll be retried anyway.
    if (fs__default["default"][gracefulQueue][i].length > 2) {
      fs__default["default"][gracefulQueue][i][3] = now; // startTime
      fs__default["default"][gracefulQueue][i][4] = now; // lastTime
    }
  }
  // call retry to make sure we're actively processing the queue
  retry();
}

function retry () {
  // clear the timer and remove it to help prevent unintended concurrency
  clearTimeout(retryTimer);
  retryTimer = undefined;

  if (fs__default["default"][gracefulQueue].length === 0)
    return

  var elem = fs__default["default"][gracefulQueue].shift();
  var fn = elem[0];
  var args = elem[1];
  // these items may be unset if they were added by an older graceful-fs
  var err = elem[2];
  var startTime = elem[3];
  var lastTime = elem[4];

  // if we don't have a startTime we have no way of knowing if we've waited
  // long enough, so go ahead and retry this item now
  if (startTime === undefined) {
    debug('RETRY', fn.name, args);
    fn.apply(null, args);
  } else if (Date.now() - startTime >= 60000) {
    // it's been more than 60 seconds total, bail now
    debug('TIMEOUT', fn.name, args);
    var cb = args.pop();
    if (typeof cb === 'function')
      cb.call(null, err);
  } else {
    // the amount of time between the last attempt and right now
    var sinceAttempt = Date.now() - lastTime;
    // the amount of time between when we first tried, and when we last tried
    // rounded up to at least 1
    var sinceStart = Math.max(lastTime - startTime, 1);
    // backoff. wait longer than the total time we've been retrying, but only
    // up to a maximum of 100ms
    var desiredDelay = Math.min(sinceStart * 1.2, 100);
    // it's been long enough since the last retry, do it again
    if (sinceAttempt >= desiredDelay) {
      debug('RETRY', fn.name, args);
      fn.apply(null, args.concat([startTime]));
    } else {
      // if we can't do this job yet, push it to the end of the queue
      // and let the next iteration check again
      fs__default["default"][gracefulQueue].push(elem);
    }
  }

  // schedule our next run if one isn't already scheduled
  if (retryTimer === undefined) {
    retryTimer = setTimeout(retry, 0);
  }
}
});

const nextTick = require$$0__default$1["default"].nextTick;

/** @typedef {import("./Resolver").FileSystem} FileSystem */
/** @typedef {import("./Resolver").SyncFileSystem} SyncFileSystem */

const dirname = path => {
	let idx = path.length - 1;
	while (idx >= 0) {
		const c = path.charCodeAt(idx);
		// slash or backslash
		if (c === 47 || c === 92) break;
		idx--;
	}
	if (idx < 0) return "";
	return path.slice(0, idx);
};

const runCallbacks = (callbacks, err, result) => {
	if (callbacks.length === 1) {
		callbacks[0](err, result);
		callbacks.length = 0;
		return;
	}
	let error;
	for (const callback of callbacks) {
		try {
			callback(err, result);
		} catch (e) {
			if (!error) error = e;
		}
	}
	callbacks.length = 0;
	if (error) throw error;
};

class OperationMergerBackend {
	/**
	 * @param {any} provider async method
	 * @param {any} syncProvider sync method
	 * @param {any} providerContext call context for the provider methods
	 */
	constructor(provider, syncProvider, providerContext) {
		this._provider = provider;
		this._syncProvider = syncProvider;
		this._providerContext = providerContext;
		this._activeAsyncOperations = new Map();

		this.provide = this._provider
			? (path, options, callback) => {
					if (typeof options === "function") {
						callback = options;
						options = undefined;
					}
					if (options) {
						return this._provider.call(
							this._providerContext,
							path,
							options,
							callback
						);
					}
					if (typeof path !== "string") {
						callback(new TypeError("path must be a string"));
						return;
					}
					let callbacks = this._activeAsyncOperations.get(path);
					if (callbacks) {
						callbacks.push(callback);
						return;
					}
					this._activeAsyncOperations.set(path, (callbacks = [callback]));
					provider(path, (err, result) => {
						this._activeAsyncOperations.delete(path);
						runCallbacks(callbacks, err, result);
					});
			  }
			: null;
		this.provideSync = this._syncProvider
			? (path, options) => {
					return this._syncProvider.call(this._providerContext, path, options);
			  }
			: null;
	}

	purge() {}
	purgeParent() {}
}

/*

IDLE:
	insert data: goto SYNC

SYNC:
	before provide: run ticks
	event loop tick: goto ASYNC_ACTIVE

ASYNC:
	timeout: run tick, goto ASYNC_PASSIVE

ASYNC_PASSIVE:
	before provide: run ticks

IDLE --[insert data]--> SYNC --[event loop tick]--> ASYNC_ACTIVE --[interval tick]-> ASYNC_PASSIVE
                                                          ^                             |
                                                          +---------[insert data]-------+
*/

const STORAGE_MODE_IDLE = 0;
const STORAGE_MODE_SYNC = 1;
const STORAGE_MODE_ASYNC = 2;

class CacheBackend {
	/**
	 * @param {number} duration max cache duration of items
	 * @param {any} provider async method
	 * @param {any} syncProvider sync method
	 * @param {any} providerContext call context for the provider methods
	 */
	constructor(duration, provider, syncProvider, providerContext) {
		this._duration = duration;
		this._provider = provider;
		this._syncProvider = syncProvider;
		this._providerContext = providerContext;
		/** @type {Map<string, (function(Error, any): void)[]>} */
		this._activeAsyncOperations = new Map();
		/** @type {Map<string, { err: Error, result: any, level: Set<string> }>} */
		this._data = new Map();
		/** @type {Set<string>[]} */
		this._levels = [];
		for (let i = 0; i < 10; i++) this._levels.push(new Set());
		for (let i = 5000; i < duration; i += 500) this._levels.push(new Set());
		this._currentLevel = 0;
		this._tickInterval = Math.floor(duration / this._levels.length);
		/** @type {STORAGE_MODE_IDLE | STORAGE_MODE_SYNC | STORAGE_MODE_ASYNC} */
		this._mode = STORAGE_MODE_IDLE;

		/** @type {NodeJS.Timeout | undefined} */
		this._timeout = undefined;
		/** @type {number | undefined} */
		this._nextDecay = undefined;

		this.provide = provider ? this.provide.bind(this) : null;
		this.provideSync = syncProvider ? this.provideSync.bind(this) : null;
	}

	provide(path, options, callback) {
		if (typeof options === "function") {
			callback = options;
			options = undefined;
		}
		if (typeof path !== "string") {
			callback(new TypeError("path must be a string"));
			return;
		}
		if (options) {
			return this._provider.call(
				this._providerContext,
				path,
				options,
				callback
			);
		}

		// When in sync mode we can move to async mode
		if (this._mode === STORAGE_MODE_SYNC) {
			this._enterAsyncMode();
		}

		// Check in cache
		let cacheEntry = this._data.get(path);
		if (cacheEntry !== undefined) {
			if (cacheEntry.err) return nextTick(callback, cacheEntry.err);
			return nextTick(callback, null, cacheEntry.result);
		}

		// Check if there is already the same operation running
		let callbacks = this._activeAsyncOperations.get(path);
		if (callbacks !== undefined) {
			callbacks.push(callback);
			return;
		}
		this._activeAsyncOperations.set(path, (callbacks = [callback]));

		// Run the operation
		this._provider.call(this._providerContext, path, (err, result) => {
			this._activeAsyncOperations.delete(path);
			this._storeResult(path, err, result);

			// Enter async mode if not yet done
			this._enterAsyncMode();

			runCallbacks(callbacks, err, result);
		});
	}

	provideSync(path, options) {
		if (typeof path !== "string") {
			throw new TypeError("path must be a string");
		}
		if (options) {
			return this._syncProvider.call(this._providerContext, path, options);
		}

		// In sync mode we may have to decay some cache items
		if (this._mode === STORAGE_MODE_SYNC) {
			this._runDecays();
		}

		// Check in cache
		let cacheEntry = this._data.get(path);
		if (cacheEntry !== undefined) {
			if (cacheEntry.err) throw cacheEntry.err;
			return cacheEntry.result;
		}

		// Get all active async operations
		// This sync operation will also complete them
		const callbacks = this._activeAsyncOperations.get(path);
		this._activeAsyncOperations.delete(path);

		// Run the operation
		// When in idle mode, we will enter sync mode
		let result;
		try {
			result = this._syncProvider.call(this._providerContext, path);
		} catch (err) {
			this._storeResult(path, err, undefined);
			this._enterSyncModeWhenIdle();
			if (callbacks) runCallbacks(callbacks, err, undefined);
			throw err;
		}
		this._storeResult(path, undefined, result);
		this._enterSyncModeWhenIdle();
		if (callbacks) runCallbacks(callbacks, undefined, result);
		return result;
	}

	purge(what) {
		if (!what) {
			if (this._mode !== STORAGE_MODE_IDLE) {
				this._data.clear();
				for (const level of this._levels) {
					level.clear();
				}
				this._enterIdleMode();
			}
		} else if (typeof what === "string") {
			for (let [key, data] of this._data) {
				if (key.startsWith(what)) {
					this._data.delete(key);
					data.level.delete(key);
				}
			}
			if (this._data.size === 0) {
				this._enterIdleMode();
			}
		} else {
			for (let [key, data] of this._data) {
				for (const item of what) {
					if (key.startsWith(item)) {
						this._data.delete(key);
						data.level.delete(key);
						break;
					}
				}
			}
			if (this._data.size === 0) {
				this._enterIdleMode();
			}
		}
	}

	purgeParent(what) {
		if (!what) {
			this.purge();
		} else if (typeof what === "string") {
			this.purge(dirname(what));
		} else {
			const set = new Set();
			for (const item of what) {
				set.add(dirname(item));
			}
			this.purge(set);
		}
	}

	_storeResult(path, err, result) {
		if (this._data.has(path)) return;
		const level = this._levels[this._currentLevel];
		this._data.set(path, { err, result, level });
		level.add(path);
	}

	_decayLevel() {
		const nextLevel = (this._currentLevel + 1) % this._levels.length;
		const decay = this._levels[nextLevel];
		this._currentLevel = nextLevel;
		for (let item of decay) {
			this._data.delete(item);
		}
		decay.clear();
		if (this._data.size === 0) {
			this._enterIdleMode();
		} else {
			// @ts-ignore _nextDecay is always a number in sync mode
			this._nextDecay += this._tickInterval;
		}
	}

	_runDecays() {
		while (
			/** @type {number} */ (this._nextDecay) <= Date.now() &&
			this._mode !== STORAGE_MODE_IDLE
		) {
			this._decayLevel();
		}
	}

	_enterAsyncMode() {
		let timeout = 0;
		switch (this._mode) {
			case STORAGE_MODE_ASYNC:
				return;
			case STORAGE_MODE_IDLE:
				this._nextDecay = Date.now() + this._tickInterval;
				timeout = this._tickInterval;
				break;
			case STORAGE_MODE_SYNC:
				this._runDecays();
				// @ts-ignore _runDecays may change the mode
				if (this._mode === STORAGE_MODE_IDLE) return;
				timeout = Math.max(
					0,
					/** @type {number} */ (this._nextDecay) - Date.now()
				);
				break;
		}
		this._mode = STORAGE_MODE_ASYNC;
		const ref = setTimeout(() => {
			this._mode = STORAGE_MODE_SYNC;
			this._runDecays();
		}, timeout);
		if (ref.unref) ref.unref();
		this._timeout = ref;
	}

	_enterSyncModeWhenIdle() {
		if (this._mode === STORAGE_MODE_IDLE) {
			this._mode = STORAGE_MODE_SYNC;
			this._nextDecay = Date.now() + this._tickInterval;
		}
	}

	_enterIdleMode() {
		this._mode = STORAGE_MODE_IDLE;
		this._nextDecay = undefined;
		if (this._timeout) clearTimeout(this._timeout);
	}
}

const createBackend = (duration, provider, syncProvider, providerContext) => {
	if (duration > 0) {
		return new CacheBackend(duration, provider, syncProvider, providerContext);
	}
	return new OperationMergerBackend(provider, syncProvider, providerContext);
};

var CachedInputFileSystem_1 = class CachedInputFileSystem {
	constructor(fileSystem, duration) {
		this.fileSystem = fileSystem;

		this._lstatBackend = createBackend(
			duration,
			this.fileSystem.lstat,
			this.fileSystem.lstatSync,
			this.fileSystem
		);
		const lstat = this._lstatBackend.provide;
		this.lstat = /** @type {FileSystem["lstat"]} */ (lstat);
		const lstatSync = this._lstatBackend.provideSync;
		this.lstatSync = /** @type {SyncFileSystem["lstatSync"]} */ (lstatSync);

		this._statBackend = createBackend(
			duration,
			this.fileSystem.stat,
			this.fileSystem.statSync,
			this.fileSystem
		);
		const stat = this._statBackend.provide;
		this.stat = /** @type {FileSystem["stat"]} */ (stat);
		const statSync = this._statBackend.provideSync;
		this.statSync = /** @type {SyncFileSystem["statSync"]} */ (statSync);

		this._readdirBackend = createBackend(
			duration,
			this.fileSystem.readdir,
			this.fileSystem.readdirSync,
			this.fileSystem
		);
		const readdir = this._readdirBackend.provide;
		this.readdir = /** @type {FileSystem["readdir"]} */ (readdir);
		const readdirSync = this._readdirBackend.provideSync;
		this.readdirSync = /** @type {SyncFileSystem["readdirSync"]} */ (readdirSync);

		this._readFileBackend = createBackend(
			duration,
			this.fileSystem.readFile,
			this.fileSystem.readFileSync,
			this.fileSystem
		);
		const readFile = this._readFileBackend.provide;
		this.readFile = /** @type {FileSystem["readFile"]} */ (readFile);
		const readFileSync = this._readFileBackend.provideSync;
		this.readFileSync = /** @type {SyncFileSystem["readFileSync"]} */ (readFileSync);

		this._readJsonBackend = createBackend(
			duration,
			this.fileSystem.readJson ||
				(this.readFile &&
					((path, callback) => {
						// @ts-ignore
						this.readFile(path, (err, buffer) => {
							if (err) return callback(err);
							if (!buffer || buffer.length === 0)
								return callback(new Error("No file content"));
							let data;
							try {
								data = JSON.parse(buffer.toString("utf-8"));
							} catch (e) {
								return callback(e);
							}
							callback(null, data);
						});
					})),
			this.fileSystem.readJsonSync ||
				(this.readFileSync &&
					(path => {
						const buffer = this.readFileSync(path);
						const data = JSON.parse(buffer.toString("utf-8"));
						return data;
					})),
			this.fileSystem
		);
		const readJson = this._readJsonBackend.provide;
		this.readJson = /** @type {FileSystem["readJson"]} */ (readJson);
		const readJsonSync = this._readJsonBackend.provideSync;
		this.readJsonSync = /** @type {SyncFileSystem["readJsonSync"]} */ (readJsonSync);

		this._readlinkBackend = createBackend(
			duration,
			this.fileSystem.readlink,
			this.fileSystem.readlinkSync,
			this.fileSystem
		);
		const readlink = this._readlinkBackend.provide;
		this.readlink = /** @type {FileSystem["readlink"]} */ (readlink);
		const readlinkSync = this._readlinkBackend.provideSync;
		this.readlinkSync = /** @type {SyncFileSystem["readlinkSync"]} */ (readlinkSync);
	}

	purge(what) {
		this._statBackend.purge(what);
		this._lstatBackend.purge(what);
		this._readdirBackend.purgeParent(what);
		this._readFileBackend.purge(what);
		this._readlinkBackend.purge(what);
		this._readJsonBackend.purge(what);
	}
};

const deprecateContext = util__default["default"].deprecate(() => {},
"Hook.context is deprecated and will be removed");

const CALL_DELEGATE = function(...args) {
	this.call = this._createCall("sync");
	return this.call(...args);
};
const CALL_ASYNC_DELEGATE = function(...args) {
	this.callAsync = this._createCall("async");
	return this.callAsync(...args);
};
const PROMISE_DELEGATE = function(...args) {
	this.promise = this._createCall("promise");
	return this.promise(...args);
};

class Hook {
	constructor(args = [], name = undefined) {
		this._args = args;
		this.name = name;
		this.taps = [];
		this.interceptors = [];
		this._call = CALL_DELEGATE;
		this.call = CALL_DELEGATE;
		this._callAsync = CALL_ASYNC_DELEGATE;
		this.callAsync = CALL_ASYNC_DELEGATE;
		this._promise = PROMISE_DELEGATE;
		this.promise = PROMISE_DELEGATE;
		this._x = undefined;

		this.compile = this.compile;
		this.tap = this.tap;
		this.tapAsync = this.tapAsync;
		this.tapPromise = this.tapPromise;
	}

	compile(options) {
		throw new Error("Abstract: should be overridden");
	}

	_createCall(type) {
		return this.compile({
			taps: this.taps,
			interceptors: this.interceptors,
			args: this._args,
			type: type
		});
	}

	_tap(type, options, fn) {
		if (typeof options === "string") {
			options = {
				name: options.trim()
			};
		} else if (typeof options !== "object" || options === null) {
			throw new Error("Invalid tap options");
		}
		if (typeof options.name !== "string" || options.name === "") {
			throw new Error("Missing name for tap");
		}
		if (typeof options.context !== "undefined") {
			deprecateContext();
		}
		options = Object.assign({ type, fn }, options);
		options = this._runRegisterInterceptors(options);
		this._insert(options);
	}

	tap(options, fn) {
		this._tap("sync", options, fn);
	}

	tapAsync(options, fn) {
		this._tap("async", options, fn);
	}

	tapPromise(options, fn) {
		this._tap("promise", options, fn);
	}

	_runRegisterInterceptors(options) {
		for (const interceptor of this.interceptors) {
			if (interceptor.register) {
				const newOptions = interceptor.register(options);
				if (newOptions !== undefined) {
					options = newOptions;
				}
			}
		}
		return options;
	}

	withOptions(options) {
		const mergeOptions = opt =>
			Object.assign({}, options, typeof opt === "string" ? { name: opt } : opt);

		return {
			name: this.name,
			tap: (opt, fn) => this.tap(mergeOptions(opt), fn),
			tapAsync: (opt, fn) => this.tapAsync(mergeOptions(opt), fn),
			tapPromise: (opt, fn) => this.tapPromise(mergeOptions(opt), fn),
			intercept: interceptor => this.intercept(interceptor),
			isUsed: () => this.isUsed(),
			withOptions: opt => this.withOptions(mergeOptions(opt))
		};
	}

	isUsed() {
		return this.taps.length > 0 || this.interceptors.length > 0;
	}

	intercept(interceptor) {
		this._resetCompilation();
		this.interceptors.push(Object.assign({}, interceptor));
		if (interceptor.register) {
			for (let i = 0; i < this.taps.length; i++) {
				this.taps[i] = interceptor.register(this.taps[i]);
			}
		}
	}

	_resetCompilation() {
		this.call = this._call;
		this.callAsync = this._callAsync;
		this.promise = this._promise;
	}

	_insert(item) {
		this._resetCompilation();
		let before;
		if (typeof item.before === "string") {
			before = new Set([item.before]);
		} else if (Array.isArray(item.before)) {
			before = new Set(item.before);
		}
		let stage = 0;
		if (typeof item.stage === "number") {
			stage = item.stage;
		}
		let i = this.taps.length;
		while (i > 0) {
			i--;
			const x = this.taps[i];
			this.taps[i + 1] = x;
			const xStage = x.stage || 0;
			if (before) {
				if (before.has(x.name)) {
					before.delete(x.name);
					continue;
				}
				if (before.size > 0) {
					continue;
				}
			}
			if (xStage > stage) {
				continue;
			}
			i++;
			break;
		}
		this.taps[i] = item;
	}
}

Object.setPrototypeOf(Hook.prototype, null);

var Hook_1 = Hook;

/*
	MIT License http://www.opensource.org/licenses/mit-license.php
	Author Tobias Koppers @sokra
*/

class HookCodeFactory {
	constructor(config) {
		this.config = config;
		this.options = undefined;
		this._args = undefined;
	}

	create(options) {
		this.init(options);
		let fn;
		switch (this.options.type) {
			case "sync":
				fn = new Function(
					this.args(),
					'"use strict";\n' +
						this.header() +
						this.contentWithInterceptors({
							onError: err => `throw ${err};\n`,
							onResult: result => `return ${result};\n`,
							resultReturns: true,
							onDone: () => "",
							rethrowIfPossible: true
						})
				);
				break;
			case "async":
				fn = new Function(
					this.args({
						after: "_callback"
					}),
					'"use strict";\n' +
						this.header() +
						this.contentWithInterceptors({
							onError: err => `_callback(${err});\n`,
							onResult: result => `_callback(null, ${result});\n`,
							onDone: () => "_callback();\n"
						})
				);
				break;
			case "promise":
				let errorHelperUsed = false;
				const content = this.contentWithInterceptors({
					onError: err => {
						errorHelperUsed = true;
						return `_error(${err});\n`;
					},
					onResult: result => `_resolve(${result});\n`,
					onDone: () => "_resolve();\n"
				});
				let code = "";
				code += '"use strict";\n';
				code += this.header();
				code += "return new Promise((function(_resolve, _reject) {\n";
				if (errorHelperUsed) {
					code += "var _sync = true;\n";
					code += "function _error(_err) {\n";
					code += "if(_sync)\n";
					code +=
						"_resolve(Promise.resolve().then((function() { throw _err; })));\n";
					code += "else\n";
					code += "_reject(_err);\n";
					code += "};\n";
				}
				code += content;
				if (errorHelperUsed) {
					code += "_sync = false;\n";
				}
				code += "}));\n";
				fn = new Function(this.args(), code);
				break;
		}
		this.deinit();
		return fn;
	}

	setup(instance, options) {
		instance._x = options.taps.map(t => t.fn);
	}

	/**
	 * @param {{ type: "sync" | "promise" | "async", taps: Array<Tap>, interceptors: Array<Interceptor> }} options
	 */
	init(options) {
		this.options = options;
		this._args = options.args.slice();
	}

	deinit() {
		this.options = undefined;
		this._args = undefined;
	}

	contentWithInterceptors(options) {
		if (this.options.interceptors.length > 0) {
			const onError = options.onError;
			const onResult = options.onResult;
			const onDone = options.onDone;
			let code = "";
			for (let i = 0; i < this.options.interceptors.length; i++) {
				const interceptor = this.options.interceptors[i];
				if (interceptor.call) {
					code += `${this.getInterceptor(i)}.call(${this.args({
						before: interceptor.context ? "_context" : undefined
					})});\n`;
				}
			}
			code += this.content(
				Object.assign(options, {
					onError:
						onError &&
						(err => {
							let code = "";
							for (let i = 0; i < this.options.interceptors.length; i++) {
								const interceptor = this.options.interceptors[i];
								if (interceptor.error) {
									code += `${this.getInterceptor(i)}.error(${err});\n`;
								}
							}
							code += onError(err);
							return code;
						}),
					onResult:
						onResult &&
						(result => {
							let code = "";
							for (let i = 0; i < this.options.interceptors.length; i++) {
								const interceptor = this.options.interceptors[i];
								if (interceptor.result) {
									code += `${this.getInterceptor(i)}.result(${result});\n`;
								}
							}
							code += onResult(result);
							return code;
						}),
					onDone:
						onDone &&
						(() => {
							let code = "";
							for (let i = 0; i < this.options.interceptors.length; i++) {
								const interceptor = this.options.interceptors[i];
								if (interceptor.done) {
									code += `${this.getInterceptor(i)}.done();\n`;
								}
							}
							code += onDone();
							return code;
						})
				})
			);
			return code;
		} else {
			return this.content(options);
		}
	}

	header() {
		let code = "";
		if (this.needContext()) {
			code += "var _context = {};\n";
		} else {
			code += "var _context;\n";
		}
		code += "var _x = this._x;\n";
		if (this.options.interceptors.length > 0) {
			code += "var _taps = this.taps;\n";
			code += "var _interceptors = this.interceptors;\n";
		}
		return code;
	}

	needContext() {
		for (const tap of this.options.taps) if (tap.context) return true;
		return false;
	}

	callTap(tapIndex, { onError, onResult, onDone, rethrowIfPossible }) {
		let code = "";
		let hasTapCached = false;
		for (let i = 0; i < this.options.interceptors.length; i++) {
			const interceptor = this.options.interceptors[i];
			if (interceptor.tap) {
				if (!hasTapCached) {
					code += `var _tap${tapIndex} = ${this.getTap(tapIndex)};\n`;
					hasTapCached = true;
				}
				code += `${this.getInterceptor(i)}.tap(${
					interceptor.context ? "_context, " : ""
				}_tap${tapIndex});\n`;
			}
		}
		code += `var _fn${tapIndex} = ${this.getTapFn(tapIndex)};\n`;
		const tap = this.options.taps[tapIndex];
		switch (tap.type) {
			case "sync":
				if (!rethrowIfPossible) {
					code += `var _hasError${tapIndex} = false;\n`;
					code += "try {\n";
				}
				if (onResult) {
					code += `var _result${tapIndex} = _fn${tapIndex}(${this.args({
						before: tap.context ? "_context" : undefined
					})});\n`;
				} else {
					code += `_fn${tapIndex}(${this.args({
						before: tap.context ? "_context" : undefined
					})});\n`;
				}
				if (!rethrowIfPossible) {
					code += "} catch(_err) {\n";
					code += `_hasError${tapIndex} = true;\n`;
					code += onError("_err");
					code += "}\n";
					code += `if(!_hasError${tapIndex}) {\n`;
				}
				if (onResult) {
					code += onResult(`_result${tapIndex}`);
				}
				if (onDone) {
					code += onDone();
				}
				if (!rethrowIfPossible) {
					code += "}\n";
				}
				break;
			case "async":
				let cbCode = "";
				if (onResult)
					cbCode += `(function(_err${tapIndex}, _result${tapIndex}) {\n`;
				else cbCode += `(function(_err${tapIndex}) {\n`;
				cbCode += `if(_err${tapIndex}) {\n`;
				cbCode += onError(`_err${tapIndex}`);
				cbCode += "} else {\n";
				if (onResult) {
					cbCode += onResult(`_result${tapIndex}`);
				}
				if (onDone) {
					cbCode += onDone();
				}
				cbCode += "}\n";
				cbCode += "})";
				code += `_fn${tapIndex}(${this.args({
					before: tap.context ? "_context" : undefined,
					after: cbCode
				})});\n`;
				break;
			case "promise":
				code += `var _hasResult${tapIndex} = false;\n`;
				code += `var _promise${tapIndex} = _fn${tapIndex}(${this.args({
					before: tap.context ? "_context" : undefined
				})});\n`;
				code += `if (!_promise${tapIndex} || !_promise${tapIndex}.then)\n`;
				code += `  throw new Error('Tap function (tapPromise) did not return promise (returned ' + _promise${tapIndex} + ')');\n`;
				code += `_promise${tapIndex}.then((function(_result${tapIndex}) {\n`;
				code += `_hasResult${tapIndex} = true;\n`;
				if (onResult) {
					code += onResult(`_result${tapIndex}`);
				}
				if (onDone) {
					code += onDone();
				}
				code += `}), function(_err${tapIndex}) {\n`;
				code += `if(_hasResult${tapIndex}) throw _err${tapIndex};\n`;
				code += onError(`_err${tapIndex}`);
				code += "});\n";
				break;
		}
		return code;
	}

	callTapsSeries({
		onError,
		onResult,
		resultReturns,
		onDone,
		doneReturns,
		rethrowIfPossible
	}) {
		if (this.options.taps.length === 0) return onDone();
		const firstAsync = this.options.taps.findIndex(t => t.type !== "sync");
		const somethingReturns = resultReturns || doneReturns;
		let code = "";
		let current = onDone;
		let unrollCounter = 0;
		for (let j = this.options.taps.length - 1; j >= 0; j--) {
			const i = j;
			const unroll =
				current !== onDone &&
				(this.options.taps[i].type !== "sync" || unrollCounter++ > 20);
			if (unroll) {
				unrollCounter = 0;
				code += `function _next${i}() {\n`;
				code += current();
				code += `}\n`;
				current = () => `${somethingReturns ? "return " : ""}_next${i}();\n`;
			}
			const done = current;
			const doneBreak = skipDone => {
				if (skipDone) return "";
				return onDone();
			};
			const content = this.callTap(i, {
				onError: error => onError(i, error, done, doneBreak),
				onResult:
					onResult &&
					(result => {
						return onResult(i, result, done, doneBreak);
					}),
				onDone: !onResult && done,
				rethrowIfPossible:
					rethrowIfPossible && (firstAsync < 0 || i < firstAsync)
			});
			current = () => content;
		}
		code += current();
		return code;
	}

	callTapsLooping({ onError, onDone, rethrowIfPossible }) {
		if (this.options.taps.length === 0) return onDone();
		const syncOnly = this.options.taps.every(t => t.type === "sync");
		let code = "";
		if (!syncOnly) {
			code += "var _looper = (function() {\n";
			code += "var _loopAsync = false;\n";
		}
		code += "var _loop;\n";
		code += "do {\n";
		code += "_loop = false;\n";
		for (let i = 0; i < this.options.interceptors.length; i++) {
			const interceptor = this.options.interceptors[i];
			if (interceptor.loop) {
				code += `${this.getInterceptor(i)}.loop(${this.args({
					before: interceptor.context ? "_context" : undefined
				})});\n`;
			}
		}
		code += this.callTapsSeries({
			onError,
			onResult: (i, result, next, doneBreak) => {
				let code = "";
				code += `if(${result} !== undefined) {\n`;
				code += "_loop = true;\n";
				if (!syncOnly) code += "if(_loopAsync) _looper();\n";
				code += doneBreak(true);
				code += `} else {\n`;
				code += next();
				code += `}\n`;
				return code;
			},
			onDone:
				onDone &&
				(() => {
					let code = "";
					code += "if(!_loop) {\n";
					code += onDone();
					code += "}\n";
					return code;
				}),
			rethrowIfPossible: rethrowIfPossible && syncOnly
		});
		code += "} while(_loop);\n";
		if (!syncOnly) {
			code += "_loopAsync = true;\n";
			code += "});\n";
			code += "_looper();\n";
		}
		return code;
	}

	callTapsParallel({
		onError,
		onResult,
		onDone,
		rethrowIfPossible,
		onTap = (i, run) => run()
	}) {
		if (this.options.taps.length <= 1) {
			return this.callTapsSeries({
				onError,
				onResult,
				onDone,
				rethrowIfPossible
			});
		}
		let code = "";
		code += "do {\n";
		code += `var _counter = ${this.options.taps.length};\n`;
		if (onDone) {
			code += "var _done = (function() {\n";
			code += onDone();
			code += "});\n";
		}
		for (let i = 0; i < this.options.taps.length; i++) {
			const done = () => {
				if (onDone) return "if(--_counter === 0) _done();\n";
				else return "--_counter;";
			};
			const doneBreak = skipDone => {
				if (skipDone || !onDone) return "_counter = 0;\n";
				else return "_counter = 0;\n_done();\n";
			};
			code += "if(_counter <= 0) break;\n";
			code += onTap(
				i,
				() =>
					this.callTap(i, {
						onError: error => {
							let code = "";
							code += "if(_counter > 0) {\n";
							code += onError(i, error, done, doneBreak);
							code += "}\n";
							return code;
						},
						onResult:
							onResult &&
							(result => {
								let code = "";
								code += "if(_counter > 0) {\n";
								code += onResult(i, result, done, doneBreak);
								code += "}\n";
								return code;
							}),
						onDone:
							!onResult &&
							(() => {
								return done();
							}),
						rethrowIfPossible
					}),
				done,
				doneBreak
			);
		}
		code += "} while(false);\n";
		return code;
	}

	args({ before, after } = {}) {
		let allArgs = this._args;
		if (before) allArgs = [before].concat(allArgs);
		if (after) allArgs = allArgs.concat(after);
		if (allArgs.length === 0) {
			return "";
		} else {
			return allArgs.join(", ");
		}
	}

	getTapFn(idx) {
		return `_x[${idx}]`;
	}

	getTap(idx) {
		return `_taps[${idx}]`;
	}

	getInterceptor(idx) {
		return `_interceptors[${idx}]`;
	}
}

var HookCodeFactory_1 = HookCodeFactory;

class SyncHookCodeFactory extends HookCodeFactory_1 {
	content({ onError, onDone, rethrowIfPossible }) {
		return this.callTapsSeries({
			onError: (i, err) => onError(err),
			onDone,
			rethrowIfPossible
		});
	}
}

const factory$9 = new SyncHookCodeFactory();

const TAP_ASYNC$3 = () => {
	throw new Error("tapAsync is not supported on a SyncHook");
};

const TAP_PROMISE$3 = () => {
	throw new Error("tapPromise is not supported on a SyncHook");
};

const COMPILE$9 = function(options) {
	factory$9.setup(this, options);
	return factory$9.create(options);
};

function SyncHook$1(args = [], name = undefined) {
	const hook = new Hook_1(args, name);
	hook.constructor = SyncHook$1;
	hook.tapAsync = TAP_ASYNC$3;
	hook.tapPromise = TAP_PROMISE$3;
	hook.compile = COMPILE$9;
	return hook;
}

SyncHook$1.prototype = null;

var SyncHook_1 = SyncHook$1;

class SyncBailHookCodeFactory extends HookCodeFactory_1 {
	content({ onError, onResult, resultReturns, onDone, rethrowIfPossible }) {
		return this.callTapsSeries({
			onError: (i, err) => onError(err),
			onResult: (i, result, next) =>
				`if(${result} !== undefined) {\n${onResult(
					result
				)};\n} else {\n${next()}}\n`,
			resultReturns,
			onDone,
			rethrowIfPossible
		});
	}
}

const factory$8 = new SyncBailHookCodeFactory();

const TAP_ASYNC$2 = () => {
	throw new Error("tapAsync is not supported on a SyncBailHook");
};

const TAP_PROMISE$2 = () => {
	throw new Error("tapPromise is not supported on a SyncBailHook");
};

const COMPILE$8 = function(options) {
	factory$8.setup(this, options);
	return factory$8.create(options);
};

function SyncBailHook(args = [], name = undefined) {
	const hook = new Hook_1(args, name);
	hook.constructor = SyncBailHook;
	hook.tapAsync = TAP_ASYNC$2;
	hook.tapPromise = TAP_PROMISE$2;
	hook.compile = COMPILE$8;
	return hook;
}

SyncBailHook.prototype = null;

var SyncBailHook_1 = SyncBailHook;

class SyncWaterfallHookCodeFactory extends HookCodeFactory_1 {
	content({ onError, onResult, resultReturns, rethrowIfPossible }) {
		return this.callTapsSeries({
			onError: (i, err) => onError(err),
			onResult: (i, result, next) => {
				let code = "";
				code += `if(${result} !== undefined) {\n`;
				code += `${this._args[0]} = ${result};\n`;
				code += `}\n`;
				code += next();
				return code;
			},
			onDone: () => onResult(this._args[0]),
			doneReturns: resultReturns,
			rethrowIfPossible
		});
	}
}

const factory$7 = new SyncWaterfallHookCodeFactory();

const TAP_ASYNC$1 = () => {
	throw new Error("tapAsync is not supported on a SyncWaterfallHook");
};

const TAP_PROMISE$1 = () => {
	throw new Error("tapPromise is not supported on a SyncWaterfallHook");
};

const COMPILE$7 = function(options) {
	factory$7.setup(this, options);
	return factory$7.create(options);
};

function SyncWaterfallHook(args = [], name = undefined) {
	if (args.length < 1)
		throw new Error("Waterfall hooks must have at least one argument");
	const hook = new Hook_1(args, name);
	hook.constructor = SyncWaterfallHook;
	hook.tapAsync = TAP_ASYNC$1;
	hook.tapPromise = TAP_PROMISE$1;
	hook.compile = COMPILE$7;
	return hook;
}

SyncWaterfallHook.prototype = null;

var SyncWaterfallHook_1 = SyncWaterfallHook;

class SyncLoopHookCodeFactory extends HookCodeFactory_1 {
	content({ onError, onDone, rethrowIfPossible }) {
		return this.callTapsLooping({
			onError: (i, err) => onError(err),
			onDone,
			rethrowIfPossible
		});
	}
}

const factory$6 = new SyncLoopHookCodeFactory();

const TAP_ASYNC = () => {
	throw new Error("tapAsync is not supported on a SyncLoopHook");
};

const TAP_PROMISE = () => {
	throw new Error("tapPromise is not supported on a SyncLoopHook");
};

const COMPILE$6 = function(options) {
	factory$6.setup(this, options);
	return factory$6.create(options);
};

function SyncLoopHook(args = [], name = undefined) {
	const hook = new Hook_1(args, name);
	hook.constructor = SyncLoopHook;
	hook.tapAsync = TAP_ASYNC;
	hook.tapPromise = TAP_PROMISE;
	hook.compile = COMPILE$6;
	return hook;
}

SyncLoopHook.prototype = null;

var SyncLoopHook_1 = SyncLoopHook;

class AsyncParallelHookCodeFactory extends HookCodeFactory_1 {
	content({ onError, onDone }) {
		return this.callTapsParallel({
			onError: (i, err, done, doneBreak) => onError(err) + doneBreak(true),
			onDone
		});
	}
}

const factory$5 = new AsyncParallelHookCodeFactory();

const COMPILE$5 = function(options) {
	factory$5.setup(this, options);
	return factory$5.create(options);
};

function AsyncParallelHook(args = [], name = undefined) {
	const hook = new Hook_1(args, name);
	hook.constructor = AsyncParallelHook;
	hook.compile = COMPILE$5;
	hook._call = undefined;
	hook.call = undefined;
	return hook;
}

AsyncParallelHook.prototype = null;

var AsyncParallelHook_1 = AsyncParallelHook;

class AsyncParallelBailHookCodeFactory extends HookCodeFactory_1 {
	content({ onError, onResult, onDone }) {
		let code = "";
		code += `var _results = new Array(${this.options.taps.length});\n`;
		code += "var _checkDone = function() {\n";
		code += "for(var i = 0; i < _results.length; i++) {\n";
		code += "var item = _results[i];\n";
		code += "if(item === undefined) return false;\n";
		code += "if(item.result !== undefined) {\n";
		code += onResult("item.result");
		code += "return true;\n";
		code += "}\n";
		code += "if(item.error) {\n";
		code += onError("item.error");
		code += "return true;\n";
		code += "}\n";
		code += "}\n";
		code += "return false;\n";
		code += "}\n";
		code += this.callTapsParallel({
			onError: (i, err, done, doneBreak) => {
				let code = "";
				code += `if(${i} < _results.length && ((_results.length = ${i +
					1}), (_results[${i}] = { error: ${err} }), _checkDone())) {\n`;
				code += doneBreak(true);
				code += "} else {\n";
				code += done();
				code += "}\n";
				return code;
			},
			onResult: (i, result, done, doneBreak) => {
				let code = "";
				code += `if(${i} < _results.length && (${result} !== undefined && (_results.length = ${i +
					1}), (_results[${i}] = { result: ${result} }), _checkDone())) {\n`;
				code += doneBreak(true);
				code += "} else {\n";
				code += done();
				code += "}\n";
				return code;
			},
			onTap: (i, run, done, doneBreak) => {
				let code = "";
				if (i > 0) {
					code += `if(${i} >= _results.length) {\n`;
					code += done();
					code += "} else {\n";
				}
				code += run();
				if (i > 0) code += "}\n";
				return code;
			},
			onDone
		});
		return code;
	}
}

const factory$4 = new AsyncParallelBailHookCodeFactory();

const COMPILE$4 = function(options) {
	factory$4.setup(this, options);
	return factory$4.create(options);
};

function AsyncParallelBailHook(args = [], name = undefined) {
	const hook = new Hook_1(args, name);
	hook.constructor = AsyncParallelBailHook;
	hook.compile = COMPILE$4;
	hook._call = undefined;
	hook.call = undefined;
	return hook;
}

AsyncParallelBailHook.prototype = null;

var AsyncParallelBailHook_1 = AsyncParallelBailHook;

class AsyncSeriesHookCodeFactory extends HookCodeFactory_1 {
	content({ onError, onDone }) {
		return this.callTapsSeries({
			onError: (i, err, next, doneBreak) => onError(err) + doneBreak(true),
			onDone
		});
	}
}

const factory$3 = new AsyncSeriesHookCodeFactory();

const COMPILE$3 = function(options) {
	factory$3.setup(this, options);
	return factory$3.create(options);
};

function AsyncSeriesHook$1(args = [], name = undefined) {
	const hook = new Hook_1(args, name);
	hook.constructor = AsyncSeriesHook$1;
	hook.compile = COMPILE$3;
	hook._call = undefined;
	hook.call = undefined;
	return hook;
}

AsyncSeriesHook$1.prototype = null;

var AsyncSeriesHook_1 = AsyncSeriesHook$1;

class AsyncSeriesBailHookCodeFactory extends HookCodeFactory_1 {
	content({ onError, onResult, resultReturns, onDone }) {
		return this.callTapsSeries({
			onError: (i, err, next, doneBreak) => onError(err) + doneBreak(true),
			onResult: (i, result, next) =>
				`if(${result} !== undefined) {\n${onResult(
					result
				)}\n} else {\n${next()}}\n`,
			resultReturns,
			onDone
		});
	}
}

const factory$2 = new AsyncSeriesBailHookCodeFactory();

const COMPILE$2 = function(options) {
	factory$2.setup(this, options);
	return factory$2.create(options);
};

function AsyncSeriesBailHook$1(args = [], name = undefined) {
	const hook = new Hook_1(args, name);
	hook.constructor = AsyncSeriesBailHook$1;
	hook.compile = COMPILE$2;
	hook._call = undefined;
	hook.call = undefined;
	return hook;
}

AsyncSeriesBailHook$1.prototype = null;

var AsyncSeriesBailHook_1 = AsyncSeriesBailHook$1;

class AsyncSeriesLoopHookCodeFactory extends HookCodeFactory_1 {
	content({ onError, onDone }) {
		return this.callTapsLooping({
			onError: (i, err, next, doneBreak) => onError(err) + doneBreak(true),
			onDone
		});
	}
}

const factory$1 = new AsyncSeriesLoopHookCodeFactory();

const COMPILE$1 = function(options) {
	factory$1.setup(this, options);
	return factory$1.create(options);
};

function AsyncSeriesLoopHook(args = [], name = undefined) {
	const hook = new Hook_1(args, name);
	hook.constructor = AsyncSeriesLoopHook;
	hook.compile = COMPILE$1;
	hook._call = undefined;
	hook.call = undefined;
	return hook;
}

AsyncSeriesLoopHook.prototype = null;

var AsyncSeriesLoopHook_1 = AsyncSeriesLoopHook;

class AsyncSeriesWaterfallHookCodeFactory extends HookCodeFactory_1 {
	content({ onError, onResult, onDone }) {
		return this.callTapsSeries({
			onError: (i, err, next, doneBreak) => onError(err) + doneBreak(true),
			onResult: (i, result, next) => {
				let code = "";
				code += `if(${result} !== undefined) {\n`;
				code += `${this._args[0]} = ${result};\n`;
				code += `}\n`;
				code += next();
				return code;
			},
			onDone: () => onResult(this._args[0])
		});
	}
}

const factory = new AsyncSeriesWaterfallHookCodeFactory();

const COMPILE = function(options) {
	factory.setup(this, options);
	return factory.create(options);
};

function AsyncSeriesWaterfallHook(args = [], name = undefined) {
	if (args.length < 1)
		throw new Error("Waterfall hooks must have at least one argument");
	const hook = new Hook_1(args, name);
	hook.constructor = AsyncSeriesWaterfallHook;
	hook.compile = COMPILE;
	hook._call = undefined;
	hook.call = undefined;
	return hook;
}

AsyncSeriesWaterfallHook.prototype = null;

var AsyncSeriesWaterfallHook_1 = AsyncSeriesWaterfallHook;

const defaultFactory = (key, hook) => hook;

class HookMap {
	constructor(factory, name = undefined) {
		this._map = new Map();
		this.name = name;
		this._factory = factory;
		this._interceptors = [];
	}

	get(key) {
		return this._map.get(key);
	}

	for(key) {
		const hook = this.get(key);
		if (hook !== undefined) {
			return hook;
		}
		let newHook = this._factory(key);
		const interceptors = this._interceptors;
		for (let i = 0; i < interceptors.length; i++) {
			newHook = interceptors[i].factory(key, newHook);
		}
		this._map.set(key, newHook);
		return newHook;
	}

	intercept(interceptor) {
		this._interceptors.push(
			Object.assign(
				{
					factory: defaultFactory
				},
				interceptor
			)
		);
	}
}

HookMap.prototype.tap = util__default["default"].deprecate(function(key, options, fn) {
	return this.for(key).tap(options, fn);
}, "HookMap#tap(key,…) is deprecated. Use HookMap#for(key).tap(…) instead.");

HookMap.prototype.tapAsync = util__default["default"].deprecate(function(key, options, fn) {
	return this.for(key).tapAsync(options, fn);
}, "HookMap#tapAsync(key,…) is deprecated. Use HookMap#for(key).tapAsync(…) instead.");

HookMap.prototype.tapPromise = util__default["default"].deprecate(function(key, options, fn) {
	return this.for(key).tapPromise(options, fn);
}, "HookMap#tapPromise(key,…) is deprecated. Use HookMap#for(key).tapPromise(…) instead.");

var HookMap_1 = HookMap;

class MultiHook {
	constructor(hooks, name = undefined) {
		this.hooks = hooks;
		this.name = name;
	}

	tap(options, fn) {
		for (const hook of this.hooks) {
			hook.tap(options, fn);
		}
	}

	tapAsync(options, fn) {
		for (const hook of this.hooks) {
			hook.tapAsync(options, fn);
		}
	}

	tapPromise(options, fn) {
		for (const hook of this.hooks) {
			hook.tapPromise(options, fn);
		}
	}

	isUsed() {
		for (const hook of this.hooks) {
			if (hook.isUsed()) return true;
		}
		return false;
	}

	intercept(interceptor) {
		for (const hook of this.hooks) {
			hook.intercept(interceptor);
		}
	}

	withOptions(options) {
		return new MultiHook(
			this.hooks.map(h => h.withOptions(options)),
			this.name
		);
	}
}

var MultiHook_1 = MultiHook;

var lib$1 = createCommonjsModule(function (module, exports) {

exports.__esModule = true;
exports.SyncHook = SyncHook_1;
exports.SyncBailHook = SyncBailHook_1;
exports.SyncWaterfallHook = SyncWaterfallHook_1;
exports.SyncLoopHook = SyncLoopHook_1;
exports.AsyncParallelHook = AsyncParallelHook_1;
exports.AsyncParallelBailHook = AsyncParallelBailHook_1;
exports.AsyncSeriesHook = AsyncSeriesHook_1;
exports.AsyncSeriesBailHook = AsyncSeriesBailHook_1;
exports.AsyncSeriesLoopHook = AsyncSeriesLoopHook_1;
exports.AsyncSeriesWaterfallHook = AsyncSeriesWaterfallHook_1;
exports.HookMap = HookMap_1;
exports.MultiHook = MultiHook_1;
});

/*
	MIT License http://www.opensource.org/licenses/mit-license.php
	Author Tobias Koppers @sokra
*/

var createInnerContext = function createInnerContext(
	options,
	message,
	messageOptional
) {
	let messageReported = false;
	let innerLog = undefined;
	if (options.log) {
		if (message) {
			innerLog = msg => {
				if (!messageReported) {
					options.log(message);
					messageReported = true;
				}
				options.log("  " + msg);
			};
		} else {
			innerLog = options.log;
		}
	}
	const childContext = {
		log: innerLog,
		fileDependencies: options.fileDependencies,
		contextDependencies: options.contextDependencies,
		missingDependencies: options.missingDependencies,
		stack: options.stack
	};
	return childContext;
};

/*
	MIT License http://www.opensource.org/licenses/mit-license.php
	Author Ivan Kopeykin @vankop
*/

const PATH_QUERY_FRAGMENT_REGEXP = /^(#?(?:\0.|[^?#\0])*)(\?(?:\0.|[^#\0])*)?(#.*)?$/;

/**
 * @param {string} identifier identifier
 * @returns {[string, string, string]|null} parsed identifier
 */
function parseIdentifier$3(identifier) {
	const match = PATH_QUERY_FRAGMENT_REGEXP.exec(identifier);

	if (!match) return null;

	return [
		match[1].replace(/\0(.)/g, "$1"),
		match[2] ? match[2].replace(/\0(.)/g, "$1") : "",
		match[3] || ""
	];
}

var parseIdentifier_1 = parseIdentifier$3;

var identifier = {
	parseIdentifier: parseIdentifier_1
};

const CHAR_HASH = "#".charCodeAt(0);
const CHAR_SLASH = "/".charCodeAt(0);
const CHAR_BACKSLASH = "\\".charCodeAt(0);
const CHAR_A = "A".charCodeAt(0);
const CHAR_Z = "Z".charCodeAt(0);
const CHAR_LOWER_A = "a".charCodeAt(0);
const CHAR_LOWER_Z = "z".charCodeAt(0);
const CHAR_DOT = ".".charCodeAt(0);
const CHAR_COLON = ":".charCodeAt(0);

const posixNormalize = path__default["default"].posix.normalize;
const winNormalize = path__default["default"].win32.normalize;

/**
 * @enum {number}
 */
const PathType$3 = Object.freeze({
	Empty: 0,
	Normal: 1,
	Relative: 2,
	AbsoluteWin: 3,
	AbsolutePosix: 4,
	Internal: 5
});
var PathType_1 = PathType$3;

/**
 * @param {string} p a path
 * @returns {PathType} type of path
 */
const getType$3 = p => {
	switch (p.length) {
		case 0:
			return PathType$3.Empty;
		case 1: {
			const c0 = p.charCodeAt(0);
			switch (c0) {
				case CHAR_DOT:
					return PathType$3.Relative;
				case CHAR_SLASH:
					return PathType$3.AbsolutePosix;
				case CHAR_HASH:
					return PathType$3.Internal;
			}
			return PathType$3.Normal;
		}
		case 2: {
			const c0 = p.charCodeAt(0);
			switch (c0) {
				case CHAR_DOT: {
					const c1 = p.charCodeAt(1);
					switch (c1) {
						case CHAR_DOT:
						case CHAR_SLASH:
							return PathType$3.Relative;
					}
					return PathType$3.Normal;
				}
				case CHAR_SLASH:
					return PathType$3.AbsolutePosix;
				case CHAR_HASH:
					return PathType$3.Internal;
			}
			const c1 = p.charCodeAt(1);
			if (c1 === CHAR_COLON) {
				if (
					(c0 >= CHAR_A && c0 <= CHAR_Z) ||
					(c0 >= CHAR_LOWER_A && c0 <= CHAR_LOWER_Z)
				) {
					return PathType$3.AbsoluteWin;
				}
			}
			return PathType$3.Normal;
		}
	}
	const c0 = p.charCodeAt(0);
	switch (c0) {
		case CHAR_DOT: {
			const c1 = p.charCodeAt(1);
			switch (c1) {
				case CHAR_SLASH:
					return PathType$3.Relative;
				case CHAR_DOT: {
					const c2 = p.charCodeAt(2);
					if (c2 === CHAR_SLASH) return PathType$3.Relative;
					return PathType$3.Normal;
				}
			}
			return PathType$3.Normal;
		}
		case CHAR_SLASH:
			return PathType$3.AbsolutePosix;
		case CHAR_HASH:
			return PathType$3.Internal;
	}
	const c1 = p.charCodeAt(1);
	if (c1 === CHAR_COLON) {
		const c2 = p.charCodeAt(2);
		if (
			(c2 === CHAR_BACKSLASH || c2 === CHAR_SLASH) &&
			((c0 >= CHAR_A && c0 <= CHAR_Z) ||
				(c0 >= CHAR_LOWER_A && c0 <= CHAR_LOWER_Z))
		) {
			return PathType$3.AbsoluteWin;
		}
	}
	return PathType$3.Normal;
};
var getType_1 = getType$3;

/**
 * @param {string} p a path
 * @returns {string} the normalized path
 */
const normalize$1 = p => {
	switch (getType$3(p)) {
		case PathType$3.Empty:
			return p;
		case PathType$3.AbsoluteWin:
			return winNormalize(p);
		case PathType$3.Relative: {
			const r = posixNormalize(p);
			return getType$3(r) === PathType$3.Relative ? r : `./${r}`;
		}
	}
	return posixNormalize(p);
};
var normalize_1 = normalize$1;

/**
 * @param {string} rootPath the root path
 * @param {string | undefined} request the request path
 * @returns {string} the joined path
 */
const join$1 = (rootPath, request) => {
	if (!request) return normalize$1(rootPath);
	const requestType = getType$3(request);
	switch (requestType) {
		case PathType$3.AbsolutePosix:
			return posixNormalize(request);
		case PathType$3.AbsoluteWin:
			return winNormalize(request);
	}
	switch (getType$3(rootPath)) {
		case PathType$3.Normal:
		case PathType$3.Relative:
		case PathType$3.AbsolutePosix:
			return posixNormalize(`${rootPath}/${request}`);
		case PathType$3.AbsoluteWin:
			return winNormalize(`${rootPath}\\${request}`);
	}
	switch (requestType) {
		case PathType$3.Empty:
			return rootPath;
		case PathType$3.Relative: {
			const r = posixNormalize(rootPath);
			return getType$3(r) === PathType$3.Relative ? r : `./${r}`;
		}
	}
	return posixNormalize(rootPath);
};
var join_1 = join$1;

const joinCache = new Map();

/**
 * @param {string} rootPath the root path
 * @param {string | undefined} request the request path
 * @returns {string} the joined path
 */
const cachedJoin = (rootPath, request) => {
	let cacheEntry;
	let cache = joinCache.get(rootPath);
	if (cache === undefined) {
		joinCache.set(rootPath, (cache = new Map()));
	} else {
		cacheEntry = cache.get(request);
		if (cacheEntry !== undefined) return cacheEntry;
	}
	cacheEntry = join$1(rootPath, request);
	cache.set(request, cacheEntry);
	return cacheEntry;
};
var cachedJoin_1 = cachedJoin;

const checkExportsFieldTarget$1 = relativePath => {
	let lastNonSlashIndex = 2;
	let slashIndex = relativePath.indexOf("/", 2);
	let cd = 0;

	while (slashIndex !== -1) {
		const folder = relativePath.slice(lastNonSlashIndex, slashIndex);

		switch (folder) {
			case "..": {
				cd--;
				if (cd < 0)
					return new Error(
						`Trying to access out of package scope. Requesting ${relativePath}`
					);
				break;
			}
			default:
				cd++;
				break;
		}

		lastNonSlashIndex = slashIndex + 1;
		slashIndex = relativePath.indexOf("/", lastNonSlashIndex);
	}
};
var checkExportsFieldTarget_1 = checkExportsFieldTarget$1;

var path_1 = {
	PathType: PathType_1,
	getType: getType_1,
	normalize: normalize_1,
	join: join_1,
	cachedJoin: cachedJoin_1,
	checkExportsFieldTarget: checkExportsFieldTarget_1
};

const { AsyncSeriesBailHook, AsyncSeriesHook, SyncHook } = lib$1;

const { parseIdentifier: parseIdentifier$2 } = identifier;
const {
	normalize,
	cachedJoin: join,
	getType: getType$2,
	PathType: PathType$2
} = path_1;

/** @typedef {import("./ResolverFactory").ResolveOptions} ResolveOptions */

/**
 * @typedef {Object} FileSystemStats
 * @property {function(): boolean} isDirectory
 * @property {function(): boolean} isFile
 */

/**
 * @typedef {Object} FileSystemDirent
 * @property {Buffer | string} name
 * @property {function(): boolean} isDirectory
 * @property {function(): boolean} isFile
 */

/**
 * @typedef {Object} PossibleFileSystemError
 * @property {string=} code
 * @property {number=} errno
 * @property {string=} path
 * @property {string=} syscall
 */

/**
 * @template T
 * @callback FileSystemCallback
 * @param {PossibleFileSystemError & Error | null | undefined} err
 * @param {T=} result
 */

/**
 * @typedef {Object} FileSystem
 * @property {(function(string, FileSystemCallback<Buffer | string>): void) & function(string, object, FileSystemCallback<Buffer | string>): void} readFile
 * @property {(function(string, FileSystemCallback<(Buffer | string)[] | FileSystemDirent[]>): void) & function(string, object, FileSystemCallback<(Buffer | string)[] | FileSystemDirent[]>): void} readdir
 * @property {((function(string, FileSystemCallback<object>): void) & function(string, object, FileSystemCallback<object>): void)=} readJson
 * @property {(function(string, FileSystemCallback<Buffer | string>): void) & function(string, object, FileSystemCallback<Buffer | string>): void} readlink
 * @property {(function(string, FileSystemCallback<FileSystemStats>): void) & function(string, object, FileSystemCallback<Buffer | string>): void=} lstat
 * @property {(function(string, FileSystemCallback<FileSystemStats>): void) & function(string, object, FileSystemCallback<Buffer | string>): void} stat
 */

/**
 * @typedef {Object} SyncFileSystem
 * @property {function(string, object=): Buffer | string} readFileSync
 * @property {function(string, object=): (Buffer | string)[] | FileSystemDirent[]} readdirSync
 * @property {(function(string, object=): object)=} readJsonSync
 * @property {function(string, object=): Buffer | string} readlinkSync
 * @property {function(string, object=): FileSystemStats=} lstatSync
 * @property {function(string, object=): FileSystemStats} statSync
 */

/**
 * @typedef {Object} ParsedIdentifier
 * @property {string} request
 * @property {string} query
 * @property {string} fragment
 * @property {boolean} directory
 * @property {boolean} module
 * @property {boolean} file
 * @property {boolean} internal
 */

/**
 * @typedef {Object} BaseResolveRequest
 * @property {string | false} path
 * @property {string=} descriptionFilePath
 * @property {string=} descriptionFileRoot
 * @property {object=} descriptionFileData
 * @property {string=} relativePath
 * @property {boolean=} ignoreSymlinks
 * @property {boolean=} fullySpecified
 */

/** @typedef {BaseResolveRequest & Partial<ParsedIdentifier>} ResolveRequest */

/**
 * String with special formatting
 * @typedef {string} StackEntry
 */

/** @template T @typedef {{ add: (T) => void }} WriteOnlySet */

/**
 * Resolve context
 * @typedef {Object} ResolveContext
 * @property {WriteOnlySet<string>=} contextDependencies
 * @property {WriteOnlySet<string>=} fileDependencies files that was found on file system
 * @property {WriteOnlySet<string>=} missingDependencies dependencies that was not found on file system
 * @property {Set<StackEntry>=} stack set of hooks' calls. For instance, `resolve → parsedResolve → describedResolve`,
 * @property {(function(string): void)=} log log function
 */

/** @typedef {AsyncSeriesBailHook<[ResolveRequest, ResolveContext], ResolveRequest | null>} ResolveStepHook */

/**
 * @param {string} str input string
 * @returns {string} in camel case
 */
function toCamelCase(str) {
	return str.replace(/-([a-z])/g, str => str.substr(1).toUpperCase());
}

class Resolver {
	/**
	 * @param {ResolveStepHook} hook hook
	 * @param {ResolveRequest} request request
	 * @returns {StackEntry} stack entry
	 */
	static createStackEntry(hook, request) {
		return (
			hook.name +
			": (" +
			request.path +
			") " +
			(request.request || "") +
			(request.query || "") +
			(request.fragment || "") +
			(request.directory ? " directory" : "") +
			(request.module ? " module" : "")
		);
	}

	/**
	 * @param {FileSystem} fileSystem a filesystem
	 * @param {ResolveOptions} options options
	 */
	constructor(fileSystem, options) {
		this.fileSystem = fileSystem;
		this.options = options;
		this.hooks = {
			/** @type {SyncHook<[ResolveStepHook, ResolveRequest], void>} */
			resolveStep: new SyncHook(["hook", "request"], "resolveStep"),
			/** @type {SyncHook<[ResolveRequest, Error]>} */
			noResolve: new SyncHook(["request", "error"], "noResolve"),
			/** @type {ResolveStepHook} */
			resolve: new AsyncSeriesBailHook(
				["request", "resolveContext"],
				"resolve"
			),
			/** @type {AsyncSeriesHook<[ResolveRequest, ResolveContext]>} */
			result: new AsyncSeriesHook(["result", "resolveContext"], "result")
		};
	}

	/**
	 * @param {string | ResolveStepHook} name hook name or hook itself
	 * @returns {ResolveStepHook} the hook
	 */
	ensureHook(name) {
		if (typeof name !== "string") {
			return name;
		}
		name = toCamelCase(name);
		if (/^before/.test(name)) {
			return /** @type {ResolveStepHook} */ (this.ensureHook(
				name[6].toLowerCase() + name.substr(7)
			).withOptions({
				stage: -10
			}));
		}
		if (/^after/.test(name)) {
			return /** @type {ResolveStepHook} */ (this.ensureHook(
				name[5].toLowerCase() + name.substr(6)
			).withOptions({
				stage: 10
			}));
		}
		const hook = this.hooks[name];
		if (!hook) {
			return (this.hooks[name] = new AsyncSeriesBailHook(
				["request", "resolveContext"],
				name
			));
		}
		return hook;
	}

	/**
	 * @param {string | ResolveStepHook} name hook name or hook itself
	 * @returns {ResolveStepHook} the hook
	 */
	getHook(name) {
		if (typeof name !== "string") {
			return name;
		}
		name = toCamelCase(name);
		if (/^before/.test(name)) {
			return /** @type {ResolveStepHook} */ (this.getHook(
				name[6].toLowerCase() + name.substr(7)
			).withOptions({
				stage: -10
			}));
		}
		if (/^after/.test(name)) {
			return /** @type {ResolveStepHook} */ (this.getHook(
				name[5].toLowerCase() + name.substr(6)
			).withOptions({
				stage: 10
			}));
		}
		const hook = this.hooks[name];
		if (!hook) {
			throw new Error(`Hook ${name} doesn't exist`);
		}
		return hook;
	}

	/**
	 * @param {object} context context information object
	 * @param {string} path context path
	 * @param {string} request request string
	 * @returns {string | false} result
	 */
	resolveSync(context, path, request) {
		/** @type {Error | null | undefined} */
		let err = undefined;
		/** @type {string | false | undefined} */
		let result = undefined;
		let sync = false;
		this.resolve(context, path, request, {}, (e, r) => {
			err = e;
			result = r;
			sync = true;
		});
		if (!sync) {
			throw new Error(
				"Cannot 'resolveSync' because the fileSystem is not sync. Use 'resolve'!"
			);
		}
		if (err) throw err;
		if (result === undefined) throw new Error("No result");
		return result;
	}

	/**
	 * @param {object} context context information object
	 * @param {string} path context path
	 * @param {string} request request string
	 * @param {ResolveContext} resolveContext resolve context
	 * @param {function(Error | null, (string|false)=, ResolveRequest=): void} callback callback function
	 * @returns {void}
	 */
	resolve(context, path, request, resolveContext, callback) {
		if (!context || typeof context !== "object")
			return callback(new Error("context argument is not an object"));
		if (typeof path !== "string")
			return callback(new Error("path argument is not a string"));
		if (typeof request !== "string")
			return callback(new Error("path argument is not a string"));
		if (!resolveContext)
			return callback(new Error("resolveContext argument is not set"));

		const obj = {
			context: context,
			path: path,
			request: request
		};

		const message = `resolve '${request}' in '${path}'`;

		const finishResolved = result => {
			return callback(
				null,
				result.path === false
					? false
					: `${result.path.replace(/#/g, "\0#")}${
							result.query ? result.query.replace(/#/g, "\0#") : ""
					  }${result.fragment || ""}`,
				result
			);
		};

		const finishWithoutResolve = log => {
			/**
			 * @type {Error & {details?: string}}
			 */
			const error = new Error("Can't " + message);
			error.details = log.join("\n");
			this.hooks.noResolve.call(obj, error);
			return callback(error);
		};

		if (resolveContext.log) {
			// We need log anyway to capture it in case of an error
			const parentLog = resolveContext.log;
			const log = [];
			return this.doResolve(
				this.hooks.resolve,
				obj,
				message,
				{
					log: msg => {
						parentLog(msg);
						log.push(msg);
					},
					fileDependencies: resolveContext.fileDependencies,
					contextDependencies: resolveContext.contextDependencies,
					missingDependencies: resolveContext.missingDependencies,
					stack: resolveContext.stack
				},
				(err, result) => {
					if (err) return callback(err);

					if (result) return finishResolved(result);

					return finishWithoutResolve(log);
				}
			);
		} else {
			// Try to resolve assuming there is no error
			// We don't log stuff in this case
			return this.doResolve(
				this.hooks.resolve,
				obj,
				message,
				{
					log: undefined,
					fileDependencies: resolveContext.fileDependencies,
					contextDependencies: resolveContext.contextDependencies,
					missingDependencies: resolveContext.missingDependencies,
					stack: resolveContext.stack
				},
				(err, result) => {
					if (err) return callback(err);

					if (result) return finishResolved(result);

					// log is missing for the error details
					// so we redo the resolving for the log info
					// this is more expensive to the success case
					// is assumed by default

					const log = [];

					return this.doResolve(
						this.hooks.resolve,
						obj,
						message,
						{
							log: msg => log.push(msg),
							stack: resolveContext.stack
						},
						(err, result) => {
							if (err) return callback(err);

							return finishWithoutResolve(log);
						}
					);
				}
			);
		}
	}

	doResolve(hook, request, message, resolveContext, callback) {
		const stackEntry = Resolver.createStackEntry(hook, request);

		let newStack;
		if (resolveContext.stack) {
			newStack = new Set(resolveContext.stack);
			if (resolveContext.stack.has(stackEntry)) {
				/**
				 * Prevent recursion
				 * @type {Error & {recursion?: boolean}}
				 */
				const recursionError = new Error(
					"Recursion in resolving\nStack:\n  " +
						Array.from(newStack).join("\n  ")
				);
				recursionError.recursion = true;
				if (resolveContext.log)
					resolveContext.log("abort resolving because of recursion");
				return callback(recursionError);
			}
			newStack.add(stackEntry);
		} else {
			newStack = new Set([stackEntry]);
		}
		this.hooks.resolveStep.call(hook, request);

		if (hook.isUsed()) {
			const innerContext = createInnerContext(
				{
					log: resolveContext.log,
					fileDependencies: resolveContext.fileDependencies,
					contextDependencies: resolveContext.contextDependencies,
					missingDependencies: resolveContext.missingDependencies,
					stack: newStack
				},
				message
			);
			return hook.callAsync(request, innerContext, (err, result) => {
				if (err) return callback(err);
				if (result) return callback(null, result);
				callback();
			});
		} else {
			callback();
		}
	}

	/**
	 * @param {string} identifier identifier
	 * @returns {ParsedIdentifier} parsed identifier
	 */
	parse(identifier) {
		const part = {
			request: "",
			query: "",
			fragment: "",
			module: false,
			directory: false,
			file: false,
			internal: false
		};

		const parsedIdentifier = parseIdentifier$2(identifier);

		if (!parsedIdentifier) return part;

		[part.request, part.query, part.fragment] = parsedIdentifier;

		if (part.request.length > 0) {
			part.internal = this.isPrivate(identifier);
			part.module = this.isModule(part.request);
			part.directory = this.isDirectory(part.request);
			if (part.directory) {
				part.request = part.request.substr(0, part.request.length - 1);
			}
		}

		return part;
	}

	isModule(path) {
		return getType$2(path) === PathType$2.Normal;
	}

	isPrivate(path) {
		return getType$2(path) === PathType$2.Internal;
	}

	/**
	 * @param {string} path a path
	 * @returns {boolean} true, if the path is a directory path
	 */
	isDirectory(path) {
		return path.endsWith("/");
	}

	join(path, request) {
		return join(path, request);
	}

	normalize(path) {
		return normalize(path);
	}
}

var Resolver_1 = Resolver;

/*
	MIT License http://www.opensource.org/licenses/mit-license.php
	Author Tobias Koppers @sokra
*/

/** @typedef {import("./Resolver").FileSystem} FileSystem */
/** @typedef {import("./Resolver").SyncFileSystem} SyncFileSystem */

/**
 * @param {SyncFileSystem} fs file system implementation
 * @constructor
 */
function SyncAsyncFileSystemDecorator(fs) {
	this.fs = fs;

	this.lstat = undefined;
	this.lstatSync = undefined;
	const lstatSync = fs.lstatSync;
	if (lstatSync) {
		this.lstat = (arg, options, callback) => {
			let result;
			try {
				result = lstatSync.call(fs, arg);
			} catch (e) {
				return (callback || options)(e);
			}
			(callback || options)(null, result);
		};
		this.lstatSync = (arg, options) => lstatSync.call(fs, arg, options);
	}

	this.stat = (arg, options, callback) => {
		let result;
		try {
			result = callback ? fs.statSync(arg, options) : fs.statSync(arg);
		} catch (e) {
			return (callback || options)(e);
		}
		(callback || options)(null, result);
	};
	this.statSync = (arg, options) => fs.statSync(arg, options);

	this.readdir = (arg, options, callback) => {
		let result;
		try {
			result = fs.readdirSync(arg);
		} catch (e) {
			return (callback || options)(e);
		}
		(callback || options)(null, result);
	};
	this.readdirSync = (arg, options) => fs.readdirSync(arg, options);

	this.readFile = (arg, options, callback) => {
		let result;
		try {
			result = fs.readFileSync(arg);
		} catch (e) {
			return (callback || options)(e);
		}
		(callback || options)(null, result);
	};
	this.readFileSync = (arg, options) => fs.readFileSync(arg, options);

	this.readlink = (arg, options, callback) => {
		let result;
		try {
			result = fs.readlinkSync(arg);
		} catch (e) {
			return (callback || options)(e);
		}
		(callback || options)(null, result);
	};
	this.readlinkSync = (arg, options) => fs.readlinkSync(arg, options);

	this.readJson = undefined;
	this.readJsonSync = undefined;
	const readJsonSync = fs.readJsonSync;
	if (readJsonSync) {
		this.readJson = (arg, options, callback) => {
			let result;
			try {
				result = readJsonSync.call(fs, arg);
			} catch (e) {
				return (callback || options)(e);
			}
			(callback || options)(null, result);
		};

		this.readJsonSync = (arg, options) => readJsonSync.call(fs, arg, options);
	}
}
var SyncAsyncFileSystemDecorator_1 = SyncAsyncFileSystemDecorator;

/*
	MIT License http://www.opensource.org/licenses/mit-license.php
	Author Tobias Koppers @sokra
*/

var forEachBail = function forEachBail(array, iterator, callback) {
	if (array.length === 0) return callback();

	let i = 0;
	const next = () => {
		let loop = undefined;
		iterator(array[i++], (err, result) => {
			if (err || result !== undefined || i >= array.length) {
				return callback(err, result);
			}
			if (loop === false) while (next());
			loop = true;
		});
		if (!loop) loop = false;
		return loop;
	};
	while (next());
};

/** @typedef {import("./Resolver")} Resolver */
/** @typedef {import("./Resolver").ResolveContext} ResolveContext */

/**
 * @typedef {Object} DescriptionFileInfo
 * @property {any=} content
 * @property {string} path
 * @property {string} directory
 */

/**
 * @callback ErrorFirstCallback
 * @param {Error|null=} error
 * @param {DescriptionFileInfo=} result
 */

/**
 * @param {Resolver} resolver resolver
 * @param {string} directory directory
 * @param {string[]} filenames filenames
 * @param {DescriptionFileInfo|undefined} oldInfo oldInfo
 * @param {ResolveContext} resolveContext resolveContext
 * @param {ErrorFirstCallback} callback callback
 */
function loadDescriptionFile(
	resolver,
	directory,
	filenames,
	oldInfo,
	resolveContext,
	callback
) {
	(function findDescriptionFile() {
		if (oldInfo && oldInfo.directory === directory) {
			// We already have info for this directory and can reuse it
			return callback(null, oldInfo);
		}
		forEachBail(
			filenames,
			(filename, callback) => {
				const descriptionFilePath = resolver.join(directory, filename);
				if (resolver.fileSystem.readJson) {
					resolver.fileSystem.readJson(descriptionFilePath, (err, content) => {
						if (err) {
							if (typeof err.code !== "undefined") {
								if (resolveContext.missingDependencies) {
									resolveContext.missingDependencies.add(descriptionFilePath);
								}
								return callback();
							}
							if (resolveContext.fileDependencies) {
								resolveContext.fileDependencies.add(descriptionFilePath);
							}
							return onJson(err);
						}
						if (resolveContext.fileDependencies) {
							resolveContext.fileDependencies.add(descriptionFilePath);
						}
						onJson(null, content);
					});
				} else {
					resolver.fileSystem.readFile(descriptionFilePath, (err, content) => {
						if (err) {
							if (resolveContext.missingDependencies) {
								resolveContext.missingDependencies.add(descriptionFilePath);
							}
							return callback();
						}
						if (resolveContext.fileDependencies) {
							resolveContext.fileDependencies.add(descriptionFilePath);
						}
						let json;

						if (content) {
							try {
								json = JSON.parse(content.toString());
							} catch (e) {
								return onJson(e);
							}
						} else {
							return onJson(new Error("No content in file"));
						}

						onJson(null, json);
					});
				}

				function onJson(err, content) {
					if (err) {
						if (resolveContext.log)
							resolveContext.log(
								descriptionFilePath + " (directory description file): " + err
							);
						else
							err.message =
								descriptionFilePath + " (directory description file): " + err;
						return callback(err);
					}
					callback(null, {
						content,
						directory,
						path: descriptionFilePath
					});
				}
			},
			(err, result) => {
				if (err) return callback(err);
				if (result) {
					return callback(null, result);
				} else {
					const dir = cdUp(directory);
					if (!dir) {
						return callback();
					} else {
						directory = dir;
						return findDescriptionFile();
					}
				}
			}
		);
	})();
}

/**
 * @param {any} content content
 * @param {string|string[]} field field
 * @returns {object|string|number|boolean|undefined} field data
 */
function getField(content, field) {
	if (!content) return undefined;
	if (Array.isArray(field)) {
		let current = content;
		for (let j = 0; j < field.length; j++) {
			if (current === null || typeof current !== "object") {
				current = null;
				break;
			}
			current = current[field[j]];
		}
		return current;
	} else {
		return content[field];
	}
}

/**
 * @param {string} directory directory
 * @returns {string|null} parent directory or null
 */
function cdUp(directory) {
	if (directory === "/") return null;
	const i = directory.lastIndexOf("/"),
		j = directory.lastIndexOf("\\");
	const p = i < 0 ? j : j < 0 ? i : i < j ? j : i;
	if (p < 0) return null;
	return directory.substr(0, p || 1);
}

var loadDescriptionFile_1 = loadDescriptionFile;
var getField_1 = getField;
var cdUp_1 = cdUp;

var DescriptionFileUtils = {
	loadDescriptionFile: loadDescriptionFile_1,
	getField: getField_1,
	cdUp: cdUp_1
};

/*
	MIT License http://www.opensource.org/licenses/mit-license.php
	Author Tobias Koppers @sokra
*/

var getInnerRequest = function getInnerRequest(resolver, request) {
	if (
		typeof request.__innerRequest === "string" &&
		request.__innerRequest_request === request.request &&
		request.__innerRequest_relativePath === request.relativePath
	)
		return request.__innerRequest;
	let innerRequest;
	if (request.request) {
		innerRequest = request.request;
		if (/^\.\.?(?:\/|$)/.test(innerRequest) && request.relativePath) {
			innerRequest = resolver.join(request.relativePath, innerRequest);
		}
	} else {
		innerRequest = request.relativePath;
	}
	request.__innerRequest_request = request.request;
	request.__innerRequest_relativePath = request.relativePath;
	return (request.__innerRequest = innerRequest);
};

/** @typedef {import("./Resolver")} Resolver */
/** @typedef {import("./Resolver").ResolveRequest} ResolveRequest */
/** @typedef {import("./Resolver").ResolveStepHook} ResolveStepHook */

var AliasFieldPlugin_1 = class AliasFieldPlugin {
	/**
	 * @param {string | ResolveStepHook} source source
	 * @param {string | Array<string>} field field
	 * @param {string | ResolveStepHook} target target
	 */
	constructor(source, field, target) {
		this.source = source;
		this.field = field;
		this.target = target;
	}

	/**
	 * @param {Resolver} resolver the resolver
	 * @returns {void}
	 */
	apply(resolver) {
		const target = resolver.ensureHook(this.target);
		resolver
			.getHook(this.source)
			.tapAsync("AliasFieldPlugin", (request, resolveContext, callback) => {
				if (!request.descriptionFileData) return callback();
				const innerRequest = getInnerRequest(resolver, request);
				if (!innerRequest) return callback();
				const fieldData = DescriptionFileUtils.getField(
					request.descriptionFileData,
					this.field
				);
				if (fieldData === null || typeof fieldData !== "object") {
					if (resolveContext.log)
						resolveContext.log(
							"Field '" +
								this.field +
								"' doesn't contain a valid alias configuration"
						);
					return callback();
				}
				const data1 = fieldData[innerRequest];
				const data2 = fieldData[innerRequest.replace(/^\.\//, "")];
				const data = typeof data1 !== "undefined" ? data1 : data2;
				if (data === innerRequest) return callback();
				if (data === undefined) return callback();
				if (data === false) {
					/** @type {ResolveRequest} */
					const ignoreObj = {
						...request,
						path: false
					};
					return callback(null, ignoreObj);
				}
				const obj = {
					...request,
					path: request.descriptionFileRoot,
					request: data,
					fullySpecified: false
				};
				resolver.doResolve(
					target,
					obj,
					"aliased from description file " +
						request.descriptionFilePath +
						" with mapping '" +
						innerRequest +
						"' to '" +
						data +
						"'",
					resolveContext,
					(err, result) => {
						if (err) return callback(err);

						// Don't allow other aliasing or raw request
						if (result === undefined) return callback(null, null);
						callback(null, result);
					}
				);
			});
	}
};

/** @typedef {import("./Resolver")} Resolver */
/** @typedef {import("./Resolver").ResolveStepHook} ResolveStepHook */
/** @typedef {{alias: string|Array<string>|false, name: string, onlyModule?: boolean}} AliasOption */

var AliasPlugin_1 = class AliasPlugin {
	/**
	 * @param {string | ResolveStepHook} source source
	 * @param {AliasOption | Array<AliasOption>} options options
	 * @param {string | ResolveStepHook} target target
	 */
	constructor(source, options, target) {
		this.source = source;
		this.options = Array.isArray(options) ? options : [options];
		this.target = target;
	}

	/**
	 * @param {Resolver} resolver the resolver
	 * @returns {void}
	 */
	apply(resolver) {
		const target = resolver.ensureHook(this.target);
		resolver
			.getHook(this.source)
			.tapAsync("AliasPlugin", (request, resolveContext, callback) => {
				const innerRequest = request.request || request.path;
				if (!innerRequest) return callback();
				forEachBail(
					this.options,
					(item, callback) => {
						let shouldStop = false;
						if (
							innerRequest === item.name ||
							(!item.onlyModule && innerRequest.startsWith(item.name + "/"))
						) {
							const remainingRequest = innerRequest.substr(item.name.length);
							const resolveWithAlias = (alias, callback) => {
								if (alias === false) {
									const ignoreObj = {
										...request,
										path: false
									};
									return callback(null, ignoreObj);
								}
								if (
									innerRequest !== alias &&
									!innerRequest.startsWith(alias + "/")
								) {
									shouldStop = true;
									const newRequestStr = alias + remainingRequest;
									const obj = {
										...request,
										request: newRequestStr,
										fullySpecified: false
									};
									return resolver.doResolve(
										target,
										obj,
										"aliased with mapping '" +
											item.name +
											"': '" +
											alias +
											"' to '" +
											newRequestStr +
											"'",
										resolveContext,
										(err, result) => {
											if (err) return callback(err);
											if (result) return callback(null, result);
											return callback();
										}
									);
								}
								return callback();
							};
							const stoppingCallback = (err, result) => {
								if (err) return callback(err);

								if (result) return callback(null, result);
								// Don't allow other aliasing or raw request
								if (shouldStop) return callback(null, null);
								return callback();
							};
							if (Array.isArray(item.alias)) {
								return forEachBail(
									item.alias,
									resolveWithAlias,
									stoppingCallback
								);
							} else {
								return resolveWithAlias(item.alias, stoppingCallback);
							}
						}
						return callback();
					},
					callback
				);
			});
	}
};

/*
	MIT License http://www.opensource.org/licenses/mit-license.php
	Author Tobias Koppers @sokra
*/

/** @typedef {import("./Resolver")} Resolver */
/** @typedef {import("./Resolver").ResolveStepHook} ResolveStepHook */

var AppendPlugin_1 = class AppendPlugin {
	/**
	 * @param {string | ResolveStepHook} source source
	 * @param {string} appending appending
	 * @param {string | ResolveStepHook} target target
	 */
	constructor(source, appending, target) {
		this.source = source;
		this.appending = appending;
		this.target = target;
	}

	/**
	 * @param {Resolver} resolver the resolver
	 * @returns {void}
	 */
	apply(resolver) {
		const target = resolver.ensureHook(this.target);
		resolver
			.getHook(this.source)
			.tapAsync("AppendPlugin", (request, resolveContext, callback) => {
				const obj = {
					...request,
					path: request.path + this.appending,
					relativePath:
						request.relativePath && request.relativePath + this.appending
				};
				resolver.doResolve(
					target,
					obj,
					this.appending,
					resolveContext,
					callback
				);
			});
	}
};

/*
	MIT License http://www.opensource.org/licenses/mit-license.php
	Author Tobias Koppers @sokra
*/

/** @typedef {import("./Resolver")} Resolver */
/** @typedef {import("./Resolver").ResolveRequest} ResolveRequest */
/** @typedef {import("./Resolver").ResolveStepHook} ResolveStepHook */

var ConditionalPlugin_1 = class ConditionalPlugin {
	/**
	 * @param {string | ResolveStepHook} source source
	 * @param {Partial<ResolveRequest>} test compare object
	 * @param {string | null} message log message
	 * @param {boolean} allowAlternatives when false, do not continue with the current step when "test" matches
	 * @param {string | ResolveStepHook} target target
	 */
	constructor(source, test, message, allowAlternatives, target) {
		this.source = source;
		this.test = test;
		this.message = message;
		this.allowAlternatives = allowAlternatives;
		this.target = target;
	}

	/**
	 * @param {Resolver} resolver the resolver
	 * @returns {void}
	 */
	apply(resolver) {
		const target = resolver.ensureHook(this.target);
		const { test, message, allowAlternatives } = this;
		const keys = Object.keys(test);
		resolver
			.getHook(this.source)
			.tapAsync("ConditionalPlugin", (request, resolveContext, callback) => {
				for (const prop of keys) {
					if (request[prop] !== test[prop]) return callback();
				}
				resolver.doResolve(
					target,
					request,
					message,
					resolveContext,
					allowAlternatives
						? callback
						: (err, result) => {
								if (err) return callback(err);

								// Don't allow other alternatives
								if (result === undefined) return callback(null, null);
								callback(null, result);
						  }
				);
			});
	}
};

/** @typedef {import("./Resolver")} Resolver */
/** @typedef {import("./Resolver").ResolveStepHook} ResolveStepHook */

var DescriptionFilePlugin_1 = class DescriptionFilePlugin {
	/**
	 * @param {string | ResolveStepHook} source source
	 * @param {string[]} filenames filenames
	 * @param {boolean} pathIsFile pathIsFile
	 * @param {string | ResolveStepHook} target target
	 */
	constructor(source, filenames, pathIsFile, target) {
		this.source = source;
		this.filenames = filenames;
		this.pathIsFile = pathIsFile;
		this.target = target;
	}

	/**
	 * @param {Resolver} resolver the resolver
	 * @returns {void}
	 */
	apply(resolver) {
		const target = resolver.ensureHook(this.target);
		resolver
			.getHook(this.source)
			.tapAsync(
				"DescriptionFilePlugin",
				(request, resolveContext, callback) => {
					const path = request.path;
					if (!path) return callback();
					const directory = this.pathIsFile
						? DescriptionFileUtils.cdUp(path)
						: path;
					if (!directory) return callback();
					DescriptionFileUtils.loadDescriptionFile(
						resolver,
						directory,
						this.filenames,
						request.descriptionFilePath
							? {
									path: request.descriptionFilePath,
									content: request.descriptionFileData,
									directory: /** @type {string} */ (request.descriptionFileRoot)
							  }
							: undefined,
						resolveContext,
						(err, result) => {
							if (err) return callback(err);
							if (!result) {
								if (resolveContext.log)
									resolveContext.log(
										`No description file found in ${directory} or above`
									);
								return callback();
							}
							const relativePath =
								"." + path.substr(result.directory.length).replace(/\\/g, "/");
							const obj = {
								...request,
								descriptionFilePath: result.path,
								descriptionFileData: result.content,
								descriptionFileRoot: result.directory,
								relativePath: relativePath
							};
							resolver.doResolve(
								target,
								obj,
								"using description file: " +
									result.path +
									" (relative path: " +
									relativePath +
									")",
								resolveContext,
								(err, result) => {
									if (err) return callback(err);

									// Don't allow other processing
									if (result === undefined) return callback(null, null);
									callback(null, result);
								}
							);
						}
					);
				}
			);
	}
};

/*
	MIT License http://www.opensource.org/licenses/mit-license.php
	Author Tobias Koppers @sokra
*/

/** @typedef {import("./Resolver")} Resolver */
/** @typedef {import("./Resolver").ResolveStepHook} ResolveStepHook */

var DirectoryExistsPlugin_1 = class DirectoryExistsPlugin {
	/**
	 * @param {string | ResolveStepHook} source source
	 * @param {string | ResolveStepHook} target target
	 */
	constructor(source, target) {
		this.source = source;
		this.target = target;
	}

	/**
	 * @param {Resolver} resolver the resolver
	 * @returns {void}
	 */
	apply(resolver) {
		const target = resolver.ensureHook(this.target);
		resolver
			.getHook(this.source)
			.tapAsync(
				"DirectoryExistsPlugin",
				(request, resolveContext, callback) => {
					const fs = resolver.fileSystem;
					const directory = request.path;
					if (!directory) return callback();
					fs.stat(directory, (err, stat) => {
						if (err || !stat) {
							if (resolveContext.missingDependencies)
								resolveContext.missingDependencies.add(directory);
							if (resolveContext.log)
								resolveContext.log(directory + " doesn't exist");
							return callback();
						}
						if (!stat.isDirectory()) {
							if (resolveContext.missingDependencies)
								resolveContext.missingDependencies.add(directory);
							if (resolveContext.log)
								resolveContext.log(directory + " is not a directory");
							return callback();
						}
						if (resolveContext.fileDependencies)
							resolveContext.fileDependencies.add(directory);
						resolver.doResolve(
							target,
							request,
							`existing directory ${directory}`,
							resolveContext,
							callback
						);
					});
				}
			);
	}
};

/*
	MIT License http://www.opensource.org/licenses/mit-license.php
	Author Ivan Kopeykin @vankop
*/

/** @typedef {string|(string|ConditionalMapping)[]} DirectMapping */
/** @typedef {{[k: string]: MappingValue}} ConditionalMapping */
/** @typedef {ConditionalMapping|DirectMapping|null} MappingValue */
/** @typedef {Record<string, MappingValue>|ConditionalMapping|DirectMapping} ExportsField */
/** @typedef {Record<string, MappingValue>} ImportsField */

/**
 * @typedef {Object} PathTreeNode
 * @property {Map<string, PathTreeNode>|null} children
 * @property {MappingValue} folder
 * @property {Map<string, MappingValue>|null} wildcards
 * @property {Map<string, MappingValue>} files
 */

/**
 * Processing exports/imports field
 * @callback FieldProcessor
 * @param {string} request request
 * @param {Set<string>} conditionNames condition names
 * @returns {string[]} resolved paths
 */

/*
Example exports field:
{
  ".": "./main.js",
  "./feature": {
    "browser": "./feature-browser.js",
    "default": "./feature.js"
  }
}
Terminology:

Enhanced-resolve name keys ("." and "./feature") as exports field keys.

If value is string or string[], mapping is called as a direct mapping
and value called as a direct export.

If value is key-value object, mapping is called as a conditional mapping
and value called as a conditional export.

Key in conditional mapping is called condition name.

Conditional mapping nested in another conditional mapping is called nested mapping.

----------

Example imports field:
{
  "#a": "./main.js",
  "#moment": {
    "browser": "./moment/index.js",
    "default": "moment"
  },
  "#moment/": {
    "browser": "./moment/",
    "default": "moment/"
  }
}
Terminology:

Enhanced-resolve name keys ("#a" and "#moment/", "#moment") as imports field keys.

If value is string or string[], mapping is called as a direct mapping
and value called as a direct export.

If value is key-value object, mapping is called as a conditional mapping
and value called as a conditional export.

Key in conditional mapping is called condition name.

Conditional mapping nested in another conditional mapping is called nested mapping.

*/

const slashCode$2 = "/".charCodeAt(0);
const dotCode$1 = ".".charCodeAt(0);
const hashCode = "#".charCodeAt(0);

/**
 * @param {ExportsField} exportsField the exports field
 * @returns {FieldProcessor} process callback
 */
var processExportsField$1 = function processExportsField(
	exportsField
) {
	return createFieldProcessor(
		buildExportsFieldPathTree(exportsField),
		assertExportsFieldRequest,
		assertExportTarget
	);
};

/**
 * @param {ImportsField} importsField the exports field
 * @returns {FieldProcessor} process callback
 */
var processImportsField$1 = function processImportsField(
	importsField
) {
	return createFieldProcessor(
		buildImportsFieldPathTree(importsField),
		assertImportsFieldRequest,
		assertImportTarget
	);
};

/**
 * @param {PathTreeNode} treeRoot root
 * @param {(s: string) => string} assertRequest assertRequest
 * @param {(s: string, f: boolean) => void} assertTarget assertTarget
 * @returns {FieldProcessor} field processor
 */
function createFieldProcessor(treeRoot, assertRequest, assertTarget) {
	return function fieldProcessor(request, conditionNames) {
		request = assertRequest(request);

		const match = findMatch(request, treeRoot);

		if (match === null) return [];

		const [mapping, remainRequestIndex] = match;

		/** @type {DirectMapping|null} */
		let direct = null;

		if (isConditionalMapping(mapping)) {
			direct = conditionalMapping(
				/** @type {ConditionalMapping} */ (mapping),
				conditionNames
			);

			// matching not found
			if (direct === null) return [];
		} else {
			direct = /** @type {DirectMapping} */ (mapping);
		}

		const remainingRequest =
			remainRequestIndex === request.length + 1
				? undefined
				: remainRequestIndex < 0
				? request.slice(-remainRequestIndex - 1)
				: request.slice(remainRequestIndex);

		return directMapping(
			remainingRequest,
			remainRequestIndex < 0,
			direct,
			conditionNames,
			assertTarget
		);
	};
}

/**
 * @param {string} request request
 * @returns {string} updated request
 */
function assertExportsFieldRequest(request) {
	if (request.charCodeAt(0) !== dotCode$1) {
		throw new Error('Request should be relative path and start with "."');
	}
	if (request.length === 1) return "";
	if (request.charCodeAt(1) !== slashCode$2) {
		throw new Error('Request should be relative path and start with "./"');
	}
	if (request.charCodeAt(request.length - 1) === slashCode$2) {
		throw new Error("Only requesting file allowed");
	}

	return request.slice(2);
}

/**
 * @param {string} request request
 * @returns {string} updated request
 */
function assertImportsFieldRequest(request) {
	if (request.charCodeAt(0) !== hashCode) {
		throw new Error('Request should start with "#"');
	}
	if (request.length === 1) {
		throw new Error("Request should have at least 2 characters");
	}
	if (request.charCodeAt(1) === slashCode$2) {
		throw new Error('Request should not start with "#/"');
	}
	if (request.charCodeAt(request.length - 1) === slashCode$2) {
		throw new Error("Only requesting file allowed");
	}

	return request.slice(1);
}

/**
 * @param {string} exp export target
 * @param {boolean} expectFolder is folder expected
 */
function assertExportTarget(exp, expectFolder) {
	if (
		exp.charCodeAt(0) === slashCode$2 ||
		(exp.charCodeAt(0) === dotCode$1 && exp.charCodeAt(1) !== slashCode$2)
	) {
		throw new Error(
			`Export should be relative path and start with "./", got ${JSON.stringify(
				exp
			)}.`
		);
	}

	const isFolder = exp.charCodeAt(exp.length - 1) === slashCode$2;

	if (isFolder !== expectFolder) {
		throw new Error(
			expectFolder
				? `Expecting folder to folder mapping. ${JSON.stringify(
						exp
				  )} should end with "/"`
				: `Expecting file to file mapping. ${JSON.stringify(
						exp
				  )} should not end with "/"`
		);
	}
}

/**
 * @param {string} imp import target
 * @param {boolean} expectFolder is folder expected
 */
function assertImportTarget(imp, expectFolder) {
	const isFolder = imp.charCodeAt(imp.length - 1) === slashCode$2;

	if (isFolder !== expectFolder) {
		throw new Error(
			expectFolder
				? `Expecting folder to folder mapping. ${JSON.stringify(
						imp
				  )} should end with "/"`
				: `Expecting file to file mapping. ${JSON.stringify(
						imp
				  )} should not end with "/"`
		);
	}
}

/**
 * Trying to match request to field
 * @param {string} request request
 * @param {PathTreeNode} treeRoot path tree root
 * @returns {[MappingValue, number]|null} match or null, number is negative and one less when it's a folder mapping, number is request.length + 1 for direct mappings
 */
function findMatch(request, treeRoot) {
	if (request.length === 0) {
		const value = treeRoot.files.get("");

		return value ? [value, 1] : null;
	}

	if (
		treeRoot.children === null &&
		treeRoot.folder === null &&
		treeRoot.wildcards === null
	) {
		const value = treeRoot.files.get(request);

		return value ? [value, request.length + 1] : null;
	}

	let node = treeRoot;
	let lastNonSlashIndex = 0;
	let slashIndex = request.indexOf("/", 0);

	/** @type {[MappingValue, number]|null} */
	let lastFolderMatch = null;

	const applyFolderMapping = () => {
		const folderMapping = node.folder;
		if (folderMapping) {
			if (lastFolderMatch) {
				lastFolderMatch[0] = folderMapping;
				lastFolderMatch[1] = -lastNonSlashIndex - 1;
			} else {
				lastFolderMatch = [folderMapping, -lastNonSlashIndex - 1];
			}
		}
	};

	const applyWildcardMappings = (wildcardMappings, remainingRequest) => {
		if (wildcardMappings) {
			for (const [key, target] of wildcardMappings) {
				if (remainingRequest.startsWith(key)) {
					if (!lastFolderMatch) {
						lastFolderMatch = [target, lastNonSlashIndex + key.length];
					} else if (lastFolderMatch[1] < lastNonSlashIndex + key.length) {
						lastFolderMatch[0] = target;
						lastFolderMatch[1] = lastNonSlashIndex + key.length;
					}
				}
			}
		}
	};

	while (slashIndex !== -1) {
		applyFolderMapping();

		const wildcardMappings = node.wildcards;

		if (!wildcardMappings && node.children === null) return lastFolderMatch;

		const folder = request.slice(lastNonSlashIndex, slashIndex);

		applyWildcardMappings(wildcardMappings, folder);

		if (node.children === null) return lastFolderMatch;

		const newNode = node.children.get(folder);

		if (!newNode) {
			return lastFolderMatch;
		}

		node = newNode;
		lastNonSlashIndex = slashIndex + 1;
		slashIndex = request.indexOf("/", lastNonSlashIndex);
	}

	const remainingRequest =
		lastNonSlashIndex > 0 ? request.slice(lastNonSlashIndex) : request;

	const value = node.files.get(remainingRequest);

	if (value) {
		return [value, request.length + 1];
	}

	applyFolderMapping();

	applyWildcardMappings(node.wildcards, remainingRequest);

	return lastFolderMatch;
}

/**
 * @param {ConditionalMapping|DirectMapping|null} mapping mapping
 * @returns {boolean} is conditional mapping
 */
function isConditionalMapping(mapping) {
	return (
		mapping !== null && typeof mapping === "object" && !Array.isArray(mapping)
	);
}

/**
 * @param {string|undefined} remainingRequest remaining request when folder mapping, undefined for file mappings
 * @param {boolean} subpathMapping true, for subpath mappings
 * @param {DirectMapping|null} mappingTarget direct export
 * @param {Set<string>} conditionNames condition names
 * @param {(d: string, f: boolean) => void} assert asserting direct value
 * @returns {string[]} mapping result
 */
function directMapping(
	remainingRequest,
	subpathMapping,
	mappingTarget,
	conditionNames,
	assert
) {
	if (mappingTarget === null) return [];

	if (typeof mappingTarget === "string") {
		return [
			targetMapping(remainingRequest, subpathMapping, mappingTarget, assert)
		];
	}

	const targets = [];

	for (const exp of mappingTarget) {
		if (typeof exp === "string") {
			targets.push(
				targetMapping(remainingRequest, subpathMapping, exp, assert)
			);
			continue;
		}

		const mapping = conditionalMapping(exp, conditionNames);
		if (!mapping) continue;
		const innerExports = directMapping(
			remainingRequest,
			subpathMapping,
			mapping,
			conditionNames,
			assert
		);
		for (const innerExport of innerExports) {
			targets.push(innerExport);
		}
	}

	return targets;
}

/**
 * @param {string|undefined} remainingRequest remaining request when folder mapping, undefined for file mappings
 * @param {boolean} subpathMapping true, for subpath mappings
 * @param {string} mappingTarget direct export
 * @param {(d: string, f: boolean) => void} assert asserting direct value
 * @returns {string} mapping result
 */
function targetMapping(
	remainingRequest,
	subpathMapping,
	mappingTarget,
	assert
) {
	if (remainingRequest === undefined) {
		assert(mappingTarget, false);
		return mappingTarget;
	}
	if (subpathMapping) {
		assert(mappingTarget, true);
		return mappingTarget + remainingRequest;
	}
	assert(mappingTarget, false);
	return mappingTarget.replace(/\*/g, remainingRequest.replace(/\$/g, "$$"));
}

/**
 * @param {ConditionalMapping} conditionalMapping_ conditional mapping
 * @param {Set<string>} conditionNames condition names
 * @returns {DirectMapping|null} direct mapping if found
 */
function conditionalMapping(conditionalMapping_, conditionNames) {
	/** @type {[ConditionalMapping, string[], number][]} */
	let lookup = [[conditionalMapping_, Object.keys(conditionalMapping_), 0]];

	loop: while (lookup.length > 0) {
		const [mapping, conditions, j] = lookup[lookup.length - 1];
		const last = conditions.length - 1;

		for (let i = j; i < conditions.length; i++) {
			const condition = conditions[i];

			// assert default. Could be last only
			if (i !== last) {
				if (condition === "default") {
					throw new Error("Default condition should be last one");
				}
			} else if (condition === "default") {
				const innerMapping = mapping[condition];
				// is nested
				if (isConditionalMapping(innerMapping)) {
					const conditionalMapping = /** @type {ConditionalMapping} */ (innerMapping);
					lookup[lookup.length - 1][2] = i + 1;
					lookup.push([conditionalMapping, Object.keys(conditionalMapping), 0]);
					continue loop;
				}

				return /** @type {DirectMapping} */ (innerMapping);
			}

			if (conditionNames.has(condition)) {
				const innerMapping = mapping[condition];
				// is nested
				if (isConditionalMapping(innerMapping)) {
					const conditionalMapping = /** @type {ConditionalMapping} */ (innerMapping);
					lookup[lookup.length - 1][2] = i + 1;
					lookup.push([conditionalMapping, Object.keys(conditionalMapping), 0]);
					continue loop;
				}

				return /** @type {DirectMapping} */ (innerMapping);
			}
		}

		lookup.pop();
	}

	return null;
}

/**
 * Internal helper to create path tree node
 * to ensure that each node gets the same hidden class
 * @returns {PathTreeNode} node
 */
function createNode() {
	return {
		children: null,
		folder: null,
		wildcards: null,
		files: new Map()
	};
}

/**
 * Internal helper for building path tree
 * @param {PathTreeNode} root root
 * @param {string} path path
 * @param {MappingValue} target target
 */
function walkPath(root, path, target) {
	if (path.length === 0) {
		root.folder = target;
		return;
	}

	let node = root;
	// Typical path tree can looks like
	// root
	// - files: ["a.js", "b.js"]
	// - children:
	//    node1:
	//    - files: ["a.js", "b.js"]
	let lastNonSlashIndex = 0;
	let slashIndex = path.indexOf("/", 0);

	while (slashIndex !== -1) {
		const folder = path.slice(lastNonSlashIndex, slashIndex);
		let newNode;

		if (node.children === null) {
			newNode = createNode();
			node.children = new Map();
			node.children.set(folder, newNode);
		} else {
			newNode = node.children.get(folder);

			if (!newNode) {
				newNode = createNode();
				node.children.set(folder, newNode);
			}
		}

		node = newNode;
		lastNonSlashIndex = slashIndex + 1;
		slashIndex = path.indexOf("/", lastNonSlashIndex);
	}

	if (lastNonSlashIndex >= path.length) {
		node.folder = target;
	} else {
		const file = lastNonSlashIndex > 0 ? path.slice(lastNonSlashIndex) : path;
		if (file.endsWith("*")) {
			if (node.wildcards === null) node.wildcards = new Map();
			node.wildcards.set(file.slice(0, -1), target);
		} else {
			node.files.set(file, target);
		}
	}
}

/**
 * @param {ExportsField} field exports field
 * @returns {PathTreeNode} tree root
 */
function buildExportsFieldPathTree(field) {
	const root = createNode();

	// handle syntax sugar, if exports field is direct mapping for "."
	if (typeof field === "string") {
		root.files.set("", field);

		return root;
	} else if (Array.isArray(field)) {
		root.files.set("", field.slice());

		return root;
	}

	const keys = Object.keys(field);

	for (let i = 0; i < keys.length; i++) {
		const key = keys[i];

		if (key.charCodeAt(0) !== dotCode$1) {
			// handle syntax sugar, if exports field is conditional mapping for "."
			if (i === 0) {
				while (i < keys.length) {
					const charCode = keys[i].charCodeAt(0);
					if (charCode === dotCode$1 || charCode === slashCode$2) {
						throw new Error(
							`Exports field key should be relative path and start with "." (key: ${JSON.stringify(
								key
							)})`
						);
					}
					i++;
				}

				root.files.set("", field);
				return root;
			}

			throw new Error(
				`Exports field key should be relative path and start with "." (key: ${JSON.stringify(
					key
				)})`
			);
		}

		if (key.length === 1) {
			root.files.set("", field[key]);
			continue;
		}

		if (key.charCodeAt(1) !== slashCode$2) {
			throw new Error(
				`Exports field key should be relative path and start with "./" (key: ${JSON.stringify(
					key
				)})`
			);
		}

		walkPath(root, key.slice(2), field[key]);
	}

	return root;
}

/**
 * @param {ImportsField} field imports field
 * @returns {PathTreeNode} root
 */
function buildImportsFieldPathTree(field) {
	const root = createNode();

	const keys = Object.keys(field);

	for (let i = 0; i < keys.length; i++) {
		const key = keys[i];

		if (key.charCodeAt(0) !== hashCode) {
			throw new Error(
				`Imports field key should start with "#" (key: ${JSON.stringify(key)})`
			);
		}

		if (key.length === 1) {
			throw new Error(
				`Imports field key should have at least 2 characters (key: ${JSON.stringify(
					key
				)})`
			);
		}

		if (key.charCodeAt(1) === slashCode$2) {
			throw new Error(
				`Imports field key should not start with "#/" (key: ${JSON.stringify(
					key
				)})`
			);
		}

		walkPath(root, key.slice(1), field[key]);
	}

	return root;
}

var entrypoints = {
	processExportsField: processExportsField$1,
	processImportsField: processImportsField$1
};

const { processExportsField } = entrypoints;
const { parseIdentifier: parseIdentifier$1 } = identifier;
const { checkExportsFieldTarget } = path_1;

/** @typedef {import("./Resolver")} Resolver */
/** @typedef {import("./Resolver").ResolveStepHook} ResolveStepHook */
/** @typedef {import("./util/entrypoints").ExportsField} ExportsField */
/** @typedef {import("./util/entrypoints").FieldProcessor} FieldProcessor */

var ExportsFieldPlugin_1 = class ExportsFieldPlugin {
	/**
	 * @param {string | ResolveStepHook} source source
	 * @param {Set<string>} conditionNames condition names
	 * @param {string | string[]} fieldNamePath name path
	 * @param {string | ResolveStepHook} target target
	 */
	constructor(source, conditionNames, fieldNamePath, target) {
		this.source = source;
		this.target = target;
		this.conditionNames = conditionNames;
		this.fieldName = fieldNamePath;
		/** @type {WeakMap<any, FieldProcessor>} */
		this.fieldProcessorCache = new WeakMap();
	}

	/**
	 * @param {Resolver} resolver the resolver
	 * @returns {void}
	 */
	apply(resolver) {
		const target = resolver.ensureHook(this.target);
		resolver
			.getHook(this.source)
			.tapAsync("ExportsFieldPlugin", (request, resolveContext, callback) => {
				// When there is no description file, abort
				if (!request.descriptionFilePath) return callback();
				if (
					// When the description file is inherited from parent, abort
					// (There is no description file inside of this package)
					request.relativePath !== "." ||
					request.request === undefined
				)
					return callback();

				const remainingRequest =
					request.query || request.fragment
						? (request.request === "." ? "./" : request.request) +
						  request.query +
						  request.fragment
						: request.request;
				/** @type {ExportsField|null} */
				const exportsField = DescriptionFileUtils.getField(
					request.descriptionFileData,
					this.fieldName
				);
				if (!exportsField) return callback();

				if (request.directory) {
					return callback(
						new Error(
							`Resolving to directories is not possible with the exports field (request was ${remainingRequest}/)`
						)
					);
				}

				let paths;

				try {
					// We attach the cache to the description file instead of the exportsField value
					// because we use a WeakMap and the exportsField could be a string too.
					// Description file is always an object when exports field can be accessed.
					let fieldProcessor = this.fieldProcessorCache.get(
						request.descriptionFileData
					);
					if (fieldProcessor === undefined) {
						fieldProcessor = processExportsField(exportsField);
						this.fieldProcessorCache.set(
							request.descriptionFileData,
							fieldProcessor
						);
					}
					paths = fieldProcessor(remainingRequest, this.conditionNames);
				} catch (err) {
					if (resolveContext.log) {
						resolveContext.log(
							`Exports field in ${request.descriptionFilePath} can't be processed: ${err}`
						);
					}
					return callback(err);
				}

				if (paths.length === 0) {
					return callback(
						new Error(
							`Package path ${remainingRequest} is not exported from package ${request.descriptionFileRoot} (see exports field in ${request.descriptionFilePath})`
						)
					);
				}

				forEachBail(
					paths,
					(p, callback) => {
						const parsedIdentifier = parseIdentifier$1(p);

						if (!parsedIdentifier) return callback();

						const [relativePath, query, fragment] = parsedIdentifier;

						const error = checkExportsFieldTarget(relativePath);

						if (error) {
							return callback(error);
						}

						const obj = {
							...request,
							request: undefined,
							path: path__default["default"].join(
								/** @type {string} */ (request.descriptionFileRoot),
								relativePath
							),
							relativePath,
							query,
							fragment
						};

						resolver.doResolve(
							target,
							obj,
							"using exports field: " + p,
							resolveContext,
							callback
						);
					},
					(err, result) => callback(err, result || null)
				);
			});
	}
};

/*
	MIT License http://www.opensource.org/licenses/mit-license.php
	Author Tobias Koppers @sokra
*/

/** @typedef {import("./Resolver")} Resolver */
/** @typedef {import("./Resolver").ResolveStepHook} ResolveStepHook */

var FileExistsPlugin_1 = class FileExistsPlugin {
	/**
	 * @param {string | ResolveStepHook} source source
	 * @param {string | ResolveStepHook} target target
	 */
	constructor(source, target) {
		this.source = source;
		this.target = target;
	}

	/**
	 * @param {Resolver} resolver the resolver
	 * @returns {void}
	 */
	apply(resolver) {
		const target = resolver.ensureHook(this.target);
		const fs = resolver.fileSystem;
		resolver
			.getHook(this.source)
			.tapAsync("FileExistsPlugin", (request, resolveContext, callback) => {
				const file = request.path;
				if (!file) return callback();
				fs.stat(file, (err, stat) => {
					if (err || !stat) {
						if (resolveContext.missingDependencies)
							resolveContext.missingDependencies.add(file);
						if (resolveContext.log) resolveContext.log(file + " doesn't exist");
						return callback();
					}
					if (!stat.isFile()) {
						if (resolveContext.missingDependencies)
							resolveContext.missingDependencies.add(file);
						if (resolveContext.log) resolveContext.log(file + " is not a file");
						return callback();
					}
					if (resolveContext.fileDependencies)
						resolveContext.fileDependencies.add(file);
					resolver.doResolve(
						target,
						request,
						"existing file: " + file,
						resolveContext,
						callback
					);
				});
			});
	}
};

const { processImportsField } = entrypoints;
const { parseIdentifier } = identifier;

/** @typedef {import("./Resolver")} Resolver */
/** @typedef {import("./Resolver").ResolveStepHook} ResolveStepHook */
/** @typedef {import("./util/entrypoints").FieldProcessor} FieldProcessor */
/** @typedef {import("./util/entrypoints").ImportsField} ImportsField */

const dotCode = ".".charCodeAt(0);

var ImportsFieldPlugin_1 = class ImportsFieldPlugin {
	/**
	 * @param {string | ResolveStepHook} source source
	 * @param {Set<string>} conditionNames condition names
	 * @param {string | string[]} fieldNamePath name path
	 * @param {string | ResolveStepHook} targetFile target file
	 * @param {string | ResolveStepHook} targetPackage target package
	 */
	constructor(
		source,
		conditionNames,
		fieldNamePath,
		targetFile,
		targetPackage
	) {
		this.source = source;
		this.targetFile = targetFile;
		this.targetPackage = targetPackage;
		this.conditionNames = conditionNames;
		this.fieldName = fieldNamePath;
		/** @type {WeakMap<any, FieldProcessor>} */
		this.fieldProcessorCache = new WeakMap();
	}

	/**
	 * @param {Resolver} resolver the resolver
	 * @returns {void}
	 */
	apply(resolver) {
		const targetFile = resolver.ensureHook(this.targetFile);
		const targetPackage = resolver.ensureHook(this.targetPackage);

		resolver
			.getHook(this.source)
			.tapAsync("ImportsFieldPlugin", (request, resolveContext, callback) => {
				// When there is no description file, abort
				if (!request.descriptionFilePath || request.request === undefined) {
					return callback();
				}

				const remainingRequest =
					request.request + request.query + request.fragment;
				/** @type {ImportsField|null} */
				const importsField = DescriptionFileUtils.getField(
					request.descriptionFileData,
					this.fieldName
				);
				if (!importsField) return callback();

				if (request.directory) {
					return callback(
						new Error(
							`Resolving to directories is not possible with the imports field (request was ${remainingRequest}/)`
						)
					);
				}

				let paths;

				try {
					// We attach the cache to the description file instead of the importsField value
					// because we use a WeakMap and the importsField could be a string too.
					// Description file is always an object when exports field can be accessed.
					let fieldProcessor = this.fieldProcessorCache.get(
						request.descriptionFileData
					);
					if (fieldProcessor === undefined) {
						fieldProcessor = processImportsField(importsField);
						this.fieldProcessorCache.set(
							request.descriptionFileData,
							fieldProcessor
						);
					}
					paths = fieldProcessor(remainingRequest, this.conditionNames);
				} catch (err) {
					if (resolveContext.log) {
						resolveContext.log(
							`Imports field in ${request.descriptionFilePath} can't be processed: ${err}`
						);
					}
					return callback(err);
				}

				if (paths.length === 0) {
					return callback(
						new Error(
							`Package import ${remainingRequest} is not imported from package ${request.descriptionFileRoot} (see imports field in ${request.descriptionFilePath})`
						)
					);
				}

				forEachBail(
					paths,
					(p, callback) => {
						const parsedIdentifier = parseIdentifier(p);

						if (!parsedIdentifier) return callback();

						const [path_, query, fragment] = parsedIdentifier;

						switch (path_.charCodeAt(0)) {
							// should be relative
							case dotCode: {
								const obj = {
									...request,
									request: undefined,
									path: path__default["default"].join(
										/** @type {string} */ (request.descriptionFileRoot),
										path_
									),
									relativePath: path_,
									query,
									fragment
								};

								resolver.doResolve(
									targetFile,
									obj,
									"using imports field: " + p,
									resolveContext,
									callback
								);
								break;
							}

							// package resolving
							default: {
								const obj = {
									...request,
									request: path_,
									relativePath: path_,
									fullySpecified: true,
									query,
									fragment
								};

								resolver.doResolve(
									targetPackage,
									obj,
									"using imports field: " + p,
									resolveContext,
									callback
								);
							}
						}
					},
					(err, result) => callback(err, result || null)
				);
			});
	}
};

/*
	MIT License http://www.opensource.org/licenses/mit-license.php
	Author Tobias Koppers @sokra
*/

/** @typedef {import("./Resolver")} Resolver */
/** @typedef {import("./Resolver").ResolveStepHook} ResolveStepHook */

const namespaceStartCharCode = "@".charCodeAt(0);

var JoinRequestPartPlugin_1 = class JoinRequestPartPlugin {
	/**
	 * @param {string | ResolveStepHook} source source
	 * @param {string | ResolveStepHook} target target
	 */
	constructor(source, target) {
		this.source = source;
		this.target = target;
	}

	/**
	 * @param {Resolver} resolver the resolver
	 * @returns {void}
	 */
	apply(resolver) {
		const target = resolver.ensureHook(this.target);
		resolver
			.getHook(this.source)
			.tapAsync(
				"JoinRequestPartPlugin",
				(request, resolveContext, callback) => {
					const req = request.request || "";
					let i = req.indexOf("/", 3);

					if (i >= 0 && req.charCodeAt(2) === namespaceStartCharCode) {
						i = req.indexOf("/", i + 1);
					}

					let moduleName, remainingRequest, fullySpecified;
					if (i < 0) {
						moduleName = req;
						remainingRequest = ".";
						fullySpecified = false;
					} else {
						moduleName = req.slice(0, i);
						remainingRequest = "." + req.slice(i);
						fullySpecified = request.fullySpecified;
					}
					const obj = {
						...request,
						path: resolver.join(request.path, moduleName),
						relativePath:
							request.relativePath &&
							resolver.join(request.relativePath, moduleName),
						request: remainingRequest,
						fullySpecified
					};
					resolver.doResolve(target, obj, null, resolveContext, callback);
				}
			);
	}
};

/*
	MIT License http://www.opensource.org/licenses/mit-license.php
	Author Tobias Koppers @sokra
*/

/** @typedef {import("./Resolver")} Resolver */
/** @typedef {import("./Resolver").ResolveStepHook} ResolveStepHook */

var JoinRequestPlugin_1 = class JoinRequestPlugin {
	/**
	 * @param {string | ResolveStepHook} source source
	 * @param {string | ResolveStepHook} target target
	 */
	constructor(source, target) {
		this.source = source;
		this.target = target;
	}

	/**
	 * @param {Resolver} resolver the resolver
	 * @returns {void}
	 */
	apply(resolver) {
		const target = resolver.ensureHook(this.target);
		resolver
			.getHook(this.source)
			.tapAsync("JoinRequestPlugin", (request, resolveContext, callback) => {
				const obj = {
					...request,
					path: resolver.join(request.path, request.request),
					relativePath:
						request.relativePath &&
						resolver.join(request.relativePath, request.request),
					request: undefined
				};
				resolver.doResolve(target, obj, null, resolveContext, callback);
			});
	}
};

/** @typedef {import("./Resolver")} Resolver */
/** @typedef {import("./Resolver").ResolveStepHook} ResolveStepHook */
/** @typedef {{name: string|Array<string>, forceRelative: boolean}} MainFieldOptions */

const alreadyTriedMainField = Symbol("alreadyTriedMainField");

var MainFieldPlugin_1 = class MainFieldPlugin {
	/**
	 * @param {string | ResolveStepHook} source source
	 * @param {MainFieldOptions} options options
	 * @param {string | ResolveStepHook} target target
	 */
	constructor(source, options, target) {
		this.source = source;
		this.options = options;
		this.target = target;
	}

	/**
	 * @param {Resolver} resolver the resolver
	 * @returns {void}
	 */
	apply(resolver) {
		const target = resolver.ensureHook(this.target);
		resolver
			.getHook(this.source)
			.tapAsync("MainFieldPlugin", (request, resolveContext, callback) => {
				if (
					request.path !== request.descriptionFileRoot ||
					request[alreadyTriedMainField] === request.descriptionFilePath ||
					!request.descriptionFilePath
				)
					return callback();
				const filename = path__default["default"].basename(request.descriptionFilePath);
				let mainModule = DescriptionFileUtils.getField(
					request.descriptionFileData,
					this.options.name
				);

				if (
					!mainModule ||
					typeof mainModule !== "string" ||
					mainModule === "." ||
					mainModule === "./"
				) {
					return callback();
				}
				if (this.options.forceRelative && !/^\.\.?\//.test(mainModule))
					mainModule = "./" + mainModule;
				const obj = {
					...request,
					request: mainModule,
					module: false,
					directory: mainModule.endsWith("/"),
					[alreadyTriedMainField]: request.descriptionFilePath
				};
				return resolver.doResolve(
					target,
					obj,
					"use " +
						mainModule +
						" from " +
						this.options.name +
						" in " +
						filename,
					resolveContext,
					callback
				);
			});
	}
};

/*
	MIT License http://www.opensource.org/licenses/mit-license.php
	Author Tobias Koppers @sokra
*/

var getPaths = function getPaths(path) {
	const parts = path.split(/(.*?[\\/]+)/);
	const paths = [path];
	const seqments = [parts[parts.length - 1]];
	let part = parts[parts.length - 1];
	path = path.substr(0, path.length - part.length - 1);
	for (let i = parts.length - 2; i > 2; i -= 2) {
		paths.push(path);
		part = parts[i];
		path = path.substr(0, path.length - part.length) || "/";
		seqments.push(part.substr(0, part.length - 1));
	}
	part = parts[1];
	seqments.push(part);
	paths.push(part);
	return {
		paths: paths,
		seqments: seqments
	};
};

var basename$1 = function basename(path) {
	const i = path.lastIndexOf("/"),
		j = path.lastIndexOf("\\");
	const p = i < 0 ? j : j < 0 ? i : i < j ? j : i;
	if (p < 0) return null;
	const s = path.substr(p + 1);
	return s;
};
getPaths.basename = basename$1;

/** @typedef {import("./Resolver")} Resolver */
/** @typedef {import("./Resolver").ResolveStepHook} ResolveStepHook */

var ModulesInHierachicDirectoriesPlugin_1 = class ModulesInHierachicDirectoriesPlugin {
	/**
	 * @param {string | ResolveStepHook} source source
	 * @param {string | Array<string>} directories directories
	 * @param {string | ResolveStepHook} target target
	 */
	constructor(source, directories, target) {
		this.source = source;
		this.directories = /** @type {Array<string>} */ ([]).concat(directories);
		this.target = target;
	}

	/**
	 * @param {Resolver} resolver the resolver
	 * @returns {void}
	 */
	apply(resolver) {
		const target = resolver.ensureHook(this.target);
		resolver
			.getHook(this.source)
			.tapAsync(
				"ModulesInHierachicDirectoriesPlugin",
				(request, resolveContext, callback) => {
					const fs = resolver.fileSystem;
					const addrs = getPaths(request.path)
						.paths.map(p => {
							return this.directories.map(d => resolver.join(p, d));
						})
						.reduce((array, p) => {
							array.push.apply(array, p);
							return array;
						}, []);
					forEachBail(
						addrs,
						(addr, callback) => {
							fs.stat(addr, (err, stat) => {
								if (!err && stat && stat.isDirectory()) {
									const obj = {
										...request,
										path: addr,
										request: "./" + request.request,
										module: false
									};
									const message = "looking for modules in " + addr;
									return resolver.doResolve(
										target,
										obj,
										message,
										resolveContext,
										callback
									);
								}
								if (resolveContext.log)
									resolveContext.log(
										addr + " doesn't exist or is not a directory"
									);
								if (resolveContext.missingDependencies)
									resolveContext.missingDependencies.add(addr);
								return callback();
							});
						},
						callback
					);
				}
			);
	}
};

/*
	MIT License http://www.opensource.org/licenses/mit-license.php
	Author Tobias Koppers @sokra
*/

/** @typedef {import("./Resolver")} Resolver */
/** @typedef {import("./Resolver").ResolveStepHook} ResolveStepHook */

var ModulesInRootPlugin_1 = class ModulesInRootPlugin {
	/**
	 * @param {string | ResolveStepHook} source source
	 * @param {string} path path
	 * @param {string | ResolveStepHook} target target
	 */
	constructor(source, path, target) {
		this.source = source;
		this.path = path;
		this.target = target;
	}

	/**
	 * @param {Resolver} resolver the resolver
	 * @returns {void}
	 */
	apply(resolver) {
		const target = resolver.ensureHook(this.target);
		resolver
			.getHook(this.source)
			.tapAsync("ModulesInRootPlugin", (request, resolveContext, callback) => {
				const obj = {
					...request,
					path: this.path,
					request: "./" + request.request,
					module: false
				};
				resolver.doResolve(
					target,
					obj,
					"looking for modules in " + this.path,
					resolveContext,
					callback
				);
			});
	}
};

/*
	MIT License http://www.opensource.org/licenses/mit-license.php
	Author Tobias Koppers @sokra
*/

/** @typedef {import("./Resolver")} Resolver */
/** @typedef {import("./Resolver").ResolveStepHook} ResolveStepHook */

var NextPlugin_1 = class NextPlugin {
	/**
	 * @param {string | ResolveStepHook} source source
	 * @param {string | ResolveStepHook} target target
	 */
	constructor(source, target) {
		this.source = source;
		this.target = target;
	}

	/**
	 * @param {Resolver} resolver the resolver
	 * @returns {void}
	 */
	apply(resolver) {
		const target = resolver.ensureHook(this.target);
		resolver
			.getHook(this.source)
			.tapAsync("NextPlugin", (request, resolveContext, callback) => {
				resolver.doResolve(target, request, null, resolveContext, callback);
			});
	}
};

/*
	MIT License http://www.opensource.org/licenses/mit-license.php
	Author Tobias Koppers @sokra
*/

/** @typedef {import("./Resolver")} Resolver */
/** @typedef {import("./Resolver").ResolveRequest} ResolveRequest */
/** @typedef {import("./Resolver").ResolveStepHook} ResolveStepHook */

var ParsePlugin_1 = class ParsePlugin {
	/**
	 * @param {string | ResolveStepHook} source source
	 * @param {Partial<ResolveRequest>} requestOptions request options
	 * @param {string | ResolveStepHook} target target
	 */
	constructor(source, requestOptions, target) {
		this.source = source;
		this.requestOptions = requestOptions;
		this.target = target;
	}

	/**
	 * @param {Resolver} resolver the resolver
	 * @returns {void}
	 */
	apply(resolver) {
		const target = resolver.ensureHook(this.target);
		resolver
			.getHook(this.source)
			.tapAsync("ParsePlugin", (request, resolveContext, callback) => {
				const parsed = resolver.parse(/** @type {string} */ (request.request));
				const obj = { ...request, ...parsed, ...this.requestOptions };
				if (request.query && !parsed.query) {
					obj.query = request.query;
				}
				if (request.fragment && !parsed.fragment) {
					obj.fragment = request.fragment;
				}
				if (parsed && resolveContext.log) {
					if (parsed.module) resolveContext.log("Parsed request is a module");
					if (parsed.directory)
						resolveContext.log("Parsed request is a directory");
				}
				// There is an edge-case where a request with # can be a path or a fragment -> try both
				if (obj.request && !obj.query && obj.fragment) {
					const directory = obj.fragment.endsWith("/");
					const alternative = {
						...obj,
						directory,
						request:
							obj.request +
							(obj.directory ? "/" : "") +
							(directory ? obj.fragment.slice(0, -1) : obj.fragment),
						fragment: ""
					};
					resolver.doResolve(
						target,
						alternative,
						null,
						resolveContext,
						(err, result) => {
							if (err) return callback(err);
							if (result) return callback(null, result);
							resolver.doResolve(target, obj, null, resolveContext, callback);
						}
					);
					return;
				}
				resolver.doResolve(target, obj, null, resolveContext, callback);
			});
	}
};

/*
	MIT License http://www.opensource.org/licenses/mit-license.php
	Author Maël Nison @arcanis
*/

/** @typedef {import("./Resolver")} Resolver */
/** @typedef {import("./Resolver").ResolveStepHook} ResolveStepHook */
/**
 * @typedef {Object} PnpApiImpl
 * @property {function(string, string, object): string} resolveToUnqualified
 */

var PnpPlugin_1 = class PnpPlugin {
	/**
	 * @param {string | ResolveStepHook} source source
	 * @param {PnpApiImpl} pnpApi pnpApi
	 * @param {string | ResolveStepHook} target target
	 */
	constructor(source, pnpApi, target) {
		this.source = source;
		this.pnpApi = pnpApi;
		this.target = target;
	}

	/**
	 * @param {Resolver} resolver the resolver
	 * @returns {void}
	 */
	apply(resolver) {
		const target = resolver.ensureHook(this.target);
		resolver
			.getHook(this.source)
			.tapAsync("PnpPlugin", (request, resolveContext, callback) => {
				const req = request.request;
				if (!req) return callback();

				// The trailing slash indicates to PnP that this value is a folder rather than a file
				const issuer = `${request.path}/`;

				const packageMatch = /^(@[^/]+\/)?[^/]+/.exec(req);
				if (!packageMatch) return callback();

				const packageName = packageMatch[0];
				const innerRequest = `.${req.slice(packageName.length)}`;

				let resolution;
				let apiResolution;
				try {
					resolution = this.pnpApi.resolveToUnqualified(packageName, issuer, {
						considerBuiltins: false
					});
					if (resolveContext.fileDependencies) {
						apiResolution = this.pnpApi.resolveToUnqualified("pnpapi", issuer, {
							considerBuiltins: false
						});
					}
				} catch (error) {
					if (
						error.code === "MODULE_NOT_FOUND" &&
						error.pnpCode === "UNDECLARED_DEPENDENCY"
					) {
						// This is not a PnP managed dependency.
						// Try to continue resolving with our alternatives
						if (resolveContext.log) {
							resolveContext.log(`request is not managed by the pnpapi`);
							for (const line of error.message.split("\n").filter(Boolean))
								resolveContext.log(`  ${line}`);
						}
						return callback();
					}
					return callback(error);
				}

				if (resolution === packageName) return callback();

				if (apiResolution && resolveContext.fileDependencies) {
					resolveContext.fileDependencies.add(apiResolution);
				}

				const obj = {
					...request,
					path: resolution,
					request: innerRequest,
					ignoreSymlinks: true,
					fullySpecified: request.fullySpecified && innerRequest !== "."
				};
				resolver.doResolve(
					target,
					obj,
					`resolved by pnp to ${resolution}`,
					resolveContext,
					(err, result) => {
						if (err) return callback(err);
						if (result) return callback(null, result);
						// Skip alternatives
						return callback(null, null);
					}
				);
			});
	}
};

/*
	MIT License http://www.opensource.org/licenses/mit-license.php
	Author Ivan Kopeykin @vankop
*/

/** @typedef {import("./Resolver")} Resolver */
/** @typedef {import("./Resolver").ResolveStepHook} ResolveStepHook */

const slashCode$1 = "/".charCodeAt(0);
const backslashCode = "\\".charCodeAt(0);

const isInside = (path, parent) => {
	if (!path.startsWith(parent)) return false;
	if (path.length === parent.length) return true;
	const charCode = path.charCodeAt(parent.length);
	return charCode === slashCode$1 || charCode === backslashCode;
};

var RestrictionsPlugin_1 = class RestrictionsPlugin {
	/**
	 * @param {string | ResolveStepHook} source source
	 * @param {Set<string | RegExp>} restrictions restrictions
	 */
	constructor(source, restrictions) {
		this.source = source;
		this.restrictions = restrictions;
	}

	/**
	 * @param {Resolver} resolver the resolver
	 * @returns {void}
	 */
	apply(resolver) {
		resolver
			.getHook(this.source)
			.tapAsync("RestrictionsPlugin", (request, resolveContext, callback) => {
				if (typeof request.path === "string") {
					const path = request.path;
					for (const rule of this.restrictions) {
						if (typeof rule === "string") {
							if (!isInside(path, rule)) {
								if (resolveContext.log) {
									resolveContext.log(
										`${path} is not inside of the restriction ${rule}`
									);
								}
								return callback(null, null);
							}
						} else if (!rule.test(path)) {
							if (resolveContext.log) {
								resolveContext.log(
									`${path} doesn't match the restriction ${rule}`
								);
							}
							return callback(null, null);
						}
					}
				}

				callback();
			});
	}
};

/*
	MIT License http://www.opensource.org/licenses/mit-license.php
	Author Tobias Koppers @sokra
*/

/** @typedef {import("./Resolver")} Resolver */
/** @typedef {import("./Resolver").ResolveStepHook} ResolveStepHook */

var ResultPlugin_1 = class ResultPlugin {
	/**
	 * @param {ResolveStepHook} source source
	 */
	constructor(source) {
		this.source = source;
	}

	/**
	 * @param {Resolver} resolver the resolver
	 * @returns {void}
	 */
	apply(resolver) {
		this.source.tapAsync(
			"ResultPlugin",
			(request, resolverContext, callback) => {
				const obj = { ...request };
				if (resolverContext.log)
					resolverContext.log("reporting result " + obj.path);
				resolver.hooks.result.callAsync(obj, resolverContext, err => {
					if (err) return callback(err);
					callback(null, obj);
				});
			}
		);
	}
};

/** @typedef {import("./Resolver")} Resolver */
/** @typedef {import("./Resolver").ResolveStepHook} ResolveStepHook */

class RootsPlugin {
	/**
	 * @param {string | ResolveStepHook} source source hook
	 * @param {Set<string>} roots roots
	 * @param {string | ResolveStepHook} target target hook
	 */
	constructor(source, roots, target) {
		this.roots = Array.from(roots);
		this.source = source;
		this.target = target;
	}

	/**
	 * @param {Resolver} resolver the resolver
	 * @returns {void}
	 */
	apply(resolver) {
		const target = resolver.ensureHook(this.target);

		resolver
			.getHook(this.source)
			.tapAsync("RootsPlugin", (request, resolveContext, callback) => {
				const req = request.request;
				if (!req) return callback();
				if (!req.startsWith("/")) return callback();

				forEachBail(
					this.roots,
					(root, callback) => {
						const path = resolver.join(root, req.slice(1));
						const obj = {
							...request,
							path,
							relativePath: request.relativePath && path
						};
						resolver.doResolve(
							target,
							obj,
							`root path ${root}`,
							resolveContext,
							callback
						);
					},
					callback
				);
			});
	}
}

var RootsPlugin_1 = RootsPlugin;

/** @typedef {import("./Resolver")} Resolver */
/** @typedef {import("./Resolver").ResolveStepHook} ResolveStepHook */

const slashCode = "/".charCodeAt(0);

var SelfReferencePlugin_1 = class SelfReferencePlugin {
	/**
	 * @param {string | ResolveStepHook} source source
	 * @param {string | string[]} fieldNamePath name path
	 * @param {string | ResolveStepHook} target target
	 */
	constructor(source, fieldNamePath, target) {
		this.source = source;
		this.target = target;
		this.fieldName = fieldNamePath;
	}

	/**
	 * @param {Resolver} resolver the resolver
	 * @returns {void}
	 */
	apply(resolver) {
		const target = resolver.ensureHook(this.target);
		resolver
			.getHook(this.source)
			.tapAsync("SelfReferencePlugin", (request, resolveContext, callback) => {
				if (!request.descriptionFilePath) return callback();

				const req = request.request;
				if (!req) return callback();

				// Feature is only enabled when an exports field is present
				const exportsField = DescriptionFileUtils.getField(
					request.descriptionFileData,
					this.fieldName
				);
				if (!exportsField) return callback();

				const name = DescriptionFileUtils.getField(
					request.descriptionFileData,
					"name"
				);
				if (typeof name !== "string") return callback();

				if (
					req.startsWith(name) &&
					(req.length === name.length ||
						req.charCodeAt(name.length) === slashCode)
				) {
					const remainingRequest = `.${req.slice(name.length)}`;

					const obj = {
						...request,
						request: remainingRequest,
						path: /** @type {string} */ (request.descriptionFileRoot),
						relativePath: "."
					};

					resolver.doResolve(
						target,
						obj,
						"self reference",
						resolveContext,
						callback
					);
				} else {
					return callback();
				}
			});
	}
};

const { getType: getType$1, PathType: PathType$1 } = path_1;

/** @typedef {import("./Resolver")} Resolver */
/** @typedef {import("./Resolver").ResolveStepHook} ResolveStepHook */

var SymlinkPlugin_1 = class SymlinkPlugin {
	/**
	 * @param {string | ResolveStepHook} source source
	 * @param {string | ResolveStepHook} target target
	 */
	constructor(source, target) {
		this.source = source;
		this.target = target;
	}

	/**
	 * @param {Resolver} resolver the resolver
	 * @returns {void}
	 */
	apply(resolver) {
		const target = resolver.ensureHook(this.target);
		const fs = resolver.fileSystem;
		resolver
			.getHook(this.source)
			.tapAsync("SymlinkPlugin", (request, resolveContext, callback) => {
				if (request.ignoreSymlinks) return callback();
				const pathsResult = getPaths(request.path);
				const pathSeqments = pathsResult.seqments;
				const paths = pathsResult.paths;

				let containsSymlink = false;
				let idx = -1;
				forEachBail(
					paths,
					(path, callback) => {
						idx++;
						if (resolveContext.fileDependencies)
							resolveContext.fileDependencies.add(path);
						fs.readlink(path, (err, result) => {
							if (!err && result) {
								pathSeqments[idx] = result;
								containsSymlink = true;
								// Shortcut when absolute symlink found
								const resultType = getType$1(result.toString());
								if (
									resultType === PathType$1.AbsoluteWin ||
									resultType === PathType$1.AbsolutePosix
								) {
									return callback(null, idx);
								}
							}
							callback();
						});
					},
					(err, idx) => {
						if (!containsSymlink) return callback();
						const resultSeqments =
							typeof idx === "number"
								? pathSeqments.slice(0, idx + 1)
								: pathSeqments.slice();
						const result = resultSeqments.reduceRight((a, b) => {
							return resolver.join(a, b);
						});
						const obj = {
							...request,
							path: result
						};
						resolver.doResolve(
							target,
							obj,
							"resolved symlink to " + result,
							resolveContext,
							callback
						);
					}
				);
			});
	}
};

/*
	MIT License http://www.opensource.org/licenses/mit-license.php
	Author Tobias Koppers @sokra
*/

/** @typedef {import("./Resolver")} Resolver */
/** @typedef {import("./Resolver").ResolveStepHook} ResolveStepHook */

var TryNextPlugin_1 = class TryNextPlugin {
	/**
	 * @param {string | ResolveStepHook} source source
	 * @param {string} message message
	 * @param {string | ResolveStepHook} target target
	 */
	constructor(source, message, target) {
		this.source = source;
		this.message = message;
		this.target = target;
	}

	/**
	 * @param {Resolver} resolver the resolver
	 * @returns {void}
	 */
	apply(resolver) {
		const target = resolver.ensureHook(this.target);
		resolver
			.getHook(this.source)
			.tapAsync("TryNextPlugin", (request, resolveContext, callback) => {
				resolver.doResolve(
					target,
					request,
					this.message,
					resolveContext,
					callback
				);
			});
	}
};

/*
	MIT License http://www.opensource.org/licenses/mit-license.php
	Author Tobias Koppers @sokra
*/

/** @typedef {import("./Resolver")} Resolver */
/** @typedef {import("./Resolver").ResolveRequest} ResolveRequest */
/** @typedef {import("./Resolver").ResolveStepHook} ResolveStepHook */
/** @typedef {{[k: string]: any}} Cache */

function getCacheId(request, withContext) {
	return JSON.stringify({
		context: withContext ? request.context : "",
		path: request.path,
		query: request.query,
		fragment: request.fragment,
		request: request.request
	});
}

var UnsafeCachePlugin_1 = class UnsafeCachePlugin {
	/**
	 * @param {string | ResolveStepHook} source source
	 * @param {function(ResolveRequest): boolean} filterPredicate filterPredicate
	 * @param {Cache} cache cache
	 * @param {boolean} withContext withContext
	 * @param {string | ResolveStepHook} target target
	 */
	constructor(source, filterPredicate, cache, withContext, target) {
		this.source = source;
		this.filterPredicate = filterPredicate;
		this.withContext = withContext;
		this.cache = cache;
		this.target = target;
	}

	/**
	 * @param {Resolver} resolver the resolver
	 * @returns {void}
	 */
	apply(resolver) {
		const target = resolver.ensureHook(this.target);
		resolver
			.getHook(this.source)
			.tapAsync("UnsafeCachePlugin", (request, resolveContext, callback) => {
				if (!this.filterPredicate(request)) return callback();
				const cacheId = getCacheId(request, this.withContext);
				const cacheEntry = this.cache[cacheId];
				if (cacheEntry) {
					return callback(null, cacheEntry);
				}
				resolver.doResolve(
					target,
					request,
					null,
					resolveContext,
					(err, result) => {
						if (err) return callback(err);
						if (result) return callback(null, (this.cache[cacheId] = result));
						callback();
					}
				);
			});
	}
};

/*
	MIT License http://www.opensource.org/licenses/mit-license.php
	Author Tobias Koppers @sokra
*/

/** @typedef {import("./Resolver")} Resolver */
/** @typedef {import("./Resolver").ResolveStepHook} ResolveStepHook */

var UseFilePlugin_1 = class UseFilePlugin {
	/**
	 * @param {string | ResolveStepHook} source source
	 * @param {string} filename filename
	 * @param {string | ResolveStepHook} target target
	 */
	constructor(source, filename, target) {
		this.source = source;
		this.filename = filename;
		this.target = target;
	}

	/**
	 * @param {Resolver} resolver the resolver
	 * @returns {void}
	 */
	apply(resolver) {
		const target = resolver.ensureHook(this.target);
		resolver
			.getHook(this.source)
			.tapAsync("UseFilePlugin", (request, resolveContext, callback) => {
				const filePath = resolver.join(request.path, this.filename);
				const obj = {
					...request,
					path: filePath,
					relativePath:
						request.relativePath &&
						resolver.join(request.relativePath, this.filename)
				};
				resolver.doResolve(
					target,
					obj,
					"using path: " + filePath,
					resolveContext,
					callback
				);
			});
	}
};

var pnpapi = /*#__PURE__*/Object.freeze({
	__proto__: null
});

var require$$2 = /*@__PURE__*/getAugmentedNamespace(pnpapi);

const versions = require$$0__default$1["default"].versions;

const { getType, PathType } = path_1;





























/** @typedef {import("./AliasPlugin").AliasOption} AliasOptionEntry */
/** @typedef {import("./PnpPlugin").PnpApiImpl} PnpApi */
/** @typedef {import("./Resolver").FileSystem} FileSystem */
/** @typedef {import("./Resolver").ResolveRequest} ResolveRequest */
/** @typedef {import("./Resolver").SyncFileSystem} SyncFileSystem */

/** @typedef {string|string[]|false} AliasOptionNewRequest */
/** @typedef {{[k: string]: AliasOptionNewRequest}} AliasOptions */
/** @typedef {{apply: function(Resolver): void} | function(this: Resolver, Resolver): void} Plugin */

/**
 * @typedef {Object} UserResolveOptions
 * @property {(AliasOptions | AliasOptionEntry[])=} alias A list of module alias configurations or an object which maps key to value
 * @property {(AliasOptions | AliasOptionEntry[])=} fallback A list of module alias configurations or an object which maps key to value, applied only after modules option
 * @property {(string | string[])[]=} aliasFields A list of alias fields in description files
 * @property {(function(ResolveRequest): boolean)=} cachePredicate A function which decides whether a request should be cached or not. An object is passed with at least `path` and `request` properties.
 * @property {boolean=} cacheWithContext Whether or not the unsafeCache should include request context as part of the cache key.
 * @property {string[]=} descriptionFiles A list of description files to read from
 * @property {string[]=} conditionNames A list of exports field condition names.
 * @property {boolean=} enforceExtension Enforce that a extension from extensions must be used
 * @property {(string | string[])[]=} exportsFields A list of exports fields in description files
 * @property {(string | string[])[]=} importsFields A list of imports fields in description files
 * @property {string[]=} extensions A list of extensions which should be tried for files
 * @property {FileSystem} fileSystem The file system which should be used
 * @property {(object | boolean)=} unsafeCache Use this cache object to unsafely cache the successful requests
 * @property {boolean=} symlinks Resolve symlinks to their symlinked location
 * @property {Resolver=} resolver A prepared Resolver to which the plugins are attached
 * @property {string[] | string=} modules A list of directories to resolve modules from, can be absolute path or folder name
 * @property {(string | string[] | {name: string | string[], forceRelative: boolean})[]=} mainFields A list of main fields in description files
 * @property {string[]=} mainFiles  A list of main files in directories
 * @property {Plugin[]=} plugins A list of additional resolve plugins which should be applied
 * @property {PnpApi | null=} pnpApi A PnP API that should be used - null is "never", undefined is "auto"
 * @property {string[]=} roots A list of root paths
 * @property {boolean=} fullySpecified The request is already fully specified and no extensions or directories are resolved for it
 * @property {boolean=} resolveToContext Resolve to a context instead of a file
 * @property {(string|RegExp)[]=} restrictions A list of resolve restrictions
 * @property {boolean=} useSyncFileSystemCalls Use only the sync constiants of the file system calls
 * @property {boolean=} preferRelative Prefer to resolve module requests as relative requests before falling back to modules
 * @property {boolean=} preferAbsolute Prefer to resolve server-relative urls as absolute paths before falling back to resolve in roots
 */

/**
 * @typedef {Object} ResolveOptions
 * @property {AliasOptionEntry[]} alias
 * @property {AliasOptionEntry[]} fallback
 * @property {Set<string | string[]>} aliasFields
 * @property {(function(ResolveRequest): boolean)} cachePredicate
 * @property {boolean} cacheWithContext
 * @property {Set<string>} conditionNames A list of exports field condition names.
 * @property {string[]} descriptionFiles
 * @property {boolean} enforceExtension
 * @property {Set<string | string[]>} exportsFields
 * @property {Set<string | string[]>} importsFields
 * @property {Set<string>} extensions
 * @property {FileSystem} fileSystem
 * @property {object | false} unsafeCache
 * @property {boolean} symlinks
 * @property {Resolver=} resolver
 * @property {Array<string | string[]>} modules
 * @property {{name: string[], forceRelative: boolean}[]} mainFields
 * @property {Set<string>} mainFiles
 * @property {Plugin[]} plugins
 * @property {PnpApi | null} pnpApi
 * @property {Set<string>} roots
 * @property {boolean} fullySpecified
 * @property {boolean} resolveToContext
 * @property {Set<string|RegExp>} restrictions
 * @property {boolean} preferRelative
 * @property {boolean} preferAbsolute
 */

/**
 * @param {PnpApi | null=} option option
 * @returns {PnpApi | null} processed option
 */
function processPnpApiOption(option) {
	if (
		option === undefined &&
		/** @type {NodeJS.ProcessVersions & {pnp: string}} */ versions.pnp
	) {
		// @ts-ignore
		return require$$2; // eslint-disable-line node/no-missing-require
	}

	return option || null;
}

/**
 * @param {AliasOptions | AliasOptionEntry[] | undefined} alias alias
 * @returns {AliasOptionEntry[]} normalized aliases
 */
function normalizeAlias(alias) {
	return typeof alias === "object" && !Array.isArray(alias) && alias !== null
		? Object.keys(alias).map(key => {
				/** @type {AliasOptionEntry} */
				const obj = { name: key, onlyModule: false, alias: alias[key] };

				if (/\$$/.test(key)) {
					obj.onlyModule = true;
					obj.name = key.substr(0, key.length - 1);
				}

				return obj;
		  })
		: /** @type {Array<AliasOptionEntry>} */ (alias) || [];
}

/**
 * @param {UserResolveOptions} options input options
 * @returns {ResolveOptions} output options
 */
function createOptions(options) {
	const mainFieldsSet = new Set(options.mainFields || ["main"]);
	const mainFields = [];

	for (const item of mainFieldsSet) {
		if (typeof item === "string") {
			mainFields.push({
				name: [item],
				forceRelative: true
			});
		} else if (Array.isArray(item)) {
			mainFields.push({
				name: item,
				forceRelative: true
			});
		} else {
			mainFields.push({
				name: Array.isArray(item.name) ? item.name : [item.name],
				forceRelative: item.forceRelative
			});
		}
	}

	return {
		alias: normalizeAlias(options.alias),
		fallback: normalizeAlias(options.fallback),
		aliasFields: new Set(options.aliasFields),
		cachePredicate:
			options.cachePredicate ||
			function () {
				return true;
			},
		cacheWithContext:
			typeof options.cacheWithContext !== "undefined"
				? options.cacheWithContext
				: true,
		exportsFields: new Set(options.exportsFields || ["exports"]),
		importsFields: new Set(options.importsFields || ["imports"]),
		conditionNames: new Set(options.conditionNames),
		descriptionFiles: Array.from(
			new Set(options.descriptionFiles || ["package.json"])
		),
		enforceExtension:
			options.enforceExtension === undefined
				? options.extensions && options.extensions.includes("")
					? true
					: false
				: options.enforceExtension,
		extensions: new Set(options.extensions || [".js", ".json", ".node"]),
		fileSystem: options.useSyncFileSystemCalls
			? new SyncAsyncFileSystemDecorator_1(
					/** @type {SyncFileSystem} */ (
						/** @type {unknown} */ (options.fileSystem)
					)
			  )
			: options.fileSystem,
		unsafeCache:
			options.unsafeCache && typeof options.unsafeCache !== "object"
				? {}
				: options.unsafeCache || false,
		symlinks: typeof options.symlinks !== "undefined" ? options.symlinks : true,
		resolver: options.resolver,
		modules: mergeFilteredToArray(
			Array.isArray(options.modules)
				? options.modules
				: options.modules
				? [options.modules]
				: ["node_modules"],
			item => {
				const type = getType(item);
				return type === PathType.Normal || type === PathType.Relative;
			}
		),
		mainFields,
		mainFiles: new Set(options.mainFiles || ["index"]),
		plugins: options.plugins || [],
		pnpApi: processPnpApiOption(options.pnpApi),
		roots: new Set(options.roots || undefined),
		fullySpecified: options.fullySpecified || false,
		resolveToContext: options.resolveToContext || false,
		preferRelative: options.preferRelative || false,
		preferAbsolute: options.preferAbsolute || false,
		restrictions: new Set(options.restrictions)
	};
}

/**
 * @param {UserResolveOptions} options resolve options
 * @returns {Resolver} created resolver
 */
var createResolver = function (options) {
	const normalizedOptions = createOptions(options);

	const {
		alias,
		fallback,
		aliasFields,
		cachePredicate,
		cacheWithContext,
		conditionNames,
		descriptionFiles,
		enforceExtension,
		exportsFields,
		importsFields,
		extensions,
		fileSystem,
		fullySpecified,
		mainFields,
		mainFiles,
		modules,
		plugins: userPlugins,
		pnpApi,
		resolveToContext,
		preferRelative,
		preferAbsolute,
		symlinks,
		unsafeCache,
		resolver: customResolver,
		restrictions,
		roots
	} = normalizedOptions;

	const plugins = userPlugins.slice();

	const resolver = customResolver
		? customResolver
		: new Resolver_1(fileSystem, normalizedOptions);

	//// pipeline ////

	resolver.ensureHook("resolve");
	resolver.ensureHook("internalResolve");
	resolver.ensureHook("newInteralResolve");
	resolver.ensureHook("parsedResolve");
	resolver.ensureHook("describedResolve");
	resolver.ensureHook("internal");
	resolver.ensureHook("rawModule");
	resolver.ensureHook("module");
	resolver.ensureHook("resolveAsModule");
	resolver.ensureHook("undescribedResolveInPackage");
	resolver.ensureHook("resolveInPackage");
	resolver.ensureHook("resolveInExistingDirectory");
	resolver.ensureHook("relative");
	resolver.ensureHook("describedRelative");
	resolver.ensureHook("directory");
	resolver.ensureHook("undescribedExistingDirectory");
	resolver.ensureHook("existingDirectory");
	resolver.ensureHook("undescribedRawFile");
	resolver.ensureHook("rawFile");
	resolver.ensureHook("file");
	resolver.ensureHook("finalFile");
	resolver.ensureHook("existingFile");
	resolver.ensureHook("resolved");

	// resolve
	for (const { source, resolveOptions } of [
		{ source: "resolve", resolveOptions: { fullySpecified } },
		{ source: "internal-resolve", resolveOptions: { fullySpecified: false } }
	]) {
		if (unsafeCache) {
			plugins.push(
				new UnsafeCachePlugin_1(
					source,
					cachePredicate,
					unsafeCache,
					cacheWithContext,
					`new-${source}`
				)
			);
			plugins.push(
				new ParsePlugin_1(`new-${source}`, resolveOptions, "parsed-resolve")
			);
		} else {
			plugins.push(new ParsePlugin_1(source, resolveOptions, "parsed-resolve"));
		}
	}

	// parsed-resolve
	plugins.push(
		new DescriptionFilePlugin_1(
			"parsed-resolve",
			descriptionFiles,
			false,
			"described-resolve"
		)
	);
	plugins.push(new NextPlugin_1("after-parsed-resolve", "described-resolve"));

	// described-resolve
	plugins.push(new NextPlugin_1("described-resolve", "normal-resolve"));
	if (fallback.length > 0) {
		plugins.push(
			new AliasPlugin_1("described-resolve", fallback, "internal-resolve")
		);
	}

	// normal-resolve
	if (alias.length > 0)
		plugins.push(new AliasPlugin_1("normal-resolve", alias, "internal-resolve"));
	aliasFields.forEach(item => {
		plugins.push(
			new AliasFieldPlugin_1("normal-resolve", item, "internal-resolve")
		);
	});
	if (preferRelative) {
		plugins.push(new JoinRequestPlugin_1("after-normal-resolve", "relative"));
	}
	plugins.push(
		new ConditionalPlugin_1(
			"after-normal-resolve",
			{ module: true },
			"resolve as module",
			false,
			"raw-module"
		)
	);
	plugins.push(
		new ConditionalPlugin_1(
			"after-normal-resolve",
			{ internal: true },
			"resolve as internal import",
			false,
			"internal"
		)
	);
	if (preferAbsolute) {
		plugins.push(new JoinRequestPlugin_1("after-normal-resolve", "relative"));
	}
	if (roots.size > 0) {
		plugins.push(new RootsPlugin_1("after-normal-resolve", roots, "relative"));
	}
	if (!preferRelative && !preferAbsolute) {
		plugins.push(new JoinRequestPlugin_1("after-normal-resolve", "relative"));
	}

	// internal
	importsFields.forEach(importsField => {
		plugins.push(
			new ImportsFieldPlugin_1(
				"internal",
				conditionNames,
				importsField,
				"relative",
				"internal-resolve"
			)
		);
	});

	// raw-module
	exportsFields.forEach(exportsField => {
		plugins.push(
			new SelfReferencePlugin_1("raw-module", exportsField, "resolve-as-module")
		);
	});
	modules.forEach(item => {
		if (Array.isArray(item)) {
			if (item.includes("node_modules") && pnpApi) {
				plugins.push(
					new ModulesInHierachicDirectoriesPlugin_1(
						"raw-module",
						item.filter(i => i !== "node_modules"),
						"module"
					)
				);
				plugins.push(
					new PnpPlugin_1("raw-module", pnpApi, "undescribed-resolve-in-package")
				);
			} else {
				plugins.push(
					new ModulesInHierachicDirectoriesPlugin_1("raw-module", item, "module")
				);
			}
		} else {
			plugins.push(new ModulesInRootPlugin_1("raw-module", item, "module"));
		}
	});

	// module
	plugins.push(new JoinRequestPartPlugin_1("module", "resolve-as-module"));

	// resolve-as-module
	if (!resolveToContext) {
		plugins.push(
			new ConditionalPlugin_1(
				"resolve-as-module",
				{ directory: false, request: "." },
				"single file module",
				true,
				"undescribed-raw-file"
			)
		);
	}
	plugins.push(
		new DirectoryExistsPlugin_1(
			"resolve-as-module",
			"undescribed-resolve-in-package"
		)
	);

	// undescribed-resolve-in-package
	plugins.push(
		new DescriptionFilePlugin_1(
			"undescribed-resolve-in-package",
			descriptionFiles,
			false,
			"resolve-in-package"
		)
	);
	plugins.push(
		new NextPlugin_1("after-undescribed-resolve-in-package", "resolve-in-package")
	);

	// resolve-in-package
	exportsFields.forEach(exportsField => {
		plugins.push(
			new ExportsFieldPlugin_1(
				"resolve-in-package",
				conditionNames,
				exportsField,
				"relative"
			)
		);
	});
	plugins.push(
		new NextPlugin_1("resolve-in-package", "resolve-in-existing-directory")
	);

	// resolve-in-existing-directory
	plugins.push(
		new JoinRequestPlugin_1("resolve-in-existing-directory", "relative")
	);

	// relative
	plugins.push(
		new DescriptionFilePlugin_1(
			"relative",
			descriptionFiles,
			true,
			"described-relative"
		)
	);
	plugins.push(new NextPlugin_1("after-relative", "described-relative"));

	// described-relative
	if (resolveToContext) {
		plugins.push(new NextPlugin_1("described-relative", "directory"));
	} else {
		plugins.push(
			new ConditionalPlugin_1(
				"described-relative",
				{ directory: false },
				null,
				true,
				"raw-file"
			)
		);
		plugins.push(
			new ConditionalPlugin_1(
				"described-relative",
				{ fullySpecified: false },
				"as directory",
				true,
				"directory"
			)
		);
	}

	// directory
	plugins.push(
		new DirectoryExistsPlugin_1("directory", "undescribed-existing-directory")
	);

	if (resolveToContext) {
		// undescribed-existing-directory
		plugins.push(new NextPlugin_1("undescribed-existing-directory", "resolved"));
	} else {
		// undescribed-existing-directory
		plugins.push(
			new DescriptionFilePlugin_1(
				"undescribed-existing-directory",
				descriptionFiles,
				false,
				"existing-directory"
			)
		);
		mainFiles.forEach(item => {
			plugins.push(
				new UseFilePlugin_1(
					"undescribed-existing-directory",
					item,
					"undescribed-raw-file"
				)
			);
		});

		// described-existing-directory
		mainFields.forEach(item => {
			plugins.push(
				new MainFieldPlugin_1(
					"existing-directory",
					item,
					"resolve-in-existing-directory"
				)
			);
		});
		mainFiles.forEach(item => {
			plugins.push(
				new UseFilePlugin_1("existing-directory", item, "undescribed-raw-file")
			);
		});

		// undescribed-raw-file
		plugins.push(
			new DescriptionFilePlugin_1(
				"undescribed-raw-file",
				descriptionFiles,
				true,
				"raw-file"
			)
		);
		plugins.push(new NextPlugin_1("after-undescribed-raw-file", "raw-file"));

		// raw-file
		plugins.push(
			new ConditionalPlugin_1(
				"raw-file",
				{ fullySpecified: true },
				null,
				false,
				"file"
			)
		);
		if (!enforceExtension) {
			plugins.push(new TryNextPlugin_1("raw-file", "no extension", "file"));
		}
		extensions.forEach(item => {
			plugins.push(new AppendPlugin_1("raw-file", item, "file"));
		});

		// file
		if (alias.length > 0)
			plugins.push(new AliasPlugin_1("file", alias, "internal-resolve"));
		aliasFields.forEach(item => {
			plugins.push(new AliasFieldPlugin_1("file", item, "internal-resolve"));
		});
		plugins.push(new NextPlugin_1("file", "final-file"));

		// final-file
		plugins.push(new FileExistsPlugin_1("final-file", "existing-file"));

		// existing-file
		if (symlinks)
			plugins.push(new SymlinkPlugin_1("existing-file", "existing-file"));
		plugins.push(new NextPlugin_1("existing-file", "resolved"));
	}

	// resolved
	if (restrictions.size > 0) {
		plugins.push(new RestrictionsPlugin_1(resolver.hooks.resolved, restrictions));
	}
	plugins.push(new ResultPlugin_1(resolver.hooks.resolved));

	//// RESOLVER ////

	for (const plugin of plugins) {
		if (typeof plugin === "function") {
			plugin.call(resolver, resolver);
		} else {
			plugin.apply(resolver);
		}
	}

	return resolver;
};

/**
 * Merging filtered elements
 * @param {string[]} array source array
 * @param {function(string): boolean} filter predicate
 * @returns {Array<string | string[]>} merge result
 */
function mergeFilteredToArray(array, filter) {
	/** @type {Array<string | string[]>} */
	const result = [];
	const set = new Set(array);

	for (const item of set) {
		if (filter(item)) {
			const lastElement =
				result.length > 0 ? result[result.length - 1] : undefined;
			if (Array.isArray(lastElement)) {
				lastElement.push(item);
			} else {
				result.push([item]);
			}
		} else {
			result.push(item);
		}
	}

	return result;
}

var ResolverFactory = {
	createResolver: createResolver
};

const basename = getPaths.basename;

/** @typedef {import("./Resolver")} Resolver */

var CloneBasenamePlugin_1 = class CloneBasenamePlugin {
	constructor(source, target) {
		this.source = source;
		this.target = target;
	}

	/**
	 * @param {Resolver} resolver the resolver
	 * @returns {void}
	 */
	apply(resolver) {
		const target = resolver.ensureHook(this.target);
		resolver
			.getHook(this.source)
			.tapAsync("CloneBasenamePlugin", (request, resolveContext, callback) => {
				const filename = basename(request.path);
				const filePath = resolver.join(request.path, filename);
				const obj = {
					...request,
					path: filePath,
					relativePath:
						request.relativePath &&
						resolver.join(request.relativePath, filename)
				};
				resolver.doResolve(
					target,
					obj,
					"using path: " + filePath,
					resolveContext,
					callback
				);
			});
	}
};

/*
	MIT License http://www.opensource.org/licenses/mit-license.php
	Author Tobias Koppers @sokra
*/

/** @typedef {import("./Resolver")} Resolver */

var LogInfoPlugin_1 = class LogInfoPlugin {
	constructor(source) {
		this.source = source;
	}

	/**
	 * @param {Resolver} resolver the resolver
	 * @returns {void}
	 */
	apply(resolver) {
		const source = this.source;
		resolver
			.getHook(this.source)
			.tapAsync("LogInfoPlugin", (request, resolveContext, callback) => {
				if (!resolveContext.log) return callback();
				const log = resolveContext.log;
				const prefix = "[" + source + "] ";
				if (request.path)
					log(prefix + "Resolving in directory: " + request.path);
				if (request.request)
					log(prefix + "Resolving request: " + request.request);
				if (request.module) log(prefix + "Request is an module request.");
				if (request.directory) log(prefix + "Request is a directory request.");
				if (request.query)
					log(prefix + "Resolving request query: " + request.query);
				if (request.fragment)
					log(prefix + "Resolving request fragment: " + request.fragment);
				if (request.descriptionFilePath)
					log(
						prefix + "Has description data from " + request.descriptionFilePath
					);
				if (request.relativePath)
					log(
						prefix +
							"Relative path from description file is: " +
							request.relativePath
					);
				callback();
			});
	}
};

/** @typedef {import("./PnpPlugin").PnpApiImpl} PnpApi */
/** @typedef {import("./Resolver")} Resolver */
/** @typedef {import("./Resolver").FileSystem} FileSystem */
/** @typedef {import("./Resolver").ResolveContext} ResolveContext */
/** @typedef {import("./Resolver").ResolveRequest} ResolveRequest */
/** @typedef {import("./ResolverFactory").Plugin} Plugin */
/** @typedef {import("./ResolverFactory").UserResolveOptions} ResolveOptions */

const nodeFileSystem = new CachedInputFileSystem_1(gracefulFs, 4000);

const nodeContext = {
	environments: ["node+es3+es5+process+native"]
};

const asyncResolver = ResolverFactory.createResolver({
	conditionNames: ["node"],
	extensions: [".js", ".json", ".node"],
	fileSystem: nodeFileSystem
});
function resolve(context, path, request, resolveContext, callback) {
	if (typeof context === "string") {
		callback = resolveContext;
		resolveContext = request;
		request = path;
		path = context;
		context = nodeContext;
	}
	if (typeof callback !== "function") {
		callback = resolveContext;
	}
	asyncResolver.resolve(context, path, request, resolveContext, callback);
}

const syncResolver = ResolverFactory.createResolver({
	conditionNames: ["node"],
	extensions: [".js", ".json", ".node"],
	useSyncFileSystemCalls: true,
	fileSystem: nodeFileSystem
});
function resolveSync(context, path, request) {
	if (typeof context === "string") {
		request = path;
		path = context;
		context = nodeContext;
	}
	return syncResolver.resolveSync(context, path, request);
}

function create(options) {
	options = {
		fileSystem: nodeFileSystem,
		...options
	};
	const resolver = ResolverFactory.createResolver(options);
	return function (context, path, request, resolveContext, callback) {
		if (typeof context === "string") {
			callback = resolveContext;
			resolveContext = request;
			request = path;
			path = context;
			context = nodeContext;
		}
		if (typeof callback !== "function") {
			callback = resolveContext;
		}
		resolver.resolve(context, path, request, resolveContext, callback);
	};
}

function createSync(options) {
	options = {
		useSyncFileSystemCalls: true,
		fileSystem: nodeFileSystem,
		...options
	};
	const resolver = ResolverFactory.createResolver(options);
	return function (context, path, request) {
		if (typeof context === "string") {
			request = path;
			path = context;
			context = nodeContext;
		}
		return resolver.resolveSync(context, path, request);
	};
}

/**
 * @template A
 * @template B
 * @param {A} obj input a
 * @param {B} exports input b
 * @returns {A & B} merged
 */
const mergeExports = (obj, exports) => {
	const descriptors = Object.getOwnPropertyDescriptors(exports);
	Object.defineProperties(obj, descriptors);
	return /** @type {A & B} */ (Object.freeze(obj));
};

var lib = mergeExports(resolve, {
	get sync() {
		return resolveSync;
	},
	create: mergeExports(create, {
		get sync() {
			return createSync;
		}
	}),
	ResolverFactory,
	CachedInputFileSystem: CachedInputFileSystem_1,
	get CloneBasenamePlugin() {
		return CloneBasenamePlugin_1;
	},
	get LogInfoPlugin() {
		return LogInfoPlugin_1;
	},
	get forEachBail() {
		return forEachBail;
	}
});

var module$1 = createCommonjsModule(function (module, exports) {
Object.defineProperty(exports, "__esModule", { value: true });
exports.patchModule = exports.load = void 0;

const module_1 = tslib_1.__importDefault(require$$0__default$2["default"]);
function load(resolve, delegate) {
    const resolver = resolve.create.sync({ conditionNames: ["require", "node"] });
    return function (request, parent) {
        if (module_1.default.builtinModules.includes(request) ||
            (parent && parent.path === "internal")) {
            return delegate.apply(this, arguments);
        }
        else {
            return resolver(parent ? parent.path : "/", request);
        }
    };
}
exports.load = load;
function patchModule(resolve, delegate) {
    delegate.Module._resolveFilename = load(resolve, delegate.Module._resolveFilename);
}
exports.patchModule = patchModule;

});

createCommonjsModule(function (module, exports) {
Object.defineProperty(exports, "__esModule", { value: true });

const enhancedResolve = tslib_1.__importStar(lib);

module$1.patchModule(enhancedResolve, require$$0__default$2["default"]);

});

var __rules_nodejs_shim_root = createCommonjsModule(function (module, exports) {
Object.defineProperty(exports, "__esModule", { value: true });




});

var index = /*@__PURE__*/getDefaultExportFromCjs(__rules_nodejs_shim_root);

module.exports = index;
