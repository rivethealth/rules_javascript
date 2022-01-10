import { URL, fileURLToPath } from "url";
import * as fs from "fs";
import { Vfs, VfsNode } from "./vfs";
import * as path from "path";

/**
 * @filedescription Node.js fs implementation of Vfs
 */

class LinkBigintStat implements fs.BigIntStats {
  constructor(private readonly entry: VfsNode) {}

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

  atime = new Date(0);
  atimeMs = 0n;
  atimeNs = 0n;
  birthtime = new Date(0);
  birthtimeMs = 0n;
  birthtimeNs = 0n;
  blksize = 1024n;
  blocks = 1n;
  ctime = new Date(0);
  ctimeMs = 0n;
  ctimeNs = 0n;
  dev = 0n;
  gid = 0n;
  ino = 0n;
  mode = 0o755n;
  mtime = new Date(0);
  mtimeMs = 0n;
  mtimeNs = 0n;
  nlink = 1n;
  rdev = 0n;
  size = 1024n;
  uid = 0n;
}

function invalidError(syscall: string, path: string) {
  const error = <NodeJS.ErrnoException>(
    new Error(`EINVAL: invalid argument, ${syscall}, ${path}`)
  );
  error.path = path;
  error.syscall = syscall;
  error.code = "EINVAL";
  error.errno = -22;
  return error;
}

class LinkStat implements fs.Stats {
  constructor(private readonly entry: VfsNode) {}

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

  atime = new Date(0);
  atimeMs = 0;
  birthtime = new Date(0);
  birthtimeMs = 0;
  blksize = 1024;
  blocks = 1;
  ctime = new Date(0);
  ctimeMs = 0;
  dev = 0;
  gid = 0;
  ino = 0;
  mode = 0o755;
  mtime = new Date(0);
  mtimeMs = 0;
  nlink = 1;
  rdev = 0;
  size = 1024;
  uid = 0;
}

class VfsDir implements fs.Dir {
  constructor(
    private readonly dir: VfsNode.Path,
    private readonly delegate: fs.Dir | undefined,
  ) {}

  private extraIterator: Iterator<[string, VfsNode]> | undefined = undefined;

  readonly path: string;

