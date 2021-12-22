import { ArgumentParser } from "argparse";
import { PackageTree } from "@better-rules-javascript/commonjs-package";
import { JsonFormat } from "@better-rules-javascript/commonjs-package/json";
import * as tarStream from "tar-stream";
import * as fs from "fs";
import * as path from "path";
import { promisify } from "util";

function packagePathName(id: string): string {
  return id.replace(/@/g, "").replace(/:/g, "_").replace(/\//g, "_");
}

interface Args {
  manifest: string;
  output: string;
  root?: string;
  files: string[];
}

(async () => {
  const parser = new ArgumentParser(<any>{
    prog: "nodejs-archive-linker",
    fromfile_prefix_chars: "@",
  });
  parser.add_argument("--manifest", { required: true });
  parser.add_argument("--output", { required: true });
  parser.add_argument("--root", { help: "Root package ID" });
  parser.add_argument("files", { nargs: "*" });
  const args: Args = parser.parse_args();

  const packageTree = JsonFormat.parse(
    PackageTree.json(),
    fs.readFileSync(args.manifest, "utf8"),
  );

  const output = fs.createWriteStream(args.output);

  const tar = tarStream.pack();
  tar.pipe(output);
  const write: (
    headers: tarStream.Headers,
    buffer?: string | Buffer,
  ) => Promise<void> = promisify(tar.entry).bind(tar);
  const copyFile = async (name: string, path: string) => {
    const content = fs.readFileSync(path);
    const stat = fs.statSync(path);
    await write({ name, mode: stat.mode }, content);
  };

  const packagesByPath = new Map<string, string>();
  for (const [id, package_] of packageTree.entries()) {
    packagesByPath.set(package_.path, id);

    const packagePath = packagePathName(id);
    if (id !== args.root) {
      await write({ type: "directory", name: packagePath });
    }
    for (const [name, dep] of package_.deps) {
      const path_ =
        id === args.root ? `_/${name}` : `${packagePath}/node_modules/${name}`;
      const otherPath = packagePathName(dep);
      await write({
        type: "symlink",
        name: path_,
        linkname: path.relative(path.dirname(path_), otherPath),
      });
    }
  }

  for (const file of args.files) {
    const parts = file.split("/");
    let i: number;
    for (i = parts.length; 0 <= i; i--) {
      const path = parts.slice(0, i).join("/");
      const packageId = packagesByPath.get(path);
      if (packageId !== undefined) {
        await copyFile(
          `${packagePathName(packageId)}/${parts.slice(i).join("/")}`,
          file,
        );
        break;
      }
    }
    if (i < 0) {
      console.error(`Could not find package for file ${file}`);
      process.exit(1);
    }
  }

  tar.finalize();
})();
