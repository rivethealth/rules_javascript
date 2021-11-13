import { URL, fileURLToPath } from "url";
import * as fs from "fs";
import { Readable } from "stream";
import {
  FsResult,
  Vfs,
  EntryResult,
} from "@better_rules_javascript/commonjs-fs";

/**
 * @filedescription Node.js fs implementation of LinkFs
 */

const { fs: fsConstants } = (<any>process).binding("fs");

class AccessError extends Error implements NodeJS.ErrnoException {
  constructor(readonly path: string, readonly syscall: string) {
    super(`EACCES: permission denied, ${syscall} '${path}'`);
  }

  readonly code = "EACCES";
  readonly errno = -13;
}

class InvalidError extends Error implements NodeJS.ErrnoException {
  constructor(readonly path: string, readonly syscall: string) {
    super(`EINVAL: invalid argument, ${syscall}, ${path}`);
  }

  readonly code = "EINVAL";
  readonly errno = -22;
}

class IsDirError extends Error implements NodeJS.ErrnoException {
  constructor(path: string, readonly syscall: string) {
    super(`EISDIR: illegal operation on a directory, ${syscall}, ${path}`);
  }

  readonly code = "EISDIR";
  readonly errno = -21;
  readonly path: string;
}

class NotFoundError extends Error implements NodeJS.ErrnoException {
  constructor(readonly path: string, readonly syscall: string) {
    super(`ENOENT: no such file or directory, ${syscall} '${path}'`);
  }

  readonly code = "ENOENT";
  readonly errno = -2;
}

class NoopReadStream extends Readable implements fs.ReadStream {
  constructor(readonly path: string) {
    super();
  }

  get bytesRead() {
    return 0;
  }

  _read() {}

  close() {}
}

class LinkBigintStat implements fs.BigIntStats {
  constructor(private readonly entry: EntryResult) {}

  isFile() {
    return false;
  }

  isDirectory() {
    return this.entry.type === FsResult.DIRECTORY;
  }

  isBlockDevice() {
    return false;
  }

  isCharacterDevice() {
    return false;
  }

