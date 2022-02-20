import { PackageTree } from "@better-rules-javascript/commonjs-package";
import { JsonFormat } from "@better-rules-javascript/util-json";
import { ArgumentParser } from "argparse";
import * as fs from "fs";

interface DepArg {
  dep: string;
  label: string;
  name: string;
  id: string | null;
}

interface PackageArg {
  id: string;
  label: string;
  name: string;
  path: string;
}

interface Args {
  deps: DepArg[];
  packages: PackageArg[];
  output: string;
}

async function main() {
  function depArg(value: string) {
    return JSON.parse(value);
  }

  function packageArg(value: string) {
    return JSON.parse(value);
  }

  const parser = new ArgumentParser({
    description: "Create package manifest.",
    prog: "package-manifest",
  });
  parser.add_argument("--package", {
    action: "append",
    default: [],
    dest: "packages",
    help: "Package",
    type: packageArg,
  });
  parser.add_argument("--dep", {
    action: "append",
    default: [],
    dest: "deps",
    help: "Dependency",
    type: depArg,
  });
  parser.add_argument("output", { help: "Output" });
  const args: Args = parser.parse_args();

  const packages = getPackages(args.packages);
  const globals: DetailedDeps = new Map();

  addDeps(args.deps, packages, globals);

  const tree = getPackageTree(packages, globals);

  await fs.promises.writeFile(
    args.output,
    JsonFormat.stringify(PackageTree.json(), tree),
  );
}

main().catch((e) => {
  console.error(e.stack);
  process.exit(1);
});

type DetailedDeps = Map<string, { label: string; path: string }>;

interface DetailedPackage {
  deps: DetailedDeps;
  label: string;
  path: string;
  name: string;
}

function getPackages(packageArgs: PackageArg[]): Map<string, DetailedPackage> {
  const packages = new Map<string, DetailedPackage>();
  const packageIdByPath = new Map<string, string>();

  for (const packageArg of packageArgs) {
    const existingPackage = packages.get(packageArg.id);

    if (existingPackage) {
      throw new Error(
        `Multiple instances of package ID ${packageArg.id} from ${existingPackage.label} and ${packageArg.label}`,
      );
    }
    packages.set(packageArg.id, {
      label: packageArg.label,
      name: packageArg.name,
      deps: new Map(),
      path: packageArg.path,
    });

    const existingId = packageIdByPath.get(packageArg.path);
    if (existingId) {
      const existingPackage = packages.get(existingId)!;
      throw new Error(
        `Multiple instances of package path ${packageArg.id} from ${existingPackage.label} and ${packageArg.label}`,
      );
    }
  }

  return packages;
}

function addDeps(
  depArgs: DepArg[],
  packages: Map<string, DetailedPackage>,
  globals: DetailedDeps,
) {
  for (const depArg of depArgs) {
    if (depArg.id == null) {
      const depPackage = packages.get(depArg.dep);
      if (!depPackage) {
        throw new Error(
          `Package ${depArg.dep} does not exist, but is referenced globally (${depArg.label})`,
        );
      }
      const existingDep = globals.get(depArg.name);
      if (!existingDep) {
        globals.set(depArg.name, {
          label: depArg.label,
          path: depPackage.path,
        });
      } else if (existingDep.path !== depArg.dep) {
        throw new Error(
          `Multiple globals for ${depArg.name}: ${existingDep.path} (via ${existingDep.label}) and ${depArg.dep} (via ${depArg.label})`,
        );
      }
      continue;
    }

    const package_ = packages.get(depArg.id);
    if (!package_) {
      throw new Error(
        `Package ${depArg.id} does not exist, but is referenced (${depArg.label})`,
      );
    }

    const depPackage = packages.get(depArg.dep);
    if (!depPackage) {
      throw new Error(
        `Package ${depArg.dep} does not exist, but is referenced by ${depArg.id} (${depArg.label})`,
      );
    }

    const existingDep = depPackage.deps.get(depArg.name);
    if (existingDep && existingDep.path !== depArg.dep) {
      throw new Error(
        `Package ${depArg.id} has multiple dependencies for ${depArg.name}: ${existingDep.path} (via ${existingDep.label}) and ${depArg.dep} (via ${depArg.label})`,
      );
    }

    package_.deps.set(depArg.name, {
      label: depArg.label,
      path: depPackage.path,
    });
  }
}

function getPackageTree(
  packages: Map<string, DetailedPackage>,
  globals: DetailedDeps,
): PackageTree {
  const resultGlobals = new Map(
    [...globals.entries()].map(([name, dep]) => [name, dep.path]),
  );
  const resultPackages = new Map(
    [...packages.values()].map((package_) => [
      package_.path,
      {
        name: package_.name,
        deps: new Map(
          [...package_.deps.entries()].map(([name, dep]) => [name, dep.path]),
        ),
      },
    ]),
  );

  return { globals: resultGlobals, packages: resultPackages };
}
