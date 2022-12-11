import { spawnOptions } from "@better-rules-javascript/test";
import * as childProcess from "node:child_process";

test("Transform", () => {
  const { env } = spawnOptions();
  delete env.JEST_CONFIG;
  delete env.JEST_WORKER_ID;
  const result = childProcess.spawnSync("bazel", ["test", "transform:test"], {
    cwd: "jest/test/bazel",
    stdio: "inherit",
    env,
  });
  expect(result.status).toBe(0);
});
