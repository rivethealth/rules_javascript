import { spawnOptions } from "@better-rules-javascript/test";
import * as childProcess from "node:child_process";

test("Shard", () => {
  const result = childProcess.spawnSync("bazel", ["test", "shard:test"], {
    cwd: "playwright/test/bazel",
    stdio: "inherit",
    ...spawnOptions(),
  });
  expect(result.status).toBe(0);
});
