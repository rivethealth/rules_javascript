import { bazelBin, spawnOptions } from "@better-rules-javascript/test";
import * as childProcess from "node:child_process";
import { readFile } from "node:fs/promises";
import { join } from "node:path";

test("Paths", async () => {
  const result = childProcess.spawnSync("bazel", ["build", "paths:a"], {
    cwd: "typescript/test/bazel",
    stdio: "inherit",
    ...spawnOptions(),
  });
  expect(result.status).toBe(0);
  const bin = await bazelBin("typescript/test/bazel");

  const output = await readFile(join(bin, "paths/lib/a.js"), {
    encoding: "utf8",
  });
  expect(output).toContain('import { fruit } from "./b";');

  const types = await readFile(join(bin, "paths/types/b.d.ts"), {
    encoding: "utf8",
  });
  expect(types).toContain('export declare const fruit = "apple";');
});
