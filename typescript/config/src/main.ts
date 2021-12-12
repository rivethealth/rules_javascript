import { ArgumentParser } from "argparse";
import * as fs from "fs";
import * as path from "path";
import { booleanType } from "./cli";

const parser = new ArgumentParser({
  prog: "typescript-config",
  description: "Generate tsconfig.",
});
parser.add_argument("--config");
parser.add_argument("--import-helpers", {
  dest: "importHelpers",
  type: booleanType,
});
parser.add_argument("--root-dir", { dest: "rootDir" });
parser.add_argument("--root-dirs", {
  action: "append",
  default: [],
  dest: "rootDirs",
});
parser.add_argument("--out-dir", { required: true, dest: "outDir" });
parser.add_argument("--type-root", {
  action: "append",
  dest: "typeRoots",
  default: [],
});
parser.add_argument("output");
parser.add_argument("files", { nargs: "*", default: [] });

(async () => {
  const args = parser.parse_args();

  const outDir = path.dirname(args.output);
  const relative = (path_: string) => path.relative(outDir, path_);

  let tsconfig: any = {
    compilerOptions: {
      declaration: true,
      declarationDir: relative(args.outDir),
      importHelpers: args.importHelpers,
      outDir: relative(args.outDir),
      rootDir: relative(args.rootDir),
      rootDirs: args.rootDirs.map(relative),
      sourceMap: true,
      typeRoots: args.typeRoots.map(relative),
    },
    files: args.files.map(relative),
  };

  if (args.config) {
    tsconfig.extends = relative(args.config);
  }

  await fs.promises.writeFile(args.output, JSON.stringify(tsconfig), "utf8");
})().catch((e) => {
  console.error(e);
  process.exit(1);
});
