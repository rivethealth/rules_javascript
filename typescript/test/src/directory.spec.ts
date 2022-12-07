import { spawnOptions } from "@better-rules-javascript/test";
import * as childProcess from "node:child_process";

test("Directory", () => {
  const result = childProcess.spawnSync("bazel", ["run", "directory:bin"], {
    cwd: "typescript/test/bazel",
    stdio: "inherit",
    ...spawnOptions(),
  });
  expect(result.status).toBe(0);
});
