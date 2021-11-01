import { Reader, Writer } from "protobufjs";

export interface MessageType<T> {
  encode(message: T, writer?: Writer): Writer;
  decode(input: Reader | Uint8Array, length?: number): T;
}

function concat(buffers: ArrayBuffer[]) {
  const length = buffers.reduce((sum, buffer) => sum + buffer.byteLength, 0);
  const result = new Uint8Array(length);
  let offset = 0;
  for (const buffer of buffers) {
    result.set(new Uint8Array(buffer), offset);
    offset += buffer.byteLength;
  }
  return result.buffer;
}

export async function* readFromStream<T>(
  iterator: AsyncIterable<ArrayBuffer>,
  messageType: MessageType<T>,
): AsyncIterable<T> {
  const it = iterator[Symbol.asyncIterator]();
  let buffer: ArrayBuffer = new Uint8Array(0);
  outer: while (true) {
    while (new Uint8Array(buffer).every((v) => 128 <= v)) {
      let next = await it.next();
      if (next.done) {
        if (buffer.byteLength) {
          throw new Error("Unexpected EOF");
        } else {
          break outer;
        }
      }
      buffer = concat([buffer, next.value]);
    }
    const reader = Reader.create(new Uint8Array(buffer));
    const length = reader.uint32();
    console.error(length);
    buffer = buffer.slice(reader.pos);
    while (buffer.byteLength < length) {
      let next = await it.next();
      if (next.done) {
        throw new Error("Unexpected EOF");
      }
      buffer = concat([buffer, next.value]);
    }
    console.error("Decoding");
    yield messageType.decode(new Uint8Array(buffer), length);
    buffer = buffer.slice(length);
  }
}

export async function* writeToStream<T>(
  iterator: AsyncIterable<T>,
  messageType: MessageType<T>,
): AsyncIterable<ArrayBuffer> {
  for await (const message of iterator) {
    yield messageType.encode(message).ldelim().finish();
  }
}
