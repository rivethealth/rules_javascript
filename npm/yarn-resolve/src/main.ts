import { withFileCache } from "@better-rules-javascript/util-cache";
import { JsonFormat } from "@better-rules-javascript/util-json";
import { printStarlark } from "@better-rules-javascript/util-starlark";
import { structUtils } from "@yarnpkg/core";
import { ArgumentParser } from "argparse";
import * as fs from "fs";
import * as path from "path";
import { toStarlarkFile } from "./bzl";
import { NpmRegistryClient } from "./npm";
import { getPackage, ResolvedNpmPackage, resolvePackages } from "./resolve";
import { getPackageInfos, yarnProject } from "./yarn";

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
  parser.add_argument("output", { help: "Path to JSON output." });

  const args = parser.parse_args();

  const { configuration, project } = await yarnProject(args.dir);

  // list packages
  console.error("Listing packages");
  const packageInfos = await getPackageInfos(project);

  // resolve
  const cachePath = path.join(args.dir, ".bazel-npm-cache.json");
  const { packages: bzlPackages, roots: bzlRoots } = await withFileCache(
    cachePath,
    "2",
    JsonFormat.string(),
    ResolvedNpmPackage.json(),
  )(async (cache) => {
    const npmClient = new NpmRegistryClient(configuration);
    return await resolvePackages(
      packageInfos,
      async (npmSpecifier) => {
        const id = structUtils.stringifyLocator(npmSpecifier);
        return cache.asyncGet(
          id,
          async () => await getPackage(npmClient, npmSpecifier),
        );
      },
      (message) => console.error(message),
    );
  });

  // output
  const starlarkFile = toStarlarkFile(bzlPackages, bzlRoots);
  await fs.promises.writeFile(args.output, printStarlark(starlarkFile));
  console.error(`Created ${bzlPackages.size} packages`);
})().catch((e) => {
  console.error(e);
  process.exit(1);
});
