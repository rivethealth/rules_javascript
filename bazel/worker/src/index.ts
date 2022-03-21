import * as fs from "fs";
import {
  Input,
  WorkRequest,
  WorkResponse,
} from "bazel_tools/src/main/protobuf/worker_protocol";
import { readFromStream } from "./protobuf";

class CliError extends Error {}

/**
 * Worker factory.
 */
export interface WorkerFactory {
  /**
   * Create a worker.
   * @param args Start-up args
   */
  (args: string[]): Promise<Worker>;
}

/**
 * Worker.
 */
export interface Worker {
  /**
   * Perform work.
   * @param args Arguments.
   * @param inputs Inputs, if available.
   * @param abort Abort signal, for canceling the work.
   */
  (
    args: string[],
    inputs: Input[] | undefined,
    abort: AbortSignal,
  ): Promise<WorkResult>;
}

/**
 * Work result.
 */
export interface WorkResult {
  /** Exit code. */
  exitCode: number;
  /** Output message. */
  output: string;
}

async function runWorker(worker: Worker) {
  let abort: AbortController | undefined;
  process.on("SIGINT", () => abort?.abort());
  process.on("SIGTERM", () => abort?.abort());
  for await (const message of readFromStream(process.stdin, WorkRequest)) {
    if (message.requestId) {
      throw new CliError("Does not support multiplexed requests");
    }
    if (abort) {
      if (!message.cancel) {
        throw new CliError(
          "Unexpected request while processing existing request",
        );
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
          if (typeof gc !== "undefined") {
            gc();
          }
        },
        (e) => {
          console.error(e.stack);
          process.exit(1);
        },
      );
    }
  }
}

async function runOnce(worker: Worker, args: string[]) {
  const abort = new AbortController();
  process.on("SIGINT", () => abort.abort());
  process.on("SIGTERM", () => abort.abort());
  const result = await worker(args, undefined, abort.signal);
  console.error(result.output);
  process.exitCode = result.exitCode;
}

/**
 * Run program using the provided worker factory.
 */
export async function workerMain(workerFactory: WorkerFactory) {
  try {
    const last = process.argv[process.argv.length - 1];
    if (last === "--persistent_worker") {
      const worker = await workerFactory(process.argv.slice(2, -1));
      await runWorker(worker);
    } else if (last.startsWith("@")) {
      const worker = await workerFactory(process.argv.slice(2, -1));
      const file = await fs.promises.readFile(last.slice(1), "utf-8");
      const args = file.trim().split("\n");
      await runOnce(worker, args);
    } else {
      const worker = await workerFactory([]);
      await runOnce(worker, process.argv.slice(2));
    }
  } catch (e) {
    if (e instanceof CliError) {
      console.error(e.message);
    } else {
      console.error(e?.stack || String(e));
    }
    process.exit(1);
  }
}
