import { spawnOptions } from "@better-rules-javascript/test";
import * as childProcess from "node:child_process";

test("Passes", () => {
  const result = childProcess.spawnSync("bazel", ["test", "basic:test"], {
    cwd: "playwright/test/bazel",
    stdio: "inherit",
    ...spawnOptions(),
  });
  expect(result.status).toBe(0);
});

test("Fails", () => {
  const result = childProcess.spawnSync("bazel", ["test", "basic:test_fail"], {
    cwd: "playwright/test/bazel",
    stdio: "inherit",
    ...spawnOptions(),
  });
  expect(result.status).not.toBe(0);
});
