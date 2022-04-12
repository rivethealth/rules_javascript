import { JsonFormat } from "@better-rules-javascript/util-json";

export interface Input {
  digest: ArrayBuffer;
  path: string;
}

export namespace Input {
  export function json(): JsonFormat<Input> {
    const digest: JsonFormat<ArrayBuffer> = {
      fromJson(json) {
        return Buffer.from(json, "base64");
      },
      toJson(value) {
        return Buffer.from(value).toString("base64");
      },
    };
    return JsonFormat.object({
      digest,
      path: JsonFormat.string(),
    });
  }
}

export interface WorkRequest {
  arguments: string[];
  cancel?: boolean;
  inputs: Input[];
  request_id?: number;
  verbosity?: number;
  sandbox_dir?: string;
}

export namespace WorkRequest {
  export function json(): JsonFormat<WorkRequest> {
    return JsonFormat.object({
      arguments: JsonFormat.array(JsonFormat.string()),
      inputs: JsonFormat.array(Input.json()),
      request_id: JsonFormat.number(),
      verbosity: JsonFormat.number(),
      sandbox_dir: JsonFormat.string(),
    });
  }
}

export interface WorkResponse {
  exit_code: number;
  output: string;
  request_id?: number;
  was_cancelled?: boolean;
}

export namespace WorkResponse {
  export function json(): JsonFormat<WorkResponse> {
    return JsonFormat.object({
      exit_code: JsonFormat.number(),
      output: JsonFormat.string(),
      request_id: JsonFormat.number(),
      was_cancelled: JsonFormat.boolean(),
    });
  }
}
