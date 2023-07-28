import { workerMain } from "@better-rules-javascript/bazel-worker";
import { ArgumentParser } from "argparse";

workerMain(async (a) => {
  const parser = new ArgumentParser();
  parser.add_argument("--config");
  const args = parser.parse_args(a);

  const prettier = await import("prettier");
  const { default: resolve } = await eval("import('./resolve.mjs')");
  const { PrettierWorker } = await import("./worker");

  const options =
    args.config &&
    (await prettier.resolveConfig(args.config, { config: args.config }));
  if (options && options.plugins) {
    options.plugins = options.plugins.map((plugin: string) => resolve(plugin));
  }
  const worker = new PrettierWorker(options);

  return async (a) => {
    try {
      await worker.run(a);
    } catch (error) {
      return {
        exitCode: 1,
        output: (error instanceof Error && error.stack) || String(error),
      };
    }
    return { exitCode: 0, output: "" };
  };
});
