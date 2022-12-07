import { spawnOptions } from "@better-rules-javascript/test";
import * as childProcess from "node:child_process";

test("Ambiant", () => {
  const result = childProcess.spawnSync("bazel", ["build", "ambiant:example"], {
    cwd: "typescript/test/bazel",
    stdio: "inherit",
    ...spawnOptions(),
  });
  expect(result.status).toBe(0);
});
