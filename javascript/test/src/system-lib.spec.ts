import { spawnOptions } from "@better-rules-javascript/test";
import * as childProcess from "node:child_process";

test("Works with system_lib", () => {
  const result1 = childProcess.spawnSync("bazel", ["run", "system-lib:bin"], {
    cwd: "javascript/test/bazel",
    stdio: "inherit",
    ...spawnOptions(),
  });
  expect(result1.status).toBe(0);
  const result2 = childProcess.spawnSync(
    "bazel",
    [
      "run",
      "--@better_rules_javascript//javascript:system_lib=@//system-lib:b",
      "system-lib:bin",
    ],
    {
      cwd: "javascript/test/bazel",
      stdio: "inherit",
      ...spawnOptions(),
    },
  );
  expect(result2.status).toBe(1);
});
