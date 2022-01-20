import { ArgumentParser } from "argparse";
import * as fs from "fs";
import * as childProcess from "child_process";
import { BzlPackages, BzlRoots } from "./bzl";
import { JsonFormat } from "@better-rules-javascript/util-json";
import { YarnLocator, YarnPackageInfo, YarnVersion } from "./yarn";
import * as path from "path";
import { resolvePackages } from "./resolve";
import { NpmPackage, NpmRegistryClient } from "./npm";

const RUNFILES_DIR = process.env.RUNFILES_DIR!;
const YARN_BIN = path.resolve(RUNFILES_DIR, "better_rules_javascript/npm/yarn");

(async () => {
  // parse args
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

  // refresh
  if (args.refresh) {
    console.error("Refreshing Yarn");
    refreshYarn(args.dir);
  }

  // list packages
  console.error("Listing packages");
  const packageInfos = await getPackageInfos(args.dir);

  // load cache
  const cachePath = path.join(args.dir, ".bazel-npm-cache.json");
  let cacheContent: string;
  try {
    cacheContent = fs.readFileSync(cachePath, "utf-8");
  } catch (e) {
    cacheContent = "[]";
  }
  const cache = JsonFormat.parse(Cache.json(), cacheContent);
  const newCache = new Map<string, NpmPackage>();

  // resolve
  const npmClient = new NpmRegistryClient();
  const { packages: bzlPackages, roots: bzlRoots } = await resolvePackages(
    packageInfos,
    async (specifier) => {
      const id = `${specifier.name}@${specifier.version}`;
      const package_ =
        cache.get(id) || (await npmClient.getPackageVersion(specifier));
      newCache.set(id, package_);
      return package_;
    },
    (message) => console.error(message),
  );

  // save cache
  fs.writeFileSync(cachePath, JsonFormat.stringify(Cache.json(), newCache));

  // output
  bzlPackages.sort((a, b) => +(a.id > b.id) - +(a.id < b.id));
  fs.writeFileSync(args.output, serializeBzl(bzlRoots, bzlPackages));
  console.error(`Created ${bzlPackages.length} packages`);
})().catch((e) => {
  console.error(e);
  process.exit(1);
});

type Cache = Map<string, NpmPackage>;

namespace Cache {
  export function json(): JsonFormat<Cache> {
    return JsonFormat.map(JsonFormat.string(), JsonFormat.identity());
  }
}

async function getPackageInfos(dir: string) {
  // buffer too large for spawnSync
  // https://stackoverflow.com/questions/63796633/spawnsync-bin-sh-enobufs
  const infoProcess = childProcess.spawn(
    YARN_BIN,
    ["info", "-R", "--dependents", "--json", "--virtuals"],
    { cwd: dir, stdio: ["ignore", "pipe", "inherit"] },
  );
  const chunks: Buffer[] = [];
  infoProcess.stdout.on("data", (chunk) => chunks.push(chunk));
  await new Promise((resolve, reject) => {
    infoProcess.on("error", reject);
    infoProcess.on("close", resolve);
  });
  if (infoProcess.exitCode) {
    throw new Error(`Yarn info failed with code ${infoProcess.exitCode}`);
  }
  const infos = Buffer.concat(chunks)
    .toString()
    .trim()
    .split("\n")
    .map((line) => JsonFormat.parse(YarnPackageInfo.json(), line));

  const byId = new Map<string, YarnPackageInfo>(
    infos.map((package_) => [YarnLocator.serialize(package_.value), package_]),
  );

  // fixup dependencies
  // virtual packages don't display dependencies
  // won't work with package aliases
  for (const info of infos) {
    for (const dependent of info.children.Dependents || []) {
      if (dependent.version.type === YarnVersion.VIRTUAL) {
        const package_ = byId.get(YarnLocator.serialize(dependent));
        if (!package_.children.Dependencies) {
          package_.children.Dependencies = [];
        }
        package_.children.Dependencies.push({
          descriptor: {
            name: info.value.name,
            version: YarnVersion.serialize(info.value.version),
          },
          locator: info.value,
        });
      }
    }
  }

  return infos;
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
