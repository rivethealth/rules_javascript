import { spawnOptions } from "@better-rules-javascript/test";
import * as childProcess from "node:child_process";

test("Works with directory", () => {
  const result = childProcess.spawnSync("bazel", ["build", "directory:lib"], {
    cwd: "javascript/test/bazel",
    stdio: "inherit",
    ...spawnOptions(),
  });
  expect(result.status).toBe(0);
});
