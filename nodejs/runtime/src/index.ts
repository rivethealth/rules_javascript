const { emitWarning } = process;

/**
 * @file
 * @see https://github.com/nodejs/node/issues/30810
 */

process.emitWarning = function (warning: string | Error, type: any) {
  if (type === "ExperimentalWarning") {
    return;
  }

  if (type && typeof type === "object" && type.type === "ExperimentalWarning") {
    return;
  }

  return emitWarning.apply(this, arguments);
};
