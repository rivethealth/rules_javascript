import { PackageTree } from "@better-rules-javascript/commonjs-package";
import { JsonFormat } from "@better-rules-javascript/util-json";
import { createVfs } from "@better-rules-javascript/nodejs-fs-linker/package";
import { WrapperVfs } from "@better-rules-javascript/nodejs-fs-linker/vfs";
import { ArgumentParser } from "argparse";
import * as fs from "fs";
import * as path from "path";
import * as ts from "typescript";
import { formatDiagnostics } from "./diagnostic";

interface JsArgs {
  config: string;
  manifest: string;
  map: string;
  js: string;
  src: string;
}

export class JsWorkerError extends Error {}

class JsArgumentParser extends ArgumentParser {
  exit(status: number, message: string) {
    throw new JsWorkerError(message);
  }
}

export class JsWorker {
  constructor(private readonly vfs: WrapperVfs) {
    this.parser.add_argument("--config", { required: true });
    this.parser.add_argument("--manifest", { required: true });
    this.parser.add_argument("--map", { required: true });
    this.parser.add_argument("--js", { required: true });
    this.parser.add_argument("src");
  }

  private readonly parser = new JsArgumentParser();

  private parseConfig(config: string) {
    const parsed = ts.getParsedCommandLineOfConfigFile(
      config,
      {},
      {
        ...ts.sys,
        onUnRecoverableConfigFileDiagnostic: (error) => {
          throw new JsWorkerError(formatDiagnostics([error]));
        },
      },
    )!;
    const errors = parsed.errors.filter(
      (diagnostic) => diagnostic.code !== 18002,
    );
    if (errors.length) {
      throw new JsWorkerError(formatDiagnostics(errors));
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
    const args: JsArgs = this.parser.parse_args(a);

    this.setupVfs(args.manifest);

    const options = this.parseConfig(args.config);

    const input = fs.readFileSync(args.src, "utf8");
    const result = ts.transpileModule(input, {
      fileName: path.relative(path.dirname(args.map), args.src),
      compilerOptions: options,
    });
    if (result.diagnostics.length) {
      throw new JsWorkerError(formatDiagnostics(result.diagnostics));
    }

    fs.mkdirSync(path.dirname(args.js), { recursive: true });
    fs.writeFileSync(args.js, result.outputText, "utf8");

    fs.mkdirSync(path.dirname(args.map), { recursive: true });
    fs.writeFileSync(args.map, result.sourceMapText, "utf8");
  }
}
