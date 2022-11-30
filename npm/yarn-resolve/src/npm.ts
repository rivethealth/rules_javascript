import { JsonFormat } from "@better-rules-javascript/util-json";
import { Configuration, Locator } from "@yarnpkg/core";
import { npmHttpUtils } from "@yarnpkg/plugin-npm";

export interface NpmPackage {
  dist: {
    integrity?: string;
    tarball: string;
  };
}

export namespace NpmPackage {
  export function json(): JsonFormat<NpmPackage> {
    return JsonFormat.object({
      dist: JsonFormat.object({
        integrity: JsonFormat.string(),
        tarball: JsonFormat.string(),
      }),
    });
  }
}

export class NpmRegistryClient {
  constructor(private readonly configuration: Configuration) {}

  async getPackage(specifier: Locator): Promise<NpmPackage> {
    const path = `/${npmHttpUtils.getIdentUrl(specifier)}/${
      specifier.reference
    }`;
    const response = await npmHttpUtils.get(path, {
      configuration: this.configuration,
      ident: specifier,
      jsonResponse: true,
    });

    return NpmPackage.json().fromJson(response);
  }
}
