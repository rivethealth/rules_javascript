'use strict';

var url = require('url');
var fs = require('fs');
var path = require('path');
var minimal = require('protobufjs/minimal');
var Long = require('long');
var protobufjs = require('protobufjs');
var argparse = require('argparse');
var ts = require('typescript');

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
var Long__namespace = /*#__PURE__*/_interopNamespace(Long);
var ts__namespace = /*#__PURE__*/_interopNamespace(ts);

var VfsNode;
(function (VfsNode) {
    VfsNode.PATH = Symbol("PATH");
    VfsNode.SYMLINK = Symbol("SYMLINK");
})(VfsNode || (VfsNode = {}));
class VfsImpl {
    constructor(root) {
        this.root = root;
    }
    entry(path) {
        loop: while (true) {
            if (!path.startsWith("/")) {
                throw new Error("Path must be absolute");
            }
            const parts = path.split("/").slice(1);
            let node = this.root;
            let i;
            for (i = 0; i < parts.length; i++) {
                if (node.type === VfsNode.SYMLINK) {
                    path = [node.path, ...parts.slice(i)].join("/");
                    continue loop;
                }
                const newNode = node.extraChildren.get(parts[i]);
                if (!newNode) {
                    break;
                }
                node = newNode;
            }
            if (i < parts.length) {
                return {
                    type: VfsNode.PATH,
                    extraChildren: new Map(),
                    hardenSymlinks: node.hardenSymlinks,
                    path: [node.path, ...parts.slice(i)].join("/"),
                };
            }
            if (node.type === VfsNode.SYMLINK) {
                return node;
            }
            return { ...node, hardenSymlinks: true };
        }
    }
    realpath(path) {
        loop: while (true) {
            if (!path.startsWith("/")) {
                throw new Error("Path must be absolute");
            }
            const parts = path.split("/").slice(1);
            let node = this.root;
            let i;
            for (i = 0; i < parts.length; i++) {
                if (node.type === VfsNode.SYMLINK) {
                    path = [node.path, ...parts.slice(i)].join("/");
                    continue loop;
                }
                const newNode = node.extraChildren.get(parts[i]);
                if (!newNode) {
                    break;
                }
                node = newNode;
            }
            if (node.type === VfsNode.SYMLINK) {
                path = [node.path, ...parts.slice(i)].join("/");
                continue loop;
            }
            if (i < parts.length) {
                if (node.path === undefined) {
                    return undefined;
                }
                return {
                    hardenSymlinks: node.hardenSymlinks,
                    path: [node.path, ...parts.slice(i)].join("/"),
                };
            }
            return {
                hardenSymlinks: true,
                path: "/" + parts.join("/"),
            };
        }
    }
    /**
     * Return node representing file path
     */
    resolve(path) {
        loop: while (true) {
            if (!path.startsWith("/")) {
                throw new Error("Path must be absolute");
            }
            const parts = path.split("/").slice(1);
            let node = this.root;
            let i;
            for (i = 0; i < parts.length; i++) {
                if (node.type === VfsNode.SYMLINK) {
                    path = [node.path, ...parts.slice(i)].join("/");
                    continue loop;
                }
                const newNode = node.extraChildren.get(parts[i]);
                if (!newNode) {
                    break;
                }
                node = newNode;
            }
            if (node.type === VfsNode.SYMLINK) {
                path = [node.path, ...parts.slice(i)].join("/");
                continue loop;
            }
            if (i < parts.length) {
                if (node.path === undefined) {
                    return undefined;
                }
                return {
                    type: VfsNode.PATH,
                    extraChildren: new Map(),
                    hardenSymlinks: node.hardenSymlinks,
                    path: [node.path, ...parts.slice(i)].join("/"),
                };
            }
            return { ...node, hardenSymlinks: true };
        }
    }
    print() {
        return (function print(name, node, prefix) {
            switch (node.type) {
                case VfsNode.PATH: {
                    let result;
                    if (node.path) {
                        result = `${prefix}${name}/ (${node.path})`;
                        if (node.hardenSymlinks) {
                            result += " nolinks";
                        }
                        result += "\n";
                    }
                    else {
                        result = `${prefix}${name}/\n`;
                    }
                    for (const [name, child] of node.extraChildren.entries()) {
                        result += print(name, child, prefix + "  ");
                    }
                    return result;
                }
                case VfsNode.SYMLINK:
                    return `${prefix}${name} -> ${node.path}\n`;
            }
        })("", this.root, "");
    }
}
class NoopVfs {
    entry(path) {
        return {
            type: VfsNode.PATH,
            extraChildren: new Map(),
            hardenSymlinks: false,
            path,
        };
    }
    realpath(path) {
        return {
            hardenSymlinks: false,
            path,
        };
    }
    resolve(path) {
        return {
            type: VfsNode.PATH,
            extraChildren: new Map(),
            hardenSymlinks: false,
            path,
        };
    }
}
class WrapperVfs {
    constructor() {
        this.delegate = new NoopVfs();
    }
    entry(path) {
        return this.delegate.entry(path);
    }
    realpath(path) {
        return this.delegate.realpath(path);
    }
    resolve(path) {
        return this.delegate.resolve(path);
    }
}

