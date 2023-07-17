import { PackageTree } from "@better-rules-javascript/commonjs-package";
import { createVfs } from "@better-rules-javascript/nodejs-fs-linker/package";
import { WrapperVfs } from "@better-rules-javascript/nodejs-fs-linker/vfs";
import { JsonFormat } from "@better-rules-javascript/util-json";
import { ArgumentParser } from "argparse";
import { mkdir, readFile, writeFile } from "node:fs/promises";
import { dirname, resolve } from "node:path";
import {
  ParsedCommandLine,
  getOutputFileNames,
  getParsedCommandLineOfConfigFile,
  sys,
  transpileModule,
} from "typescript";
import { formatDiagnostics } from "./diagnostic";

interface JsArgs {
  config: string;
  manifest: string;
  src: string[];
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
    this.parser.add_argument("src", { nargs: "*" });
  }

  private readonly parser = new JsArgumentParser();

  private parseConfig(config: string) {
    const parsed = getParsedCommandLineOfConfigFile(
      config,
      {},
      {
        ...sys,
        onUnRecoverableConfigFileDiagnostic: (error) => {
          throw new JsWorkerError(formatDiagnostics([error]));
        },
      },
    )!;
    const errors = parsed.errors.filter(
      (diagnostic) => diagnostic.code !== 18_002,
    );
    if (errors.length > 0) {
      throw new JsWorkerError(formatDiagnostics(errors));
    }
    return parsed;
  }

  private async setupVfs(manifest: string) {
    const packageTree = JsonFormat.parse(
      PackageTree.json(),
      await readFile(manifest, "utf8"),
    );
    const vfs = createVfs(packageTree);
    this.vfs.delegate = vfs;
  }

  async run(a: string[]) {
    const args: JsArgs = this.parser.parse_args(a);

    await this.setupVfs(args.manifest);

    const parsed = this.parseConfig(args.config);
    await mkdir(parsed.options.outDir!, { recursive: true });

    for (const src of args.src) {
      await transpileFile(src, parsed);
    }
  }
}

async function transpileFile(src: string, parsed: ParsedCommandLine) {
  src = resolve(src);

  const [outputPath] = getOutputFileNames(
    { ...parsed, fileNames: [src] },
    src,
    false,
  );

  const input = await readFile(src, "utf8");
  const result = transpileModule(input, {
    fileName: src,
    compilerOptions: parsed.options,
  });
  if (result.diagnostics!.length > 0) {
    throw new JsWorkerError(formatDiagnostics(result.diagnostics!));
  }

  await mkdir(dirname(outputPath), { recursive: true });
  await writeFile(outputPath, result.outputText, "utf8");
  if (result.sourceMapText !== undefined) {
    await writeFile(`${outputPath}.map`, result.sourceMapText, "utf8");
  }
}
