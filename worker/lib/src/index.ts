import * as fs from "fs";
import {
  Input,
  WorkResponse,
  WorkRequest,
} from "./protocol";
import { readLines } from "./stream";

class CliError extends Error {}

export interface WorkerFactory {
  /**
   * @param args Start-up args
   */
  (args: string[]): Promise<Worker>;
}

export interface Worker {
  (
    args: string[],
    inputs: Input[] | undefined,
    abort: AbortSignal,
  ): Promise<Result>;
}

export interface Result {
  exitCode: number;
  output: string;
}

async function runWorker(worker: Worker) {
  let abort: AbortController | undefined;
  process.on("SIGINT", () => abort?.abort());
  process.on("SIGTERM", () => abort?.abort());
  for await (const line of readLines(process.stdin)) {
    const message: WorkRequest = JSON.parse(Buffer.from(line).toString());
    if (message.request_id) {
      throw new Error("Does not support multiplexed requests");
    }
    if (abort) {
      if (!message.cancel) {
        throw new Error("Unexpected request while processing");
      }
      abort.abort();
    } else {
      if (message.cancel) {
        continue;
      }
      abort = new AbortController();
      worker(message.arguments, message.inputs, abort.signal).then(
        ({ exitCode, output }) => {
          const response: WorkResponse = {
            exit_code: exitCode,
            output,
            request_id: 0,
            was_cancelled: abort.signal.aborted,
          };
          const buffer = Buffer.from(JSON.stringify(response));
          process.stdout.write(buffer);
          process.stdout.write("\n");
          abort = undefined;
          global.gc();
        },
        (e) => {
          console.error(e.stack);
          process.exit(1);
        },
      );
    }
  }
}

async function runOnce(worker: Worker, path: string) {
  const file = fs.readFileSync(path, "utf-8");
  const args = file.trim().split("\n");
  const abort = new AbortController();
  process.on("SIGINT", () => abort.abort());
  process.on("SIGTERM", () => abort.abort());
  const result = await worker(args, undefined, abort.signal);
  console.error(result.output);
  process.exitCode = result.exitCode;
}

export async function run(workerFactory: WorkerFactory) {
  try {
    const args = process.argv.slice(2, -1);
    const worker = await workerFactory(args);
    const last = process.argv[process.argv.length - 1];
    if (last === "--persistent_worker") {
      await runWorker(worker);
    } else if (last.startsWith("@")) {
      const path = last.slice(1);
      await runOnce(worker, path);
    } else {
      throw new CliError("Invalid worker arguments");
    }
  } catch (e) {
    if (e instanceof CliError) {
      console.error(e.message);
    } else {
      console.error(e.stack);
    }
    process.exit(1);
  }
}
