const { emit } = process;

/**
 * @file
 * @see https://github.com/nodejs/node/issues/30810
 */

process.emit = <any>function (name: string, data: any) {
  if (name === "warning" && data?.name === "ExperimentalWarning") {
    return;
  }

  return emit.apply(this, arguments);
};
