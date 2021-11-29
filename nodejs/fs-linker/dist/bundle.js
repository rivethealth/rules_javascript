'use strict';

var fs = require('fs');
var url = require('url');
var path = require('path');

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

var fs__namespace = /*#__PURE__*/_interopNamespace(fs);
var path__namespace = /*#__PURE__*/_interopNamespace(path);

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
    function set(format) {
        return new SetJsonFormat(format);
    }
    JsonFormat.set = set;
    function string() {
        return new StringJsonFormat();
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
class SetJsonFormat {
    constructor(format) {
        this.format = format;
    }
    fromJson(json) {
        return new Set(json.map(element => this.format.fromJson(element)));
    }
    toJson(value) {
        return [...value].map(element => this.format.toJson(element));
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

class Package {
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
})(PackageTree || (PackageTree = {}));

var VfsNode;
(function (VfsNode) {
    VfsNode.PATH = Symbol('PATH');
    VfsNode.SYMLINK = Symbol('SYMLINK');
})(VfsNode || (VfsNode = {}));
class Vfs {
    constructor(root) {
        this.root = root;
    }
    entry(path) {
        loop: while (true) {
            if (!path.startsWith('/')) {
                throw new Error('Path must be absolute');
            }
            const parts = path.split('/').slice(1);
            let node = this.root;
            let i;
            for (i = 0; i < parts.length; i++) {
                if (node.type === VfsNode.SYMLINK) {
                    path = [node.path, ...parts.slice(i)].join('/');
                    continue loop;
                }
                const newNode = node.extraChildren.get(parts[i]);
                if (!newNode) {
                    break;
                }
                node = newNode;
            }
            if (i < parts.length) {
                if (node.path === undefined) {
                    return undefined;
                }
                return { type: VfsNode.PATH, extraChildren: new Map(), hardenSymlinks: node.hardenSymlinks, path: [node.path, ...parts.slice(i)].join('/') };
            }
            return node;
        }
    }
    realpath(path) {
        loop: while (true) {
            if (!path.startsWith('/')) {
                throw new Error('Path must be absolute');
            }
            const parts = path.split('/').slice(1);
            let node = this.root;
            let i;
            for (i = 0; i < parts.length; i++) {
                if (node.type === VfsNode.SYMLINK) {
                    path = [node.path, ...parts.slice(i)].join('/');
                    continue loop;
                }
                const newNode = node.extraChildren.get(parts[i]);
                if (!newNode) {
                    break;
                }
                node = newNode;
            }
            if (node.type === VfsNode.SYMLINK) {
                path = [node.path, ...parts.slice(i)].join('/');
                continue loop;
            }
            if (i < parts.length) {
                if (node.path === undefined) {
                    return undefined;
                }
                return { hardenSymlinks: node.hardenSymlinks, path: [node.path, ...parts.slice(i)].join('/') };
            }
            return { hardenSymlinks: node.hardenSymlinks, path: '/' + parts.join('/') };
        }
    }
    /**
     * Return node representing file path
     */
    resolve(path) {
        loop: while (true) {
            if (!path.startsWith('/')) {
                throw new Error('Path must be absolute');
            }
            const parts = path.split('/').slice(1);
            let node = this.root;
            let i;
            for (i = 0; i < parts.length; i++) {
                if (node.type === VfsNode.SYMLINK) {
                    path = [node.path, ...parts.slice(i)].join('/');
                    continue loop;
                }
                const newNode = node.extraChildren.get(parts[i]);
                if (!newNode) {
                    break;
                }
                node = newNode;
            }
            if (node.type === VfsNode.SYMLINK) {
                path = [node.path, ...parts.slice(i)].join('/');
                continue loop;
            }
            if (i < parts.length) {
                if (node.path === undefined) {
                    return undefined;
                }
                return { type: VfsNode.PATH, extraChildren: new Map(), hardenSymlinks: node.hardenSymlinks, path: [node.path, ...parts.slice(i)].join('/') };
            }
            return node;
        }
    }
    print() {
        return (function print(name, node, prefix) {
            switch (node.type) {
                case VfsNode.PATH:
                    let result;
                    if (node.path) {
                        result = `${prefix}${name}/ (${node.path})\n`;
                    }
                    else {
                        result = `${prefix}${name}/\n`;
                    }
                    for (const [name, child] of node.extraChildren.entries()) {
                        result += print(name, child, prefix + '  ');
                    }
                    return result;
                case VfsNode.SYMLINK:
                    return `${prefix}${name} -> ${node.path}\n`;
            }
        })('', this.root, '');
    }
}

/**
 * @filedescription Node.js fs implementation of Vfs
 */
const { fs: fsConstants } = process.binding("fs");
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
        return this.entry.type === VfsNode.PATH;
    }
    isBlockDevice() {
        return false;
    }
    isCharacterDevice() {
        return false;
    }
    isSymbolicLink() {
        return this.entry.type === VfsNode.PATH;
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
        return this.entry.type === VfsNode.PATH;
    }
    isBlockDevice() {
        return false;
    }
    isCharacterDevice() {
        return false;
    }
    isSymbolicLink() {
        return this.entry.type === VfsNode.SYMLINK;
    }
    isFIFO() {
        return false;
    }
    isSocket() {
        return false;
    }
}
class VfsDir {
    constructor(dir, delegate) {
        this.dir = dir;
        this.delegate = delegate;
        this.extraIterator = undefined;
    }
    [Symbol.asyncIterator]() {
        return {
            next: async () => {
                const value = await this.read();
                return { done: value === null, value };
            },
            [Symbol.asyncIterator]() {
                return this;
            },
        };
    }
    close(cb) {
        if (this.delegate !== undefined) {
            return this.delegate.close.apply(this.delegate, arguments);
        }
        if (cb) {
            setImmediate(() => cb(undefined));
        }
        else {
            return Promise.resolve();
        }
    }
    closeSync() {
        if (this.delegate !== undefined) {
            return this.delegate.closeSync.apply(this.delegate, arguments);
        }
    }
    read(cb) {
        if (cb) {
            if (this.delegate !== undefined && this.extraIterator === undefined) {
                this.delegate.read((err, dirEnt) => {
                    if (err !== null || dirEnt !== null) {
                        cb(err, dirEnt);
                    }
                    this.extraIterator = this.dir.extraChildren.entries();
                    const entry = this.extraIterator.next();
                    if (entry.done) {
                        cb(null, null);
                    }
                    else {
                        cb(null, dirent(entry.value[0], entry.value[1]));
                    }
                });
            }
            else {
                if (this.extraIterator === undefined) {
                    this.extraIterator = this.dir.extraChildren.entries();
                }
                const entry = this.extraIterator.next();
                if (entry.done) {
                    setImmediate(() => cb(null, null));
                }
                else {
                    setImmediate(() => cb(null, dirent(entry.value[0], entry.value[1])));
                }
            }
            return;
        }
        return (async () => {
            if (this.delegate !== undefined && this.extraIterator === undefined) {
                const result = await this.delegate.read.apply(this.delegate, arguments);
                if (result !== null) {
                    return result;
                }
            }
            if (this.extraIterator === undefined) {
                this.extraIterator = this.dir.extraChildren.entries();
            }
            const entry = this.extraIterator.next();
            if (entry.done) {
                return null;
            }
            return dirent(entry.value[0], entry.value[1]);
        })();
    }
    readSync() {
        if (this.delegate !== undefined && this.extraIterator === undefined) {
            const result = this.delegate.readSync.apply(this.delegate, arguments);
            if (result !== null) {
                return result;
            }
        }
        if (this.extraIterator === undefined) {
            this.extraIterator = this.dir.extraChildren.entries();
        }
        const entry = this.extraIterator.next();
        if (entry.done) {
            return null;
        }
        return dirent(entry.value[0], entry.value[1]);
    }
}
function dirent(name, entry) {
    switch (entry.type) {
        case VfsNode.PATH:
            return new fs__namespace.Dirent(name, fsConstants.UV_DIRENT_DIR);
        case VfsNode.SYMLINK:
            return new fs__namespace.Dirent(name, fsConstants.UV_DIRENT_LINK);
    }
}
function stringPath(value) {
    if (value instanceof Buffer) {
        value = value.toString();
    }
    if (value instanceof url.URL) {
        if (value.protocol !== "file:") {
            throw new Error(`Invalid protocol: ${value.protocol}`);
        }
        value = url.fileURLToPath(value);
    }
    return path__namespace.resolve(value);
}
function replaceArguments(vfs, fn, indicies) {
    return function () {
        const args = [...arguments];
        for (const index of indicies) {
            const path = stringPath(args[index]);
            const resolved = vfs.resolve(path);
            if (resolved.path !== undefined && path !== resolved.path) {
                args[index] = resolved.path;
            }
        }
        return fn.apply(this, args);
    };
}
function access$1(vfs, delegate) {
    return replaceArguments(vfs, delegate, [0]);
}
function accessSync(vfs, delegate) {
    return replaceArguments(vfs, delegate, [0]);
}
function appendFile$1(vfs, delegate) {
    return replaceArguments(vfs, delegate, [0]);
}
function appendFileSync(vfs, delegate) {
    return replaceArguments(vfs, delegate, [0]);
}
function chmod$1(vfs, delegate) {
    return replaceArguments(vfs, delegate, [0]);
}
function chmodSync(vfs, delegate) {
    return replaceArguments(vfs, delegate, [0]);
}
function chown$1(vfs, delegate) {
    return replaceArguments(vfs, delegate, [0]);
}
function chownSync(vfs, delegate) {
    return replaceArguments(vfs, delegate, [0]);
}
function copyFile$1(vfs, delegate) {
    return replaceArguments(vfs, delegate, [0, 1]);
}
function copyFileSync(vfs, delegate) {
    return replaceArguments(vfs, delegate, [0, 1]);
}
function createReadStream(vfs, delegate) {
    return replaceArguments(vfs, delegate, [0]);
}
function createWriteStream(vfs, delegate) {
    return replaceArguments(vfs, delegate, [0]);
}
function exists(vfs, delegate) {
    return replaceArguments(vfs, delegate, [0]);
}
function existsSync(vfs, delegate) {
    return replaceArguments(vfs, delegate, [0]);
}
function link(vfs, delegate) {
    return replaceArguments(vfs, delegate, [0, 1]);
}
function linkSync(vfs, delegate) {
    return replaceArguments(vfs, delegate, [0, 1]);
}
function lstat(vfs, delegate) {
    return function (path, options, callback) {
        const filePath = stringPath(path);
        const resolved = vfs.entry(filePath);
        if (typeof options === "function") {
            callback = options;
            options = {};
        }
        if (resolved) {
            if (resolved.type === VfsNode.SYMLINK || resolved.path === undefined) {
                setImmediate(() => callback(null, options.bigint ? new LinkBigintStat(resolved) : new LinkStat(resolved)));
            }
            else if (resolved.hardenSymlinks) {
                fs__namespace.stat(resolved.path, options, callback);
                return;
            }
        }
        if (resolved && filePath !== resolved.path) ;
        return delegate.apply(this, arguments);
    };
}
function lstatSync(vfs, delegate) {
    return function (path, options) {
        const filePath = stringPath(path);
        const resolved = vfs.entry(filePath);
        if (resolved) {
            if (resolved.type === VfsNode.SYMLINK || resolved.path === undefined) {
                return options.bigint ? new LinkBigintStat(resolved) : new LinkStat(resolved);
            }
            else if (resolved.hardenSymlinks) {
                return fs__namespace.statSync(resolved.path, options);
            }
        }
        if (resolved && filePath !== resolved.path) ;
        return delegate.apply(this, arguments);
    };
}
function mkdir(vfs, delegate) {
    return replaceArguments(vfs, delegate, [0]);
}
function mkdirSync(vfs, delegate) {
    return replaceArguments(vfs, delegate, [0]);
}
function open(vfs, delegate) {
    return function (path) {
        const filePath = stringPath(path);
        const resolved = vfs.resolve(filePath);
        const args = [...arguments];
        if (resolved && resolved.path === undefined) ;
        else if (filePath !== resolved.path) {
            args[0] = resolved.path;
        }
        return delegate.apply(this, args);
    };
}
function openSync(vfs, delegate) {
    return function (path) {
        const filePath = stringPath(path);
        const resolved = vfs.resolve(filePath);
        const args = [...arguments];
        if (resolved && resolved.path === undefined) ;
        else if (filePath !== resolved.path) {
            args[0] = resolved.path;
        }
        return delegate.apply(this, args);
    };
}
function opendir(vfs, delegate) {
    return function (path, options, callback) {
        const filePath = stringPath(path);
        if (typeof options === "function") {
            callback = options;
        }
        const resolved = vfs.resolve(filePath);
        if (resolved && resolved.path === undefined) {
            setImmediate(() => callback(null, new VfsDir(resolved, undefined)));
            return;
        }
        const args = [...arguments];
        if (resolved && filePath !== resolved.path) {
            args[0] = resolved.path;
        }
        if (resolved && resolved.extraChildren.size) {
            args[typeof args[1] === "function" ? 1 : 2] = function (err, dir) {
                if (err) {
                    return callback.apply(this, arguments);
                }
                callback(null, new VfsDir(resolved, dir));
            };
        }
        return delegate.apply(this, args);
    };
}
function opendirSync(vfs, delegate) {
    return function (path) {
        const filePath = stringPath(path);
        const resolved = vfs.resolve(filePath);
        if (resolved && resolved.path === undefined) {
            return new VfsDir(resolved, undefined);
        }
        const args = [...arguments];
        if (resolved && filePath !== resolved.path) {
            args[0] = resolved.path;
        }
        const dir = delegate.apply(this, args);
        if (resolved && resolved.extraChildren.size) {
            return new VfsDir(resolved, dir);
        }
        return dir;
    };
}
function readdir(vfs, delegate) {
    return function (path, options, callback) {
        const filePath = stringPath(path);
        if (typeof options === "function") {
            callback = options;
            options = {};
        }
        else if (typeof options === "string") {
            options = { encoding: options };
        }
        else {
            options = {};
        }
        const resolved = vfs.resolve(filePath);
        let extra = [];
        if (resolved && resolved.extraChildren.size) {
            if (options.withFileTypes) {
                extra = [...resolved.extraChildren.entries()].map(([name, entry]) => dirent(name, entry));
            }
            else if (options.encoding === "buffer") {
                extra = [...resolved.extraChildren.keys()].map(name => Buffer.from(name));
            }
            else {
                extra = [...resolved.extraChildren.keys()];
            }
        }
        if (resolved && resolved.path === undefined) {
            setImmediate(() => callback(null, extra));
            return;
        }
        const args = [...arguments];
        if (resolved && filePath !== resolved.path) {
            args[0] = resolved.path;
        }
        if (extra.length) {
            args[typeof args[1] === "function" ? 1 : 2] = function (err, files) {
                if (err) {
                    return callback.apply(this, arguments);
                }
                callback(null, [...files, ...extra]);
            };
        }
        return delegate.apply(this, args);
    };
}
function readdirSync(vfs, delegate) {
    return function (path, options) {
        const filePath = stringPath(path);
        if (typeof options === "string") {
            options = { encoding: options };
        }
        else {
            options = {};
        }
        const resolved = vfs.resolve(filePath);
        let extra = [];
        if (resolved && resolved.extraChildren.size) {
            if (options.withFileTypes) {
                extra = [...resolved.extraChildren.entries()].map(([name, entry]) => dirent(name, entry));
            }
            else if (options.encoding === "buffer") {
                extra = [...resolved.extraChildren.keys()].map(name => Buffer.from(name));
            }
            else {
                extra = [...resolved.extraChildren.keys()];
            }
        }
        if (resolved && resolved.path === undefined) {
            return extra;
        }
        const args = [...arguments];
        if (resolved && filePath !== resolved.path) {
            args[0] = resolved.path;
        }
        const result = delegate.apply(this, args);
        if (extra.length) {
            return [...result, ...extra];
        }
        return result;
    };
}
function readFile(vfs, delegate) {
    return replaceArguments(vfs, delegate, [0]);
}
function readFileSync(vfs, delegate) {
    return replaceArguments(vfs, delegate, [0]);
}
function readlink(vfs, delegate) {
    return function (path, options, callback) {
        const filePath = stringPath(path);
        if (typeof options === "function") {
            callback = options;
            options = {};
        }
        else if (typeof options === "string") {
            options = { encoding: options };
        }
        else {
            options = {};
        }
        const resolved = vfs.entry(filePath);
        if (resolved && resolved.type === VfsNode.SYMLINK) {
            if (options.encoding === 'buffer') {
                setImmediate(() => callback(null, Buffer.from(resolved.path)));
            }
            else {
                setImmediate(() => callback(null, resolved.path));
            }
            return;
        }
        const args = [...arguments];
        if (resolved && filePath !== resolved.path) {
            args[0] = resolved.path;
        }
        return delegate.apply(this, args);
    };
}
function readlinkSync(vfs, delegate) {
    return function (path, options) {
        const filePath = stringPath(path);
        if (typeof options === "string") {
            options = { encoding: options };
        }
        else {
            options = {};
        }
        const resolved = vfs.entry(filePath);
        if (resolved && resolved.type === VfsNode.SYMLINK) {
            if (options.encoding === 'buffer') {
                return Buffer.from(resolved.path);
            }
            else {
                return resolved.path;
            }
        }
        const args = [...arguments];
        if (resolved && filePath !== resolved.path) {
            args[0] = resolved.path;
        }
        return delegate.apply(this, args);
    };
}
function realpath(vfs, delegate) {
    function realpath(path, options, callback) {
        const filePath = stringPath(path);
        if (typeof options === "function") {
            callback = options;
        }
        const resolved = vfs.realpath(filePath);
        const args = [...arguments];
        if (resolved && filePath != resolved.path) {
            args[0] = resolved.path;
        }
        if (resolved.hardenSymlinks) {
            args[typeof args[1] === "function" ? 1 : 2] = function (err) {
                if (err) {
                    return callback.apply(this, arguments);
                }
                else {
                    callback(null, options === 'buffer' ? Buffer.from(resolved.path) : resolved.path);
                }
            };
        }
        delegate.apply(this, args);
    }
    realpath.native = delegate.native;
    return realpath;
}
function realpathSync(vfs, delegate) {
    function realpathSync(path, options) {
        const filePath = stringPath(path);
        const resolved = vfs.realpath(filePath);
        const args = [...arguments];
        if (resolved && filePath != resolved.path) {
            args[0] = resolved.path;
        }
        const result = delegate.apply(this, args);
        if (resolved === null || resolved === void 0 ? void 0 : resolved.hardenSymlinks) {
            return options === 'buffer' ? Buffer.from(resolved.path) : resolved.path;
        }
        return result;
    }
    realpathSync.native = delegate.native;
    return realpathSync;
}
function rename(vfs, delegate) {
    return replaceArguments(vfs, delegate, [0, 1]);
}
function renameSync(vfs, delegate) {
    return replaceArguments(vfs, delegate, [0, 1]);
}
function rm(vfs, delegate) {
    return replaceArguments(vfs, delegate, [0]);
}
function rmSync(vfs, delegate) {
    return replaceArguments(vfs, delegate, [0]);
}
function rmdir(vfs, delegate) {
    return replaceArguments(vfs, delegate, [0]);
}
function rmdirSync(vfs, delegate) {
    return replaceArguments(vfs, delegate, [0]);
}
function stat(vfs, delegate) {
    return function (path, options, callback) {
        const filePath = stringPath(path);
        const resolved = vfs.resolve(filePath);
        if (typeof options === "function") {
            callback = options;
            options = {};
        }
        if (resolved && resolved.path === undefined) {
            setImmediate(() => callback(null, options.bigint ? new LinkBigintStat(resolved) : new LinkStat(resolved)));
            return;
        }
        const args = [...arguments];
        if (resolved && filePath !== resolved.path) {
            args[0] = resolved.path;
        }
        return delegate.apply(this, args);
    };
}
function statSync(vfs, delegate) {
    return function (path, options) {
        const filePath = stringPath(path);
        const resolved = vfs.resolve(filePath);
        if (resolved && resolved.path === undefined) {
            return (options === null || options === void 0 ? void 0 : options.bigint) ? new LinkBigintStat(resolved) : new LinkStat(resolved);
        }
        const args = [...arguments];
        if (resolved && filePath !== resolved.path) {
            args[0] = resolved.path;
        }
        return delegate.apply(this, args);
    };
}
function symlink(vfs, delegate) {
    // difficult to sensibly manipulate target
    return replaceArguments(vfs, delegate, [0]);
}
function symlinkSync(vfs, delegate) {
    // difficult to sensibly manipulate target
    return replaceArguments(vfs, delegate, [0]);
}
function truncate(vfs, delegate) {
    return replaceArguments(vfs, delegate, [0]);
}
function truncateSync(vfs, delegate) {
    return replaceArguments(vfs, delegate, [0]);
}
function unlink(vfs, delegate) {
    return replaceArguments(vfs, delegate, [0]);
}
function unlinkSync(vfs, delegate) {
    return replaceArguments(vfs, delegate, [0]);
}
function utimes(vfs, delegate) {
    return replaceArguments(vfs, delegate, [0]);
}
function utimesSync(vfs, delegate) {
    return replaceArguments(vfs, delegate, [0]);
}
function writeFile(vfs, delegate) {
    return replaceArguments(vfs, delegate, [0]);
}
function writeFileSync(vfs, delegate) {
    return replaceArguments(vfs, delegate, [0]);
}
function patchFs(vfs, delegate) {
    delegate.access = access$1(vfs, delegate.access);
    delegate.accessSync = accessSync(vfs, delegate.accessSync);
    delegate.appendFile = appendFile$1(vfs, delegate.appendFile);
    delegate.appendFileSync = appendFileSync(vfs, delegate.appendFileSync);
    delegate.chmod = chmod$1(vfs, delegate.chmod);
    delegate.chmodSync = chmodSync(vfs, delegate.chmodSync);
    delegate.chown = chown$1(vfs, delegate.chown);
    delegate.chownSync = chownSync(vfs, delegate.chownSync);
    delegate.copyFile = copyFile$1(vfs, delegate.copyFile);
    delegate.copyFileSync = copyFileSync(vfs, delegate.copyFileSync);
    delegate.createReadStream = createReadStream(vfs, delegate.createReadStream);
    delegate.createWriteStream = createWriteStream(vfs, delegate.createWriteStream);
    delegate.exists = exists(vfs, delegate.exists);
    delegate.existsSync = existsSync(vfs, delegate.existsSync);
    // delegate.lchmod;
    // delegate.lchmodSync;
    // delegate.lchown;
    // delegate.lchownSync;
    // delegate.lutimes;
    // delegate.lutimesSync;
    delegate.link = link(vfs, delegate.link);
    delegate.linkSync = linkSync(vfs, delegate.linkSync);
    delegate.lstat = lstat(vfs, delegate.lstat);
    delegate.lstatSync = lstatSync(vfs, delegate.lstatSync);
    delegate.mkdir = mkdir(vfs, delegate.mkdir);
    delegate.mkdirSync = mkdirSync(vfs, delegate.mkdirSync);
    delegate.open = open(vfs, delegate.open);
    delegate.openSync = openSync(vfs, delegate.openSync);
    delegate.opendir = opendir(vfs, delegate.opendir);
    delegate.opendirSync = opendirSync(vfs, delegate.opendirSync);
    delegate.readdir = readdir(vfs, delegate.readdir);
    delegate.readdirSync = readdirSync(vfs, delegate.readdirSync);
    delegate.readFile = readFile(vfs, delegate.readFile);
    delegate.readFileSync = readFileSync(vfs, delegate.readFileSync);
    delegate.readlink = readlink(vfs, delegate.readlink);
    delegate.readlinkSync = readlinkSync(vfs, delegate.readlinkSync);
    delegate.realpath = realpath(vfs, delegate.realpath);
    delegate.realpathSync = realpathSync(vfs, delegate.realpathSync);
    delegate.rename = rename(vfs, delegate.rename);
    delegate.renameSync = renameSync(vfs, delegate.renameSync);
    delegate.rmdir = rmdir(vfs, delegate.rmdir);
    delegate.rmdirSync = rmdirSync(vfs, delegate.rmdirSync);
    delegate.rm = rm(vfs, delegate.rm);
    delegate.rmSync = rmSync(vfs, delegate.rmSync);
    delegate.stat = stat(vfs, delegate.stat);
    delegate.statSync = statSync(vfs, delegate.statSync);
    delegate.symlink = symlink(vfs, delegate.symlink);
    delegate.symlinkSync = symlinkSync(vfs, delegate.symlinkSync);
    delegate.truncate = truncate(vfs, delegate.truncate);
    delegate.truncateSync = truncateSync(vfs, delegate.truncateSync);
    delegate.unlink = unlink(vfs, delegate.unlink);
    delegate.unlinkSync = unlinkSync(vfs, delegate.unlinkSync);
    delegate.utimes = utimes(vfs, delegate.utimes);
    delegate.utimesSync = utimesSync(vfs, delegate.unlinkSync);
    delegate.writeFile = writeFile(vfs, delegate.writeFile);
    delegate.writeFileSync = writeFileSync(vfs, delegate.writeFileSync);
}

