import { spawnOptions } from "@better-rules-javascript/test";
import * as childProcess from "node:child_process";
import * as fs from "node:fs";

test("Snapshot", async () => {
  try {
    await fs.promises.unlink(
      "jest/test/bazel/snapshot/__snapshots__/example.spec.js.snap",
    );
  } catch {}
  const result = childProcess.spawnSync(
    "bazel",
    ["run", "snapshot:test", "--", "-u"],
    {
      cwd: "jest/test/bazel",
      stdio: "inherit",
      ...spawnOptions(),
    },
  );
  expect(result.status).toBe(0);
  await fs.promises.stat(
    "jest/test/bazel/snapshot/__snapshots__/example.spec.js.snap",
  );
  await fs.promises.unlink(
    "jest/test/bazel/snapshot/__snapshots__/example.spec.js.snap",
  );
});
