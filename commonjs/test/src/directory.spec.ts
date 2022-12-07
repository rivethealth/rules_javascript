import { spawnOptions } from "@better-rules-javascript/test";
import * as childProcess from "node:child_process";

test("Works with directory", () => {
  const result = childProcess.spawnSync("bazel", ["run", "directory:bin"], {
    cwd: "commonjs/test/bazel",
    encoding: "utf-8",
    stdio: ["ignore", "pipe", "inherit"],
    ...spawnOptions(),
  });
  expect(result.status).toBe(0);
  expect(result.stdout).toContain("Hello world");
});
