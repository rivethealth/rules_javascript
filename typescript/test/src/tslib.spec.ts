import { bazelBin, spawnOptions } from "@better-rules-javascript/test";
import * as childProcess from "node:child_process";
import * as fs from "node:fs";
import * as path from "node:path";

test("References tslib", async () => {
  const bin = await bazelBin("typescript/test/bazel");
  const result = childProcess.spawnSync("bazel", ["build", "tslib:lib"], {
    cwd: "typescript/test/bazel",
    stdio: "pipe",
    ...spawnOptions(),
  });
  expect(result.status).toBe(0);

  const output = await fs.promises.readFile(
    path.join(bin, "tslib/root_lib/example.js"),
    { encoding: "utf8" },
  );
  expect(output).toContain('require("tslib")');
});

test("Does not reference tslib", async () => {
  const bin = await bazelBin("typescript/test/bazel");
  const result = childProcess.spawnSync("bazel", ["build", "tslib:nolib"], {
    cwd: "typescript/test/bazel",
    stdio: "pipe",
    ...spawnOptions(),
  });
  expect(result.status).toBe(0);

  const output = await fs.promises.readFile(
    path.join(bin, "tslib/root_nolib/example.js"),
    { encoding: "utf8" },
  );
  expect(output).not.toContain('require("tslib")');
});
