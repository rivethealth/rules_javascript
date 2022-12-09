import { bazelBin, spawnOptions } from "@better-rules-javascript/test";
import * as childProcess from "node:child_process";
import * as fs from "node:fs";
import * as path from "node:path";

test("Dev mode", async () => {
  const bin = await bazelBin("webpack/test/bazel");
  const result = childProcess.spawnSync("bazel", ["build", "basic:bundle"], {
    cwd: "webpack/test/bazel",
    stdio: "inherit",
    ...spawnOptions(),
  });
  expect(result.status).toBe(0);
  const content = await fs.promises.readFile(
    path.join(bin, "basic/bundle/main.js"),
    { encoding: "utf8" },
  );
  expect(content).toContain("eval");
});

test("Optimized mode", async () => {
  const bin = await bazelBin("webpack/test/bazel", ["--compilation_mode=opt"]);
  const result = childProcess.spawnSync(
    "bazel",
    ["build", "--compilation_mode=opt", "basic:bundle"],
    {
      cwd: "webpack/test/bazel",
      stdio: "inherit",
      ...spawnOptions(),
    },
  );
  expect(result.status).toBe(0);
  const content = await fs.promises.readFile(
    path.join(bin, "basic/bundle/main.js"),
    { encoding: "utf8" },
  );
  expect(content).not.toContain("eval");
});
