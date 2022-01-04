import { PackageTree } from "@better-rules-javascript/commonjs-package";
import { JsonFormat } from "@better-rules-javascript/commonjs-package/json";
import { ArgumentParser } from "argparse";
import * as fs from "fs";

async function main() {
  function depArg(value: string) {
    return JSON.parse(value);
  }

  function globalArg(value: string) {
    return JSON.parse(value);
  }

  function packageArg(value: string) {
    return JSON.parse(value);
  }

  const parser = new ArgumentParser({
    description: "Create package manifest",
    prog: "package-manifest",
  });
  parser.add_argument("--global", {
    action: "append",
    default: [],
    dest: "globals",
    help: "Global dependencies",
    type: globalArg,
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
  const args = parser.parse_args();

  const packages = new Map<
    string,
    {
      label: string;
      path: string;
      deps: Map<string, { id: string; label: string }>;
    }
  >();

  for (const package_ of args.packages) {
    const existingPackage = packages.get(package_.id);

    if (existingPackage) {
      throw new Error(
        `Multiple instances of package ${package_.id} from ${existingPackage.label} and ${package_.label}`,
      );
    }

    const p = {
      label: package_.label,
      deps: new Map(),
      path: package_.path,
    };
    if (package_.id && package_.name) {
      p.deps.set(package_.name, { label: p.label, id: package_.id });
    }
    packages.set(package_.id, p);
  }

  for (const dep of args.deps) {
    const package_ = packages.get(dep.id);
    if (!package_) {
      throw new Error(
        `Package ${dep.id} does not exist, but is referenced by ${dep.label}`,
      );
    }

    const existingDep = package_.deps.get(dep.name);
    if (existingDep && existingDep.id !== dep.dep) {
      throw new Error(
        `Multiple dependencies ${existingDep.id} (${existingDep.label}) and ${dep.dep} (${dep.label}) for ${dep.name} in ${dep.id}`,
      );
    }

    package_.deps.set(dep.name, { label: dep.label, id: dep.dep });
  }

  for (const package_ of packages.values()) {
    for (const dep of args.globals) {
      const existingDep = package_.deps.get(dep.name);
      if (!existingDep) {
        package_.deps.set(dep.name, { label: "", id: dep.id });
      }
    }
  }

  const tree: PackageTree = new Map(
    [...packages.entries()].map(([id, package_]) => [
      id,
      {
        path: package_.path,
        deps: new Map(
          [...package_.deps.entries()].map(([name, dep]) => [name, dep.id]),
        ),
      },
    ]),
  );

  await fs.promises.writeFile(
    args.output,
    JsonFormat.stringify(PackageTree.json(), tree),
  );
}

main().catch((e) => {
  console.error(e.stack);
  process.exit(1);
});
