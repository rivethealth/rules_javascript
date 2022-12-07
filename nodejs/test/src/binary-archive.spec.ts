import { spawnOptions } from "@better-rules-javascript/test";
import * as childProcess from "node:child_process";

test("Binary archive", () => {
  const result = childProcess.spawnSync(
    "bazel",
    ["build", "binary-archive:archive"],
    {
      cwd: "nodejs/test/bazel",
      stdio: "inherit",
      ...spawnOptions(),
    },
  );
  expect(result.status).toBe(0);
});
