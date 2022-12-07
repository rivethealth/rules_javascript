import { spawnOptions } from "@better-rules-javascript/test";
import * as childProcess from "node:child_process";

test("Reference", () => {
  const result = childProcess.spawnSync("bazel", ["build", "reference:lib"], {
    cwd: "typescript/test/bazel",
    stdio: "inherit",
    ...spawnOptions(),
  });
  expect(result.status).toBe(0);
});
