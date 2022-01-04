import { createRequire } from "module";
import * as path from "path";
import { Configuration } from "webpack";

const runfilesDir = process.env.RUNFILES_DIR;
const configRunfilePath = process.env.WEBPACK_CONFIG;
const compilationMode = process.env.COMPILATION_MODE;
const inputRoot = process.env.WEBPACK_INPUT_ROOT;
const output = process.env.WEBPACK_OUTPUT;

const configPath = path.resolve(runfilesDir, configRunfilePath);

export async function configure(): Promise<Configuration> {
  const baseConfig = await import(configPath);
  const configRequire = createRequire(configPath);

  const config: Configuration = { ...baseConfig };
  if (config.mode === undefined) {
    config.mode = compilationMode === "opt" ? "production" : "development";
  }

  // config.output = config.output ? { ...config.output } : {};
  // config.output.path = path.resolve(path.dirname(output));
  // config.output.filename = path.basename(output);
  if (typeof config.entry === "string") {
    config.entry = path.resolve(inputRoot, config.entry);
  } else if (config.entry) {
    config.entry = Object.fromEntries(
      Object.entries(config.entry).map(([name, path_]) => [
        name,
        path.resolve(inputRoot, path_),
      ]),
    );
  }

  config.module = config.module ? { ...config.module } : {};
  if (config.module.rules) {
    config.module.rules = config.module.rules.map((rule) => {
      if (typeof rule === "string") {
        return rule;
      }
      rule = { ...rule };
      if (rule.loader) {
        rule.loader = configRequire.resolve(rule.loader);
      }
      if (rule.use instanceof Array) {
        rule.use = rule.use.map((use) => {
          if (typeof use === "string") {
            return;
          }
          use = { ...use };
          if (use.loader) {
            use.loader = configRequire.resolve(use.loader);
          }
          return use;
        });
      } else if (typeof rule.use === "object") {
        rule.use = { ...rule.use };
        if (rule.use.loader) {
          rule.use.loader = configRequire.resolve(rule.use.loader);
        }
      }
      return rule;
    });
  }

  config.optimization = config.optimization ? { ...config.optimization } : {};
  if (config.optimization.minimize === undefined) {
    config.optimization.minimize = compilationMode === "opt";
  }

  // config.resolve = config.resolve ? { ...config.resolve } : {};
  // config.resolve.symlinks = true;

  config.resolveLoader = config.resolveLoader
    ? { ...config.resolveLoader }
    : {};
  config.resolveLoader.symlinks = false;

  return config;
}
