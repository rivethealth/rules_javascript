export async function* lines(
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
      yield data.slice(i, j + 1);
      i = j + 1;
    }
    data = data.slice(i);
  }
  if (data) {
    yield data;
  }
}
