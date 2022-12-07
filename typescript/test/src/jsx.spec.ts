import { spawnOptions } from "@better-rules-javascript/test";
import * as childProcess from "node:child_process";

test("Compiles TSX to JSX", () => {
  const result = childProcess.spawnSync("bazel", ["build", "jsx:lib"], {
    cwd: "typescript/test/bazel",
    stdio: "inherit",
    ...spawnOptions(),
  });
  expect(result.status).toBe(0);
});
