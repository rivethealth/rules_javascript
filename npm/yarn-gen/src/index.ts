import { ArgumentParser } from "argparse";
import * as fs from "fs";
import * as childProcess from "child_process";
import * as path from "path";
import * as lockfile from "@yarnpkg/lockfile";
import * as yaml from "yaml";
import { parsePackageName, specifierV1, specifierV2 } from "./util";

async function main() {
  const parser = new ArgumentParser({
    description: "Convert yarn lock file to Starlark",
    prog: "yarn-gen",
  });
  parser.add_argument("--dir", {
    help: "Directory for refresh. Defaults to .",
    default: ".",
  });
  parser.add_argument("--package", { help: "Path to package.json." });
  parser.add_argument("--lock", { help: "Path to yarn.lock." });
  parser.add_argument("--refresh", {
    action: "store_true",
    help: "Run yarn to refresh yarn.lock. For version 1, node_modules will also be updated.",
  });
  parser.add_argument("--version", {
    default: "1",
    choices: ["1", "2"],
    help: "Yarn version. Defaults to 1.",
  });
  parser.add_argument("output", { help: "Path to Starlark output." });

  const args = parser.parse_args();

  if (args.refresh) {
    if (args.lock) {
      throw new Error("Cannot set --lock if --refresh is enabled");
    }
    if (args.package) {
      throw new Error("Cannot set --package if --refresh is enabled");
    }
  }
  const lockPath = args.lock || path.resolve(args.dir, "yarn.lock");
  const packagePath = args.path || path.resolve(args.dir, "package.json");

  if (!fs.existsSync(packagePath)) {
    throw new Error(`Package file does not exist at ${packagePath}`);
  }

  if (args.refresh) {
    let installProcess: childProcess.ChildProcess;
    if (args.version === "1") {
      const yarnBin = `${process.env.RUNFILES_DIR}/${process.env._YARN_BIN}`;
      installProcess = childProcess.spawn(yarnBin, ["install"], {
        cwd: args.dir,
        stdio: ["ignore", "inherit", "inherit"],
      });
    } else {
      const yarnBin = `${process.env.RUNFILES_DIR}/${process.env._YARN2_BIN}`;
      installProcess = childProcess.spawn(
        yarnBin,
        ["install", "--mode", "update-lockfile"],
        {
          cwd: args.dir,
          stdio: ["ignore", "inherit", "inherit"],
        },
      );
    }

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

  const packages = [];
  const roots = [];

  const packageData = JSON.parse(fs.readFileSync(packagePath, "utf8"));
  const lockText = fs.readFileSync(lockPath, "utf8");
  if (args.version === "1") {
    const lockResult = lockfile.parse(lockText);
    if (lockResult.type !== "success") {
      throw new Error(lockResult.type);
    }
    const lockData = lockResult.object;

    const packageByObject = new Map();
    const packageBySpecifier = new Map();

    for (const [specifier, obj] of <any[]>Object.entries(lockData)) {
      if (!packageByObject.has(obj)) {
        const { name } = parsePackageName(specifier);

        const package_ = {
          name: `${name}@${obj.version}`,
          url: obj.resolved,
          integrity: obj.integrity,
          deps: [],
        };
        packages.push(package_);

        packageByObject.set(obj, package_);
      }
      packageBySpecifier.set(specifier, packageByObject.get(obj));
    }

    for (const obj of <any[]>Object.values(lockData)) {
      const package_ = packageByObject.get(obj);
      if (!obj.dependencies || package_.deps.length) {
        continue;
      }
      for (const [name, version] of Object.entries(obj.dependencies)) {
        let specifier = specifierV1(name, <string>version);
        if (specifier === "@isaacs/string-locale-compare@^1.1.0") {
          specifier = "@isaacs/string-locale-compare@^1.0.1";
        }
        if (specifier === "@npmcli/arborist@^4.0.4") {
          specifier = "@npmcli/arborist@^4.0.0";
        }
        const depPackage = packageBySpecifier.get(specifier);
        if (!depPackage) {
          throw new Error(`Unknown dependency: "${specifier}"`);
        }
        package_.deps.push({ dep: depPackage.name, name });
      }
    }

    for (const [name, version] of Object.entries({
      ...(packageData.dependencies || {}),
      ...(packageData.devDependencies || {}),
    })) {
      const package_ = packageBySpecifier.get(
        specifierV1(name, <string>version),
      );
      if (!package_) {
        throw new Error(`No package for ${name}`);
      }
      roots.push({ name, dep: package_.name });
    }
  } else {
    const lockData = yaml.parse(lockText);

    const packageByObject = new Map();
    const packageBySpecifier = new Map();

    for (const [key, obj] of <any[]>Object.entries(lockData)) {
      if (key === "__metadata") {
        continue;
      }

      const specifiers = key.split(", ");
      const { name } = parsePackageName(specifiers[0]);

      const baseName = name.split("/").slice(-1)[0];
      // can't understand how checksum is calculated (seems like SHA-512 but doesn't match)
      const package_ = {
        name: `${name}@${obj.version}`,
        url: `https://registry.npmjs.org/${name}/-/${baseName}-${obj.version}.tgz`,
        deps: [],
      };
      packages.push(package_);

      packageByObject.set(obj, package_);

      for (const specifier of specifiers) {
        packageBySpecifier.set(specifier, package_);
      }
    }

    for (const obj of <any[]>Object.values(lockData)) {
      const package_ = packageByObject.get(obj);
      if (!package_) {
        continue;
      }

      if (!obj.dependencies || package_.deps.length) {
        continue;
      }
      // TODO: add peerDependencies
      const deps = [...Object.entries(obj.dependencies || [])];
      for (const [name, version] of deps) {
        const specifier = specifierV2(name, String(version));
        const depPackage = packageBySpecifier.get(specifier);
        if (!depPackage) {
          throw new Error(`Unknown dependency: ${specifier}`);
        }
        package_.deps.push({ dep: depPackage.name, name });
      }
    }

    for (const [name, version] of Object.entries({
      ...(packageData.dependencies || {}),
      ...(packageData.devDependencies || {}),
    })) {
      const package_ = packageBySpecifier.get(
        specifierV2(name, <string>version),
      );
      if (!package_) {
        throw new Error(`No package for ${name}`);
      }
      roots.push({ name, dep: package_.name });
    }
  }

  let bzl = "";
  bzl += `PACKAGES = ${JSON.stringify(packages, undefined, 4)}\n\n`;
  bzl += `ROOTS = ${JSON.stringify(roots, undefined, 4)}\n\n`;

  if (args.output === "-") {
    console.log(bzl);
  } else {
    fs.writeFileSync(args.output, bzl);
  }

  console.error(`Processed ${packages.length} packages`);
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
