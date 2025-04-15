import { spawnOptions } from "@better-rules-javascript/test";
import { spawnSync } from "node:child_process";

test("Build", async () => {
  const result = spawnSync("bazel", ["build", "nested-dep:bundle"], {
    cwd: "webpack/test/bazel",
    stdio: "inherit",
    ...spawnOptions(),
  });
  expect(result.status).toBe(0);
});
