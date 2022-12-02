import { PackageTree } from "@better-rules-javascript/commonjs-package";
import { createVfs } from "@better-rules-javascript/nodejs-fs-linker/package";
import { WrapperVfs } from "@better-rules-javascript/nodejs-fs-linker/vfs";
import { JsonFormat } from "@better-rules-javascript/util-json";
import { ArgumentParser } from "argparse";
import * as fs from "fs";
import * as path from "path";
import * as ts from "typescript";
import { formatDiagnostics } from "./diagnostic";
import { resourceTransformer } from "./transform";

interface Args {
  config: string;
  manifest: string;
  src: string;
}

export class AngularWorkerError extends Error {}

class WorkerArgumentParser extends ArgumentParser {
  exit(status: number, message: string) {
    throw new AngularWorkerError(message);
  }
}

export class AngularWorker {
  constructor(private readonly vfs: WrapperVfs) {
    this.parser.add_argument("--config", { required: true });
    this.parser.add_argument("--manifest", { required: true });
    this.parser.add_argument("src");
  }

  private readonly parser = new WorkerArgumentParser();

  private parseConfig(config: string): ts.ParsedCommandLine {
    const parsed = ts.getParsedCommandLineOfConfigFile(
      config,
      {},
      {
        ...ts.sys,
        onUnRecoverableConfigFileDiagnostic: (error) => {
          throw new AngularWorkerError(formatDiagnostics([error]));
        },
      },
    )!;
    const errors = parsed.errors.filter(
      (diagnostic) => diagnostic.code !== 18002,
    );
    if (errors.length) {
      throw new AngularWorkerError(formatDiagnostics(errors));
    }
    return parsed;
  }

  private async setupVfs(manifest: string) {
    const packageTree = JsonFormat.parse(
      PackageTree.json(),
      await fs.promises.readFile(manifest, "utf8"),
    );
    const vfs = createVfs(packageTree, undefined);
    this.vfs.delegate = vfs;
  }

  async run(a: string[]) {
    const args: Args = this.parser.parse_args(a);

    await this.setupVfs(args.manifest);

    const parsed = this.parseConfig(args.config);
    await fs.promises.mkdir(parsed.options.outDir!, { recursive: true });

    await (async function process(src: string): Promise<void> {
      const stat = await fs.promises.stat(src);

      if (stat.isDirectory()) {
        for (const child of await fs.promises.readdir(src)) {
          await process(path.join(src, child));
        }
      } else {
        await transpileFile(src, parsed);
      }
    })(args.src);
  }
}

async function transpileFile(src: string, parsed: ts.ParsedCommandLine) {
  let name: string;
  const resolvedSrc = path.resolve(src);
  if (resolvedSrc === parsed.options.rootDir) {
    name = "";
  } else if (resolvedSrc.startsWith(`${parsed.options.rootDir}/`)) {
    name = resolvedSrc.slice(`${parsed.options.rootDir}/`.length);
  } else {
    throw new Error(`File ${resolvedSrc} not in ${parsed.options.rootDir}`);
  }

  src = path.resolve(src);

  const [outputPath] = ts.getOutputFileNames(
    { ...parsed, fileNames: [src] },
    src,
    false,
  );

  const input = await fs.promises.readFile(src, "utf8");
  const result = ts.transpileModule(input, {
    fileName: name,
    compilerOptions: parsed.options,
    transformers: {
      before: [resourceTransformer()],
    },
  });
  if (result.diagnostics!.length) {
    throw new AngularWorkerError(formatDiagnostics(result.diagnostics!));
  }

  await fs.promises.mkdir(path.dirname(outputPath), { recursive: true });
  await fs.promises.writeFile(outputPath, result.outputText, "utf8");
  if (result.sourceMapText !== undefined) {
    await fs.promises.writeFile(
      `${outputPath}.map`,
      result.sourceMapText,
      "utf8",
    );
  }
}
