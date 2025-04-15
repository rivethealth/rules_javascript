import {
  InstallEntry,
  InstallManifest,
  installManifestFormat,
} from "@better-rules-javascript/pkg-install-manifest";
import { JsonFormat } from "@better-rules-javascript/util-json";
import { ArgumentParser } from "argparse";
import { createHash } from "node:crypto";
import {
  open,
  readFile,
  readdir,
  readlink,
  stat,
  writeFile,
} from "node:fs/promises";
import { join } from "node:path";

export class InstallManifestGenWorker {
  constructor() {
    const parser = new ArgumentParser();
    parser.add_argument("--dir", {
      action: "append",
      default: [],
      metavar: ["NAME", "ORIGIN"],
      nargs: 2,
    });
    parser.add_argument("--file", {
      action: "append",
      default: [],
      metavar: ["NAME", "SRC", "RUNFILE", "EXECUTABLE", "ORIGIN"],
      nargs: 5,
    });
    parser.add_argument("--manifest", {
      action: "append",
      default: [],
      metavar: "PATH",
    });
    parser.add_argument("--origin", {
      action: "store_true",
      default: false,
    });
    parser.add_argument("--symlink", {
      action: "append",
      default: [],
      metavar: ["NAME", "TARGET", "ORIGIN"],
      nargs: 3,
    });
    parser.add_argument("output", { metavar: "PATH" });
    this.parser = parser;
  }

  private readonly parser: ArgumentParser;

  async run(a: string[]) {
    const args = this.parser.parse_args(a) as {
      dir: [string, string][];
      file: [string, string, string, string, string][];
      manifest: string[];
      origin: boolean;
      output: string;
      symlink: [string, string, string][];
    };

    const result: InstallManifest = {
      type: InstallEntry.DIR,
      entries: new Map(),
    };

    const add = (name: string, entry: InstallEntry, origin: string) => {
      let parent = result;
      const parts = name.split("/");
      for (const part of parts.slice(0, -1)) {
        let child = parent.entries.get(part);
        if (child === undefined) {
          child = dirEntry(origin);
          parent.entries.set(part, child);
        }
        if (child.type !== InstallEntry.DIR) {
          throw new ConflictError(name, entry, parent);
        }
        parent = child;
      }
      parent.entries.set(parts.at(-1)!, entry);
    };

    const merge = (
      root: InstallEntry.Dir,
      name: string,
      entry: InstallEntry,
      { path }: { path: string },
    ) => {
      if (entry.type === InstallEntry.DIR) {
        let child = root.entries.get(name);
        if (child === undefined) {
          child = dirEntry(entry.origin);
          root.entries.set(name, child);
        } else if (child.type !== InstallEntry.DIR) {
          throw new ConflictError(join(path, name), entry, child);
        }
        for (const [name, e] of entry.entries) {
          merge(child, name, e, { path: join(path, name) });
        }
      } else if (root.entries.has(name)) {
        // const existing = root.entries.get(name)!;
        // throw new ConflictError(
        //   path,
        //   origins.get(existing)!,
        //   existing,
        //   origin,
        //   entry,
        // );
      } else {
        root.entries.set(name, entry);
      }
    };

    for (const [name, origin] of args.dir) {
      add(name, dirEntry(origin), origin);
    }

    for (const [name, target, origin] of args.symlink) {
      add(name.slice(1), symlinkEntry(target, origin), origin);
    }

    await Promise.all([
      ...args.file.map(async ([name, src, runfile, executable, origin]) => {
        const stats = await stat(src);
        const entry = stats.isDirectory()
          ? await fileDirEntry(src, runfile, origin)
          : stats.isSymbolicLink()
            ? await fileSymlinkEntry(src, origin)
            : await fileEntry(src, runfile, JSON.parse(executable), origin);
        add(name, entry, origin);
      }),
      ...args.manifest.map(async (path) => {
        const content = await readFile(path, "utf8");
        const manifest = JsonFormat.parse(installManifestFormat(true), content);
        for (const [name, entry] of manifest.entries) {
          merge(result, name, entry, { path: name });
        }
      }),
    ]);

    await writeFile(
      args.output,
      JsonFormat.stringify(installManifestFormat(args.origin), result),
    );
  }
}

function dirEntry(origin: string | undefined): InstallEntry.Dir {
  return {
    type: InstallEntry.DIR,
    entries: new Map(),
    origin,
  };
}

async function fileEntry(
  src: string,
  runfile: string,
  executable: boolean,
  origin: string | undefined,
): Promise<InstallEntry.File> {
  const hash = createHash("sha1");
  const input = await open(src);
  try {
    await new Promise<void>((resolve, reject) =>
      input
        .createReadStream()
        .on("end", resolve)
        .on("error", reject)
        .pipe(hash),
    );
  } finally {
    await input.close();
  }

  return {
    type: InstallEntry.FILE,
    digest: hash.digest(),
    executable,
    origin,
    src: runfile,
  };
}

function symlinkEntry(
  target: string,
  origin: string | undefined,
): InstallEntry.Symlink {
  return {
    type: InstallEntry.SYMLINK,
    origin,
    target,
  };
}

async function fileDirEntry(
  path: string,
  runfile: string,
  origin: string,
): Promise<InstallEntry.Dir> {
  const entries = new Map<string, InstallEntry>();
  await Promise.all(
    (await readdir(path, { withFileTypes: true })).map(async (child) => {
      if (child.isDirectory()) {
        entries.set(
          child.name,
          await fileDirEntry(
            join(path, child.name),
            join(runfile, child.name),
            origin,
          ),
        );
      } else if (child.isSymbolicLink()) {
        entries.set(child.name, symlinkEntry(join(path, child.name), origin));
      } else if (child.isFile()) {
        const stats = await stat(join(path, child.name));
        entries.set(
          child.name,
          await fileEntry(
            join(path, child.name),
            join(runfile, child.name),
            Boolean(stats.mode & 0b1),
            origin,
          ),
        );
      } else if (child.isSymbolicLink()) {
        const target = await readlink(join(path, child.name));
        entries.set(child.name, symlinkEntry(target, origin));
      }
    }),
  );

  return {
    type: InstallEntry.DIR,
    entries,
  };
}

async function fileSymlinkEntry(
  src: string,
  origin: string,
): Promise<InstallEntry.Symlink> {
  const target = await readlink(src);
  return symlinkEntry(target, origin);
}

class ConflictError extends Error {
  constructor(path: string, entry: InstallEntry, otherEntry: InstallEntry) {
    super(
      `Conflict at ${path}: ${entry.origin} has ${entry.type.description}, ${otherEntry.origin} has ${otherEntry.type.description}`,
    );
  }
}
