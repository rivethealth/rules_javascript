import { ArgumentParser } from "argparse";
import * as fs from "fs";
import * as path from "path";

const parser = new ArgumentParser({
  prog: "typescript-config",
  description: "Generate tsconfig.",
});
parser.add_argument("--config");
parser.add_argument("--declaration-dir", { dest: "declarationDir" });
parser.add_argument("--root-dir", { dest: "rootDir" });
parser.add_argument("--root-dirs", {
  action: "append",
  dest: "rootDirs",
  default: [],
});
parser.add_argument("--out-dir", { dest: "outDir" });
parser.add_argument("--type-root", {
  action: "append",
  dest: "typeRoots",
  default: [],
});
parser.add_argument("output");

interface Args {
  config?: string;
  declarationDir?: string;
  rootDir?: string;
  rootDirs: string[];
  outDir?: string;
  typeRoots: string[];
  output?: string;
}

(async () => {
  const args: Args = parser.parse_args();

  const outDir = path.dirname(args.output);
  const relative = (path_: string) => {
    let result = path.relative(outDir, path_);
    if (!result.startsWith("./") && !result.startsWith("../")) {
      result = `./${result}`;
    }
    return result;
  };

  const tsconfig: any = {
    compilerOptions: {
      typeRoots: args.typeRoots.map(relative),
    },
  };

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
    tsconfig.include = [path.join(relative(args.rootDir), "**/*")];
    tsconfig.exclude = [];
  } else {
    tsconfig.files = [];
  }

  if (args.outDir) {
    tsconfig.compilerOptions.outDir = relative(args.outDir);
    tsconfig.compilerOptions.sourceMap = true;
  }

  if (args.config) {
    tsconfig.extends = relative(args.config);
  }

  await fs.promises.writeFile(args.output, JSON.stringify(tsconfig), "utf8");
})().catch((e) => {
  console.error(e);
  process.exit(1);
});
