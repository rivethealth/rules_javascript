import { spawnOptions } from "@better-rules-javascript/test";
import * as childProcess from "node:child_process";

test("Modules binary", () => {
  const result = childProcess.spawnSync(
    "bazel",
    ["run", "modules-binary:bin"],
    {
      cwd: "nodejs/test/bazel",
      encoding: "utf8",
      stdio: ["ignore", "pipe", "inherit"],
      ...spawnOptions(),
    },
  );
  expect(result.status).toBe(0);
  expect(result.stdout).toContain("3");
});
