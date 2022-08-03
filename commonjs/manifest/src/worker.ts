import { PackageTree } from "@better-rules-javascript/commonjs-package";
import { JsonFormat } from "@better-rules-javascript/util-json";
import { ArgumentParser } from "argparse";
import * as fs from "fs";
import {
  addDeps,
  DepArg,
  DetailedDeps,
  getPackages,
  getPackageTree,
  PackageArg,
} from "./manifest";

interface Args {
  deps: DepArg[];
  packages: PackageArg[];
  output: string;
}

function depArg(value: string): DepArg {
  return JSON.parse(value);
}

function packageArg(value: string): PackageArg {
  return JSON.parse(value);
}

export class ManifestWorkerError extends Error {}

class WorkerArgumentParser extends ArgumentParser {
  exit(status: number, message: string) {
    throw new ManifestWorkerError(message);
  }
}

export class ManifestWorker {
  constructor() {
    this.parser.add_argument("--package", {
      action: "append",
      default: [],
      dest: "packages",
      help: "Package",
      type: packageArg,
    });
    this.parser.add_argument("--dep", {
      action: "append",
      default: [],
      dest: "deps",
      help: "Dependency",
      type: depArg,
    });
    this.parser.add_argument("output", { help: "Output" });
  }

  private readonly parser = new WorkerArgumentParser({
    description: "Create package manifest.",
    prog: "package-manifest",
  });

  async run(a: string[]) {
    const args: Args = this.parser.parse_args(a);

    const packages = getPackages(args.packages);
    const globals: DetailedDeps = new Map();

    addDeps(args.deps, packages, globals);

    const tree = getPackageTree(packages, globals);

    await fs.promises.writeFile(
      args.output,
      JsonFormat.stringify(PackageTree.json(), tree),
    );
  }
}
