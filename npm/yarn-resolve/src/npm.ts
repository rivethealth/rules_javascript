import { JsonFormat } from "@better-rules-javascript/util-json";
import { Agent } from "https";
import fetch from "node-fetch";

export interface NpmSpecifier {
  name: string;
  version: string;
}

export namespace NpmSpecifier {
  export function stringify(value: NpmSpecifier) {
    return `${value.name}@${value.version}`;
  }
}

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
  private readonly agent = new Agent({
    keepAlive: true,
    maxTotalSockets: 10,
  });
  private readonly url = "https://registry.npmjs.org";

  async getPackageContent(url: string): Promise<ArrayBuffer> {
    const response = await fetch(url, { agent: this.agent });
    if (!response.ok) {
      throw new Error(`Registry error ${response.status}`);
    }
    return await response.arrayBuffer();
  }

  async getPackage(specifier: NpmSpecifier): Promise<NpmPackage> {
    const response = await fetch(
      `${this.url}/${specifier.name}/${specifier.version}`,
      { agent: this.agent },
    );
    if (!response.ok) {
      throw new Error(`Registry error ${response.status}`);
    }
    return NpmPackage.json().fromJson(await response.json());
  }
}
