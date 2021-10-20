import * as path from 'path';
import { JsonFormat } from "./json";
export var VfsEntry;
(function (VfsEntry) {
    VfsEntry.DIRECTORY = Symbol("DIRECTORY");
    VfsEntry.LINK = Symbol("LINK");
    VfsEntry.PATH = Symbol("PATH");
    function json() {
        let children;
        const result = {
            fromJson(json) {
                switch (json.type) {
                    case 'LINK':
                        return { type: VfsEntry.LINK, path: VfsPath.parse(json.path) };
                    case 'DIRECTORY':
                        return { type: VfsEntry.DIRECTORY, children: children.fromJson(json.children) };
                    case 'PATH':
                        return { type: VfsEntry.PATH, path: JsonFormat.string().fromJson(json.path) };
                }
            },
            toJson(entry) {
                switch (entry.type) {
                    case VfsEntry.LINK:
                        return { type: 'LINK', path: VfsPath.text(entry.path) };
                    case VfsEntry.PATH:
                        return { type: 'PATH', path: entry.path };
                    case VfsEntry.DIRECTORY:
                        return { type: 'DIRECTORY', children: children.toJson(entry.children) };
                }
            }
        };
        children = JsonFormat.map(JsonFormat.string(), JsonFormat.defer(() => result));
        return result;
    }
    VfsEntry.json = json;
})(VfsEntry || (VfsEntry = {}));
export var VfsPath;
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
})(VfsPath || (VfsPath = {}));
/**
 * Mounted part of link file system
 */
export class VfsMount {
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
                        path: [entry.path, ...path.slice(i)].join('/'),
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
                    return [entry.path, ...path.slice(i)].join('/');
            }
        }
        return realpath.join('/');
    }
    *tree() {
        yield* (function* f(entry) {
            switch (entry.type) {
                case VfsEntry.LINK:
                    yield `-> ${entry.path.join('/')}`;
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
export var FsResult;
(function (FsResult) {
    FsResult.LINK = Symbol('LINK');
    FsResult.PATH = Symbol('PATH');
    FsResult.DIRECTORY = Symbol('DIRECTORY');
    FsResult.NOT_FOUND = Symbol('NOT_FOUND');
    FsResult.NotFound = { type: FsResult.NOT_FOUND };
})(FsResult || (FsResult = {}));
/**
 * Link file system.
 * First path component is the mount point.
 */
export class Vfs {
    constructor() {
        this._mountPoints = [];
    }
    _resolvePath(path_) {
        path_ = path.resolve(path_);
        const mount = this._mountPoints.find(({ path }) => path === path_ || path_.startsWith(`${path}/`));
        if (!mount) {
            return;
        }
        return { mountPoint: mount, path: VfsPath.parse(path_.slice(mount.path.length + 1)) };
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
                return { type: FsResult.LINK, path: this._prepend(mountPoint, VfsPath.text(resolved.path)) };
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
            if (path === '/home/paul/.cache/bazel/_bazel_paul/827675ad2bd429ed573f7c0cfab03422/sandbox/linux-sandbox/54/execroot/better_rules_typescript/bazel-ts') {
                console.log(entry);
            }
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
