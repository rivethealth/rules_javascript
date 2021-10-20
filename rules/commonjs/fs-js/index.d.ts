import { JsonFormat } from "./json";
/**
 * Entry
 */
export declare type VfsEntry = VfsEntry.Directory | VfsEntry.Link | VfsEntry.Path;
export declare namespace VfsEntry {
    const DIRECTORY: unique symbol;
    const LINK: unique symbol;
    const PATH: unique symbol;
    /** Virtual directory */
    interface Directory {
        type: typeof DIRECTORY;
        children: Map<string, VfsEntry>;
    }
    /** Internal symlink */
    interface Link {
        type: typeof LINK;
        path: Path_;
    }
    /** External path */
    interface Path {
        type: typeof PATH;
        path: string;
    }
    function json(): JsonFormat<VfsEntry>;
}
/**
 * Path
 */
export declare type VfsPath = string[];
export declare namespace VfsPath {
    /**
     * Parse path from text
     */
    function parse(path: string): VfsPath;
    /**
     * Convert path to text
     */
    function text(path: VfsPath): string;
}
declare type Path_ = VfsPath;
/**
 * Mounted part of link file system
 */
export declare class VfsMount {
    private readonly root;
    constructor(root: VfsEntry);
    lookup(path: VfsPath): VfsEntry | undefined;
    realpath(path: VfsPath): string | undefined;
    tree(): IterableIterator<string>;
}
export declare type EntryResult = FsResult.Link | FsResult.Path | FsResult.Directory | FsResult.NotFound | undefined;
export declare type PathResult = FsResult.Path | FsResult.NotFound | undefined;
export declare type ResolveResult = FsResult.Path | FsResult.Directory | FsResult.NotFound | undefined;
export declare namespace FsResult {
    const LINK: unique symbol;
    const PATH: unique symbol;
    const DIRECTORY: unique symbol;
    const NOT_FOUND: unique symbol;
    interface Link {
        type: typeof LINK;
        path: string;
    }
    interface Path {
        type: typeof PATH;
        path: string;
    }
    interface Directory {
        type: typeof DIRECTORY;
        children: Iterable<string>;
    }
    interface NotFound {
        type: typeof NOT_FOUND;
    }
    const NotFound: NotFound;
}
/**
 * Link file system.
 * First path component is the mount point.
 */
export declare class Vfs {
    private readonly _mountPoints;
    private _resolvePath;
    private _prepend;
    /**
     * Add mount
     */
    mount(path_: string, mount: VfsMount): void;
    /**
     * Get entry
     */
    entry(path: string): EntryResult;
    realpath(path: string): PathResult;
    /**
     * Resolve entry
     * @return path or directory, null if does not exist, or undefined if not part of
     *   the virtual file system
     */
    resolve(path: string): ResolveResult;
}
export {};
