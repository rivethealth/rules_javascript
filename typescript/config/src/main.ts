import { ArgumentParser } from "argparse";
import { JsonFormat } from "@better-rules-javascript/util-json";
import * as fs from "fs";
import * as path from "path";

const parser = new ArgumentParser({
  prog: "typescript-config",
  description: "Generate tsconfig.",
});
parser.add_argument("--config");
parser.add_argument("--declaration-dir", { dest: "declarationDir" });
parser.add_argument("--module");
parser.add_argument("--root-dir", { dest: "rootDir" });
parser.add_argument("--file", { action: "append", default: [], dest: "files" });
parser.add_argument("--root-dirs", {
  action: "append",
  dest: "rootDirs",
  default: [],
});
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
  module?: string;
  rootDir?: string;
  rootDirs: string[];
  files: string[];
  outDir?: string;
  target?: string;
  typeRoots: string[];
  output?: string;
}

(async () => {
  const args: Args = parser.parse_args();

  const outDir = path.dirname(args.output);
  const relative = (path_: string) => {
    let result = path.relative(outDir, path_);
    const [first] = result.split("/", 1);
    if (first != "." && first != "..") {
      result = `./${result}`;
    }
    return result;
  };

  const tsconfig: any = {
    compilerOptions: {
      typeRoots: args.typeRoots.map(relative),
    },
    files: args.files.map(relative),
    include: [],
    exclude: [],
  };

  if (args.module) {
    tsconfig.compilerOptions.module = args.module;
  }

  if (args.rootDirs.length) {
    tsconfig.compilerOptions.rootDirs = (
      args.rootDirs.length ? args.rootDirs : [args.rootDir]
    ).map(relative);
  }

  if (args.declarationDir) {
    tsconfig.compilerOptions.declaration = true;
    tsconfig.compilerOptions.declarationDir = relative(args.declarationDir);
    if (!args.outDir) {
      tsconfig.compilerOptions.emitDeclarationOnly = true;
    }
  }

  if (args.rootDir) {
    tsconfig.compilerOptions.rootDir = relative(args.rootDir);
  }

  if (args.outDir) {
    tsconfig.compilerOptions.outDir = relative(args.outDir);
    tsconfig.compilerOptions.sourceMap = true;
  }

  if (args.config) {
    tsconfig.extends = relative(args.config);
  }

  if (args.target) {
    tsconfig.compilerOptions.target = args.target;
  }

  const content = JsonFormat.stringify(JsonFormat.any(), tsconfig);
  await fs.promises.writeFile(args.output, content, "utf8");
})().catch((e) => {
  console.error(e);
  process.exit(1);
});
