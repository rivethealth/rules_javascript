import { ArgumentParser } from "argparse";
import { JsonFormat } from "@better-rules-javascript/util-json";
import * as fs from "fs";
import * as path from "path";

const parser = new ArgumentParser({
  prog: "typescript-config",
  description: "Generate tsconfig.",
});
parser.add_argument("--config");
parser.add_argument("--empty", {
  default: false,
  help: "Whether to have empty file list",
});
parser.add_argument("--declaration-dir", { dest: "declarationDir" });
parser.add_argument("--module");
parser.add_argument("--root-dir", { dest: "rootDir", required: true });
parser.add_argument("--source-map", { default: "false", dest: "sourceMap" });
parser.add_argument("--out-dir", { dest: "outDir" });
parser.add_argument("--source-root", { dest: "sourceRoot" });
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
  empty: boolean;
  module?: string;
  rootDir: string;
  outDir?: string;
  sourceMap: "true" | "false";
  sourceRoot?: string;
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
  };
  tsconfig.compilerOptions.rootDir = relative(args.rootDir);
  if (args.empty) {
    tsconfig.files = [];
  } else {
    tsconfig.include = [`${tsconfig.compilerOptions.rootDir}/**/*`];
    tsconfig.exclude = [];
  }

  if (args.module) {
    tsconfig.compilerOptions.module = args.module;
  }

  if (args.declarationDir) {
    tsconfig.compilerOptions.declaration = true;
    tsconfig.compilerOptions.declarationDir = relative(args.declarationDir);
    if (!args.outDir) {
      tsconfig.compilerOptions.emitDeclarationOnly = true;
    }
  }

  if (args.outDir) {
    tsconfig.compilerOptions.outDir = relative(args.outDir);
  }

  if (args.config) {
    tsconfig.extends = relative(args.config);
  }

  if (args.sourceRoot) {
    tsconfig.compilerOptions.sourceRoot = args.sourceRoot;
  }

  tsconfig.compilerOptions.sourceMap = args.sourceMap === "true";
  tsconfig.compilerOptions.inlineSources = args.sourceMap === "true";

  if (args.target) {
    tsconfig.compilerOptions.target = args.target;
  }

  const content = JsonFormat.stringify(JsonFormat.any(), tsconfig);
  await fs.promises.writeFile(args.output, content, "utf8");
})().catch((e) => {
  console.error(e);
  process.exit(1);
});
