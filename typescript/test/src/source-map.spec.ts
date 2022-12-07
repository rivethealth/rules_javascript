import { spawnOptions } from "@better-rules-javascript/test";
import * as childProcess from "node:child_process";

test("Compiles TSX to JSX", () => {
  const result = childProcess.spawnSync("bazel", ["run", "source-map:bin"], {
    cwd: "typescript/test/bazel",
    encoding: "utf-8",
    stdio: "pipe",
    ...spawnOptions(),
  });
  expect(result.stderr).toContain("lib.ts:2:9");
});
