import { spawnOptions } from "@better-rules-javascript/test";
import * as childProcess from "node:child_process";

test("Module details", () => {
  const result = childProcess.spawnSync(
    "bazel",
    ["run", "module-details:bin"],
    {
      cwd: "nodejs/test/bazel",
      encoding: "utf8",
      stdio: ["ignore", "pipe", "inherit"],
      ...spawnOptions(),
    },
  );
  expect(result.status).toBe(0);
  expect(result.stdout).toBe(
    "@better-rules-javascript-test/module-details\nmain.js\n",
  );
});
