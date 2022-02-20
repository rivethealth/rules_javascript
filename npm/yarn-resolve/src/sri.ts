import { createHash } from "crypto";

export function getIntegrity(buffer: ArrayBuffer) {
  const hash = createHash("sha256");
  hash.update(Buffer.from(buffer));
  return `sha256-${hash.digest().toString("base64")}`;
}
