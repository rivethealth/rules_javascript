import { Compiler, Configuration, Watching } from "webpack";
import * as fs from "fs";
import * as path from "path";

type InputFileSystem = Compiler["inputFileSystem"];
type WatchOptions = Configuration["watchOptions"];
type WatchFileSystem = Compiler["watchFileSystem"];
type Watcher = Watching["watcher"];

interface FileSystemInfoEntry {
  safeTime: number;
  timestamp?: number;
}

function maybeStat(path: string): fs.Stats | undefined {
  try {
    return fs.statSync(path);
  } catch (e) {}
}

export class BazelWatchFileSystem implements WatchFileSystem {
  constructor(private readonly _inputFileSystem: InputFileSystem) {}

  private _callback:
    | ((
        arg0: undefined | Error,
        arg1: Map<string, FileSystemInfoEntry | "ignore">,
        arg2: Map<string, FileSystemInfoEntry | "ignore">,
        arg3: Set<string>,
        arg4: Set<string>,
      ) => void)
    | undefined;
  private _immediateCallback:
    | ((path: string, timestamp: number) => void)
    | undefined;

  private _files: string[] = [];
  private _directories: string[] = [];
  private _missing: string[] = [];
  private _start: number = Date.now();

  private readonly _timestamps = new Map<
    string,
    { isFile: boolean; timestamp: number }
  >();

  private _changes = new Set<string>();
  private _removals = new Set<string>();

  refresh() {
    this._refresh(false);
  }

  private _refresh(init: boolean) {
    for (const path of this._files) {
      const stat = maybeStat(path);
      if (stat) {
        if (this._start <= stat.mtimeMs) {
          this._change(path, stat.mtimeMs);
        }
        this._timestamps.set(path, {
          isFile: stat.isFile(),
          timestamp: Math.floor(stat.mtimeMs),
        });
      } else if (init || this._timestamps.delete(path)) {
        this._remove(path);
      }
    }
    for (const path_ of this._directories) {
      (function visit(path_: string) {
        const stat = maybeStat(path_);
        if (stat) {
          if (this._start <= stat.mtimeMs) {
            this._change(path_, stat.mtimeMs);
          }
          this.timestamps.set(path_, {
            isFile: stat.isFile(),
            timestamp: Math.floor(stat.mtimeMs),
          });
        } else if (init || this.timestamps.delete(path_)) {
          this._remove(path_);
        }
        if (stat.isDirectory()) {
          for (const child of fs.readdirSync(path_)) {
            visit(path.join(path_, child));
          }
        }
      })(path_);
    }
    for (const path of this._missing) {
      const stat = maybeStat(path);
      if (stat) {
        if (init || this._start <= stat.mtimeMs) {
          this._change(path, stat.mtimeMs);
        }
        this._timestamps.set(path, {
          isFile: stat.isFile(),
          timestamp: Math.floor(stat.mtimeMs),
        });
      } else if (this._timestamps.delete(path)) {
        this._remove(path);
      }
    }

    if (!this._changes.size && !this._removals.size) {
      return;
    }

    if (this._callback) {
      const callback = this._callback;
      this._callback = undefined;
      Promise.resolve().then(() =>
        callback(
          null,
          this._fileTimeInfoEntries(),
          this._contextTimeInfoEntries(),
          this._changes,
          this._removals,
        ),
      );
    }
  }

  private _change(path: string, timestamp: number) {
    this._changes.add(path);
    if (this._immediateCallback) {
      const immediateCallback = this._immediateCallback;
      this._immediateCallback = undefined;
      Promise.resolve().then(() => immediateCallback(path, timestamp));
    }
    if (this._inputFileSystem.purge) {
      this._inputFileSystem.purge(path);
    }
  }

  private _remove(path: string) {
    this._removals.add(path);
    if (this._immediateCallback) {
      const immediateCallback = this._immediateCallback;
      this._immediateCallback = undefined;
      Promise.resolve().then(() => immediateCallback(path, 0));
    }
    if (this._inputFileSystem.purge) {
      this._inputFileSystem.purge(path);
    }
  }

  private _fileTimeInfoEntries() {
    const entries = new Map<string, FileSystemInfoEntry>();
    for (const [path, timestamp] of this._timestamps.entries()) {
      if (timestamp.isFile) {
        entries.set(path, {
          safeTime: timestamp.timestamp,
          timestamp: timestamp.timestamp,
        });
      }
    }
    return entries;
  }

  private _contextTimeInfoEntries() {
    const entries = new Map<string, FileSystemInfoEntry>();
    for (const [path, timestamp] of this._timestamps.entries()) {
      if (!timestamp.isFile) {
        entries.set(path, {
          safeTime: timestamp.timestamp,
          timestamp: timestamp.timestamp,
        });
      }
    }
    return entries;
  }

  watch(
    files: Iterable<string>,
    directories: Iterable<string>,
    missing: Iterable<string>,
    startTime: number,
    options: WatchOptions,
    callback: (
      arg0: undefined | Error,
      arg1: Map<string, FileSystemInfoEntry | "ignore">,
      arg2: Map<string, FileSystemInfoEntry | "ignore">,
      arg3: Set<string>,
      arg4: Set<string>,
    ) => void,
    callbackUndelayed: (arg0: string, arg1: number) => void,
  ): Watcher {
    this._callback = <any>callback;
    this._immediateCallback = callbackUndelayed;
    this._start = startTime;
    this._files = [...files];
    this._directories = [...directories];
    this._missing = []; // [...missing] // several node_modules-related issues
    this._refresh(true);
    this._timestamps.clear();
    this._removals = new Set();
    this._changes = new Set();

    return {
      close() {},
      pause() {},
      getAggregatedRemovals(): never {
        throw new Error("Unsupported");
      },
      getAggregatedChanges(): never {
        throw new Error("Unsupported");
      },
      getFileTimeInfoEntries(): never {
        throw new Error("Unsupported");
      },
      getContextTimeInfoEntries(): never {
        throw new Error("Unsupported");
      },
      getInfo: () => {
        if (this._inputFileSystem.purge) {
          for (const path of this._changes) {
            this._inputFileSystem.purge(path);
          }
          for (const path of this._removals) {
            this._inputFileSystem.purge(path);
          }
        }

        return {
          changes: this._changes,
          removals: this._removals,
          fileTimeInfoEntries: this._fileTimeInfoEntries(),
          contextTimeInfoEntries: this._contextTimeInfoEntries(),
        };
      },
    };
  }
}