function access(vfs, delegate) {
    return replaceArguments(vfs, delegate, [0]);
}
function appendFile(vfs, delegate) {
    return replaceArguments(vfs, delegate, [0]);
}
function chmod(vfs, delegate) {
    return replaceArguments(vfs, delegate, [0]);
}
function chown(vfs, delegate) {
    return replaceArguments(vfs, delegate, [0]);
}
function copyFile(vfs, delegate) {
    return replaceArguments(vfs, delegate, [0, 1]);
}
function cp(vfs, delegate) {
    return replaceArguments(vfs, delegate, [0, 1]);
}
function lutimes(vfs, delegate) {
    return replaceArguments(vfs, delegate, [0]);
}
function patchFsPromises(vfs, delegate) {
    delegate.access = access(vfs, fs.promises.access);
    delegate.appendFile = appendFile(vfs, fs.promises.appendFile);
    delegate.chmod = chmod(vfs, delegate.chmod);
    delegate.chown = chown(vfs, delegate.chown);
    delegate.copyFile = copyFile(vfs, delegate.copyFile);
    delegate.cp = cp(vfs, delegate.cp);
    // delegate.lchmod
    // delegate.lchown
    delegate.lutimes = lutimes(vfs, delegate.lutimes);
}

class DependencyConflictError extends Error {
}
function addPackageNode(root, path) {
    const parts = path.split('/').slice(1);
    for (let i = 0; i < parts.length; i++) {
        let newRoot = root.extraChildren.get(parts[i]);
        if (!newRoot) {
            newRoot = { type: VfsNode.PATH, hardenSymlinks: false, extraChildren: new Map(), path: '/' + parts.slice(0, i + 1).join('/') };
            root.extraChildren.set(parts[i], newRoot);
        }
        root = newRoot;
    }
    root.hardenSymlinks = true;
    return root;
}
function addDep(root, name, path) {
    const parts = name.split('/');
    for (let i = 0; i < parts.length - 1; i++) {
        let newRoot = root.extraChildren.get(parts[i]);
        if (!newRoot) {
            newRoot = { type: VfsNode.PATH, hardenSymlinks: false, extraChildren: new Map(), path: undefined };
            root.extraChildren.set(parts[i], newRoot);
        }
        else if (newRoot.type !== VfsNode.PATH) {
            throw new DependencyConflictError();
        }
        root = newRoot;
    }
    root.extraChildren.set(parts[parts.length - 1], {
        type: VfsNode.SYMLINK,
        path,
    });
}
function createVfs(packageTree) {
    const root = { type: VfsNode.PATH, hardenSymlinks: false, extraChildren: new Map(), path: '/' };
    for (const [id, package_] of packageTree.entries()) {
        const packageNode = addPackageNode(root, path__namespace.resolve(package_.path));
        const nodeModules = { type: VfsNode.PATH, hardenSymlinks: false, extraChildren: new Map(), path: undefined };
        packageNode.extraChildren.set('node_modules', nodeModules);
        for (const [name, dep] of package_.deps) {
            try {
                addDep(nodeModules, name, path__namespace.resolve(packageTree.get(dep).path));
            }
            catch (e) {
                if (!(e instanceof DependencyConflictError)) {
                    throw e;
                }
                throw new Error(`Dependency "${name}" of "${id}" conflicts with another`);
            }
        }
    }
    return new Vfs(root);
}

const manifestPath = process.env.NODE_FS_PACKAGE_MANIFEST;
if (!manifestPath) {
    throw new Error('NODE_FS_PACKAGE_MANIFEST is not set');
}
const packageTree = JsonFormat.parse(PackageTree.json(), fs__namespace.readFileSync(manifestPath, 'utf8'));
const vfs = createVfs(packageTree);
if (process.env.NODE_FS_TRACE2 === 'true') {
    process.stderr.write(vfs.print());
}
patchFs(vfs, require('fs'));
patchFsPromises(vfs, require('fs').promises);
