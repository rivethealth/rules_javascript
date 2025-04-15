const { emit } = process;

/**
 * @file
 * @see https://github.com/nodejs/node/issues/30810
 */

process.emit = <any>function (this: any, name: string, data: any) {
  if (name === "warning" && data?.name === "ExperimentalWarning") {
    return;
  }

  return Reflect.apply(emit, this, arguments);
};
