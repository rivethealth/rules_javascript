import { ArgumentParser } from "argparse";
import * as fs from "fs";
import * as path from "path";

function booleanType(str: string) {
  switch (str) {
    case "true":
      return true;
    case "false":
      return false;
  }
  throw new TypeError(`Could not covert string to boolean: ${str}`);
}

const parser = new ArgumentParser();
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

  let tsconfig: any;
  if (args.config) {
    tsconfig = JSON.parse(await fs.promises.readFile(args.config, "utf8"));
  } else {
    tsconfig = {};
  }
  tsconfig.compilerOptions = tsconfig.compilerOptions || {};
  tsconfig.compilerOptions.declaration = true;
  console.error("IMPORT HELPERS IS", args.importHelpers);
  tsconfig.compilerOptions.importHelpers = args.importHelpers;
  tsconfig.compilerOptions.outDir = relative(args.outDir);
  tsconfig.compilerOptions.rootDir = relative(args.rootDir);
  tsconfig.compilerOptions.rootDirs = args.rootDirs.map(relative);
  tsconfig.compilerOptions.sourceMap = true;
  tsconfig.compilerOptions.typeRoots = args.typeRoots.map(relative);
  tsconfig.files = args.files.map(relative);
  delete tsconfig.compilerOptions.declarationDir;
  await fs.promises.writeFile(args.output, JSON.stringify(tsconfig), "utf8");
})().catch((e) => {
  console.error(e);
  process.exit(1);
});
