import { lazy } from "@better-rules-javascript/util/cache";
import * as fs from "fs";
import * as path from "path";
import * as os from "os";

export interface LinkPackage {
  context: string;
  name: string;
}

export class NodeLinks {
  constructor(private readonly nameFn: (path: string) => string) {}

  private _linkRoot: string | undefined = undefined;

  readonly linkRoot = lazy(() => {
    const root = fs.mkdtempSync(path.join(os.tmpdir(), "nodejs-"));
    this._linkRoot = root;
    return root;
  });

  private readonly linked = new Set<string>();

  package(packagePath: string): LinkPackage {
    const packageName = this.nameFn(packagePath);

    const directory = this.linkRoot();
    const linkPath = path.join(directory, packageName);
    if (!this.linked.has(packageName)) {
      this.linked.add(packageName);
      fs.symlinkSync(packagePath, linkPath);
    }

    return {
      context: directory,
      name: packageName,
    };
  }

  destroy() {
    if (this._linkRoot === undefined) {
      return;
    }
    fs.rmSync(this._linkRoot, { recursive: true });
  }
}
