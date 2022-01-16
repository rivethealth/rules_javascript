import { ArgumentParser } from "argparse";
import * as fs from "fs";
import * as childProcess from "child_process";
import { BzlPackages, BzlDep, BzlRoots, BzlPackage } from "./bzl";
import { JsonFormat } from "@better-rules-javascript/util-json";
import { YarnPackageInfo } from "./yarn";
import * as path from "path";
import { resolvePackages } from "./resolve";

const RUNFILES_DIR = process.env.RUNFILES_DIR!;
const YARN_BIN = path.resolve(RUNFILES_DIR, "better_rules_javascript/npm/yarn");

(async () => {
  const parser = new ArgumentParser({
    description: "Generate Starlark from yarn resolutions.",
    prog: "yarn-resolve",
  });
  parser.add_argument("--dir", {
    help: "Directory for package.json and yarn.lock.",
    required: true,
  });
  parser.add_argument("--refresh", {
    action: "store_true",
    help: "Run yarn to refresh yarn.lock.",
  });
  parser.add_argument("output", { help: "Path to Starlark output." });

  const args = parser.parse_args();

  if (args.refresh) {
    refreshYarn(args.dir);
  }

  const packageInfos = getPackageInfos(args.dir);
  const { packages: bzlPackages, roots: bzlRoots } =
    resolvePackages(packageInfos);
  fs.writeFileSync(args.output, serializeBzl(bzlRoots, bzlPackages));

  console.error(`Processed ${bzlPackages.length} packages`);
})().catch((e) => {
  console.error(e);
  process.exit(1);
});

function getPackageInfos(dir: string) {
  const infoResult = childProcess.spawnSync(
    YARN_BIN,
    ["info", "-R", "--json", "--virtuals"],
    { cwd: dir, stdio: ["ignore", "pipe", "inherit"], encoding: "utf-8" },
  );
  if (infoResult.error) {
    throw new Error(`Yarn info failed with ${infoResult.error}`);
  }
  if (infoResult.status) {
    throw new Error(`Yarn info failed with code ${infoResult.status}`);
  }

  return infoResult.stdout
    .trim()
    .split("\n")
    .map((line) => JsonFormat.parse(YarnPackageInfo.json(), line));
}

function refreshYarn(dir: string) {
  const installResult = childProcess.spawnSync(
    YARN_BIN,
    ["install", "--mode", "update-lockfile"],
    {
      cwd: dir,
      stdio: ["ignore", "inherit", "inherit"],
    },
  );
  if (installResult.error) {
    throw new Error(`Yarn install failed with ${installResult.error}`);
  }
  if (installResult.status) {
    throw new Error(`Yarn install failed with code ${installResult.status}`);
  }
}

function serializeBzl(roots: BzlRoots, packages: BzlPackages): string {
  let bzl = "";
  bzl += `PACKAGES = ${BzlPackages.serialize(packages)}\n\n`;
  bzl += `ROOTS = ${BzlRoots.serialize(roots)}\n\n`;
  return bzl;
}
