import { JsonFormat } from "@better-rules-javascript/util-json";

export type InstallManifest = InstallEntry.Dir;

export function installManifestFormat(
  origin: boolean,
): JsonFormat<InstallManifest> {
  return JsonFormat.defer(() => InstallEntry.dirFormat(origin));
}

export type InstallEntry =
  | InstallEntry.Dir
  | InstallEntry.File
  | InstallEntry.Symlink;

export namespace InstallEntry {
  export const DIR = Symbol("dir");
  export const FILE = Symbol("file");
  export const SYMLINK = Symbol("symlink");

  export interface Dir {
    type: typeof DIR;
    entries: Map<string, InstallEntry>;
    origin?: string;
  }

  export function dirFormat(origin: boolean): JsonFormat<Dir> {
    return JsonFormat.object({
      type: JsonFormat.symbolConstant(DIR),
      entries: JsonFormat.stringMap(
        JsonFormat.defer(() => installEntryFormat(origin)),
      ),
      ...(origin && { origin: JsonFormat.string() }),
    });
  }

  export interface File {
    type: typeof FILE;
    digest: Buffer;
    executable: boolean;
    origin?: string;
    src: string;
  }

  export function fileFormat(origin: boolean): JsonFormat<File> {
    return JsonFormat.object({
      type: JsonFormat.symbolConstant(FILE),
      digest: JsonFormat.buffer(),
      executable: JsonFormat.boolean(),
      src: JsonFormat.string(),
      ...(origin && { origin: JsonFormat.string() }),
    });
  }

  export interface Symlink {
    type: typeof SYMLINK;
    origin?: string;
    target: string;
  }

  export function symlinkFormat(origin: boolean): JsonFormat<Symlink> {
    return JsonFormat.object({
      type: JsonFormat.symbolConstant(SYMLINK),
      target: JsonFormat.string(),
      ...(origin && { origin: JsonFormat.string() }),
    });
  }
}

function installEntryFormat(origin: boolean): JsonFormat<InstallEntry> {
  const dirFormat = InstallEntry.dirFormat(origin);
  const fileFormat = InstallEntry.fileFormat(origin);
  const symlinkFormat = InstallEntry.symlinkFormat(origin);
  return {
    fromJson(json) {
      switch (json.type) {
        case InstallEntry.DIR.description:
          return dirFormat.fromJson(json);
        case InstallEntry.FILE.description:
          return fileFormat.fromJson(json);
        case InstallEntry.SYMLINK.description:
          return symlinkFormat.fromJson(json);
      }
      throw new Error(`Invalid entry type: ${json.type}`);
    },
    toJson(value) {
      switch (value.type) {
        case InstallEntry.DIR:
          return dirFormat.toJson(value);
        case InstallEntry.FILE:
          return fileFormat.toJson(value);
        case InstallEntry.SYMLINK:
          return symlinkFormat.toJson(value);
      }
    },
  };
}
