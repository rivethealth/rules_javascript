import { spawnOptions } from "@better-rules-javascript/test";
import * as childProcess from "node:child_process";

test("Tools", () => {
  const result = childProcess.spawnSync("bazel", ["test", "tools:test"], {
    cwd: "jest/test/bazel",
    stdio: "inherit",
    ...spawnOptions(),
  });
  expect(result.status).toBe(0);
});
