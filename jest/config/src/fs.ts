import * as fs from "fs";

export function touch(file: string) {
  const now = new Date();
  try {
    fs.utimesSync(file, now, now);
  } catch {
    fs.closeSync(fs.openSync(file, "w"));
  }
}
