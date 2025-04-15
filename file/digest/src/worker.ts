import { ArgumentParser } from "argparse";
import { createHash, Hash } from "node:crypto";
import { Stats } from "node:fs";
import { open, readdir, readlink, stat, writeFile } from "node:fs/promises";
import { join } from "node:path";

export class DigestWorker {
  async run(a: string[]) {
    const parser = new ArgumentParser();
    parser.add_argument("input");
    parser.add_argument("output");
    const args = parser.parse_args(a);

    const hash = createHash("sha256");
    const s = await stat(args.input);
    if (s.isDirectory()) {
      await dirHash(hash, args.input);
    } else if (s.isFile()) {
      await fileHash(hash, args.input, s);
    } else if (s.isSymbolicLink()) {
      await symlinkHash(hash, args.input);
    }

    await writeFile(args.output, hash.digest());
  }
}

async function dirHash(hash: Hash, path: string) {
  await (async function dirHash(subPath: string) {
    hash.update("d");
    hash.update(subPath);
    hash.update("\0");
    const entries = await readdir(join(path, subPath), { withFileTypes: true });
    entries.sort((a, b) => (a.name < b.name ? -1 : a.name > b.name ? 1 : 0));
    const buffer = Buffer.alloc(4);
    buffer.writeInt32LE(entries.length);
    hash.update(buffer);
    for (const entry of entries) {
      if (entry.isDirectory()) {
        await dirHash(join(subPath, entry.name));
      } else if (entry.isFile()) {
        const stats = await stat(path);
        await fileHash(hash, join(path, subPath, entry.name), stats);
      } else if (entry.isSymbolicLink()) {
        await symlinkHash(hash, join(path, subPath, entry.name));
      }
    }
  })("");
}

async function fileHash(hash: Hash, path: string, stats: Stats) {
  hash.update("f");
  hash.update(Buffer.from([stats.mode & 0b1]));
  const buffer = Buffer.alloc(8);
  buffer.writeBigInt64LE(BigInt(stats.size));
  hash.update(buffer);
  const input = await open(path);
  try {
    for await (const chunk of input.createReadStream()) {
      hash.update(chunk);
    }
  } finally {
    await input.close();
  }
}

async function symlinkHash(hash: Hash, path: string) {
  hash.update("s");
  const target = await readlink(path);
  hash.update(target);
  hash.update("\0");
}
