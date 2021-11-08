import "source-map-support/register";
import { ArgumentParser } from "argparse";
import * as fs from "fs";
import * as childProcess from "child_process";
import * as path from "path";
import * as lockfile from "@yarnpkg/lockfile";
import { parsePackageName } from "./util";

async function main() {
  const parser = new ArgumentParser({
    description: "Convert yarn lock file to Starlark",
  });
  parser.add_argument("--dir", { default: "." });
  parser.add_argument("--package");
  parser.add_argument("--lock");
  parser.add_argument("--refresh", { action: "store_true" });
  parser.add_argument("output");

  const args = parser.parse_args();

  const lockPath = args.lock || path.resolve(args.dir, "yarn.lock");
  const packagePath = args.path || path.resolve(args.dir, "package.json");

  if (!fs.existsSync(packagePath)) {
    throw new Error(`Package file does not exist at ${packagePath}`);
  }

  if (args.refresh) {
    const yarnBin = (<any>global).runfilePath(process.env.YARN_BIN);
    const installProcess = childProcess.spawn(yarnBin, ["install"], {
      cwd: args.dir,
      stdio: ["ignore", "inherit", "inherit"],
    });
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

  const packageData = JSON.parse(fs.readFileSync(packagePath, "utf8"));

  const lockData = lockfile.parse(fs.readFileSync(lockPath, "utf8"));
  if (lockData.type !== "success") {
    throw new Error(lockData.type);
  }

  const packageByObject = new Map();
  const packageBySpecifier = new Map();
  const packages = [];

  for (const [specifier, obj] of <any[]>Object.entries(lockData.object)) {
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

  for (const obj of <any[]>Object.values(lockData.object)) {
    const package_ = packageByObject.get(obj);
    if (!obj.dependencies || package_.deps.length) {
      continue;
    }
    for (const [name, version] of Object.entries(obj.dependencies)) {
      const depPackage = packageBySpecifier.get(`${name}@${version}`);
      package_.deps.push({ dep: depPackage.name, name });
    }
  }

  const roots = [];
  for (const [name, version] of Object.entries({
    ...(packageData.dependencies || {}),
    ...(packageData.devDependencies || {}),
  })) {
    const package_ = packageBySpecifier.get(`${name}@${version}`);
    if (!package_) {
      throw new Error(`No package for ${name}`);
    }
    roots.push({ name, dep: package_.name });
  }

  let bzl = "";
  bzl += `PACKAGES = ${JSON.stringify(packages, undefined, 4)}\n\n`;
  bzl += `ROOTS = ${JSON.stringify(roots, undefined, 4)}\n\n`;

  if (args.output === "-") {
    console.log(bzl);
  } else {
    fs.writeFileSync(args.output, bzl);
  }
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
