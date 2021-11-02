import * as fs from "fs";
import {
  Input,
  WorkRequest,
  WorkResponse,
} from "@bazel_tools/src/main/protobuf/worker_protocol";
import { readFromStream } from "./protobuf";

export interface WorkerFactory {
  /**
   * @param args Start-up args
   */
  (args: string[]): Promise<Worker>;
}

export interface Worker {
  (args: string[], inputs: Input[], abort: AbortSignal): Promise<Result>;
}

export interface Result {
  exitCode: number;
  output: string;
}

async function runWorker(worker: Worker) {
  let abort: AbortController | undefined;
  process.on("SIGINT", () => abort?.abort());
  process.on("SIGTERM", () => abort?.abort());
  for await (const message of readFromStream(process.stdin, WorkRequest)) {
    if (message.requestId) {
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
            exitCode,
            output,
            requestId: 0,
            wasCancelled: abort.signal.aborted,
          };
          const buffer = WorkResponse.encode(response).ldelim().finish();
          process.stdout.write(buffer);
          abort = undefined;
          // global.gc();
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
  const result = await worker(args, [], abort.signal);
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
      throw new Error();
    }
  } catch (e) {
    console.error(e.stack);
    process.exit(1);
  }
}
