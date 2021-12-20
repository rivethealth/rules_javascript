const NEWLINE = '\n'.charCodeAt(0);

export async function* readLines(iterable: AsyncIterable<ArrayBuffer>) {
  let data = new ArrayBuffer(0);
  for await (const chunk of iterable) {
    const buffer = Buffer.concat([new Uint8Array(data), new Uint8Array(chunk)]);
    data = buffer.buffer.slice(buffer.byteOffset, buffer.byteOffset + buffer.byteLength);
    while (true) {
      const i = new Uint8Array(data).indexOf(NEWLINE);
      if (i < 0) {
        break;
      }
      yield data.slice(0, i);
      data = data.slice(i + 1);
    }
  }
}
