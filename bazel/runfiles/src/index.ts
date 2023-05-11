import { lazy } from "@better-rules-javascript/util/cache";
import { existsSync, readFileSync } from "node:fs";
import { join } from "node:path";

function parseManifest(content: string) {
  const entries: [string, string][] = content
    .trim()
    .split("\n")
    .map((line) => {
      const i = line.indexOf(" ");
      return [line.slice(0, i), line.slice(i + 1)];
    });
  return new Map(entries);
}

function loadManifest(path: string) {
  const manifest = readFileSync(path, "utf8");
  return parseManifest(manifest);
}

const manifest = lazy(() => loadManifest(process.env.RUNFILES_MANIFEST_FILE!));

export function rlocation(path: string): string | undefined {
  if (process.env.RUNFILES_DIR) {
    const result = join(process.env.RUNFILES_DIR, path);
    return existsSync(result) ? result : undefined;
  }
  if (process.env.RUNFILES_MANIFEST_FILE) {
    return manifest().get(path);
  }
  throw new Error("process.env.RUNFILES_DIR not set");
}
