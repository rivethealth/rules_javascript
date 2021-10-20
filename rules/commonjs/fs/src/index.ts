import * as path from 'path';
import { JsonFormat } from "./json";

/**
 * Entry
 */
export type VfsEntry = VfsEntry.Directory | VfsEntry.Link | VfsEntry.Path;

export namespace VfsEntry {
  export const DIRECTORY = Symbol("DIRECTORY");
  export const LINK = Symbol("LINK");
  export const PATH = Symbol("PATH");

  /** Virtual directory */
  export interface Directory {
    type: typeof DIRECTORY;
    children: Map<string, VfsEntry>;
  }

  /** Internal symlink */
  export interface Link {
    type: typeof LINK;
    path: Path_;
  }

  /** External path */
  export interface Path {
    type: typeof PATH;
    path: string;
  }

  export function json(): JsonFormat<VfsEntry> {
    let children: JsonFormat<Map<string, VfsEntry>>;
    const result: JsonFormat<VfsEntry> = {
      fromJson(json: any) {
        switch (json.type) {
          case 'LINK':
            return { type: LINK, path: VfsPath.parse(json.path) };
          case 'DIRECTORY':
            return { type: DIRECTORY, children: children.fromJson(json.children) };
          case 'PATH':
            return { type: PATH, path: JsonFormat.string().fromJson(json.path) }
        }
      },
      toJson(entry: VfsEntry) {
        switch (entry.type) {
          case VfsEntry.LINK:
            return { type: 'LINK', path: VfsPath.text(entry.path) };
          case VfsEntry.PATH:
            return { type: 'PATH', path: entry.path };
          case VfsEntry.DIRECTORY:
            return { type: 'DIRECTORY', children: children.toJson(entry.children) };
        }
      }
    }
    children = JsonFormat.map(JsonFormat.string(), JsonFormat.defer(() => result));
    return result;
  }
}

/**
 * Path
 */
export type VfsPath = string[];

export namespace VfsPath {
  /**
   * Parse path from text
   */
  export function parse(path: string): VfsPath {
    if (!path) {
      return [];
    }
    return path.split("/");
  }

  /**
   * Convert path to text
   */
  export function text(path: VfsPath) {
    return path.join("/");
  }
}

type Path_ = VfsPath;

/**
 * Mounted part of link file system
 */
export class VfsMount {
  constructor(private readonly root: VfsEntry) {
  }

  lookup(
    path: VfsPath
  ): VfsEntry | undefined {
    let entry: VfsEntry = this.root;
    for (let i = 0; i<  path.length; ) {
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
              path: [entry.path,... path.slice(i)].join('/'),
            };
      }
    }
    return entry;
  }

  realpath(path: VfsPath): string | undefined {
    let realpath = [];
    for (let i = 0, entry: VfsEntry = this.root; i < path.length; ) {
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

  *tree(): IterableIterator<string> {
    yield *(function *f(entry: VfsEntry): IterableIterator<string> {
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

export type EntryResult = FsResult.Link | FsResult.Path | FsResult.Directory | FsResult.NotFound | undefined;

export type PathResult = FsResult.Path | FsResult.NotFound | undefined;

export type ResolveResult = FsResult.Path | FsResult.Directory | FsResult.NotFound | undefined;

export namespace FsResult {
  export const LINK = Symbol('LINK');
  export const PATH = Symbol('PATH');
  export const DIRECTORY = Symbol('DIRECTORY');
  export const NOT_FOUND = Symbol('NOT_FOUND');

  export interface Link {
    type: typeof LINK;
    path: string;
  }

  export interface Path {
    type: typeof PATH;
    path: string;
  }

  export interface Directory {
    type: typeof DIRECTORY;
    children: Iterable<string>;
  }

  export interface NotFound {
    type: typeof NOT_FOUND;
  }
  export const NotFound: NotFound = { type: NOT_FOUND };
}

interface VfsMountPoint {
  mount: VfsMount;
  path: string;
}

/**
 * Link file system.
 * First path component is the mount point.
 */
export class Vfs {
  private readonly _mountPoints: VfsMountPoint[] = [];

  private _resolvePath(path_: string): { mountPoint: VfsMountPoint, path: VfsPath } | undefined {
    path_= path.resolve(path_);
    const mount = this._mountPoints.find(({ path }) => path === path_ || path_.startsWith(`${path}/`));
    if (!mount) {
      return;
    }

    return { mountPoint: mount, path: VfsPath.parse(path_.slice(mount.path.length + 1)) };
  }

  private _prepend(mountPoint: VfsMountPoint, path: string) {
    if (!path) {
      return mountPoint.path;
    } else {
      return `${mountPoint.path}/${path}`
    }
  }

  /**
   * Add mount
   */
  mount(path_: string, mount: VfsMount) {
    path_ = path.resolve(path_);
    this._mountPoints.push({path: path_, mount });
  }

  /**
   * Get entry
   */
  entry(path: string): EntryResult {
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
        return { type: FsResult.PATH, path: resolved.path  };
      case VfsEntry.DIRECTORY:
        return { type: FsResult.DIRECTORY, children: resolved.children.keys() };
    }
  }

  realpath(path: string): PathResult {
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
  resolve(path: string): ResolveResult {
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
