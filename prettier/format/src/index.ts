import { workerMain } from "@better-rules-javascript/bazel-worker";
import { ArgumentParser } from "argparse";
import { dirname } from "node:path";
import { pathToFileURL } from "node:url";
import { Options } from "prettier";
import { load, resolve } from "./import";

interface Args {
  config?: string;
}

workerMain(async (a) => {
  const parser = new ArgumentParser({ prog: "prettier-format" });
  parser.add_argument("--config", { help: "Configuration path" });
  const args: Args = parser.parse_args(a);

  const { resolveConfig } = await import("prettier");
  const { PrettierWorker } = await import("./worker");

  const options: Options | undefined =
    args.config === undefined
      ? undefined
      : (await resolveConfig(args.config, { config: args.config })) ||
        undefined;
  if (options?.plugins) {
    const contextUrl = pathToFileURL(dirname(args.config!));
    options.plugins = await Promise.all(
      options.plugins.map(async (plugin) => {
        // in theory, should be able to just resolve the path, but for some reason
        // that dereferences symlinks
        if (typeof plugin === "string") {
          const path = await resolve(plugin, contextUrl);
          const p = await load(path);
          plugin = p.default ?? p;
        }
        return plugin;
      }),
    );
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
