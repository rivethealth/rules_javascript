const childProcess = require("child_process");
const path = require("path");

const runfiles = process.env.RUNFILES_DIR;

test("adds numbers", () => {
  const executable = path.join(runfiles, "better_rules_javascript_test/tools/bin")
  const result = childProcess.spawnSync(executable);
  expect(result.error).toBeUndefined();
  expect(result.status).toBe(0);
  expect(result.stdout.toString()).toBe("Hello world\n");
});
