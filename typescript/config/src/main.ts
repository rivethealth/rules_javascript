import { ArgumentParser } from "argparse";
import { writeFile } from "node:fs/promises";
import { dirname, relative } from "node:path";

const parser = new ArgumentParser(<any>{
  prog: "typescript-config",
  description: "Generate tsconfig.",
  fromfile_prefix_chars: "@",
});
parser.add_argument("--config");
parser.add_argument("--declaration-dir", { dest: "declarationDir" });
parser.add_argument("--file", { dest: "files", action: "append", default: [] });
parser.add_argument("--module");
parser.add_argument("--root-dir", { dest: "rootDir", required: true });
parser.add_argument("--root-dirs", { dest: "rootDirs", action: "append" });
parser.add_argument("--source-map", { default: "false", dest: "sourceMap" });
parser.add_argument("--out-dir", { dest: "outDir" });
parser.add_argument("--target");
parser.add_argument("--type-root", {
  action: "append",
  dest: "typeRoots",
  default: [],
});
parser.add_argument("output");

interface Args {
  config?: string;
  declarationDir?: string;
  files: string[];
  empty: boolean;
  module?: string;
  rootDir: string;
  rootDirs?: string[];
  outDir?: string;
  sourceMap: "true" | "false";
  target?: string;
  typeRoots: string[];
  output: string;
}

(async () => {
  const args: Args = parser.parse_args();

  const outDir = dirname(args.output);
  const relativePath = (path_: string) => {
    let result = relative(outDir, path_);
    const [first] = result.split("/", 1);
    if (first != "." && first != "..") {
      result = `./${result}`;
    }
    return result;
  };

  const tsconfig: any = {
    compilerOptions: {
      composite: true,
      declaration: !!args.declarationDir,
      typeRoots: args.typeRoots.map(relativePath),
      rootDir: relativePath(args.rootDir),
      sourceMap: args.sourceMap === "true",
      inlineSources: args.sourceMap === "true",
    },
    files: args.files.map(relativePath),
  };
  if (args.rootDirs) {
    tsconfig.compilerOptions.rootDirs = args.rootDirs.map(relativePath);
  }

  if (args.module) {
    tsconfig.compilerOptions.module = args.module;
  }

  if (args.declarationDir) {
    tsconfig.compilerOptions.declarationDir = relativePath(args.declarationDir);
    if (!args.outDir) {
      tsconfig.compilerOptions.emitDeclarationOnly = true;
    }
  }

  if (args.outDir) {
    tsconfig.compilerOptions.outDir = relativePath(args.outDir);
  }

  if (args.config) {
    tsconfig.extends = relativePath(args.config);
  }

  if (args.target) {
    tsconfig.compilerOptions.target = args.target;
  }

  const content = JSON.stringify(tsconfig);
  await writeFile(args.output, content, "utf8");
})().catch((error) => {
  console.error(error);
  process.exit(1);
});
