import * as fs from "node:fs";
import * as path from "node:path";

export function parseManifest(runfilesDir: string, content: string) {
  const entries: [string, string][] = content
    .trim()
    .split("\n")
    .map((line) => {
      const [name, value] = line.split(" ", 2);
      return [path.resolve(runfilesDir, name), value];
    });
  return new Map(entries);
}

export function loadManifest() {
  const runfilesDir = process.env.RUNFILES_DIR;
  const manifest = fs.readFileSync(
    path.resolve(runfilesDir, "MANIFEST"),
    "utf-8",
  );
  return parseManifest(runfilesDir, manifest);
}
