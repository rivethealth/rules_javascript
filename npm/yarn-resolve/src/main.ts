import { ArgumentParser } from "argparse";
import * as fs from "node:fs";
import * as childProcess from "child_process";
import { toStarlarkFile } from "./bzl";
import { JsonFormat } from "@better-rules-javascript/util-json";
import { YarnLocator, YarnPackageInfo, YarnVersion } from "./yarn";
import * as path from "node:path";
import { getPackage, ResolvedNpmPackage, resolvePackages } from "./resolve";
import { NpmRegistryClient, NpmSpecifier } from "./npm";
import { printStarlark } from "./starlark";

const RUNFILES_DIR = process.env.RUNFILES_DIR!;
const YARN_BIN = path.join(RUNFILES_DIR, "better_rules_javascript/npm/yarn");

(async () => {
  // parse args
  const parser = new ArgumentParser({
    description: "Generate JSON package tree from yarn resolutions.",
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
  parser.add_argument("output", { help: "Path to JSON output." });

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
  let cacheContent: string | undefined;
  try {
    cacheContent = fs.readFileSync(cachePath, "utf-8");
  } catch (e) {}
  if (
    cacheContent !== undefined &&
    !cacheContent.startsWith('{"_version":"1"')
  ) {
    cacheContent = undefined;
  }
  const newCache: Cache = {
    _version: "1",
    packages: new Map(),
  };
  const cache: Cache = cacheContent
    ? JsonFormat.parse(Cache.json(), cacheContent)
    : newCache;

  // resolve
  const npmClient = new NpmRegistryClient();
  const { packages: bzlPackages, roots: bzlRoots } = await resolvePackages(
    packageInfos,
    async (specifier) => {
      const id = NpmSpecifier.stringify(specifier);
      const package_ =
        cache.packages.get(id) || (await getPackage(npmClient, specifier));
      newCache.packages.set(id, package_);
      return package_;
    },
    (message) => console.error(message),
  );

  // save cache
  fs.promises.writeFile(
    cachePath,
    JsonFormat.stringify(Cache.json(), newCache),
  );

  // output
  const starlarkFile = toStarlarkFile(bzlPackages, bzlRoots);
  fs.writeFileSync(args.output, printStarlark(starlarkFile));
  console.error(`Created ${bzlPackages.size} packages`);
})().catch((e) => {
  console.error(e);
  process.exit(1);
});

interface Cache {
  _version: "1";
  packages: Map<string, ResolvedNpmPackage>;
}

namespace Cache {
  export function json(): JsonFormat<Cache> {
    return JsonFormat.object({
      _version: JsonFormat.identity(),
      packages: JsonFormat.map(JsonFormat.string(), ResolvedNpmPackage.json()),
    });
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
