import { JsonFormat } from "@better-rules-javascript/util-json";
import { splitOnce } from "./string";

const PKG_INPUT = /^(.?[^@]+)(?:@(.+))?$/;

export interface YarnLocator {
  name: string;
  version: YarnVersion;
}

export type YarnVersion =
  | YarnVersion.Npm
  | YarnVersion.Patch
  | YarnVersion.Unknown
  | YarnVersion.Virtual
  | YarnVersion.Workspace;

export namespace YarnVersion {
  export const NPM = Symbol("NPM");
  export const PATCH = Symbol("PATCH");
  export const VIRTUAL = Symbol("VIRTUAL");
  export const WORKSPACE = Symbol("WORKSPACE");
  export const UNKNOWN = Symbol("UNKNOWN");

  export interface Npm {
    type: typeof NPM;
    version: string;
  }

  export interface Patch {
    patch: string;
    type: typeof PATCH;
    locator: YarnLocator;
  }

  export interface Unknown {
    type: typeof UNKNOWN;
    schema: string;
    value: string;
  }

  export interface Virtual {
    digest: string;
    version: YarnVersion;
    type: typeof VIRTUAL;
  }

  export interface Workspace {
    path: string;
    type: typeof WORKSPACE;
  }

  export function parse(string: string): YarnVersion {
    const [schema, value] = splitOnce(string, ":");
    switch (schema) {
      case "npm":
        return { type: NPM, version: value };
      case "patch": {
        const [version, patch] = splitOnce(value, "#");
        return {
          type: PATCH,
          locator: YarnLocator.parse(decodeURIComponent(version)),
          patch,
        };
      }
      case "virtual": {
        const [digest, version] = splitOnce(value, "#");
        return { digest, type: VIRTUAL, version: parse(version) };
      }
      case "workspace":
        return { type: WORKSPACE, path: value };
    }
    return { type: UNKNOWN, schema, value };
  }

  export function serialize(value: YarnVersion): string {
    switch (value.type) {
      case NPM:
        return `npm:${value.version}`;
      case PATCH:
        return `patch:${encodeURIComponent(
          YarnLocator.serialize(value.locator),
        )}`;
      case UNKNOWN:
        return `${value.schema}:${value.value}`;
      case VIRTUAL:
        return `virtual:${value.digest}#${serialize(value.version)}`;
      case WORKSPACE:
        return `workspace:${value.path}`;
    }
  }
}

export namespace YarnLocator {
  export function json(): JsonFormat<YarnLocator> {
    return {
      fromJson(json: any) {
        return parse(json);
      },
      toJson() {
        throw new Error("Unsupported");
      },
    };
  }

  export function parse(string: string): YarnLocator {
    const [, name, version] = PKG_INPUT.exec(string);

    return { name, version: YarnVersion.parse(version) };
  }

  export function serialize(value: YarnLocator) {
    return `${value.name}@${YarnVersion.serialize(value.version)}`;
  }
}

export interface YarnDescriptor {
  name: string;
  version: string;
}

export namespace YarnDescriptor {
  export function json(): JsonFormat<YarnDescriptor> {
    return {
      fromJson(json: any) {
        return parse(json);
      },
      toJson() {
        throw new Error("Unsupported");
      },
    };
  }

  export function parse(string: string): YarnDescriptor {
    const [, name, version] = PKG_INPUT.exec(string);
    return { name, version };
  }
}

export interface YarnPackageInfo {
  value: YarnLocator;
  children: {
    Dependents?: YarnLocator[];
    Dependencies?: YarnDependencyInfo[];
    "Peer dependencies"?: YarnDependencyInfo[];
    Instances?: number;
    Version: string;
  };
}

export namespace YarnPackageInfo {
  export function json(): JsonFormat<YarnPackageInfo> {
    return JsonFormat.object({
      value: YarnLocator.json(),
      children: JsonFormat.object({
        Instances: JsonFormat.number(),
        Version: JsonFormat.string(),
        Dependents: JsonFormat.array(YarnLocator.json()),
        Dependencies: JsonFormat.array(YarnDependencyInfo.json()),
        "Peer dependencies": JsonFormat.array(YarnDependencyInfo.json()),
      }),
    });
  }
}

export interface YarnDependencyInfo {
  descriptor: YarnDescriptor;
  locator: YarnLocator | null;
}

export namespace YarnDependencyInfo {
  export function json(): JsonFormat<YarnDependencyInfo> {
    return JsonFormat.object({
      descriptor: YarnDescriptor.json(),
      locator: JsonFormat.nullable(YarnLocator.json()),
    });
  }
}
