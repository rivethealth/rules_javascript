import * as yaml from "yaml";

const PKG_INPUT = /^(.?[^@]+)(?:@(.+))?$/;

export const NPM_SCHEMA = "npm";
export const WORKSPACE_SCHEMA = "workspace";

export interface YarnPackageSpecifier {
  name: string;
  schema: string;
  version: string;
}

export namespace YarnPackageSpecifier {
  export function parse(input: string): YarnPackageSpecifier {
    const [, name, fullVersion] = PKG_INPUT.exec(input);
    const [schema, version] = fullVersion.split(":", 2);

    return {
      name,
      version: version != null ? version : schema,
      schema: version != null ? schema : NPM_SCHEMA,
    };
  }

  export function serialize(specifier: YarnPackageSpecifier) {
    return `${specifier.name}@${specifier.schema}:${specifier.version}`;
  }
}

export interface YarnPackage {
  version: string;
  resolution: string;
  dependencies?: { [name: string]: string };
  peerDependencies?: { [name: string]: string };
}

export interface YarnLock {
  __metadata: any;
  [specifier: string]: YarnPackage;
}

export function parseYarnLock(string: string): YarnLock {
  const result = yaml.parse(string);
  for (const value of Object.values(result)) {
    if ((<any>value).dependencies) {
      for (const key in (<any>value).dependencies) {
        (<any>value).dependencies[key] = String((<any>value).dependencies[key]);
      }
    }
    if ((<any>value).peerDependencies) {
      for (const key in (<any>value).peerDependencies) {
        (<any>value).peerDependencies[key] = String(
          (<any>value).peerDependencies[key],
        );
      }
    }
  }
  return result;
}
