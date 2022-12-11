import { spawnOptions } from "@better-rules-javascript/test";
import * as childProcess from "node:child_process";

test("Dep", () => {
  const result = childProcess.spawnSync("bazel", ["test", "dep:test"], {
    cwd: "jest/test/bazel",
    stdio: "inherit",
    ...spawnOptions(),
  });
  expect(result.status).toBe(0);
});
