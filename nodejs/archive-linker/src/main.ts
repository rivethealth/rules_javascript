import { ArgumentParser } from "argparse";
import type { ArchiveFile, ArchiveLink } from "./archive";

interface Args {
  manifest: string;
  output: string;
  files: [string, string][];
  nodeModules: boolean;
  links: [string, string][];
}

(async () => {
  const parser = new ArgumentParser(<any>{
    prog: "nodejs-archive-linker",
    fromfile_prefix_chars: "@",
  });
  parser.add_argument("--manifest", {
    required: true,
    help: "Package manifest",
  });
  parser.add_argument("--node-modules", {
    default: false,
    dest: "nodeModules",
    help: "Whether this is generated for node_modules",
    type: Boolean,
  });
  parser.add_argument("--file", {
    action: "append",
    default: [],
    dest: "files",
    nargs: 2,
    metavar: ["NAME", "PATH"],
    help: "File",
  });
  parser.add_argument("--link", {
    action: "append",
    default: [],
    dest: "links",
    nargs: 2,
    metavar: ["NAME", "PATH"],
    help: "Package symlinks",
  });
  parser.add_argument("output", { help: "Output file" });
  const args: Args = parser.parse_args();

  const { createArchive } = await import("./archive");

  const links: ArchiveLink[] = args.links.map(([name, path]) => ({
    name,
    path,
  }));
  const files: ArchiveFile[] = args.files.map(
    ([name, path]): ArchiveFile => ({ name, path }),
  );
  await createArchive(
    { manifestPath: args.manifest, nodeModules: args.nodeModules, links },
    files,
    args.output,
  );
})();
