import { ArgumentParser } from "argparse";
import * as fs from "node:fs";
import * as path from "node:path";

interface ResourceArgs {
  out: string;
  src: string;
}

export class ResourceWorkerError extends Error {}

class ResourceArgumentParser extends ArgumentParser {
  exit(status: number, message: string) {
    throw new ResourceWorkerError(message);
  }
}

export class ResourceWorker {
  constructor() {
    this.parser = new ResourceArgumentParser();
    this.parser.add_argument("src");
    this.parser.add_argument("out");
  }

  private readonly parser: ArgumentParser;

  run(a: string[]) {
    const args: ResourceArgs = this.parser.parse_args(a);

    const input = fs.readFileSync(args.src, "utf8");
    const result = `exports.content = ${JSON.stringify(input)}`;
    fs.mkdirSync(path.dirname(args.out), { recursive: true });
    fs.writeFileSync(args.out, result, "utf8");
  }
}
