'use strict';var emitWarning = process.emitWarning;
/**
 * @file
 * @see https://github.com/nodejs/node/issues/30810
 */
process.emitWarning = function (warning, type) {
    if (type === "ExperimentalWarning") {
        return;
    }
    if (type && typeof type === "object" && type.type === "ExperimentalWarning") {
        return;
    }
    return emitWarning.apply(this, arguments);
};