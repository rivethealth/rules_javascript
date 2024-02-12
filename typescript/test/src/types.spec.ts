import { spawnOptions } from "@better-rules-javascript/test";
import * as childProcess from "node:child_process";

test("Types", () => {
  const result = childProcess.spawnSync(
    "bazel",
    ["build", "--output_groups=dts", "types:main_lib"],
    {
      cwd: "typescript/test/bazel",
      stdio: "inherit",
      ...spawnOptions(),
    },
  );
  expect(result.status).toBe(0);
});
