export interface Input {
  path: string;
  digest: string;
}

export interface WorkRequest {
  arguments: string[];
  inputs: Input[];
  request_id: number;
  cancel: boolean;
  verbosity: number;
}

export interface WorkResponse {
  exit_code: number;
  output: string;
  request_id: number;
  was_cancelled: boolean;
}
