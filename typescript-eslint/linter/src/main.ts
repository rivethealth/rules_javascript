import { PackageTree } from "@better-rules-javascript/commonjs-package";
import { patchFs } from "@better-rules-javascript/nodejs-fs-linker/fs";
import { patchFsPromises } from "@better-rules-javascript/nodejs-fs-linker/fs-promises";
import { createVfs } from "@better-rules-javascript/nodejs-fs-linker/package";
import { ArgumentParser } from "argparse";
import { ESLint, Linter } from "eslint";
import { JsonFormat } from "@better-rules-javascript/util-json";
import { readFile, writeFile } from "node:fs/promises";

async function main() {
  const parser = new ArgumentParser();
  parser.add_argument("--config", { required: true });
  parser.add_argument("--manifest", { required: true });
  parser.add_argument("srcs", { nargs: "*" });

  const args = parser.parse_args();

  const packageTree = JsonFormat.parse(
    PackageTree.json(),
    await readFile(args.manifest, "utf8"),
  );
  const vfs = createVfs(packageTree);
  patchFs(vfs, require("node:fs"));
  patchFsPromises(vfs, require("node:fs").promises);

  const eslint = new ESLint({
    fix: true,
    globInputPaths: false,
    overrideConfigFile: args.config,
    useEslintrc: false,
  });

  for (const spec of args.srcs) {
    const [src, dest] = spec.split("=", 2);
    const input = await readFile(src, "utf-8")
    const [report] = await eslint.lintText(input, {
      filePath: src,
    });
    await writeFile(dest, report?.output ?? input, "utf-8");
    if (!report) {
      continue;
    }
    for (const message of report.messages) {
      console.log(messageString(src, message));
    }
    if (report.errorCount) {
      process.exit(2);
    }
  }
}

main().catch(error => {
  console.error(error.stack);
  process.exit(1);
});

function messageString(file: string, message: Linter.LintMessage) {
  return `${file} ${message.line}:${message.column}: ${message.ruleId} ${message.message}`;
}
