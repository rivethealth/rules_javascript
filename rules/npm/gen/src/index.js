const { ArgumentParser } = require("argparse");
const fs = require("fs");
const lockfile = require("@yarnpkg/lockfile");
const { parsePackageName } = require("./util");

const parser = new ArgumentParser();
const subparsers = parser.addSubparsers({ dest: "command" });

const yarnParser = subparsers.addParser("yarn");
yarnParser.addArgument("--lock", { required: true });
yarnParser.addArgument("--package", { required: true });
yarnParser.addArgument("output");

const args = parser.parseArgs();

const packageData = JSON.parse(fs.readFileSync(args.package, "utf8"));

const lockData = lockfile.parse(fs.readFileSync(args.lock, "utf8"));

if (lockData.type !== "success") {
  throw new Error(lockData.type);
}

const packageByObject = new Map();
const packageBySpecifier = new Map();
const packages = [];

for (const [specifier, obj] of Object.entries(lockData.object)) {
  if (!packageByObject.has(obj)) {
    const { name } = parsePackageName(specifier);

    const package = {
      name: `${name}@${obj.version}`,
      url: obj.resolved,
      integrity: obj.integrity,
      deps: [],
    };
    packages.push(package);

    packageByObject.set(obj, package);
  }
  packageBySpecifier.set(specifier, packageByObject.get(obj));
}

for (const obj of Object.values(lockData.object)) {
  const package = packageByObject.get(obj);
  if (!obj.dependencies || package.deps.length) {
    continue;
  }
  for (const [name, version] of Object.entries(obj.dependencies)) {
    const depPackage = packageBySpecifier.get(`${name}@${version}`);
    package.deps.push({ dep: depPackage.name, name });
  }
}

const roots = [];
for (const [name, version] of Object.entries({
  ...(packageData.dependencies || {}),
  ...(packageData.devDependencies || {}),
})) {
  const package = packageBySpecifier.get(`${name}@${version}`);
  roots.push({ name, dep: package.name });
}

let bzl = "";
bzl += `PACKAGES = ${JSON.stringify(packages, undefined, 2)}\n\n`;
bzl += `ROOTS = ${JSON.stringify(roots, undefined, 2)}\n\n`;

if (args.output === "-") {
  console.log(bzl);
} else {
  fs.writeFileSync(args.output, bzl);
}
