/**
 * IBazel notification
 */
export type IbazelNotification =
  | IbazelNotification.Completed
  | IbazelNotification.Started;

export namespace IbazelNotification {
  export const COMPLETED = Symbol("COMPLETED");
  export const STARTED = Symbol("STARTED");

  /**
   * Completed
   */
  export interface Completed {
    status: IbazelStatus;
    type: typeof COMPLETED;
  }

  /**
   * Started
   */
  export interface Started {
    type: typeof STARTED;
  }
}

export enum IbazelStatus {
  FAILURE,
  SUCCESS,
}

async function* lines(
  stream: AsyncIterableIterator<string>,
): AsyncIterableIterator<string> {
  let data: string = "";
  for await (const chunk of stream) {
    data += chunk;
    let i = 0;
    while (true) {
      const j = data.indexOf("\n", i);
      if (j < 0) {
        break;
      }
      yield data.substring(i, j + 1);
      i = j + 1;
    }
    data = data.substring(i);
  }
  if (data) {
    yield data;
  }
}

function parseNotification(string: string): IbazelNotification {
  switch (string) {
    case "IBAZEL_BUILD_STARTED":
      return { type: IbazelNotification.STARTED };
    case "IBAZEL_BUILD_COMPLETED FAILURE":
      return {
        type: IbazelNotification.COMPLETED,
        status: IbazelStatus.FAILURE,
      };
    case "IBAZEL_BUILD_COMPLETED SUCCESS":
      return {
        type: IbazelNotification.COMPLETED,
        status: IbazelStatus.SUCCESS,
      };
  }
  throw new Error(`Unrecognized notification: ${string}`);
}

export async function* readNotifications(
  stream: AsyncIterableIterator<string>,
): AsyncIterableIterator<IbazelNotification> {
  for await (const line of lines(stream)) {
    yield parseNotification(line.trimEnd());
  }
}
