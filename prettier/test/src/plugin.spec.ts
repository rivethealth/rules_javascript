import { spawnOptions } from "@better-rules-javascript/test";
import * as childProcess from "node:child_process";

test("Format", () => {
  const result = childProcess.spawnSync("bazel", ["run", "plugin:format"], {
    cwd: "prettier/test/bazel",
    stdio: "inherit",
    ...spawnOptions(),
  });
  expect(result.status).toBe(0);
});
