import { spawnOptions } from "@better-rules-javascript/test";
import * as childProcess from "node:child_process";

test("Server", async () => {
  const result = childProcess.spawnSync("bazel", ["build", "server"], {
    cwd: "webpack/test/bazel",
    stdio: "inherit",
    ...spawnOptions(),
  });
  expect(result.status).toBe(0);
});
