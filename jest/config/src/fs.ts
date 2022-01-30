import * as fs from "fs";
import * as path from "path";

export function touch(file: string) {
  const now = new Date();
  try {
    fs.utimesSync(file, now, now);
  } catch {
    fs.closeSync(fs.openSync(file, "w"));
  }
}

export function* findFiles(
  path_: string,
): IterableIterator<{ entry: fs.Dirent; path: string }> {
  for (const child of fs.readdirSync(path_, { withFileTypes: true })) {
    const childPath = path.join(path_, child.name);
    yield { path: childPath, entry: child };
    if (child.isDirectory()) {
      yield* findFiles(childPath);
    }
  }
}
