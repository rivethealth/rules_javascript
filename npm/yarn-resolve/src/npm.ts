import { Agent } from "https";
import fetch from "node-fetch";

export interface NpmSpecifier {
  name: string;
  version: string;
}

export interface NpmPackage {
  dist: {
    integrity: string;
    tarball: string;
  };
}

export class NpmRegistryClient {
  private readonly agent = new Agent({
    keepAlive: true,
    maxTotalSockets: 10,
    timeout: 1000 * 5,
  });
  private readonly url = "https://registry.npmjs.org";

  async getPackageVersion(specifier: NpmSpecifier): Promise<NpmPackage> {
    const response = await fetch(
      `${this.url}/${specifier.name}/${specifier.version}`,
      { agent: this.agent },
    );
    if (!response.ok) {
      throw new Error(`Registry error ${response.status}`);
    }
    return <NpmPackage>await response.json();
  }
}