  isSymbolicLink() {
    return this.entry.type === FsResult.LINK;
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

class LinkStat implements fs.Stats {
  constructor(private readonly entry: EntryResult) {}

  isFile() {
    return false;
  }

  isDirectory() {
    return this.entry.type === FsResult.DIRECTORY;
  }

  isBlockDevice() {
    return false;
  }

  isCharacterDevice() {
    return false;
  }

  isSymbolicLink() {
    return this.entry.type === FsResult.LINK;
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

class LinkDir implements fs.Dir {
  constructor(private readonly dir: FsResult.Directory) {}

  private readonly iterator = this.dir.children[Symbol.iterator]();

  readonly path: string;

  [Symbol.asyncIterator](): AsyncIterableIterator<fs.Dirent> {
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

  close(): Promise<void>;
  close(cb: fs.NoParamCallback): void;
  close(cb?: fs.NoParamCallback): Promise<void> | void {
    if (cb) {
      setImmediate(cb);
    } else {
      return Promise.resolve();
    }
  }

  closeSync() {}

  read(): Promise<fs.Dirent | null>;
  read(
    cb: (err: NodeJS.ErrnoException | null, dirEnt: fs.Dirent | null) => void,
  ): void;
  read(
    cb?: (err: NodeJS.ErrnoException | null, dirEnt: fs.Dirent | null) => void,
  ): Promise<fs.Dirent | null> | null {
    const result = this.readSync();
    if (cb) {
      setImmediate(() => cb(null, result));
      return;
    }
    return Promise.resolve(result);
  }

  readSync(): fs.Dirent {
    const entry = this.iterator.next();
    if (entry.done) {
      return null;
    }
    return dirEntry(entry.value[0], entry.value[1]);
  }
}

function errorReadStream(path: string, error: Error) {
  const readStream = new NoopReadStream(path);
  setImmediate(() => readStream.destroy(error));
}

function addPromisify<T>(f: T): T & { __promisify__: any } {
  return <any>f;
}

function stringPath(value: fs.PathLike): string {
  if (value instanceof Buffer) {
    value = value.toString();
  }
  if (value instanceof URL) {
    if (value.protocol !== "file:") {
      throw new Error(`Invalid protocol: ${value.protocol}`);
    }
    value = fileURLToPath(value);
  }
  return value;
}

function access(linkFs: Vfs, delegate: typeof fs.access): typeof fs.access {
  function access(path: fs.PathLike, callback: fs.NoParamCallback): void;
  function access(
    path: fs.PathLike,
    mode: number | undefined,
    callback: fs.NoParamCallback,
  ): void;
  function access(
    path: fs.PathLike,
    mode: fs.NoParamCallback | number | undefined,
    callback?: fs.NoParamCallback,
  ) {
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
      case FsResult.DIRECTORY:
        if (mode & fs.constants.W_OK) {
          callback(new AccessError(stringPath(path), "access"));
        } else {
          callback(null);
        }
        break;
      case FsResult.NOT_FOUND:
        callback(new NotFoundError(stringPath(path), "access"));
        break;
      case FsResult.PATH: {
        const args = [...arguments];
        args[0] = resolved.path;
        return delegate.apply(this, args);
      }
    }
  }
  return addPromisify(access);
}

function accessSync(
  linkFs: Vfs,
  delegate: typeof fs.accessSync,
): typeof fs.accessSync {
  return function (path, mode) {
    const fsPath = stringPath(path);
    mode = mode || fs.constants.F_OK;

    const resolved = linkFs.resolve(fsPath);
    if (resolved === undefined) {
      return delegate.apply(this, arguments);
    }

    switch (resolved.type) {
      case FsResult.DIRECTORY:
        if (mode & fs.constants.W_OK) {
          throw new AccessError(stringPath(path), "access");
        }
        break;
      case FsResult.NOT_FOUND:
        throw new NotFoundError(stringPath(path), "access");
      case FsResult.PATH: {
        const args = [...arguments];
        args[0] = resolved.path;
        return delegate.apply(this, args);
      }
    }
  };
}

function appendFile(
  linkFs: Vfs,
  delegate: typeof fs.appendFile,
): typeof fs.appendFile {
  function appendFile(
    file: fs.PathLike | number,
    data: any,
    callback: fs.NoParamCallback,
  ): void;
  function appendFile(
    file: fs.PathLike | number,
    data: any,
    options: fs.WriteFileOptions,
    callback: fs.NoParamCallback,
  ): void;
  function appendFile(
    file: fs.PathLike | number,
    data: any,
    options: fs.WriteFileOptions | fs.NoParamCallback,
    callback?: fs.NoParamCallback,
  ): ReturnType<typeof fs.appendFile> {
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
      case FsResult.NOT_FOUND:
        callback(null);
        break;
      default:
        callback(new AccessError(stringPath(file), "appendfile"));
    }
  }
  return addPromisify(appendFile);
}

function appendFileSync(
  linkFs: Vfs,
  delegate: typeof fs.appendFileSync,
): typeof fs.appendFileSync {
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
      case FsResult.NOT_FOUND:
        throw new NotFoundError(stringPath(file), "appendfile");
      default:
        throw new AccessError(stringPath(file), "appendfile");
    }
  };
}

function chmod(linkFs: Vfs, delegate: typeof fs.chmod): typeof fs.chmod {
  function chmod(
    path: fs.PathLike,
    mode: string | number,
    callback: fs.NoParamCallback,
  ): void {
    const fsPath = stringPath(path);

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

function chmodSync(
  linkFs: Vfs,
  delegate: typeof fs.chmodSync,
): typeof fs.chmodSync {
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

function chown(linkFs: Vfs, delegate: typeof fs.chown): typeof fs.chown {
  function chown(
    path: fs.PathLike,
    uid: number,
    gid: number,
    callback: fs.NoParamCallback,
  ): void {
    const fsPath = stringPath(path);

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

function chownSync(
  linkFs: Vfs,
  delegate: typeof fs.chownSync,
): typeof fs.chownSync {
  return function (path) {
    const fsPath = stringPath(path);
    const resolved = linkFs.entry(fsPath);
    if (resolved !== undefined) {
      throw new AccessError(stringPath(path), "chown");
    }
    return delegate.apply(this, arguments);
  };
}

function copyFile(
  linkFs: Vfs,
  delegate: typeof fs.copyFile,
): typeof fs.copyFile {
  function copyFile(
    src: fs.PathLike,
    dest: fs.PathLike,
    callback: fs.NoParamCallback,
  ): void;
  function copyFile(
    src: fs.PathLike,
    dest: fs.PathLike,
    flags: number,
    callback: fs.NoParamCallback,
  ): void;
  function copyFile(
    src: fs.PathLike,
    dest: fs.PathLike,
    flags: number | fs.NoParamCallback,
    callback?: fs.NoParamCallback,
  ) {
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
      case FsResult.DIRECTORY:
        callback(new IsDirError(stringPath(src), "copyfile"));
        break;
      case FsResult.NOT_FOUND:
        callback(new NotFoundError(stringPath(src), "copyfile"));
        break;
      case FsResult.PATH: {
        const args = [...arguments];
        args[0] = resolvedSrc.path;
        return delegate.apply(this, args);
      }
    }
  }
  return addPromisify(copyFile);
}

function createReadStream(
  linkFs: Vfs,
  delegate: typeof fs.createReadStream,
): typeof fs.createReadStream {
  return function (path: fs.PathLike) {
    const filePath = stringPath(path);

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
      case FsResult.DIRECTORY: {
        return errorReadStream(
          stringPath(path),
          new IsDirError(stringPath(path), "read"),
        );
      }
      case FsResult.PATH: {
        const args = [...arguments];
        args[0] = resolved.path;
        return delegate.apply(this, args);
      }
    }
  };
}

function createWriteStream(
  linkFs: Vfs,
  delegate: typeof fs.createWriteStream,
): typeof fs.createWriteStream {
  return function (path: fs.PathLike) {
    const filePath = stringPath(path);

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

function copyFileSync(
  linkFs: Vfs,
  delegate: typeof fs.copyFileSync,
): typeof fs.copyFileSync {
  return function (src: fs.PathLike, dest: fs.PathLike): void {
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
      case FsResult.DIRECTORY:
        throw new IsDirError(stringPath(src), "copyfile");
      case FsResult.NOT_FOUND:
        throw new NotFoundError(stringPath(src), "copyfile");
      case FsResult.PATH: {
        const args = [...arguments];
        args[0] = resolvedSrc.path;
        return delegate.apply(this, args);
      }
    }
  };
}

function exists(linkFs: Vfs, delegate: typeof fs.exists): typeof fs.exists {
  function exists(
    path: fs.PathLike,
    callback: (exists: boolean) => void,
  ): void {
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
      case FsResult.DIRECTORY:
        callback(true);
        break;
      case FsResult.PATH: {
        const args = [...arguments];
        args[0] = resolved.path;
        return delegate.apply(this, args);
      }
    }
  }
  return addPromisify(exists);
}

function dirEntry(name: string, entry: EntryResult) {
  switch (entry.type) {
    case FsResult.DIRECTORY:
      return new (<any>fs.Dir)(name, fsConstants.UV_DIRENT_DIR);
    case FsResult.LINK:
      return new (<any>fs.Dir)(name, fsConstants.UV_DIRENT_LINK);
    case FsResult.FILE:
      return new (<any>fs.Dir)(name, fsConstants.UV_DIRENT_FILE);
  }
}

function existsSync(
  linkFs: Vfs,
  delegate: typeof fs.existsSync,
): typeof fs.existsSync {
  return function (path) {
    const filePath = stringPath(path);
    const resolved = linkFs.resolve(filePath);
    if (resolved === undefined) {
      return delegate.apply(this, arguments);
    }

    switch (resolved.type) {
      case FsResult.DIRECTORY:
        return true;
      case FsResult.NOT_FOUND:
        return false;
      case FsResult.PATH: {
        const args = [...arguments];
        args[0] = resolved.path;
        return delegate.apply(this, args);
      }
    }
  };
}

function mkdir(linkFs: Vfs, delegate: typeof fs.mkdir): typeof fs.mkdir {
  function mkdir(
    path: fs.PathLike,
    options: number | string | fs.MakeDirectoryOptions | undefined | null,
    callback: fs.NoParamCallback,
  ): void;
  function mkdir(path: fs.PathLike, callback: fs.NoParamCallback): void;
  function mkdir(
    path: fs.PathLike,
    options:
      | number
      | string
      | fs.MakeDirectoryOptions
      | undefined
      | null
      | fs.NoParamCallback,
    callback?: fs.NoParamCallback,
  ) {
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

function mkdirSync(
  linkFs: Vfs,
  delegate: typeof fs.mkdirSync,
): typeof fs.mkdirSync {
  return function (path) {
    const filePath = stringPath(path);

    const resolved = linkFs.resolve(filePath);
    if (resolved === undefined) {
      return delegate.apply(this, arguments);
    }

    throw new AccessError(stringPath(path), "mkdir");
  };
}

function mkdtemp(linkFs: Vfs, delegate: typeof fs.mkdtemp): typeof fs.mkdtemp {
  function mkdtemp(
    prefix: string,
    options:
      | { encoding?: BufferEncoding | null }
      | BufferEncoding
      | undefined
      | null,
    callback: (err: NodeJS.ErrnoException | null, folder: string) => void,
  ): void;
  function mkdtemp(
    prefix: string,
    options: "buffer" | { encoding: "buffer" },
    callback: (err: NodeJS.ErrnoException | null, folder: Buffer) => void,
  ): void;
  function mkdtemp(
    prefix: string,
    options: { encoding?: string | null } | string | undefined | null,
    callback: (
      err: NodeJS.ErrnoException | null,
      folder: string | Buffer,
    ) => void,
  ): void;
  function mkdtemp(
    prefix: string,
    callback: (err: NodeJS.ErrnoException | null, folder: string) => void,
  ): void;
  function mkdtemp(
    path: fs.PathLike,
    options: any,
    callback?:
      | ((err: NodeJS.ErrnoException | null, folder: string) => void)
      | ((err: NodeJS.ErrnoException | null, folder: Buffer) => void),
  ) {
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

function mkdtempSync(
  linkFs: Vfs,
  delegate: typeof fs.mkdtempSync,
): typeof fs.mkdtempSync {
  return function (path) {
    const filePath = stringPath(path);

    const resolved = linkFs.resolve(filePath);
    if (resolved === undefined) {
      return delegate.apply(this, arguments);
    }

    throw new AccessError(stringPath(path), "mkdtemp");
  };
}

function open(linkFs: Vfs, delegate: typeof fs.open): typeof fs.open {
  function open(
    path: fs.PathLike,
    flags: string | number,
    mode: string | number | undefined | null,
    callback: (err: NodeJS.ErrnoException | null, fd: number) => void,
  ): void;
  function open(
    path: fs.PathLike,
    flags: string | number,
    callback: (err: NodeJS.ErrnoException | null, fd: number) => void,
  ): void;
  function open(
    path: string,
    flags: string | number,
    mode:
      | string
      | number
      | undefined
      | null
      | ((err: NodeJS.ErrnoException | null, fd: number) => void),
  ) {
    const filePath = stringPath(path);

    const resolved = linkFs.resolve(filePath);
    if (resolved === undefined) {
      return delegate.apply(this, arguments);
    }

    if (typeof mode === "function") {
      callback = mode;
    }
    switch (resolved.type) {
      case FsResult.DIRECTORY: {
        const args = [...arguments];
        args[0] = "/";
        return delegate.apply(this, args);
      }
      case FsResult.NOT_FOUND:
        throw new NotFoundError(stringPath(path), "open");
      case FsResult.PATH: {
        const args = [...arguments];
        args[0] = resolved.path;
        return delegate.apply(this, args);
      }
    }
  }
  return addPromisify(open);
}

function openSync(
  linkFs: Vfs,
  delegate: typeof fs.openSync,
): typeof fs.openSync {
  return function (path) {
    const filePath = stringPath(path);

    const resolved = linkFs.resolve(filePath);
    if (resolved === undefined) {
      return delegate.apply(this, arguments);
    }

    switch (resolved.type) {
      case FsResult.DIRECTORY: {
        const args = [...arguments];
        args[0] = "/";
        return delegate.apply(this, args);
      }
      case FsResult.NOT_FOUND:
        throw new NotFoundError(stringPath(path), "open");
      case FsResult.PATH: {
        const args = [...arguments];
        args[0] = resolved.path;
        return delegate.apply(this, args);
      }
    }
  };
}

function opendir(linkFs: Vfs, delegate: typeof fs.opendir): typeof fs.opendir {
  function opendir(
    path: string,
    cb: (err: NodeJS.ErrnoException | null, dir: fs.Dir) => void,
  ): void;
  function opendir(
    path: string,
    options: fs.OpenDirOptions,
    cb: (err: NodeJS.ErrnoException | null, dir: fs.Dir) => void,
  ): void;
  function opendir(
    path: string,
    options:
      | fs.OpenDirOptions
      | ((err: NodeJS.ErrnoException | null, dir: fs.Dir) => void),
    callback?: (err: NodeJS.ErrnoException | null, dir: fs.Dir) => void,
  ) {
    const filePath = stringPath(path);

    const resolved = linkFs.resolve(filePath);
    if (resolved === undefined) {
      return delegate.apply(this, arguments);
    }

    if (typeof options === "function") {
      callback = options;
    }
    switch (resolved.type) {
      case FsResult.DIRECTORY:
        callback(null, new LinkDir(resolved));
        return;
      case FsResult.PATH:
        callback(new InvalidError(path, "opendir"), null);
        return;
    }
  }
  return addPromisify(opendir);
}

function opendirSync(
  linkFs: Vfs,
  delegate: typeof fs.opendirSync,
): typeof fs.opendirSync {
  return function (path) {
    const filePath = stringPath(path);

    const resolved = linkFs.resolve(filePath);
    if (resolved === undefined) {
      return delegate.apply(this, arguments);
    }

    switch (resolved.type) {
      case FsResult.DIRECTORY:
        return new LinkDir(resolved);
      case FsResult.PATH:
        throw new InvalidError(path, "opendir");
    }
  };
}

function readdir(linkFs: Vfs, delegate: typeof fs.readdir): typeof fs.readdir {
  function readdir(
    path: fs.PathLike,
    options:
      | { encoding: BufferEncoding | null; withFileTypes?: false }
      | BufferEncoding
      | undefined
      | null,
    callback: (err: NodeJS.ErrnoException | null, files: string[]) => void,
  ): void;
  function readdir(
    path: fs.PathLike,
    options: { encoding: "buffer"; withFileTypes?: false } | "buffer",
    callback: (err: NodeJS.ErrnoException | null, files: Buffer[]) => void,
  ): void;
  function readdir(
    path: fs.PathLike,
    options:
      | { encoding?: string | null; withFileTypes?: false }
      | string
      | undefined
      | null,
    callback: (
      err: NodeJS.ErrnoException | null,
      files: string[] | Buffer[],
    ) => void,
  ): void;
  function readdir(
    path: fs.PathLike,
    callback: (err: NodeJS.ErrnoException | null, files: string[]) => void,
  ): void;
  function readdir(
    path: fs.PathLike,
    options: { encoding?: string | null; withFileTypes: true },
    callback: (err: NodeJS.ErrnoException | null, files: fs.Dirent[]) => void,
  ): void;
  function readdir(
    path: fs.PathLike,
    options:
      | { encoding?: string | null; withFileTypes?: boolean }
      | string
      | undefined
      | null
      | ((err: NodeJS.ErrnoException | null, files: string[]) => void),
    callback?: (
      err: NodeJS.ErrnoException | null,
      files: fs.Dirent[] & Buffer[] & string[],
    ) => void,
  ) {
    const filePath = stringPath(path);

    const resolved = linkFs.resolve(filePath);
    if (resolved === undefined) {
      return delegate.apply(this, arguments);
    }

    if (typeof options === "function") {
      callback = options;
    }

    switch (resolved.type) {
      case FsResult.DIRECTORY:
        callback(undefined, <any[]>[...resolved.children]);
        break;
      case FsResult.NOT_FOUND:
        callback(new NotFoundError(stringPath(path), "readdir"), undefined);
        break;
      case FsResult.PATH:
        callback(new InvalidError(stringPath(path), "readdir"), undefined!);
        break;
    }
  }

  return addPromisify(readdir);
}

function readdirSync(
  linkFs: Vfs,
  delegate: typeof fs.readdirSync,
): typeof fs.readdirSync {
  return function (path: fs.PathLike) {
    const filePath = stringPath(path);

    const resolved = linkFs.resolve(filePath);
    if (resolved === undefined) {
      return delegate.apply(this, arguments);
    }

    switch (resolved.type) {
      case FsResult.DIRECTORY:
        return [...resolved.children];
      case FsResult.NOT_FOUND:
        throw new NotFoundError(stringPath(path), "readdir");
      case FsResult.PATH:
        throw new InvalidError(stringPath(path), "readdir");
    }
  };
}

function readFile(
  linkFs: Vfs,
  delegate: typeof fs.readFile,
): typeof fs.readFile {
  function readFile(
    path: fs.PathLike | number,
    options: { encoding?: null; flag?: string } | undefined | null,
    callback: (err: NodeJS.ErrnoException | null, data: Buffer) => void,
  ): void;
  function readFile(
    path: fs.PathLike | number,
    options: { encoding: string; flag?: string } | string,
    callback: (err: NodeJS.ErrnoException | null, data: string) => void,
  ): void;
  function readFile(
    path: fs.PathLike | number,
    options:
      | { encoding?: string | null; flag?: string }
      | string
      | undefined
      | null,
    callback: (
      err: NodeJS.ErrnoException | null,
      data: string | Buffer,
    ) => void,
  ): void;
  function readFile(
    path: fs.PathLike | number,
    callback: (err: NodeJS.ErrnoException | null, data: Buffer) => void,
  ): void;
  function readFile(
    path: fs.PathLike | number,
    options:
      | { encoding?: string | null; flag?: string }
      | string
      | undefined
      | null
      | ((err: NodeJS.ErrnoException | null, data: Buffer) => void),
    callback?: (
      err: NodeJS.ErrnoException | null,
      data: string & Buffer,
    ) => void,
  ) {
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
      case FsResult.DIRECTORY:
        callback(new InvalidError(stringPath(path), "readfile"), undefined!);
        break;
      case FsResult.NOT_FOUND:
        callback(new NotFoundError(stringPath(path), "readfile"), undefined);
        break;
      case FsResult.PATH: {
        const args = [...arguments];
        args[0] = resolved.path;
        delegate.apply(this, args);
        break;
      }
    }
  }

  return addPromisify(readFile);
}

function readFileSync(
  linkFs: Vfs,
  delegate: typeof fs.readFileSync,
): typeof fs.readFileSync {
  return function (path: fs.PathLike | number): string & Buffer {
    if (typeof path === "number") {
      return delegate.apply(this, arguments);
    }

    const filePath = stringPath(path);

    const resolved = linkFs.resolve(filePath);
    if (resolved === undefined) {
      return delegate.apply(this, arguments);
    }

    switch (resolved.type) {
      case FsResult.DIRECTORY:
        throw new InvalidError(stringPath(path), "readfile");
      case FsResult.NOT_FOUND:
        throw new NotFoundError(stringPath(path), "readfile");
      case FsResult.PATH: {
        const args = [...arguments];
        args[0] = resolved.path;
        return delegate.apply(this, args);
      }
    }
  };
}

function readlink(
  linkFs: Vfs,
  delegate: typeof fs.readlink,
): typeof fs.readlink {
  function readlink(
    path: fs.PathLike,
    options:
      | { encoding?: BufferEncoding | null }
      | BufferEncoding
      | undefined
      | null,
    callback: (err: NodeJS.ErrnoException | null, linkString: string) => void,
  ): void;
  function readlink(
    path: fs.PathLike,
    options: { encoding: "buffer" } | "buffer",
    callback: (err: NodeJS.ErrnoException | null, linkString: Buffer) => void,
  ): void;
  function readlink(
    path: fs.PathLike,
    options: { encoding?: string | null } | string | undefined | null,
    callback: (
      err: NodeJS.ErrnoException | null,
      linkString: string | Buffer,
    ) => void,
  ): void;
  function readlink(
    path: fs.PathLike,
    callback: (err: NodeJS.ErrnoException | null, linkString: string) => void,
  ): void;
  function readlink(
    path: fs.PathLike,
    options:
      | { encoding?: string | null }
      | string
      | undefined
      | null
      | ((err: NodeJS.ErrnoException | null, linkString: string) => void),
    callback?:
      | ((err: NodeJS.ErrnoException | null, linkString: Buffer) => void)
      | ((
          err: NodeJS.ErrnoException | null,
          linkString: string | Buffer,
        ) => void),
  ) {
    const filePath = stringPath(path);

    const entry = linkFs.entry(filePath);
    if (entry === undefined) {
      return delegate.apply(this, arguments);
    }

    if (typeof options === "function") {
      callback = options;
    }

    switch (entry.type) {
      case FsResult.DIRECTORY:
      case FsResult.PATH:
        callback(new InvalidError(stringPath(path), "readlink"), undefined!);
        return;
      case FsResult.NOT_FOUND:
        callback(new NotFoundError(stringPath(path), "readlink"), undefined!);
        break;
      case FsResult.LINK:
        callback(null, <string & Buffer>entry.path);
        return;
    }
  }
  return addPromisify(readlink);
}

function readlinkSync(
  linkFs: Vfs,
  delegate: typeof fs.readlinkSync,
): typeof fs.readlinkSync {
  return function (path: fs.PathLike) {
    const filePath = stringPath(path);

    const resolved = linkFs.entry(filePath);
    if (resolved === undefined) {
      return delegate.apply(this, arguments);
    }

    switch (resolved.type) {
      case FsResult.DIRECTORY:
      case FsResult.PATH:
        throw new InvalidError(stringPath(path), "readlink");
      case FsResult.NOT_FOUND:
        throw new NotFoundError(stringPath(path), "readlink");
      case FsResult.LINK:
        return resolved.path;
    }
  };
}

function realpath(
  linkFs: Vfs,
  delegate: typeof fs.realpath,
): typeof fs.realpath {
  function realpath(
    path: fs.PathLike,
    options:
      | { encoding?: BufferEncoding | null }
      | BufferEncoding
      | undefined
      | null,
    callback: (err: NodeJS.ErrnoException | null, resolvedPath: string) => void,
  ): void;
  function realpath(
    path: fs.PathLike,
    options: { encoding: "buffer" } | "buffer",
    callback: (err: NodeJS.ErrnoException | null, resolvedPath: Buffer) => void,
  ): void;
  function realpath(
    path: fs.PathLike,
    options: { encoding?: string | null } | string | undefined | null,
    callback: (
      err: NodeJS.ErrnoException | null,
      resolvedPath: string | Buffer,
    ) => void,
  ): void;
  function realpath(
    path: fs.PathLike,
    callback: (err: NodeJS.ErrnoException | null, resolvedPath: string) => void,
  ): void;
  function realpath(
    path: fs.PathLike,
    options:
      | { encoding?: string | null }
      | string
      | undefined
      | null
      | ((err: NodeJS.ErrnoException | null, resolvedPath: string) => void),
    callback?:
      | ((
          err: NodeJS.ErrnoException | null,
          resolvedPath: string | Buffer,
        ) => void)
      | ((err: NodeJS.ErrnoException | null, resolvedPath: string) => void),
  ): void {
    const filePath = stringPath(path);

    if (typeof options === "function") {
      callback = options;
    }
    const resolved = linkFs.realpath(filePath);
    if (resolved === undefined) {
      return delegate.apply(this, arguments);
    }

    switch (resolved.type) {
      case FsResult.NOT_FOUND:
        callback(new NotFoundError(stringPath(path), "lstat"), undefined!);
        break;
      case FsResult.PATH:
        callback(null, resolved.path);
        break;
    }
  }
  realpath.native = delegate.native;
  return addPromisify(realpath);
}

function realpathSync(
  linkFs: Vfs,
  delegate: typeof fs.realpathSync,
): typeof fs.realpathSync {
  function realpathSync(
    path: fs.PathLike,
    options?: { encoding?: BufferEncoding | null } | BufferEncoding | null,
  ): string;
  function realpathSync(
    path: fs.PathLike,
    options: { encoding: "buffer" } | "buffer",
  ): Buffer;
  function realpathSync(
    path: fs.PathLike,
    options?: { encoding?: string | null } | string | null,
  ): string | Buffer;
  function realpathSync(path: fs.PathLike): string | Buffer {
    const filePath = stringPath(path);

    const resolved = linkFs.realpath(filePath);
    if (resolved === undefined) {
      return delegate.apply(this, arguments);
    }

    switch (resolved.type) {
      case FsResult.NOT_FOUND:
        throw new NotFoundError(stringPath(path), "realpath");
      case FsResult.PATH:
        return resolved.path;
    }
  }
  realpathSync.native = delegate.native;
  return realpathSync;
}

function rename(linkFs: Vfs, delegate: typeof fs.rename): typeof fs.rename {
  function rename(
    oldPath: fs.PathLike,
    newPath: fs.PathLike,
    callback: fs.NoParamCallback,
  ): void {
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

function renameSync(
  linkFs: Vfs,
  delegate: typeof fs.renameSync,
): typeof fs.renameSync {
  return function (oldPath: fs.PathLike, newPath: fs.PathLike): void {
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

function rmdir(linkFs: Vfs, delegate: typeof fs.rmdir): typeof fs.rmdir {
  function rmdir(path: fs.PathLike, callback: fs.NoParamCallback): void;
  function rmdir(
    path: fs.PathLike,
    options: fs.RmDirOptions,
    callback: fs.NoParamCallback,
  ): void;
  function rmdir(
    path: fs.PathLike,
    options: fs.RmDirOptions | fs.NoParamCallback,
    callback?: fs.NoParamCallback,
  ): void {
    const filePath = stringPath(path);

    const resolved = linkFs.resolve(filePath);
    if (resolved === undefined) {
      return delegate.apply(this, arguments);
    }

    if (typeof options === "function") {
      callback = options;
    }

    switch (resolved.type) {
      case FsResult.NOT_FOUND:
        callback(new NotFoundError(stringPath(path), "rmdir"));
        break;
      default:
        callback(new AccessError(stringPath(path), "rmdir"));
    }
  }

  return addPromisify(rmdir);
}

function rmdirSync(
  linkFs: Vfs,
  delegate: typeof fs.rmdirSync,
): typeof fs.rmdirSync {
  return function (path): void {
    const filePath = stringPath(path);

    const resolved = linkFs.resolve(filePath);
    if (resolved === undefined) {
      return delegate.apply(this, arguments);
    }

    switch (resolved.type) {
      case FsResult.NOT_FOUND:
        throw new NotFoundError(stringPath(path), "rmdir");
      default:
        throw new AccessError(stringPath(path), "rmdir");
    }
  };
}

function stat(linkFs: Vfs, delegate: typeof fs.stat) {
  function stat(
    path: fs.PathLike,
    options: fs.BigIntOptions,
    callback: (
      err: NodeJS.ErrnoException | null,
      stats: fs.BigIntStats,
    ) => void,
  ): void;
  function stat(
    path: fs.PathLike,
    options: fs.StatOptions,
    callback: (
      err: NodeJS.ErrnoException | null,
      stats: fs.Stats | fs.BigIntStats,
    ) => void,
  ): void;
  function stat(
    path: fs.PathLike,
    callback: (err: NodeJS.ErrnoException | null, stats: fs.Stats) => void,
  ): void;
  function stat(
    path: fs.PathLike,
    options:
      | fs.BigIntOptions
      | fs.StatOptions
      | ((err: NodeJS.ErrnoException | null, stats: fs.Stats) => void)
      | ((err: NodeJS.ErrnoException | null, stats: fs.BigIntStats) => void),
    callback?:
      | ((err: NodeJS.ErrnoException | null, stats: fs.Stats) => void)
      | ((err: NodeJS.ErrnoException | null, stats: fs.BigIntStats) => void),
  ) {
    const filePath = stringPath(path);

    const resolved = linkFs.resolve(filePath);
    if (resolved === undefined) {
      return delegate.apply(this, arguments);
    }

    if (typeof options === "function") {
      callback = options;
      options = undefined;
    }
    const bigint = options && (<any>options).bigint;

    switch (resolved.type) {
      case FsResult.DIRECTORY:
        callback(
          null,
          <any>(bigint ? new LinkBigintStat(resolved) : new LinkStat(resolved)),
        );
        break;
      case FsResult.NOT_FOUND:
        callback(new NotFoundError(stringPath(path), "stat"), null);
        break;
      case FsResult.PATH: {
        const args = [...arguments];
        args[0] = resolved.path;
        return delegate.apply(this, args);
      }
    }
  }
  return addPromisify(stat);
}

function statSync(
  linkFs: Vfs,
  delegate: typeof fs.statSync,
): typeof fs.statSync {
  function statSync(
    path: fs.PathLike,
    options: fs.BigIntOptions,
  ): fs.BigIntStats;
  function statSync(
    path: fs.PathLike,
    options: fs.StatOptions,
  ): fs.Stats | fs.BigIntStats;
  function statSync(path: fs.PathLike): fs.Stats;
  function statSync(
    path: fs.PathLike,
    options?: fs.BigIntOptions | fs.StatOptions,
  ): fs.Stats | fs.BigIntStats {
    const filePath = stringPath(path);

    const resolved = linkFs.resolve(filePath);
    if (resolved === undefined) {
      return delegate.apply(this, arguments);
    }

    const bigint = options && (<any>options).bigint;

    switch (resolved.type) {
      case FsResult.DIRECTORY:
        return bigint ? new LinkBigintStat(resolved) : new LinkStat(resolved);
      case FsResult.NOT_FOUND:
        throw new NotFoundError(stringPath(path), "stat");
      case FsResult.PATH: {
        const args = [...arguments];
        args[0] = resolved.path;
        return delegate.apply(this, args);
      }
    }
  }
  return statSync;
}

function symlink(linkFs: Vfs, delegate: typeof fs.symlink): typeof fs.symlink {
  function symlink(
    target: fs.PathLike,
    path: fs.PathLike,
    type: fs.symlink.Type | undefined | null,
    callback: fs.NoParamCallback,
  ): void;
  function symlink(
    target: fs.PathLike,
    path: fs.PathLike,
    callback: fs.NoParamCallback,
  ): void;
  function symlink(
    target: fs.PathLike,
    path: fs.PathLike,
    type: fs.symlink.Type | undefined | null | fs.NoParamCallback,
    callback?: fs.NoParamCallback,
  ) {
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

function symlinkSync(
  linkFs: Vfs,
  delegate: typeof fs.symlinkSync,
): typeof fs.symlinkSync {
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

function truncate(
  linkFs: Vfs,
  delegate: typeof fs.truncate,
): typeof fs.truncate {
  function truncate(
    path: fs.PathLike,
    len: number | undefined | null,
    callback: fs.NoParamCallback,
  ): void;
  function truncate(path: fs.PathLike, callback: fs.NoParamCallback): void;

  function truncate(
    path: fs.PathLike,
    len: number | undefined | null | fs.NoParamCallback,
    callback?: fs.NoParamCallback,
  ): void {
    const filePath = stringPath(path);

    const resolved = linkFs.resolve(filePath);
    if (resolved === undefined) {
      return delegate.apply(this, arguments);
    }

    callback(new AccessError(stringPath(path), "truncate"));
  }
  return addPromisify(truncate);
}

function truncateSync(
  linkFs: Vfs,
  delegate: typeof fs.truncateSync,
): typeof fs.truncateSync {
  return function (path) {
    const filePath = stringPath(path);

    const resolved = linkFs.resolve(filePath);
    if (resolved === undefined) {
      return delegate.apply(this, arguments);
    }

    throw new AccessError(stringPath(path), "truncate");
  };
}

function unlink(linkFs: Vfs, delegate: typeof fs.unlink): typeof fs.unlink {
  function unlink(path: fs.PathLike, callback: fs.NoParamCallback): void {
    const filePath = stringPath(path);

    const resolved = linkFs.resolve(filePath);
    if (resolved === undefined) {
      return delegate.apply(this, arguments);
    }

    callback(new AccessError(stringPath(path), "unlink"));
  }
  return addPromisify(unlink);
}

function unlinkSync(
  linkFs: Vfs,
  delegate: typeof fs.unlinkSync,
): typeof fs.unlinkSync {
  return function (path) {
    const filePath = stringPath(path);

    const resolved = linkFs.resolve(filePath);
    if (resolved === undefined) {
      return delegate.apply(this, arguments);
    }

    throw new AccessError(stringPath(path), "unlink");
  };
}

function utimes(linkFs: Vfs, delegate: typeof fs.utimes): typeof fs.utimes {
  function utimes(
    path: fs.PathLike,
    atime: string | number | Date,
    mtime: string | number | Date,
    callback: fs.NoParamCallback,
  ): void {
    const filePath = stringPath(path);

    const resolved = linkFs.resolve(filePath);
    if (resolved === undefined) {
      return delegate.apply(this, arguments);
    }

    callback(new AccessError(stringPath(path), "utimes"));
  }
  return addPromisify(utimes);
}

function utimesSync(
  linkFs: Vfs,
  delegate: typeof fs.utimesSync,
): typeof fs.utimesSync {
  return function (path) {
    const filePath = stringPath(path);

    const resolved = linkFs.resolve(filePath);
    if (resolved === undefined) {
      return delegate.apply(this, arguments);
    }

    throw new AccessError(stringPath(path), "utimes");
  };
}

function writeFile(
  linkFs: Vfs,
  delegate: typeof fs.writeFile,
): typeof fs.writeFile {
  function writeFile(
    path: fs.PathLike | number,
    data: any,
    options: fs.WriteFileOptions,
    callback: fs.NoParamCallback,
  ): void;
  function writeFile(
    path: fs.PathLike | number,
    data: any,
    callback: fs.NoParamCallback,
  ): void;
  function writeFile(
    path: fs.PathLike | number,
    data: any,
    options: fs.WriteFileOptions | fs.NoParamCallback,
    callback?: fs.NoParamCallback,
  ): void {
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

function writeFileSync(
  linkFs: Vfs,
  delegate: typeof fs.writeFileSync,
): typeof fs.writeFileSync {
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

export function patchFs(linkFs: Vfs, delegate: typeof fs) {
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
  delegate.lstat = stat(linkFs, <any>delegate.stat);
  delegate.lstatSync = statSync(linkFs, <any>delegate.statSync);
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
