import * as fs from "fs";
import { JsonFormat } from "@better-rules-javascript/util-json";
import { WorkRequest, WorkResponse } from "./protocol";
import { lines } from "./stream";

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
    inputs: { path: string; digest: ArrayBuffer }[] | undefined,
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
  process.stdin.setEncoding("utf8");

  let abort: AbortController | undefined;
  process.on("SIGINT", () => abort?.abort());
  process.on("SIGTERM", () => abort?.abort());
  for await (const line of lines(<any>process.stdin)) {
    const message = JsonFormat.parse(WorkRequest.json(), line);
    if (message.request_id) {
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
            requestId: message.request_id,
            // wasCancelled: abort.signal.aborted,
          };
          const outputData = JsonFormat.stringify(
            WorkResponse.json(),
            response,
          );
          process.stdout.write(outputData + "\n");
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