  [Symbol.asyncIterator](): AsyncIterableIterator<fs.Dirent> {
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

  close(): Promise<void>;
  close(cb: fs.NoParamCallback): void;
  close(cb?: fs.NoParamCallback): Promise<void> | void {
    if (this.delegate !== undefined) {
      return this.delegate.close.apply(this.delegate, arguments);
    }
    if (cb) {
      setImmediate(() => cb(undefined));
    } else {
      return Promise.resolve();
    }
  }

  closeSync() {
    if (this.delegate !== undefined) {
      return this.delegate.closeSync.apply(this.delegate, arguments);
    }
  }

  read(): Promise<fs.Dirent | null>;
  read(
    cb: (err: NodeJS.ErrnoException | null, dirEnt: fs.Dirent | null) => void,
  ): void;
  read(
    cb?: (err: NodeJS.ErrnoException | null, dirEnt: fs.Dirent | null) => void,
  ): Promise<fs.Dirent | null> | void {
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
          } else {
            cb(null, dirent(entry.value[0], entry.value[1]));
          }
        });
      } else {
        if (this.extraIterator === undefined) {
          this.extraIterator = this.dir.extraChildren.entries();
        }
        const entry = this.extraIterator.next();
        if (entry.done) {
          setImmediate(() => cb(null, null));
        } else {
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

  readSync(): fs.Dirent | null {
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

function dirent(name: string, entry: VfsNode): fs.Dirent {
  switch (entry.type) {
    case VfsNode.PATH:
      return new (<any>fs.Dirent)(name, (<any>fs.constants).UV_DIRENT_DIR);
    case VfsNode.SYMLINK:
      return new (<any>fs.Dirent)(name, (<any>fs.constants).UV_DIRENT_LINK);
  }
}

export function stringPath(value: fs.PathLike): string {
  if (value instanceof Buffer) {
    value = value.toString();
  }
  if (value instanceof URL) {
    if (value.protocol !== "file:") {
      throw new Error(`Invalid protocol: ${value.protocol}`);
    }
    value = fileURLToPath(value);
  }
  return path.resolve(value);
}

export function replaceArguments<F extends Function>(
  vfs: Vfs,
  fn: F,
  indicies: number[],
): F {
  return <F>(<Function>function () {
    const args = [...arguments];
    for (const index of indicies) {
      const path = stringPath(args[index]);
      const resolved = vfs.resolve(path);
      if (resolved !== undefined && path !== resolved.path) {
        args[index] = resolved.path;
      }
    }
    return fn.apply(this, args);
  });
}

function access(vfs: Vfs, delegate: typeof fs.access): typeof fs.access {
  return replaceArguments(vfs, delegate, [0]);
}

function accessSync(
  vfs: Vfs,
  delegate: typeof fs.accessSync,
): typeof fs.accessSync {
  return replaceArguments(vfs, delegate, [0]);
}

function appendFile(
  vfs: Vfs,
  delegate: typeof fs.appendFile,
): typeof fs.appendFile {
  return replaceArguments(vfs, delegate, [0]);
}

function appendFileSync(
  vfs: Vfs,
  delegate: typeof fs.appendFileSync,
): typeof fs.appendFileSync {
  return replaceArguments(vfs, delegate, [0]);
}

function chmod(vfs: Vfs, delegate: typeof fs.chmod): typeof fs.chmod {
  return replaceArguments(vfs, delegate, [0]);
}

function chmodSync(
  vfs: Vfs,
  delegate: typeof fs.chmodSync,
): typeof fs.chmodSync {
  return replaceArguments(vfs, delegate, [0]);
}

function chown(vfs: Vfs, delegate: typeof fs.chown): typeof fs.chown {
  return replaceArguments(vfs, delegate, [0]);
}

function chownSync(
  vfs: Vfs,
  delegate: typeof fs.chownSync,
): typeof fs.chownSync {
  return replaceArguments(vfs, delegate, [0]);
}

function copyFile(vfs: Vfs, delegate: typeof fs.copyFile): typeof fs.copyFile {
  return replaceArguments(vfs, delegate, [0, 1]);
}

function copyFileSync(
  vfs: Vfs,
  delegate: typeof fs.copyFileSync,
): typeof fs.copyFileSync {
  return replaceArguments(vfs, delegate, [0, 1]);
}

function createReadStream(
  vfs: Vfs,
  delegate: typeof fs.createReadStream,
): typeof fs.createReadStream {
  return replaceArguments(vfs, delegate, [0]);
}

function createWriteStream(
  vfs: Vfs,
  delegate: typeof fs.createWriteStream,
): typeof fs.createWriteStream {
  return replaceArguments(vfs, delegate, [0]);
}

function exists(vfs: Vfs, delegate: typeof fs.exists): typeof fs.exists {
  return replaceArguments(vfs, delegate, [0]);
}

function existsSync(
  vfs: Vfs,
  delegate: typeof fs.existsSync,
): typeof fs.existsSync {
  return replaceArguments(vfs, delegate, [0]);
}

function link(vfs: Vfs, delegate: typeof fs.link) {
  return replaceArguments(vfs, delegate, [0, 1]);
}

function linkSync(vfs: Vfs, delegate: typeof fs.linkSync) {
  return replaceArguments(vfs, delegate, [0, 1]);
}

function lstat(vfs: Vfs, delegate: typeof fs.lstat) {
  return <typeof fs.stat>(
    function (path: fs.PathLike, options: any, callback?: Function) {
      const filePath = stringPath(path);
      const resolved = vfs.entry(filePath);
      if (typeof options === "function") {
        callback = options;
        options = {};
      }
      if (resolved) {
        if (resolved.type === VfsNode.SYMLINK || resolved.path === undefined) {
          setImmediate(() =>
            callback(
              null,
              options.bigint
                ? new LinkBigintStat(resolved)
                : new LinkStat(resolved),
            ),
          );
        } else if (resolved.hardenSymlinks) {
          fs.stat(resolved.path, options, <any>callback);
          return;
        }
      }
      const args = [...arguments];
      if (resolved && filePath !== resolved.path) {
        args[0] = resolved.path;
      }
      return delegate.apply(this, arguments);
    }
  );
}

function lstatSync(
  vfs: Vfs,
  delegate: typeof fs.lstatSync,
): typeof fs.lstatSync {
  return <typeof fs.statSync>(
    function (
      path: fs.PathLike,
      options?: any,
    ): fs.Stats | fs.BigIntStats | undefined {
      const filePath = stringPath(path);
      const resolved = vfs.entry(filePath);
      if (resolved) {
        if (resolved.type === VfsNode.SYMLINK || resolved.path === undefined) {
          return options.bigint
            ? new LinkBigintStat(resolved)
            : new LinkStat(resolved);
        } else if (resolved.hardenSymlinks) {
          return fs.statSync(resolved.path, options);
        }
      }
      const args = [...arguments];
      if (resolved && filePath !== resolved.path) {
        args[0] = resolved.path;
      }
      return delegate.apply(this, arguments);
    }
  );
}

function mkdir(vfs: Vfs, delegate: typeof fs.mkdir): typeof fs.mkdir {
  return replaceArguments(vfs, delegate, [0]);
}

function mkdirSync(
  vfs: Vfs,
  delegate: typeof fs.mkdirSync,
): typeof fs.mkdirSync {
  return replaceArguments(vfs, delegate, [0]);
}

function open(vfs: Vfs, delegate: typeof fs.open): typeof fs.open {
  return <any>function (path: fs.PathLike) {
    const filePath = stringPath(path);
    const resolved = vfs.resolve(filePath);
    const args = [...arguments];
    if (resolved && resolved.path === undefined) {
      const args = [...arguments];
      args[0] = "/";
    } else if (resolved && filePath !== resolved.path) {
      args[0] = resolved.path;
    }
    return delegate.apply(this, args);
  };
}

function openSync(vfs: Vfs, delegate: typeof fs.openSync): typeof fs.openSync {
  return function (path: fs.PathLike) {
    const filePath = stringPath(path);
    const resolved = vfs.resolve(filePath);
    const args = [...arguments];
    if (resolved && resolved.path === undefined) {
      const args = [...arguments];
      args[0] = "/";
    } else if (resolved && filePath !== resolved.path) {
      args[0] = resolved.path;
    }
    return delegate.apply(this, args);
  };
}

function opendir(vfs: Vfs, delegate: typeof fs.opendir): typeof fs.opendir {
  return <typeof fs.opendir>(
    function (path: string, options: any, callback?: Function) {
      const filePath = stringPath(path);
      if (typeof options === "function") {
        callback = options;
      }
      const resolved = vfs.resolve(filePath);
      if (resolved && resolved.path === undefined) {
        setImmediate(() =>
          callback(null, new VfsDir(<VfsNode.Path>resolved, undefined)),
        );
        return;
      }
      const args = [...arguments];
      if (resolved && filePath !== resolved.path) {
        args[0] = resolved.path;
      }
      if (resolved && resolved.extraChildren.size) {
        args[typeof args[1] === "function" ? 1 : 2] = function (
          err: NodeJS.ErrnoException | null,
          dir?: fs.Dir,
        ) {
          if (err) {
            return callback.apply(this, arguments);
          }
          callback(null, new VfsDir(resolved, dir));
        };
      }
      return delegate.apply(this, args);
    }
  );
}

function opendirSync(
  vfs: Vfs,
  delegate: typeof fs.opendirSync,
): typeof fs.opendirSync {
  return function (path) {
    const filePath = stringPath(path);
    const resolved = vfs.resolve(filePath);
    if (resolved && resolved.path === undefined) {
      return new VfsDir(<VfsNode.Path>resolved, undefined);
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

function readdir(vfs: Vfs, delegate: typeof fs.readdir): typeof fs.readdir {
  return <any>function (path: fs.PathLike, options: any, callback?: Function) {
    const filePath = stringPath(path);
    if (typeof options === "function") {
      callback = options;
      options = {};
    } else if (typeof options === "string") {
      options = { encoding: options };
    } else if (options == null) {
      options = {};
    }
    const resolved = vfs.resolve(filePath);
    let extra: fs.Dirent[] | Buffer[] | string[] = [];
    if (resolved && resolved.extraChildren.size) {
      if (options.withFileTypes) {
        extra = [...(<VfsNode.Path>resolved).extraChildren.entries()].map(
          ([name, entry]) => dirent(name, entry),
        );
      } else if (options.encoding === "buffer") {
        extra = [...(<VfsNode.Path>resolved).extraChildren.keys()].map((name) =>
          Buffer.from(name),
        );
      } else {
        extra = [...(<VfsNode.Path>resolved).extraChildren.keys()];
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
    args[typeof args[1] === "function" ? 1 : 2] = function (
      err: NodeJS.ErrnoException | null,
      files?: fs.Dirent[] | Buffer[] | string[],
    ) {
      if (err) {
        return callback.apply(this, arguments);
      }
      if (options.withFileTypes && resolved.hardenSymlinks) {
        files = (<fs.Dirent[]>files).map((file) => {
          if (file.isSymbolicLink()) {
            try {
              const stat = fs.statSync(`${filePath}/${file.name}`);
              if (stat.isDirectory()) {
                return new (<any>fs.Dirent)(
                  file.name,
                  (<any>fs.constants).UV_DIRENT_DIR,
                );
              }
              return new (<any>fs.Dirent)(
                file.name,
                (<any>fs.constants).UV_DIRENT_FILE,
              );
            } catch {}
          }
          return file;
        });
      }
      callback(null, <fs.Dirent[] | Buffer[] | string[]>[...files, ...extra]);
    };
    return delegate.apply(this, args);
  };
}

function readdirSync(
  vfs: Vfs,
  delegate: typeof fs.readdirSync,
): typeof fs.readdirSync {
  return function (path, options) {
    const filePath = stringPath(path);
    if (typeof options === "string") {
      options = { encoding: options };
    } else if (options == null) {
      options = {};
    }
    const resolved = vfs.resolve(filePath);
    let extra: fs.Dirent[] | Buffer[] | string[] = [];
    if (resolved && resolved.extraChildren.size) {
      if (options.withFileTypes) {
        extra = [...(<VfsNode.Path>resolved).extraChildren.entries()].map(
          ([name, entry]) => dirent(name, entry),
        );
      } else if (options.encoding === "buffer") {
        extra = [...(<VfsNode.Path>resolved).extraChildren.keys()].map((name) =>
          Buffer.from(name),
        );
      } else {
        extra = [...(<VfsNode.Path>resolved).extraChildren.keys()];
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
      result = (<fs.Dirent[]>result).map((file) => {
        if (file.isSymbolicLink()) {
          try {
            const stat = fs.statSync(`${filePath}/${file.name}`);
            if (stat.isDirectory()) {
              return new (<any>fs.Dirent)(
                file.name,
                (<any>fs.constants).UV_DIRENT_DIR,
              );
            }
            return new (<any>fs.Dirent)(
              file.name,
              (<any>fs.constants).UV_DIRENT_FILE,
            );
          } catch {}
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

function readFile(vfs: Vfs, delegate: typeof fs.readFile): typeof fs.readFile {
  return replaceArguments(vfs, delegate, [0]);
}

function readFileSync(
  vfs: Vfs,
  delegate: typeof fs.readFileSync,
): typeof fs.readFileSync {
  return replaceArguments(vfs, delegate, [0]);
}

function readlink(vfs: Vfs, delegate: typeof fs.readlink): typeof fs.readlink {
  return <any>function (path: fs.PathLike, options: any, callback?: Function) {
    const filePath = stringPath(path);
    if (typeof options === "function") {
      callback = options;
      options = {};
    } else if (typeof options === "string") {
      options = { encoding: options };
    } else {
      options = {};
    }
    const resolved = vfs.entry(filePath);
    if (resolved.type === VfsNode.SYMLINK) {
      if (options.encoding === "buffer") {
        setImmediate(() => callback(null, Buffer.from(resolved.path)));
      } else {
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

function readlinkSync(
  vfs: Vfs,
  delegate: typeof fs.readlinkSync,
): typeof fs.readlinkSync {
  return function (path: fs.PathLike, options: any) {
    const filePath = stringPath(path);
    if (typeof options === "string") {
      options = { encoding: options };
    } else {
      options = {};
    }
    const resolved = vfs.entry(filePath);
    if (resolved.type === VfsNode.SYMLINK) {
      if (options.encoding === "buffer") {
        return Buffer.from(resolved.path);
      } else {
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

function realpath(vfs: Vfs, delegate: typeof fs.realpath): typeof fs.realpath {
  function realpath(
    path: fs.PathLike,
    options: any,
    callback?: Function,
  ): void {
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
        } else {
          callback(
            null,
            options === "buffer" ? Buffer.from(resolved.path) : resolved.path,
          );
        }
      };
    }
    delegate.apply(this, args);
  }
  realpath.native = function (
    path: fs.PathLike,
    options: any,
    callback?: Function,
  ): void {
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
        } else {
          callback(
            null,
            options === "buffer" ? Buffer.from(resolved.path) : resolved.path,
          );
        }
      };
    }
    delegate.native.apply(this, args);
  };
  return <typeof fs.realpath>realpath;
}

function realpathSync(
  vfs: Vfs,
  delegate: typeof fs.realpathSync,
): typeof fs.realpathSync {
  function realpathSync(path: fs.PathLike, options: string): Buffer | string {
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
  realpathSync.native = function (
    path: fs.PathLike,
    options: string,
  ): Buffer | string {
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
  return <typeof fs.realpathSync>realpathSync;
}

function rename(vfs: Vfs, delegate: typeof fs.rename): typeof fs.rename {
  return replaceArguments(vfs, delegate, [0, 1]);
}

function renameSync(
  vfs: Vfs,
  delegate: typeof fs.renameSync,
): typeof fs.renameSync {
  return replaceArguments(vfs, delegate, [0, 1]);
}

function rm(vfs: Vfs, delegate: typeof fs.rm): typeof fs.rm {
  return replaceArguments(vfs, delegate, [0]);
}

function rmSync(vfs: Vfs, delegate: typeof fs.rmSync): typeof fs.rmSync {
  return replaceArguments(vfs, delegate, [0]);
}

function rmdir(vfs: Vfs, delegate: typeof fs.rmdir): typeof fs.rmdir {
  return replaceArguments(vfs, delegate, [0]);
}

function rmdirSync(
  vfs: Vfs,
  delegate: typeof fs.rmdirSync,
): typeof fs.rmdirSync {
  return replaceArguments(vfs, delegate, [0]);
}

function stat(vfs: Vfs, delegate: typeof fs.stat) {
  return <typeof fs.stat>(
    function (path: fs.PathLike, options: any, callback?: Function) {
      const filePath = stringPath(path);
      const resolved = vfs.resolve(filePath);
      if (typeof options === "function") {
        callback = options;
        options = {};
      }
      if (resolved && resolved.path === undefined) {
        setImmediate(() =>
          callback(
            null,
            options.bigint
              ? new LinkBigintStat(resolved)
              : new LinkStat(resolved),
          ),
        );
        return;
      }
      const args = [...arguments];
      if (resolved && filePath !== resolved.path) {
        args[0] = resolved.path;
      }
      return delegate.apply(this, args);
    }
  );
}

function statSync(vfs: Vfs, delegate: typeof fs.statSync): typeof fs.statSync {
  return <typeof fs.statSync>(
    function (
      path: fs.PathLike,
      options?: any,
    ): fs.Stats | fs.BigIntStats | undefined {
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
    }
  );
}

function symlink(vfs: Vfs, delegate: typeof fs.symlink): typeof fs.symlink {
  // difficult to sensibly manipulate target
  return replaceArguments(vfs, delegate, [0]);
}

function symlinkSync(
  vfs: Vfs,
  delegate: typeof fs.symlinkSync,
): typeof fs.symlinkSync {
  // difficult to sensibly manipulate target
  return replaceArguments(vfs, delegate, [0]);
}

function truncate(vfs: Vfs, delegate: typeof fs.truncate): typeof fs.truncate {
  return replaceArguments(vfs, delegate, [0]);
}

function truncateSync(
  vfs: Vfs,
  delegate: typeof fs.truncateSync,
): typeof fs.truncateSync {
  return replaceArguments(vfs, delegate, [0]);
}

function unlink(vfs: Vfs, delegate: typeof fs.unlink): typeof fs.unlink {
  return replaceArguments(vfs, delegate, [0]);
}

function unlinkSync(
  vfs: Vfs,
  delegate: typeof fs.unlinkSync,
): typeof fs.unlinkSync {
  return replaceArguments(vfs, delegate, [0]);
}

function utimes(vfs: Vfs, delegate: typeof fs.utimes): typeof fs.utimes {
  return replaceArguments(vfs, delegate, [0]);
}

function utimesSync(
  vfs: Vfs,
  delegate: typeof fs.utimesSync,
): typeof fs.utimesSync {
  return replaceArguments(vfs, delegate, [0]);
}

function watch(vfs: Vfs, delegate: typeof fs.watch): typeof fs.watch {
  return replaceArguments(vfs, delegate, [0]);
}

function watchFile(
  vfs: Vfs,
  delegate: typeof fs.watchFile,
): typeof fs.watchFile {
  return replaceArguments(vfs, delegate, [0]);
}

function writeFile(
  vfs: Vfs,
  delegate: typeof fs.writeFile,
): typeof fs.writeFile {
  return replaceArguments(vfs, delegate, [0]);
}

function writeFileSync(
  vfs: Vfs,
  delegate: typeof fs.writeFileSync,
): typeof fs.writeFileSync {
  return replaceArguments(vfs, delegate, [0]);
}

export function patchFs(
  vfs: Vfs,
  delegate: { -readonly [K in keyof typeof fs]: typeof fs[K] },
) {
  delegate.access = access(vfs, delegate.access);
  delegate.accessSync = accessSync(vfs, delegate.accessSync);
  delegate.appendFile = appendFile(vfs, delegate.appendFile);
  delegate.appendFileSync = appendFileSync(vfs, delegate.appendFileSync);
  delegate.chmod = chmod(vfs, delegate.chmod);
  delegate.chmodSync = chmodSync(vfs, delegate.chmodSync);
  delegate.chown = chown(vfs, delegate.chown);
  delegate.chownSync = chownSync(vfs, delegate.chownSync);
  delegate.copyFile = copyFile(vfs, delegate.copyFile);
  delegate.copyFileSync = copyFileSync(vfs, delegate.copyFileSync);
  delegate.createReadStream = createReadStream(vfs, delegate.createReadStream);
  delegate.createWriteStream = createWriteStream(
    vfs,
    delegate.createWriteStream,
  );
  delegate.exists = exists(vfs, delegate.exists);
  delegate.existsSync = existsSync(vfs, delegate.existsSync);
  // delegate.lchmod;
  // delegate.lchmodSync;
  // delegate.lchown;
  // delegate.lchownSync;
  // delegate.lutimes;
  // delegate.lutimesSync;
  delegate.link = link(vfs, <any>delegate.link);
  delegate.linkSync = linkSync(vfs, <any>delegate.linkSync);
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
