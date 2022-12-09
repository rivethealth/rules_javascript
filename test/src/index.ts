import { spawnSync } from "node:child_process";

export function spawnOptions() {
  const env = { ...process.env };
  delete env.RUNFILES_DIR;
  delete env.TEST_TMPDIR;
  return { env };
}

export async function bazelBin(
  dir: string,
  options: string[] = [],
): Promise<string> {
  const result = spawnSync("bazel", ["info", ...options, "bazel-bin"], {
    encoding: "utf8",
    cwd: dir,
    stdio: ["ignore", "pipe", "inherit"],
    ...spawnOptions(),
  });
  if (result.status) {
    throw new Error("Failed to get bazel-bin");
  }
  return result.stdout.trimEnd();
}
