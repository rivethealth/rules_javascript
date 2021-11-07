import { ArgumentParser } from "argparse";
import * as fs from "fs";
import * as lockfile from "@yarnpkg/lockfile";
import { parsePackageName } from "./util";

const parser = new ArgumentParser();
const subparsers = parser.add_subparsers({ dest: "command" });

const yarnParser = subparsers.add_parser("yarn");
yarnParser.add_argument("--lock", { required: true });
yarnParser.add_argument("--package", { required: true });
yarnParser.add_argument("output");

const args = parser.parse_args();

const packageData = JSON.parse(fs.readFileSync(args.package, "utf8"));

const lockData = lockfile.parse(fs.readFileSync(args.lock, "utf8"));

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
