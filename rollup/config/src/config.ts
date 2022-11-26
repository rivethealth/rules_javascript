import * as path from "path";
import type { OutputOptions, RollupOptions } from "rollup";

const compilationMode = process.env.COMPILATION_MODE!;
const jsModule = process.env.JS_MODULE!;
const jsSourceMap = process.env.JS_SOURCE_MAP!;
const inputRoot = process.env.ROLLUP_INPUT_ROOT!;
const outputRoot = process.env.ROLLUP_OUTPUT_ROOT!;

export async function configure(config: RollupOptions): Promise<RollupOptions> {
  config = { ...config };

  if (config.output instanceof Array) {
    config.output = config.output.map(output);
  } else if (config.output) {
    config.output = output(config.output);
  }

  if (typeof config.input === "string") {
    config.input = input(config.input);
  } else if (config.input instanceof Array) {
    config.input = config.input.map(input);
  } else if (config.input) {
    config.input = Object.fromEntries(
      Object.entries(config.input).map(([key, value]) => [key, input(value)]),
    );
  }

  return config;
}

function input(input: string) {
  return path.resolve(inputRoot, input);
}

function output(output: OutputOptions) {
  output = { ...output };
  if (output.file !== undefined) {
    output.file = path.resolve(outputRoot!, output.file);
  }
  if (output.compact === undefined) {
    output.compact = compilationMode === "opt";
  }
  if (output.sourcemap === undefined) {
    output.sourcemap = jsSourceMap === "true";
  }
  if (output.format === undefined) {
    switch (jsModule) {
      case "amd":
        output.format = "amd";
        break;
      case "commonjs":
      case "node":
        output.format = "commonjs";
        break;
      case "es2015":
      case "es2020":
      case "esnext":
        output.format = "es";
        break;
      case "umd":
        output.format = "umd";
        break;
      case "system":
        output.format = "system";
    }
  }
  return output;
}