/**
 * @filedescription Node.js fs implementation of Vfs
 */
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
function invalidError(syscall, path) {
    const error = (new Error(`EINVAL: invalid argument, ${syscall}, ${path}`));
    error.path = path;
    error.syscall = syscall;
    error.code = "EINVAL";
    error.errno = -22;
    return error;
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
            return new fs__namespace.Dirent(name, fs__namespace.constants.UV_DIRENT_DIR);
        case VfsNode.SYMLINK:
            return new fs__namespace.Dirent(name, fs__namespace.constants.UV_DIRENT_LINK);
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
            if (resolved !== undefined && path !== resolved.path) {
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
    return (function (path, options, callback) {
        const filePath = stringPath(path);
        const resolved = vfs.entry(filePath);
        if (typeof options === "function") {
            callback = options;
            options = {};
        }
        if (resolved) {
            if (resolved.type === VfsNode.SYMLINK || resolved.path === undefined) {
                setImmediate(() => callback(null, options.bigint
                    ? new LinkBigintStat(resolved)
                    : new LinkStat(resolved)));
            }
            else if (resolved.hardenSymlinks) {
                fs__namespace.stat(resolved.path, options, callback);
                return;
            }
        }
        if (resolved && filePath !== resolved.path) ;
        return delegate.apply(this, arguments);
    });
}
function lstatSync(vfs, delegate) {
    return (function (path, options) {
        const filePath = stringPath(path);
        const resolved = vfs.entry(filePath);
        if (resolved) {
            if (resolved.type === VfsNode.SYMLINK || resolved.path === undefined) {
                return options.bigint
                    ? new LinkBigintStat(resolved)
                    : new LinkStat(resolved);
            }
            else if (resolved.hardenSymlinks) {
                return fs__namespace.statSync(resolved.path, options);
            }
        }
        if (resolved && filePath !== resolved.path) ;
        return delegate.apply(this, arguments);
    });
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
        else if (resolved && filePath !== resolved.path) {
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
        else if (resolved && filePath !== resolved.path) {
            args[0] = resolved.path;
        }
        return delegate.apply(this, args);
    };
}
function opendir(vfs, delegate) {
    return (function (path, options, callback) {
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
    });
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
        else if (options == null) {
            options = {};
        }
        const resolved = vfs.resolve(filePath);
        let extra = [];
        if (resolved && resolved.extraChildren.size) {
            if (options.withFileTypes) {
                extra = [...resolved.extraChildren.entries()].map(([name, entry]) => dirent(name, entry));
            }
            else if (options.encoding === "buffer") {
                extra = [...resolved.extraChildren.keys()].map((name) => Buffer.from(name));
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
        args[typeof args[1] === "function" ? 1 : 2] = function (err, files) {
            if (err) {
                return callback.apply(this, arguments);
            }
            if (options.withFileTypes && resolved.hardenSymlinks) {
                files = files.map((file) => {
                    if (file.isSymbolicLink()) {
                        try {
                            const stat = fs__namespace.statSync(`${filePath}/${file.name}`);
                            if (stat.isDirectory()) {
                                return new fs__namespace.Dirent(file.name, fs__namespace.constants.UV_DIRENT_DIR);
                            }
                            return new fs__namespace.Dirent(file.name, fs__namespace.constants.UV_DIRENT_FILE);
                        }
                        catch { }
                    }
                    return file;
                });
            }
            callback(null, [...files, ...extra]);
        };
        return delegate.apply(this, args);
    };
}
function readdirSync(vfs, delegate) {
    return function (path, options) {
        const filePath = stringPath(path);
        if (typeof options === "string") {
            options = { encoding: options };
        }
        else if (options == null) {
            options = {};
        }
        const resolved = vfs.resolve(filePath);
        let extra = [];
        if (resolved && resolved.extraChildren.size) {
            if (options.withFileTypes) {
                extra = [...resolved.extraChildren.entries()].map(([name, entry]) => dirent(name, entry));
            }
            else if (options.encoding === "buffer") {
                extra = [...resolved.extraChildren.keys()].map((name) => Buffer.from(name));
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
        let result = delegate.apply(this, args);
        if (options.withFileTypes && resolved.hardenSymlinks) {
            result = result.map((file) => {
                if (file.isSymbolicLink()) {
                    try {
                        const stat = fs__namespace.statSync(`${filePath}/${file.name}`);
                        if (stat.isDirectory()) {
                            return new fs__namespace.Dirent(file.name, fs__namespace.constants.UV_DIRENT_DIR);
                        }
                        return new fs__namespace.Dirent(file.name, fs__namespace.constants.UV_DIRENT_FILE);
                    }
                    catch { }
                }
                return file;
            });
        }
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
        if (resolved.type === VfsNode.SYMLINK) {
            if (options.encoding === "buffer") {
                setImmediate(() => callback(null, Buffer.from(resolved.path)));
            }
            else {
                setImmediate(() => callback(null, resolved.path));
            }
            return;
        }
        if (resolved.hardenSymlinks) {
            callback(invalidError("readlink", filePath));
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
        if (resolved.type === VfsNode.SYMLINK) {
            if (options.encoding === "buffer") {
                return Buffer.from(resolved.path);
            }
            else {
                return resolved.path;
            }
        }
        if (resolved.hardenSymlinks) {
            throw invalidError("readlink", filePath);
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
        if (resolved?.hardenSymlinks) {
            args[typeof args[1] === "function" ? 1 : 2] = function (err) {
                if (err) {
                    return callback.apply(this, arguments);
                }
                else {
                    callback(null, options === "buffer" ? Buffer.from(resolved.path) : resolved.path);
                }
            };
        }
        delegate.apply(this, args);
    }
    realpath.native = function (path, options, callback) {
        const filePath = stringPath(path);
        if (typeof options === "function") {
            callback = options;
        }
        const resolved = vfs.realpath(filePath);
        const args = [...arguments];
        if (resolved && filePath != resolved.path) {
            args[0] = resolved.path;
        }
        if (resolved?.hardenSymlinks) {
            args[typeof args[1] === "function" ? 1 : 2] = function (err) {
                if (err) {
                    return callback.apply(this, arguments);
                }
                else {
                    callback(null, options === "buffer" ? Buffer.from(resolved.path) : resolved.path);
                }
            };
        }
        delegate.native.apply(this, args);
    };
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
        if (resolved?.hardenSymlinks) {
            return options === "buffer" ? Buffer.from(resolved.path) : resolved.path;
        }
        return result;
    }
    realpathSync.native = function (path, options) {
        const filePath = stringPath(path);
        const resolved = vfs.realpath(filePath);
        const args = [...arguments];
        if (resolved && filePath != resolved.path) {
            args[0] = resolved.path;
        }
        const result = delegate.native.apply(this, args);
        if (resolved?.hardenSymlinks) {
            return options === "buffer" ? Buffer.from(resolved.path) : resolved.path;
        }
        return result;
    };
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
    return (function (path, options, callback) {
        const filePath = stringPath(path);
        const resolved = vfs.resolve(filePath);
        if (typeof options === "function") {
            callback = options;
            options = {};
        }
        if (resolved && resolved.path === undefined) {
            setImmediate(() => callback(null, options.bigint
                ? new LinkBigintStat(resolved)
                : new LinkStat(resolved)));
            return;
        }
        const args = [...arguments];
        if (resolved && filePath !== resolved.path) {
            args[0] = resolved.path;
        }
        return delegate.apply(this, args);
    });
}
function statSync(vfs, delegate) {
    return (function (path, options) {
        const filePath = stringPath(path);
        const resolved = vfs.resolve(filePath);
        if (resolved && resolved.path === undefined) {
            return options?.bigint
                ? new LinkBigintStat(resolved)
                : new LinkStat(resolved);
        }
        const args = [...arguments];
        if (resolved && filePath !== resolved.path) {
            args[0] = resolved.path;
        }
        return delegate.apply(this, args);
    });
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
function watch(vfs, delegate) {
    return replaceArguments(vfs, delegate, [0]);
}
function watchFile(vfs, delegate) {
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
    delegate.watch = watch(vfs, delegate.watch);
    delegate.watchFile = watchFile(vfs, delegate.watchFile);
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

/* eslint-disable */
const baseInput = { path: "" };
const Input = {
    encode(message, writer = minimal.Writer.create()) {
        if (message.path !== "") {
            writer.uint32(10).string(message.path);
        }
        if (message.digest.length !== 0) {
            writer.uint32(18).bytes(message.digest);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof minimal.Reader ? input : new minimal.Reader(input);
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseInput };
        message.digest = new Uint8Array();
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.path = reader.string();
                    break;
                case 2:
                    message.digest = reader.bytes();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseInput };
        message.digest = new Uint8Array();
        if (object.path !== undefined && object.path !== null) {
            message.path = String(object.path);
        }
        else {
            message.path = "";
        }
        if (object.digest !== undefined && object.digest !== null) {
            message.digest = bytesFromBase64(object.digest);
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.path !== undefined && (obj.path = message.path);
        message.digest !== undefined &&
            (obj.digest = base64FromBytes(message.digest !== undefined ? message.digest : new Uint8Array()));
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseInput };
        if (object.path !== undefined && object.path !== null) {
            message.path = object.path;
        }
        else {
            message.path = "";
        }
        if (object.digest !== undefined && object.digest !== null) {
            message.digest = object.digest;
        }
        else {
            message.digest = new Uint8Array();
        }
        return message;
    },
};
const baseWorkRequest = {
    arguments: "",
    requestId: 0,
    cancel: false,
    verbosity: 0,
};
const WorkRequest = {
    encode(message, writer = minimal.Writer.create()) {
        for (const v of message.arguments) {
            writer.uint32(10).string(v);
        }
        for (const v of message.inputs) {
            Input.encode(v, writer.uint32(18).fork()).ldelim();
        }
        if (message.requestId !== 0) {
            writer.uint32(24).int32(message.requestId);
        }
        if (message.cancel === true) {
            writer.uint32(32).bool(message.cancel);
        }
        if (message.verbosity !== 0) {
            writer.uint32(40).int32(message.verbosity);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof minimal.Reader ? input : new minimal.Reader(input);
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseWorkRequest };
        message.arguments = [];
        message.inputs = [];
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.arguments.push(reader.string());
                    break;
                case 2:
                    message.inputs.push(Input.decode(reader, reader.uint32()));
                    break;
                case 3:
                    message.requestId = reader.int32();
                    break;
                case 4:
                    message.cancel = reader.bool();
                    break;
                case 5:
                    message.verbosity = reader.int32();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseWorkRequest };
        message.arguments = [];
        message.inputs = [];
        if (object.arguments !== undefined && object.arguments !== null) {
            for (const e of object.arguments) {
                message.arguments.push(String(e));
            }
        }
        if (object.inputs !== undefined && object.inputs !== null) {
            for (const e of object.inputs) {
                message.inputs.push(Input.fromJSON(e));
            }
        }
        if (object.requestId !== undefined && object.requestId !== null) {
            message.requestId = Number(object.requestId);
        }
        else {
            message.requestId = 0;
        }
        if (object.cancel !== undefined && object.cancel !== null) {
            message.cancel = Boolean(object.cancel);
        }
        else {
            message.cancel = false;
        }
        if (object.verbosity !== undefined && object.verbosity !== null) {
            message.verbosity = Number(object.verbosity);
        }
        else {
            message.verbosity = 0;
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        if (message.arguments) {
            obj.arguments = message.arguments.map((e) => e);
        }
        else {
            obj.arguments = [];
        }
        if (message.inputs) {
            obj.inputs = message.inputs.map((e) => (e ? Input.toJSON(e) : undefined));
        }
        else {
            obj.inputs = [];
        }
        message.requestId !== undefined && (obj.requestId = message.requestId);
        message.cancel !== undefined && (obj.cancel = message.cancel);
        message.verbosity !== undefined && (obj.verbosity = message.verbosity);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseWorkRequest };
        message.arguments = [];
        message.inputs = [];
        if (object.arguments !== undefined && object.arguments !== null) {
            for (const e of object.arguments) {
                message.arguments.push(e);
            }
        }
        if (object.inputs !== undefined && object.inputs !== null) {
            for (const e of object.inputs) {
                message.inputs.push(Input.fromPartial(e));
            }
        }
        if (object.requestId !== undefined && object.requestId !== null) {
            message.requestId = object.requestId;
        }
        else {
            message.requestId = 0;
        }
        if (object.cancel !== undefined && object.cancel !== null) {
            message.cancel = object.cancel;
        }
        else {
            message.cancel = false;
        }
        if (object.verbosity !== undefined && object.verbosity !== null) {
            message.verbosity = object.verbosity;
        }
        else {
            message.verbosity = 0;
        }
        return message;
    },
};
const baseWorkResponse = {
    exitCode: 0,
    output: "",
    requestId: 0,
    wasCancelled: false,
};
const WorkResponse = {
    encode(message, writer = minimal.Writer.create()) {
        if (message.exitCode !== 0) {
            writer.uint32(8).int32(message.exitCode);
        }
        if (message.output !== "") {
            writer.uint32(18).string(message.output);
        }
        if (message.requestId !== 0) {
            writer.uint32(24).int32(message.requestId);
        }
        if (message.wasCancelled === true) {
            writer.uint32(32).bool(message.wasCancelled);
        }
        return writer;
    },
    decode(input, length) {
        const reader = input instanceof minimal.Reader ? input : new minimal.Reader(input);
        let end = length === undefined ? reader.len : reader.pos + length;
        const message = { ...baseWorkResponse };
        while (reader.pos < end) {
            const tag = reader.uint32();
            switch (tag >>> 3) {
                case 1:
                    message.exitCode = reader.int32();
                    break;
                case 2:
                    message.output = reader.string();
                    break;
                case 3:
                    message.requestId = reader.int32();
                    break;
                case 4:
                    message.wasCancelled = reader.bool();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
            }
        }
        return message;
    },
    fromJSON(object) {
        const message = { ...baseWorkResponse };
        if (object.exitCode !== undefined && object.exitCode !== null) {
            message.exitCode = Number(object.exitCode);
        }
        else {
            message.exitCode = 0;
        }
        if (object.output !== undefined && object.output !== null) {
            message.output = String(object.output);
        }
        else {
            message.output = "";
        }
        if (object.requestId !== undefined && object.requestId !== null) {
            message.requestId = Number(object.requestId);
        }
        else {
            message.requestId = 0;
        }
        if (object.wasCancelled !== undefined && object.wasCancelled !== null) {
            message.wasCancelled = Boolean(object.wasCancelled);
        }
        else {
            message.wasCancelled = false;
        }
        return message;
    },
    toJSON(message) {
        const obj = {};
        message.exitCode !== undefined && (obj.exitCode = message.exitCode);
        message.output !== undefined && (obj.output = message.output);
        message.requestId !== undefined && (obj.requestId = message.requestId);
        message.wasCancelled !== undefined &&
            (obj.wasCancelled = message.wasCancelled);
        return obj;
    },
    fromPartial(object) {
        const message = { ...baseWorkResponse };
        if (object.exitCode !== undefined && object.exitCode !== null) {
            message.exitCode = object.exitCode;
        }
        else {
            message.exitCode = 0;
        }
        if (object.output !== undefined && object.output !== null) {
            message.output = object.output;
        }
        else {
            message.output = "";
        }
        if (object.requestId !== undefined && object.requestId !== null) {
            message.requestId = object.requestId;
        }
        else {
            message.requestId = 0;
        }
        if (object.wasCancelled !== undefined && object.wasCancelled !== null) {
            message.wasCancelled = object.wasCancelled;
        }
        else {
            message.wasCancelled = false;
        }
        return message;
    },
};
var globalThis = (() => {
    if (typeof globalThis !== "undefined")
        return globalThis;
    if (typeof self !== "undefined")
        return self;
    if (typeof window !== "undefined")
        return window;
    if (typeof global !== "undefined")
        return global;
    throw "Unable to locate global object";
})();
const atob = globalThis.atob ||
    ((b64) => globalThis.Buffer.from(b64, "base64").toString("binary"));
function bytesFromBase64(b64) {
    const bin = atob(b64);
    const arr = new Uint8Array(bin.length);
    for (let i = 0; i < bin.length; ++i) {
        arr[i] = bin.charCodeAt(i);
    }
    return arr;
}
const btoa = globalThis.btoa ||
    ((bin) => globalThis.Buffer.from(bin, "binary").toString("base64"));
function base64FromBytes(arr) {
    const bin = [];
    for (const byte of arr) {
        bin.push(String.fromCharCode(byte));
    }
    return btoa(bin.join(""));
}
// If you get a compile-error about 'Constructor<Long> and ... have no overlap',
// add '--ts_proto_opt=esModuleInterop=true' as a flag when calling 'protoc'.
if (minimal.util.Long !== Long__namespace) {
    minimal.util.Long = Long__namespace;
    minimal.configure();
}

function concat(buffers) {
    const length = buffers.reduce((sum, buffer) => sum + buffer.byteLength, 0);
    const result = new Uint8Array(length);
    let offset = 0;
    for (const buffer of buffers) {
        result.set(new Uint8Array(buffer), offset);
        offset += buffer.byteLength;
    }
    return result.buffer;
}
async function* readFromStream(iterator, messageType) {
    const it = iterator[Symbol.asyncIterator]();
    let buffer = new Uint8Array(0);
    outer: while (true) {
        while (new Uint8Array(buffer).every((v) => 128 <= v)) {
            const next = await it.next();
            if (next.done) {
                if (buffer.byteLength) {
                    throw new Error("Unexpected EOF");
                }
                else {
                    break outer;
                }
            }
            buffer = concat([buffer, next.value]);
        }
        const reader = protobufjs.Reader.create(new Uint8Array(buffer));
        const length = reader.uint32();
        console.error(length);
        buffer = buffer.slice(reader.pos);
        while (buffer.byteLength < length) {
            const next = await it.next();
            if (next.done) {
                throw new Error("Unexpected EOF");
            }
            buffer = concat([buffer, next.value]);
        }
        yield messageType.decode(new Uint8Array(buffer), length);
        buffer = buffer.slice(length);
    }
}

class CliError extends Error {
}
async function runWorker(worker) {
    let abort;
    process.on("SIGINT", () => abort?.abort());
    process.on("SIGTERM", () => abort?.abort());
    for await (const message of readFromStream(process.stdin, WorkRequest)) {
        if (message.requestId) {
            throw new CliError("Does not support multiplexed requests");
        }
        if (abort) {
            if (!message.cancel) {
                throw new CliError("Unexpected request while processing existing request");
            }
            abort.abort();
        }
        else {
            if (message.cancel) {
                continue;
            }
            abort = new AbortController();
            worker(message.arguments, message.inputs, abort.signal).then(({ exitCode, output }) => {
                const response = {
                    exitCode,
                    output,
                    requestId: 0,
                    wasCancelled: abort.signal.aborted,
                };
                const buffer = WorkResponse.encode(response).ldelim().finish();
                process.stdout.write(buffer);
                abort = undefined;
                if (typeof gc !== "undefined") {
                    gc();
                }
            }, (e) => {
                console.error(e.stack);
                process.exit(1);
            });
        }
    }
}
async function runOnce(worker, args) {
    const abort = new AbortController();
    process.on("SIGINT", () => abort.abort());
    process.on("SIGTERM", () => abort.abort());
    const result = await worker(args, undefined, abort.signal);
    console.error(result.output);
    process.exitCode = result.exitCode;
}
/**
 * Run program using the provided worker factory.
 */
async function workerMain(workerFactory) {
    try {
        const args = process.argv.slice(2, -1);
        const worker = await workerFactory(args);
        const last = process.argv[process.argv.length - 1];
        if (last === "--persistent_worker") {
            await runWorker(worker);
        }
        else if (last.startsWith("@")) {
            const path = last.slice(1);
            const file = fs__namespace.readFileSync(path, "utf-8");
            const args = file.trim().split("\n");
            await runOnce(worker, args);
        }
        else {
            await runOnce(worker, args);
        }
    }
    catch (e) {
        if (e instanceof CliError) {
            console.error(e.message);
        }
        else {
            console.error(e?.stack || String(e));
        }
        process.exit(1);
    }
}

workerMain(async () => {
    const vfs = new WrapperVfs();
    patchFs(vfs, require("fs"));
    patchFsPromises(vfs, require("fs").promises);
    const { JsWorker, JsWorkerError } = await Promise.resolve().then(function () { return worker; });
    const worker$1 = new JsWorker(vfs);
    return async (a) => {
        try {
            await worker$1.run(a);
        }
        catch (e) {
            if (e instanceof JsWorkerError) {
                return { exitCode: 2, output: e.message };
            }
            return { exitCode: 1, output: String(e?.stack || e) };
        }
        return { exitCode: 0, output: "" };
    };
});

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
    function arrayBuffer() {
        return new ArrayBufferFormat();
    }
    JsonFormat.arrayBuffer = arrayBuffer;
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

class DependencyConflictError extends Error {
}
function addPackageNode(root, path) {
    const parts = path.split("/").slice(1);
    for (let i = 0; i < parts.length; i++) {
        let newRoot = root.extraChildren.get(parts[i]);
        if (!newRoot) {
            newRoot = {
                type: VfsNode.PATH,
                hardenSymlinks: false,
                extraChildren: new Map(),
                path: "/" + parts.slice(0, i + 1).join("/"),
            };
            root.extraChildren.set(parts[i], newRoot);
        }
        root = newRoot;
    }
    root.hardenSymlinks = true;
    return root;
}
function addDep(root, name, path) {
    const parts = name.split("/");
    for (let i = 0; i < parts.length - 1; i++) {
        let newRoot = root.extraChildren.get(parts[i]);
        if (!newRoot) {
            newRoot = {
                type: VfsNode.PATH,
                hardenSymlinks: false,
                extraChildren: new Map(),
                path: undefined,
            };
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
function createVfs(packageTree, runfiles) {
    const resolve = (path_) => runfiles
        ? path__namespace.resolve(process.env.RUNFILES_DIR, path_)
        : path__namespace.resolve(path_);
    const root = {
        type: VfsNode.PATH,
        hardenSymlinks: false,
        extraChildren: new Map(),
        path: "/",
    };
    for (const [path, package_] of packageTree.packages.entries()) {
        const packageNode = addPackageNode(root, resolve(path));
        const nodeModules = {
            type: VfsNode.PATH,
            hardenSymlinks: false,
            extraChildren: new Map(),
            path: undefined,
        };
        packageNode.extraChildren.set("node_modules", nodeModules);
        addDep(nodeModules, package_.name, resolve(path));
        for (const [name, dep] of package_.deps) {
            try {
                addDep(nodeModules, name, resolve(dep));
            }
            catch (e) {
                if (!(e instanceof DependencyConflictError)) {
                    throw e;
                }
                throw new Error(`Dependency "${name}" of "${path}" conflicts with another`);
            }
        }
        for (const [name, dep] of packageTree.globals.entries()) {
            try {
                addDep(nodeModules, name, resolve(dep));
            }
            catch (e) {
                if (!(e instanceof DependencyConflictError)) {
                    throw e;
                }
            }
        }
    }
    return new VfsImpl(root);
}

function formatDiagnostic(diagnostic) {
    if (diagnostic.file) {
        const { line, character } = diagnostic.file.getLineAndCharacterOfPosition(diagnostic.start);
        const message = ts__namespace.flattenDiagnosticMessageText(diagnostic.messageText, "\n");
        return `${diagnostic.file.fileName} (${line + 1},${character + 1}): ${message}`;
    }
    else {
        return ts__namespace.flattenDiagnosticMessageText(diagnostic.messageText, "\n");
    }
}
function formatDiagnostics(diagnostics) {
    return diagnostics
        .map((diagnostic) => `${formatDiagnostic(diagnostic)}\n`)
        .join();
}

class JsWorkerError extends Error {
}
class JsArgumentParser extends argparse.ArgumentParser {
    exit(status, message) {
        throw new JsWorkerError(message);
    }
}
class JsWorker {
    constructor(vfs) {
        this.vfs = vfs;
        this.parser = new JsArgumentParser();
        this.parser.add_argument("--config", { required: true });
        this.parser.add_argument("--manifest", { required: true });
        this.parser.add_argument("src");
    }
    parseConfig(config) {
        const parsed = ts__namespace.getParsedCommandLineOfConfigFile(config, { files: [] }, {
            ...ts__namespace.sys,
            onUnRecoverableConfigFileDiagnostic: (error) => {
                throw new JsWorkerError(formatDiagnostics([error]));
            },
        });
        const errors = parsed.errors.filter((diagnostic) => diagnostic.code !== 18002);
        if (errors.length) {
            throw new JsWorkerError(formatDiagnostics(errors));
        }
        return parsed.options;
    }
    setupVfs(manifest) {
        const packageTree = JsonFormat.parse(PackageTree.json(), fs__namespace.readFileSync(manifest, "utf8"));
        const vfs = createVfs(packageTree, false);
        this.vfs.delegate = vfs;
    }
    async run(a) {
        const args = this.parser.parse_args(a);
        this.setupVfs(args.manifest);
        const options = this.parseConfig(args.config);
        await fs__namespace.promises.mkdir(options.outDir, { recursive: true });
        await (async function process(src) {
            const stat = await fs__namespace.promises.stat(src);
            if (stat.isDirectory()) {
                for (const child of await fs__namespace.promises.readdir(src)) {
                    await process(path__namespace.join(src, child));
                }
            }
            else {
                await transpileFile(src, options);
            }
        })(args.src);
    }
}
async function transpileFile(src, options) {
    let name;
    const resolvedSrc = path__namespace.resolve(src);
    if (resolvedSrc === options.rootDir) {
        name = "";
    }
    else if (resolvedSrc.startsWith(`${options.rootDir}/`)) {
        name = resolvedSrc.slice(`${options.rootDir}/`.length);
    }
    else {
        throw new Error(`File ${resolvedSrc} not in ${options.rootDir}`);
    }
    const outputPath = outputName(name ? path__namespace.join(options.outDir, name) : options.outDir);
    const input = fs__namespace.readFileSync(src, "utf8");
    const result = ts__namespace.transpileModule(input, {
        fileName: path__namespace.relative(path__namespace.dirname(outputPath), src),
        compilerOptions: options,
    });
    if (result.diagnostics.length) {
        throw new JsWorkerError(formatDiagnostics(result.diagnostics));
    }
    await fs__namespace.promises.mkdir(path__namespace.dirname(outputPath), { recursive: true });
    await fs__namespace.promises.writeFile(outputPath, result.outputText, "utf8");
    await fs__namespace.promises.writeFile(`${outputPath}.map`, result.sourceMapText, "utf8");
}
function outputName(path) {
    if (path.endsWith(".cts")) {
        return path.slice(0, -".cts".length) + ".cjs";
    }
    if (path.endsWith(".ts")) {
        return path.slice(0, -".ts".length) + ".js";
    }
    if (path.endsWith(".tsx")) {
        return path.slice(0, -".tsx".length) + ".jsx";
    }
    if (path.endsWith(".mts")) {
        return path.slice(0, -".mts".length) + ".mjs";
    }
}

var worker = /*#__PURE__*/Object.freeze({
    __proto__: null,
    JsWorkerError: JsWorkerError,
    JsWorker: JsWorker
});
//# sourceMappingURL=bundle.js.map
