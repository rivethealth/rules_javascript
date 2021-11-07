var __classPrivateFieldGet =
  (this && this.__classPrivateFieldGet) ||
  function (receiver, state, kind, f) {
    if (kind === "a" && !f)
      throw new TypeError("Private accessor was defined without a getter");
    if (
      typeof state === "function"
        ? receiver !== state || !f
        : !state.has(receiver)
    )
      throw new TypeError(
        "Cannot read private member from an object whose class did not declare it",
      );
    return kind === "m"
      ? f
      : kind === "a"
      ? f.call(receiver)
      : f
      ? f.value
      : state.get(receiver);
  };
define("commonjs/fs/json", ["require", "exports"], function (require, exports) {
  "use strict";
  Object.defineProperty(exports, "__esModule", { value: true });
  exports.JsonFormat = void 0;
  var JsonFormat;
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
  })((JsonFormat = exports.JsonFormat || (exports.JsonFormat = {})));
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
      return new Map(
        json.map(({ key, value }) => [
          this.keyFormat.fromJson(key),
          this.valueFormat.fromJson(value),
        ]),
      );
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
define("commonjs/fs/index", [
  "require",
  "exports",
  "commonjs/fs/json",
], function (require, exports, json_1) {
  "use strict";
  Object.defineProperty(exports, "__esModule", { value: true });
  exports.LinkFs =
    exports.LinkMount =
    exports.Path =
    exports.LinkEntry =
      void 0;
  var LinkEntry;
  (function (LinkEntry) {
    LinkEntry.DIRECTORY = Symbol("DIRECTORY");
    LinkEntry.LINK = Symbol("LINK");
    LinkEntry.PATH = Symbol("PATH");
    function json() {
      let children;
      const result = {
        fromJson(json) {
          switch (json.type) {
            case LinkEntry.LINK:
              return { type: LinkEntry.LINK, path: Path.parse(json.path) };
            case LinkEntry.DIRECTORY:
              return {
                type: LinkEntry.DIRECTORY,
                children: children.fromJson(json.children),
              };
            case LinkEntry.PATH:
              return {
                type: LinkEntry.PATH,
                path: json_1.JsonFormat.string().fromJson(json.value),
              };
          }
        },
        toJson(entry) {
          switch (entry.type) {
            case LinkEntry.LINK:
              return { type: LinkEntry.LINK, path: Path.text(entry.path) };
            case LinkEntry.PATH:
              return { type: LinkEntry.PATH, path: entry.path };
            case LinkEntry.DIRECTORY:
              return {
                type: LinkEntry.DIRECTORY,
                children: children.toJson(entry.children),
              };
          }
        },
      };
      children = json_1.JsonFormat.map(
        json_1.JsonFormat.string(),
        json_1.JsonFormat.defer(() => result),
      );
      return result;
    }
    LinkEntry.json = json;
  })((LinkEntry = exports.LinkEntry || (exports.LinkEntry = {})));
  var Path;
  (function (Path) {
    /**
     * Parse path from text
     */
    function parse(path) {
      if (!path.startsWith("/")) {
        throw new Error(`Path ${path} does not start with /`);
      }
      return path.slice(1).split("/");
    }
    Path.parse = parse;
    /**
     * Convert path to text
     */
    function text(path) {
      return `/${path.join("/")}`;
    }
    Path.text = text;
  })((Path = exports.Path || (exports.Path = {})));
  /**
   * Mounted part of link file system
   */
  class LinkMount {
    constructor(root) {
      this.root = root;
    }
    lookup(path, resolveLink) {
      let resolvedPath = [];
      for (let i = 0, entry = this.root; ; i++) {
        switch (entry.type) {
          case LinkEntry.DIRECTORY: {
            if (path.length <= i) {
              return { entry, path };
            }
            const newEntry = entry.children.get(path[i]);
            if (!newEntry) {
              return undefined;
            }
            resolvedPath.push(path[i]);
            entry = newEntry;
            break;
          }
          case LinkEntry.LINK:
            if (resolveLink || i < path.length - 1) {
              ({ entry, path: resolvedPath } = this.lookup(
                entry.path,
                resolveLink,
              ));
              continue;
            }
            return { entry, path };
          case LinkEntry.PATH:
            return {
              entry: {
                type: LinkEntry.PATH,
                path: path.slice(i).join("/") + entry.path,
              },
              path,
            };
        }
      }
    }
  }
  exports.LinkMount = LinkMount;
  /**
   * Link file system
   */
  class LinkFs {
    constructor() {
      this.mounts = new Map();
    }
    /**
     * Add mount
     */
    addMount(path, mount) {
      this.mounts.set(Path.text(path), mount);
    }
    _getMount(path) {
      let mount;
      let root;
      for (const [p, m] of this.mounts) {
        if (Path.text(path) === p || Path.text(path).startsWith(`${p}/`)) {
          mount = m;
          root = path;
        }
      }
      if (!mount) {
        return undefined;
      }
      return { path: path.slice(root.length + 1), root, mount };
    }
    /**
     * Get entry
     */
    entry(path) {
      const mount = this._getMount(path);
      if (mount === undefined) {
        return;
      }
      const resolved = mount.mount.lookup(mount.path, false);
      if (resolved === undefined) {
        return null;
      }
      if (resolved.entry.type === LinkEntry.LINK) {
        return {
          type: LinkEntry.LINK,
          path: [...mount.root, ...resolved.path],
        };
      }
      return resolved.entry;
    }
    realpath(path) {
      const mount = this._getMount(path);
      if (mount === undefined) {
        return;
      }
      const resolved = mount.mount.lookup(mount.path, true);
      if (resolved === undefined) {
        return null;
      }
      return resolved.path;
    }
    /**
     * Get and resolve entry
     * @return path or directory, null if does not exist, or undefined if not part of
     *   the virtual file system
     */
    resolve(path) {
      const mount = this._getMount(path);
      if (mount === undefined) {
        return;
      }
      const resolved = mount.mount.lookup(mount.path, true);
      if (resolved === undefined) {
        return null;
      }
      return resolved.entry;
    }
  }
  exports.LinkFs = LinkFs;
});
define("nodejs/shim/fs", [
  "require",
  "exports",
  "url",
  "fs",
  "stream",
  "path",
  "commonjs/fs/index",
], function (require, exports, url_1, fs, stream_1, path_1, commonjs_fs_1) {
  "use strict";
  Object.defineProperty(exports, "__esModule", { value: true });
  exports.patch = void 0;
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
  class NoopReadStream extends stream_1.Readable {
    constructor(path) {
      super();
      this.path = path;
    }
    get bytesRead() {
      return 0;
    }
    _read() {}
    close() {}
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
      return this.entry.type === commonjs_fs_1.LinkEntry.DIRECTORY;
    }
    isBlockDevice() {
      return false;
    }
    isCharacterDevice() {
      return false;
    }
    isSymbolicLink() {
      return this.entry.type === commonjs_fs_1.LinkEntry.LINK;
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
      return this.entry.type === commonjs_fs_1.LinkEntry.DIRECTORY;
    }
    isBlockDevice() {
      return false;
    }
    isCharacterDevice() {
      return false;
    }
    isSymbolicLink() {
      return this.entry.type === commonjs_fs_1.LinkEntry.LINK;
    }
    isFIFO() {
      return false;
    }
    isSocket() {
      return false;
    }
  }
  class LinkDir {
    constructor(link) {
      this.link = link;
      this.iterator = this.link.children.entries();
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
      } else {
        return Promise.resolve();
      }
    }
    closeSync() {}
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
    if (value instanceof url_1.URL) {
      if (value.protocol !== "file") {
        throw new Error(`Invalid protocol: ${value.protocol}`);
      }
      value = (0, url_1.fileURLToPath)(value);
    }
    return value;
  }
  function getPath(value) {
    value = stringPath(value);
    if (typeof value === "string") {
      return commonjs_fs_1.Path.parse((0, path_1.resolve)(value));
    }
    throw new Error(`Invalid path: ${value}`);
  }
  function access(linkFs, delegate) {
    function access(path, mode, callback) {
      const fsPath = getPath(path);
      if (typeof mode === "function") {
        callback = mode;
        mode = fs.constants.F_OK;
      }
      const resolved = linkFs.resolve(fsPath);
      if (resolved === undefined) {
        return delegate.apply(this, arguments);
      }
      if (resolved === null) {
        callback(new NotFoundError(stringPath(path), "access"));
      } else {
        switch (resolved.type) {
          case commonjs_fs_1.LinkEntry.DIRECTORY:
            if (mode & fs.constants.W_OK) {
              callback(new AccessError(stringPath(path), "access"));
            } else {
              callback(null);
            }
            break;
          case commonjs_fs_1.LinkEntry.PATH:
            const args = [...arguments];
            args[0] = resolved.path;
            return delegate.apply(this, args);
        }
      }
    }
    return addPromisify(access);
  }
  function accessSync(linkFs, delegate) {
    return function (path, mode) {
      const fsPath = getPath(path);
      mode = mode || fs.constants.F_OK;
      const resolved = linkFs.resolve(fsPath);
      if (resolved === undefined) {
        return delegate.apply(this, arguments);
      }
      if (resolved === null) {
        throw new NotFoundError(stringPath(path), "access");
      } else {
        switch (resolved.type) {
          case commonjs_fs_1.LinkEntry.DIRECTORY:
            if (mode & fs.constants.W_OK) {
              throw new AccessError(stringPath(path), "access");
            }
            break;
          case commonjs_fs_1.LinkEntry.PATH:
            const args = [...arguments];
            args[0] = resolved.path;
            return delegate.apply(this, args);
        }
      }
    };
  }
  function appendFile(linkFs, delegate) {
    function appendFile(file, data, options, callback) {
      if (typeof file === "number") {
        return delegate.apply(this, arguments);
      }
      const filePath = getPath(file);
      const resolved = linkFs.resolve(filePath);
      if (resolved === undefined) {
        return delegate.apply(this, arguments);
      }
      if (typeof options === "function") {
        callback = options;
      }
      if (resolved === null) {
        callback(null);
      } else {
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
      const path = getPath(file);
      const resolved = linkFs.resolve(path);
      if (resolved == undefined) {
        return delegate.apply(this, arguments);
      }
      if (resolved === null) {
        throw new NotFoundError(stringPath(file), "appendfile");
      }
      throw new AccessError(stringPath(file), "appendfile");
    };
  }
  function chmod(linkFs, delegate) {
    function chmod(path, mode, callback) {
      const fsPath = getPath(path);
      const resolved = linkFs.resolve(fsPath);
      if (resolved === undefined) {
        return delegate.apply(this, arguments);
      }
      if (resolved === null) {
        callback(new NotFoundError(stringPath(path), "chmod"));
      } else {
        callback(new AccessError(stringPath(path), "chmod"));
      }
    }
    return addPromisify(chmod);
  }
  function chmodSync(linkFs, delegate) {
    return function (path) {
      const fsPath = getPath(path);
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
      const fsPath = getPath(path);
      const resolved = linkFs.resolve(fsPath);
      if (resolved === undefined) {
        return delegate.apply(this, arguments);
      }
      if (resolved === null) {
        callback(new NotFoundError(stringPath(path), "chown"));
      } else {
        callback(new AccessError(stringPath(path), "chown"));
      }
    }
    return addPromisify(chown);
  }
  function chownSync(linkFs, delegate) {
    return function (path) {
      const fsPath = getPath(path);
      const resolved = linkFs.entry(fsPath);
      if (resolved !== undefined) {
        throw new AccessError(stringPath(path), "chown");
      }
      return delegate.apply(this, arguments);
    };
  }
  function copyFile(linkFs, delegate) {
    function copyFile(src, dest, flags, callback) {
      const destPath = getPath(dest);
      const srcPath = getPath(src);
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
      if (resolvedSrc === null) {
        callback(new NotFoundError(stringPath(src), "copyfile"));
        return;
      }
      switch (resolvedSrc.type) {
        case commonjs_fs_1.LinkEntry.DIRECTORY:
          callback(new IsDirError(stringPath(src), "copyfile"));
          break;
        case commonjs_fs_1.LinkEntry.PATH:
          const args = [...arguments];
          args[0] = resolvedSrc.path;
          return delegate.apply(this, args);
      }
    }
    return addPromisify(copyFile);
  }
  function createReadStream(linkFs, delegate) {
    return function (path) {
      const filePath = getPath(path);
      const resolved = linkFs.resolve(filePath);
      if (resolved === undefined) {
        return delegate.apply(this, arguments);
      }
      if (resolved == null) {
        return errorReadStream(
          stringPath(path),
          new NotFoundError(stringPath(path), "read"),
        );
      }
      switch (resolved.type) {
        case commonjs_fs_1.LinkEntry.DIRECTORY: {
          return errorReadStream(
            stringPath(path),
            new IsDirError(stringPath(path), "read"),
          );
        }
        case commonjs_fs_1.LinkEntry.PATH: {
          const args = [...arguments];
          args[0] = resolved.path;
          return delegate.apply(this, args);
        }
      }
    };
  }
  function createWriteStream(linkFs, delegate) {
    return function (path) {
      const filePath = getPath(path);
      const resolved = linkFs.resolve(filePath);
      if (resolved === undefined) {
        return delegate.apply(this, arguments);
      }
      return errorReadStream(
        stringPath(path),
        new AccessError(stringPath(path), "read"),
      );
    };
  }
  function copyFileSync(linkFs, delegate) {
    return function (src, dest, flags) {
      const srcPath = getPath(src);
      const destPath = getPath(dest);
      const resolvedSrc = linkFs.resolve(srcPath);
      const resolvedDest = linkFs.resolve(destPath);
      if (resolvedSrc === undefined && resolvedDest === undefined) {
        return delegate.apply(this, arguments);
      }
      if (resolvedDest !== undefined) {
        throw new AccessError(stringPath(dest), "copyfile");
      }
      if (resolvedSrc === null) {
        throw new NotFoundError(stringPath(src), "copyfile");
      }
      switch (resolvedSrc.type) {
        case commonjs_fs_1.LinkEntry.DIRECTORY:
          throw new IsDirError(stringPath(src), "copyfile");
        case commonjs_fs_1.LinkEntry.PATH:
          const args = [...arguments];
          args[0] = resolvedSrc.path;
          return delegate.apply(this, args);
      }
    };
  }
  function exists(linkFs, delegate) {
    function exists(path, callback) {
      const filePath = getPath(path);
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
        case commonjs_fs_1.LinkEntry.DIRECTORY:
          callback(true);
          break;
        case commonjs_fs_1.LinkEntry.PATH:
          const args = [...arguments];
          args[0] = resolved.path;
          return delegate.apply(this, args);
      }
    }
    return addPromisify(exists);
  }
  function dirEntry(name, linkEntry) {
    switch (linkEntry.type) {
      case commonjs_fs_1.LinkEntry.DIRECTORY:
        return new fs.Dir(name, fsConstants.UV_DIRENT_DIR);
      case commonjs_fs_1.LinkEntry.LINK:
        return new fs.Dir(name, fsConstants.UV_DIRENT_LINK);
      case commonjs_fs_1.LinkEntry.DIRECTORY:
        return new fs.Dir(name, fsConstants.UV_DIRENT_FILE);
    }
  }
  function existsSync(linkFs, delegate) {
    return function (path) {
      const filePath = getPath(path);
      const resolved = linkFs.resolve(filePath);
      if (resolved === undefined) {
        return delegate.apply(this, arguments);
      }
      if (resolved === null) {
        return false;
      }
      switch (resolved.type) {
        case commonjs_fs_1.LinkEntry.DIRECTORY:
          return true;
        case commonjs_fs_1.LinkEntry.PATH:
          const args = [...arguments];
          args[0] = resolved.path;
          return delegate.apply(this, args);
      }
    };
  }
  function mkdir(linkFs, delegate) {
    function mkdir(path, options, callback) {
      const filePath = getPath(path);
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
    return (path) => {
      const filePath = getPath(path);
      const resolved = linkFs.resolve(filePath);
      if (resolved === undefined) {
        return delegate.apply(this, arguments);
      }
      throw new AccessError(stringPath(path), "mkdir");
    };
  }
  function mkdtemp(linkFs, delegate) {
    function mkdtemp(path, options, callback) {
      const filePath = getPath(path);
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
    return (path) => {
      const filePath = getPath(path);
      const resolved = linkFs.resolve(filePath);
      if (resolved === undefined) {
        return delegate.apply(this, arguments);
      }
      throw new AccessError(stringPath(path), "mkdtemp");
    };
  }
  function open(linkFs, delegate) {
    function open(path, flags, mode, callback) {
      const filePath = getPath(path);
      const resolved = linkFs.resolve(filePath);
      if (resolved === undefined) {
        return delegate.apply(this, arguments);
      }
      if (typeof mode === "function") {
        callback = mode;
      }
      switch (resolved.type) {
        case commonjs_fs_1.LinkEntry.DIRECTORY:
          callback(new AccessError(path, "open"), undefined);
          return;
        case commonjs_fs_1.LinkEntry.PATH:
          const args = [...arguments];
          args[0] = resolved.path;
          return delegate.apply(this, args);
      }
    }
    return addPromisify(open);
  }
  function openSync(linkFs, delegate) {
    return function (path) {
      const filePath = getPath(path);
      const resolved = linkFs.resolve(filePath);
      if (resolved === undefined) {
        return delegate.apply(this, arguments);
      }
      switch (resolved.type) {
        case commonjs_fs_1.LinkEntry.DIRECTORY:
          throw new AccessError(stringPath(path), "open");
        case commonjs_fs_1.LinkEntry.PATH:
          const args = [...arguments];
          args[0] = resolved.path;
          return delegate.apply(this, args);
      }
    };
  }
  function opendir(linkFs, delegate) {
    function opendir(path, options, callback) {
      const filePath = getPath(path);
      const resolved = linkFs.resolve(filePath);
      if (resolved === undefined) {
        return delegate.apply(this, arguments);
      }
      if (typeof options === "function") {
        callback = options;
      }
      switch (resolved.type) {
        case commonjs_fs_1.LinkEntry.DIRECTORY:
          callback(null, new LinkDir(resolved));
          return;
        case commonjs_fs_1.LinkEntry.PATH:
          callback(new InvalidError(path, "opendir"), null);
          return;
      }
    }
    return addPromisify(opendir);
  }
  function opendirSync(linkFs, delegate) {
    return function (path) {
      const filePath = getPath(path);
      const resolved = linkFs.resolve(filePath);
      if (resolved === undefined) {
        return delegate.apply(this, arguments);
      }
      switch (resolved.type) {
        case commonjs_fs_1.LinkEntry.DIRECTORY:
          return new LinkDir(resolved);
        case commonjs_fs_1.LinkEntry.PATH:
          throw new InvalidError(path, "opendir");
      }
    };
  }
  function readdir(linkFs, delegate) {
    function readdir(path, options, callback) {
      const filePath = getPath(path);
      const resolved = linkFs.resolve(filePath);
      if (resolved === undefined) {
        return delegate.apply(this, arguments);
      }
      if (typeof options === "function") {
        callback = options;
      }
      if (resolved === null) {
        callback(new NotFoundError(stringPath(path), "readdir"), undefined);
      }
      switch (resolved.type) {
        case commonjs_fs_1.LinkEntry.DIRECTORY:
          callback(undefined, [...resolved.children.keys()]);
          break;
        case commonjs_fs_1.LinkEntry.PATH:
          callback(new InvalidError(stringPath(path), "readdir"), undefined);
          break;
      }
    }
    return addPromisify(readdir);
  }
  function readdirSync(linkFs, delegate) {
    return function (path, options) {
      const filePath = getPath(path);
      const resolved = linkFs.resolve(filePath);
      if (resolved === undefined) {
        return delegate.apply(this, arguments);
      }
      if (resolved === null) {
        throw new NotFoundError(stringPath(path), "readdir");
      }
      switch (resolved.type) {
        case commonjs_fs_1.LinkEntry.DIRECTORY:
          return [...resolved.children.keys()];
        case commonjs_fs_1.LinkEntry.PATH:
          throw new InvalidError(stringPath(path), "readdir");
      }
    };
  }
  function readFile(linkFs, delegate) {
    function readFile(path, options, callback) {
      if (typeof path === "number") {
        return delegate.apply(this, arguments);
      }
      const filePath = getPath(path);
      const resolved = linkFs.resolve(filePath);
      if (resolved === undefined) {
        return delegate.apply(this, arguments);
      }
      if (typeof options === "function") {
        callback = options;
      }
      if (resolved === null) {
        callback(new NotFoundError(stringPath(path), "readfile"), undefined);
      }
      switch (resolved.type) {
        case commonjs_fs_1.LinkEntry.DIRECTORY:
          callback(new InvalidError(stringPath(path), "readlink"), undefined);
          break;
        case commonjs_fs_1.LinkEntry.PATH:
          const args = [...arguments];
          args[0] = resolved;
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
      const filePath = getPath(path);
      const resolved = linkFs.resolve(filePath);
      if (resolved === undefined) {
        return delegate.apply(this, arguments);
      }
      if (resolved === null) {
        throw new NotFoundError(stringPath(path), "readfile");
      }
      switch (resolved.type) {
        case commonjs_fs_1.LinkEntry.DIRECTORY:
          throw new InvalidError(stringPath(path), "readlink");
        case commonjs_fs_1.LinkEntry.PATH:
          const args = [...arguments];
          args[0] = resolved;
          return delegate.apply(this, args);
      }
    };
  }
  function readlink(linkFs, delegate) {
    function readlink(path, options, callback) {
      const filePath = getPath(path);
      const resolved = linkFs.entry(filePath);
      if (resolved === undefined) {
        return delegate.apply(this, arguments);
      }
      if (typeof options === "function") {
        callback = options;
      }
      if (resolved === null) {
        callback(new NotFoundError(stringPath(path), "readlink"), undefined);
        return;
      }
      switch (resolved.type) {
        case commonjs_fs_1.LinkEntry.DIRECTORY:
        case commonjs_fs_1.LinkEntry.PATH:
          callback(new InvalidError(stringPath(path), "readlink"), undefined);
          return;
        case commonjs_fs_1.LinkEntry.LINK:
          callback(null, resolved.path.join("/"));
          return;
      }
    }
    return addPromisify(readlink);
  }
  function readlinkSync(linkFs, delegate) {
    return (path, options) => {
      const filePath = getPath(path);
      const resolved = linkFs.entry(filePath);
      if (resolved === undefined) {
        return delegate.apply(this, arguments);
      }
      if (resolved === null) {
        throw new NotFoundError(stringPath(path), "readlink");
      }
      switch (resolved.type) {
        case commonjs_fs_1.LinkEntry.DIRECTORY:
        case commonjs_fs_1.LinkEntry.PATH:
          throw new InvalidError(stringPath(path), "readlink");
        case commonjs_fs_1.LinkEntry.LINK:
          return resolved.path;
      }
    };
  }
  function realpath(linkFs, delegate) {
    function realpath(path, options, callback) {
      const filePath = getPath(path);
      if (typeof options === "function") {
        callback = options;
      }
      const resolved = linkFs.entry(filePath);
      if (resolved === undefined) {
        return delegate.apply(this, arguments);
      }
      if (resolved === null) {
        callback(new NotFoundError(stringPath(path), "lstat"), undefined);
        return;
      }
      switch (resolved.type) {
        case commonjs_fs_1.LinkEntry.DIRECTORY:
        case commonjs_fs_1.LinkEntry.PATH:
          callback(null, stringPath(path));
          return;
        case commonjs_fs_1.LinkEntry.LINK:
          callback(null, resolved.path.join("/"));
          return;
      }
    }
    realpath.native = delegate.native;
    return addPromisify(realpath);
  }
  function realpathSync(linkFs, delegate) {
    function realpathSync(path) {
      const filePath = getPath(path);
      const resolved = linkFs.entry(filePath);
      if (resolved === undefined) {
        return delegate.apply(this, arguments);
      }
      if (resolved === null) {
        throw new NotFoundError(stringPath(path), "lstat");
      }
      switch (resolved.type) {
        case commonjs_fs_1.LinkEntry.DIRECTORY:
          return stringPath(path);
        case commonjs_fs_1.LinkEntry.PATH:
          return resolved.path;
        case commonjs_fs_1.LinkEntry.LINK:
      }
    }
    realpathSync.native = delegate.native;
    return realpathSync;
  }
  function rename(linkFs, delegate) {
    function rename(oldPath, newPath, callback) {
      const oldFilePath = getPath(oldPath);
      const newFilePath = getPath(newPath);
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
      const oldFilePath = getPath(oldPath);
      const newFilePath = getPath(newPath);
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
      const filePath = getPath(path);
      const resolved = linkFs.resolve(filePath);
      if (resolved === undefined) {
        return delegate.apply(this, arguments);
      }
      if (typeof options === "function") {
        callback = options;
      }
      if (resolved === null) {
        return callback(new NotFoundError(stringPath(path), "rmdir"));
      }
      callback(new AccessError(stringPath(path), "rmdir"));
    }
    return addPromisify(rmdir);
  }
  function rmdirSync(linkFs, delegate) {
    return function (path) {
      const filePath = getPath(path);
      const resolved = linkFs.resolve(filePath);
      if (resolved === undefined) {
        return delegate.apply(this, arguments);
      }
      if (resolved === null) {
        throw new NotFoundError(stringPath(path), "rmdir");
      }
      throw new AccessError(stringPath(path), "rmdir");
    };
  }
  function stat(linkFs, delegate) {
    function stat(path, options, callback) {
      const filePath = getPath(path);
      const resolved = linkFs.resolve(filePath);
      if (resolved === undefined) {
        return delegate.apply(this, arguments);
      }
      if (typeof options === "function") {
        callback = options;
        options = undefined;
      }
      const bigint = options && options.bigint;
      if (resolved === null) {
        callback(new NotFoundError(stringPath(path), "stat"), null);
        return;
      }
      switch (resolved.type) {
        case commonjs_fs_1.LinkEntry.DIRECTORY:
          callback(
            null,
            bigint ? new LinkBigintStat(resolved) : new LinkStat(resolved),
          );
          return;
        case commonjs_fs_1.LinkEntry.PATH:
          const args = [...arguments];
          args[0] = path;
          return delegate.apply(this, arguments);
      }
    }
    return addPromisify(stat);
  }
  function statSync(linkFs, delegate) {
    function statSync(path, options) {
      const filePath = getPath(path);
      const resolved = linkFs.resolve(filePath);
      if (resolved === undefined) {
        return delegate.apply(this, arguments);
      }
      const bigint = options && options.bigint;
      if (resolved === null) {
        throw new NotFoundError(stringPath(path), "stat");
      }
      switch (resolved.type) {
        case commonjs_fs_1.LinkEntry.DIRECTORY:
          return bigint ? new LinkBigintStat(resolved) : new LinkStat(resolved);
        case commonjs_fs_1.LinkEntry.PATH:
          const args = [...arguments];
          args[0] = path;
          return delegate.apply(this, arguments);
      }
    }
    return statSync;
  }
  function symlink(linkFs, delegate) {
    function symlink(target, path, type, callback) {
      const targetPath = getPath(target);
      const filePath = getPath(path);
      const targetResolved = linkFs.resolve(targetPath);
      const pathResolved = linkFs.resolve(filePath);
      if (targetResolved === undefined && pathResolved === undefined) {
        return delegate.apply(this.arguments);
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
    return (target, path) => {
      const targetPath = getPath(target);
      const filePath = getPath(path);
      const targetResolved = linkFs.resolve(targetPath);
      const pathResolved = linkFs.resolve(filePath);
      if (targetResolved === undefined && pathResolved === undefined) {
        return delegate.apply(this.arguments);
      }
      if (pathResolved !== undefined) {
        throw new AccessError(stringPath(path), "symlink");
      }
      throw new AccessError(stringPath(target), "symlink");
    };
  }
  function truncate(linkFs, delegate) {
    function truncate(path, len, callback) {
      const filePath = getPath(path);
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
      const filePath = getPath(path);
      const resolved = linkFs.resolve(filePath);
      if (resolved === undefined) {
        return delegate.apply(this, arguments);
      }
      throw new AccessError(stringPath(path), "truncate");
    };
  }
  function unlink(linkFs, delegate) {
    function unlink(path, callback) {
      const filePath = getPath(path);
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
      const filePath = getPath(path);
      const resolved = linkFs.resolve(filePath);
      if (resolved === undefined) {
        return delegate.apply(this, arguments);
      }
      throw new AccessError(stringPath(path), "unlink");
    };
  }
  function utimes(linkFs, delegate) {
    function utimes(path, atime, mtime, callback) {
      const filePath = getPath(path);
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
      const filePath = getPath(path);
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
      const filePath = getPath(path);
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
      const filePath = getPath(path);
      const resolved = linkFs.resolve(filePath);
      if (resolved === undefined) {
        return delegate.apply(this, arguments);
      }
      throw new AccessError(stringPath(path), "writeFile");
    };
  }
  function patch(linkFs, delegate) {
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
    delegate.createReadStream = createReadStream(
      linkFs,
      delegate.createReadStream,
    );
    delegate.createWriteStream = createWriteStream(
      linkFs,
      delegate.createWriteStream,
    );
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
    delegate.lstat;
    delegate.lstatSync;
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
  exports.patch = patch;
});
define("nodejs/runfile/init", ["require", "exports", "fs"], function (
  require,
  exports,
  fs,
) {
  "use strict";
  var _ManifestRunfiles_pathByName;
  Object.defineProperty(exports, "__esModule", { value: true });
  const BAZEL_WORKSPACE = process.env["BAZEL_WORKSPACE"];
  const RUNFILES_DIR = process.env["RUNFILES_DIR"];
  const RUNFILES_MANIFEST = process.env["RUNFILES_MANIFEST_FILE"];
  /**
   * Bazel has symlinks
   */
  class SymlinkRunfiles {
    constructor(runfilesDir) {
      this.runfilesDir = runfilesDir;
    }
    getPath(name) {
      return `${this.runfilesDir}/${name}`;
    }
  }
  /**
   * Uses a manifest
   */
  class ManifestRunfiles {
    constructor(workspace, dir) {
      this.workspace = workspace;
      this.dir = dir;
      _ManifestRunfiles_pathByName.set(this, new Map());
    }
    addRunfile(name, path) {
      __classPrivateFieldGet(this, _ManifestRunfiles_pathByName, "f").set(
        name,
        path,
      );
    }
    getPath(name) {
      if (name.startsWith("../")) {
        name = `${name.slice("../".length)}`;
      } else {
        name = `${this.workspace}/${name}`;
      }
      const path = __classPrivateFieldGet(
        this,
        _ManifestRunfiles_pathByName,
        "f",
      ).get(name);
      if (!path) {
        throw new Error(`No runfile for ${name}`);
      }
      return path;
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
  _ManifestRunfiles_pathByName = new WeakMap();
  let runfiles;
  if (RUNFILES_MANIFEST) {
    runfiles = new ManifestRunfiles(BAZEL_WORKSPACE, RUNFILES_DIR);
    ManifestRunfiles.readManifest(runfiles, RUNFILES_MANIFEST);
  } else {
    runfiles = new SymlinkRunfiles(RUNFILES_DIR);
  }
  global.runfilePath = (name) => runfiles.getPath(name);
});
define("nodejs/shim/index", [
  "require",
  "exports",
  "fs",
  "commonjs/fs/index",
  "nodejs/shim/fs",
  "nodejs/runfile/init",
], function (require, exports, fs, commonjs_fs_2, fs_1) {
  "use strict";
  Object.defineProperty(exports, "__esModule", { value: true });
  const linkFs = new commonjs_fs_2.LinkFs();
  (0, fs_1.patch)(linkFs, fs);
  global.linkFsMount = (path, config) => {
    const entry = commonjs_fs_2.LinkEntry.json().fromJson(config);
    const mount = new commonjs_fs_2.LinkMount(entry);
    if (!path.startsWith("/")) {
      throw new Error("Must start with /");
    }
    linkFs.addMount(path.slice(1).split("/"), mount);
  };
});
