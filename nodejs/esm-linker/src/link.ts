import { lazy } from "@better-rules-javascript/util/cache";
import * as fs from "fs";
import * as path from "path";
import * as os from "os";

export interface LinkPackage {
  context: string;
  name: string;
}

export class NodeModuleLinks {
  constructor(private readonly nameFn: (path: string) => string) {}

  _root: string | undefined = undefined;

  readonly root = lazy(async () => {
    const dir = await fs.promises.mkdtemp(path.join(os.tmpdir(), "nodejs-"));
    await fs.promises.mkdir(path.join(dir, "node_modules"));
    return dir;
  });

  private readonly linked = new Map<string, Promise<void>>();

  async package(packagePath: string): Promise<LinkPackage> {
    const packageName = this.nameFn(packagePath);
    const root = await this.root();
    const linkPath = path.join(root, "node_modules", packageName);
    let promise = this.linked.get(packageName);
    if (!promise) {
      promise = fs.promises.symlink(packagePath, linkPath);
      this.linked.set(packageName, promise);
    }
    await promise;
    return { context: root, name: packagePath };
  }

  destroy() {
    if (this._root === undefined) {
      return;
    }
    fs.rmSync(this._root, { recursive: true });
  }
}
