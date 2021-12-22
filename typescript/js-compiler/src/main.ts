import { PackageTree } from "@better-rules-javascript/commonjs-package";
import { JsonFormat } from "@better-rules-javascript/commonjs-package/json";
import { patchFs } from "@better-rules-javascript/nodejs-fs-linker/fs";
import { patchFsPromises } from "@better-rules-javascript/nodejs-fs-linker/fs-promises";
import { createVfs } from "@better-rules-javascript/nodejs-fs-linker/package";
import { WrapperVfs } from "@better-rules-javascript/nodejs-fs-linker/vfs";
import { run } from "@better-rules-javascript/worker";
import { ArgumentParser } from "argparse";
import * as fs from "fs";
import * as path from "path";
import * as ts from "typescript";
import { formatDiagnostics } from "./diagnostic";

interface Args {
  config: string;
  manifest: string;
  map: string;
  js: string;
  src: string;
}

class WorkerError extends Error {}

class WorkerArgumentParser extends ArgumentParser {
  exit(status: number, message: string) {
    throw new WorkerError(message);
  }
}

class JsWorker {
  constructor(private readonly vfs: WrapperVfs) {
    this.parser.add_argument("--config", { required: true });
    this.parser.add_argument("--manifest", { required: true });
    this.parser.add_argument("--map", { required: true });
    this.parser.add_argument("--js", { required: true });
    this.parser.add_argument("src");
  }

  private readonly parser = new WorkerArgumentParser();

  private parseConfig(config: string) {
    const parsed = ts.getParsedCommandLineOfConfigFile(
      config,
      {},
      {
        ...ts.sys,
        onUnRecoverableConfigFileDiagnostic: (error) => {
          throw new WorkerError(formatDiagnostics([error]));
        },
      },
    )!;
    const errors = parsed.errors.filter(
      (diagnostic) => diagnostic.code !== 18002,
    );
    if (errors.length) {
      throw new WorkerError(formatDiagnostics(errors));
    }
    return parsed.options;
  }

  private setupVfs(manifest: string) {
    const packageTree = JsonFormat.parse(
      PackageTree.json(),
      fs.readFileSync(manifest, "utf8"),
    );
    const vfs = createVfs(packageTree, false);
    this.vfs.delegate = vfs;
  }

  run(a: string[]) {
    const args: Args = this.parser.parse_args(a);

    this.setupVfs(args.manifest);

    const options = this.parseConfig(args.config);

    const input = fs.readFileSync(args.src, "utf8");
    const result = ts.transpileModule(input, {
      fileName: args.src,
      compilerOptions: options,
    });
    if (result.diagnostics.length) {
      throw new WorkerError(formatDiagnostics(result.diagnostics));
    }

    fs.mkdirSync(path.dirname(args.js), { recursive: true });
    fs.writeFileSync(args.js, result.outputText, "utf8");

    fs.mkdirSync(path.dirname(args.map), { recursive: true });
    fs.writeFileSync(args.map, result.sourceMapText, "utf8");
  }
}

run(async () => {
  const vfs = new WrapperVfs();
  patchFs(vfs, require("fs"));
  patchFsPromises(vfs, require("fs").promises);

  const worker = new JsWorker(vfs);
  return async (a) => {
    try {
      worker.run(a);
    } catch (e) {
      if (e instanceof WorkerError) {
        return { exitCode: 2, output: e.message };
      }
      return { exitCode: 1, output: String(e?.stack || e) };
    }
    return { exitCode: 0, output: "" };
  };
});
