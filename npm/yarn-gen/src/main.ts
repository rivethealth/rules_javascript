import { ArgumentParser } from "argparse";
import * as fs from "fs";
import * as childProcess from "child_process";
import * as path from "path";
import * as semver from "semver";
import { BzlPackages, BzlDep, BzlRoots, bzlName } from "./bzl";
import { npmUrl } from "./npm";
import {
  NPM_SCHEMA,
  parseYarnLock,
  WORKSPACE_SCHEMA,
  YarnPackage,
  YarnPackageSpecifier,
} from "./yarn";

async function main() {
  const parser = new ArgumentParser({
    description: "Convert yarn lock file to Starlark",
    prog: "yarn-gen",
  });
  parser.add_argument("--dir", {
    help: "Directory for refresh. Defaults to .",
    default: ".",
  });
  parser.add_argument("--lock", { help: "Path to yarn.lock." });
  parser.add_argument("--refresh", {
    action: "store_true",
    help: "Run yarn to refresh yarn.lock.",
  });
  parser.add_argument("output", { help: "Path to Starlark output." });

  const args = parser.parse_args();

  if (args.refresh) {
    if (args.lock) {
      throw new Error("Cannot set --lock if --refresh is enabled");
    }
  }
  const lockPath = args.lock || path.resolve(args.dir, "yarn.lock");
  if (args.refresh) {
    const yarnBin = `${process.env.RUNFILES_DIR}/${process.env._YARN_BIN}`;
    const installProcess = childProcess.spawn(
      yarnBin,
      ["install", "--mode", "update-lockfile"],
      {
        cwd: args.dir,
        stdio: ["ignore", "inherit", "inherit"],
      },
    );

    await new Promise((resolve) => installProcess.on("close", resolve));
    if (installProcess.exitCode) {
      throw new Error(
        `Yarn install failed with code ${installProcess.exitCode}`,
      );
    }
  }

  if (!fs.existsSync(lockPath)) {
    throw new Error(`Lock file does not exist at ${lockPath}`);
  }

  const lockData = parseYarnLock(fs.readFileSync(lockPath, "utf8"));

  const packagesByName = new Map<string, YarnPackage[]>();
  const packagesBySpecifier = new Map<string, YarnPackage>();
  for (const [key, package_] of Object.entries(lockData)) {
    if (key === "__metadata") {
      continue;
    }

    const specifiers = key.split(", ");
    for (const specifier of specifiers) {
      packagesBySpecifier.set(specifier, package_);
    }

    const { name } = YarnPackageSpecifier.parse(specifiers[0]);
    if (!packagesByName.has(name)) {
      packagesByName.set(name, []);
    }
    packagesByName.get(name)!.push(package_);
  }

  const bzlPackages: BzlPackages = [];
  const bzlRoots: BzlRoots = [];
  for (const [key, package_] of Object.entries(lockData)) {
    if (key === "__metadata") {
      continue;
    }

    let deps: BzlDep[];
    const specifier = YarnPackageSpecifier.parse(package_.resolution);
    if (specifier.schema === NPM_SCHEMA) {
      deps = [];
      // would add integrity, but can't understand how Yarn checksum is calculated
      // (seems like SHA-512 but doesn't match)
      const bzlPackage = {
        name: bzlName(package_.resolution),
        url: npmUrl(specifier.name, package_.version),
        deps,
      };
      bzlPackages.push(bzlPackage);
    } else if (
      specifier.schema === WORKSPACE_SCHEMA &&
      specifier.version === "."
    ) {
      deps = bzlRoots;
    } else {
      continue;
    }

    for (const [name, versionRange] of Object.entries(
      package_.dependencies || {},
    )) {
      let specifier: string;
      if (versionRange.includes("@")) {
        if (YarnPackageSpecifier.parse(versionRange).schema !== NPM_SCHEMA) {
          continue;
        }
        specifier = versionRange;
      } else {
        specifier = YarnPackageSpecifier.serialize({
          name,
          schema: NPM_SCHEMA,
          version: versionRange,
        });
      }
      const package_ = packagesBySpecifier.get(specifier);
      if (!package_) {
        throw new Error(`Dependency ${specifier} not found for ${key}`);
      }
      deps.push({ dep: bzlName(package_.resolution), name });
    }

    for (let [name, versionRange] of Object.entries(
      package_.peerDependencies || {},
    )) {
      if (versionRange.includes("@")) {
        const specifier = YarnPackageSpecifier.parse(versionRange);
        if (specifier.schema !== NPM_SCHEMA) {
          continue;
        }
        name = specifier.name;
        versionRange = specifier.version;
      }
      for (const candidate of packagesByName.get(name) || []) {
        if (semver.satisfies(candidate.version, versionRange)) {
          deps.push({ dep: bzlName(candidate.resolution), name });
          break;
        }
      }
    }
  }

  let bzl = "";
  bzl += `PACKAGES = ${BzlPackages.serialize(bzlPackages)}\n\n`;
  bzl += `ROOTS = ${BzlRoots.serialize(bzlRoots)}\n\n`;

  if (args.output === "-") {
    process.stdout.write(bzl);
  } else {
    fs.writeFileSync(args.output, bzl);
  }

  console.error(`Processed ${bzlPackages.length} packages`);
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
