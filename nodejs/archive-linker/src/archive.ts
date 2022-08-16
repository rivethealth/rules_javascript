import { PackageTree } from "@better-rules-javascript/commonjs-package";
import { JsonFormat } from "@better-rules-javascript/util-json";
import * as tarStream from "tar-stream";
import * as fs from "node:fs";
import { promisify } from "util";
import * as path from "node:path";

export interface ArchiveFile {
  name: string;
  path: string;
}

export interface ArchiveLink {
  name: string;
  path: string;
}

export interface ArchivePackages {
  manifestPath: string;
  nodeModules: boolean;
  links: ArchiveLink[];
}

export async function createArchive(
  packages: ArchivePackages,
  entries: ArchiveFile[],
  outputPath: string,
) {
  const packageTree = JsonFormat.parse(
    PackageTree.json(),
    fs.readFileSync(packages.manifestPath, "utf8"),
  );

  const output = fs.createWriteStream(outputPath, {
    highWaterMark: 1024 * 128,
  });

  const tar = tarStream.pack();
  tar.pipe(output);

  const write: (
    headers: tarStream.Headers,
    buffer?: string | Buffer,
  ) => Promise<void> = promisify(tar.entry).bind(tar);

  const copyFile = async (name: string, path: string) => {
    const stat = await fs.promises.stat(path);
    if (stat.isDirectory()) {
      for (const child of await fs.promises.readdir(path)) {
        await copyFile(`${name}/${child}`, `${path}/${child}`);
      }
    } else {
      const content = await fs.promises.readFile(path);
      write({ name, mode: stat.mode }, content);
    }
  };

  const linkPaths = new Map(
    packages.links.map((link) => [link.name, link.path]),
  );

  const contentPath = (path: string) =>
    packages.nodeModules ? `.content/${path}` : path;
  const globalPath = (path: string) =>
    packages.nodeModules ? path : `node_modules/${path}`;

  for (let [path_, package_] of packageTree.packages.entries()) {
    const linkPath = linkPaths.get(path_);

    path_ = contentPath(path_);

    if (linkPath !== undefined) {
      await write({
        type: "symlink",
        name: path_,
        linkname: path.relative(path.dirname(path_), `../${linkPath}`),
      });
      continue;
    }

    await write({ type: "directory", name: path_ });
    for (const [depName, depPath] of package_.deps.entries()) {
      const name = `${path_}/node_modules/${depName}`;
      await write({
        type: "symlink",
        name,
        linkname: path.relative(path.dirname(name), contentPath(depPath)),
      });
    }
  }

  for (const [depName, depPath] of packageTree.globals.entries()) {
    const name = globalPath(depName);
    await write({
      type: "symlink",
      name,
      linkname: path.relative(path.dirname(name), contentPath(depPath)),
    });
  }

  for (const entry of entries) {
    await copyFile(contentPath(entry.name), entry.path);
  }

  tar.finalize();
}
