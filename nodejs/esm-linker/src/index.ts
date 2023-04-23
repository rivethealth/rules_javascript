export async function resolve(this: any) {
  const { resolve } = await import("./loader");

  return await Reflect.apply(await resolve(), this, arguments);
}
