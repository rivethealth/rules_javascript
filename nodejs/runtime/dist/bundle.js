'use strict';

const { emit } = process;
/**
 * @file
 * @see https://github.com/nodejs/node/issues/30810
 */
process.emit = function (name, data) {
    if (name === "warning" && data?.name === "ExperimentalWarning") {
        return;
    }
    return emit.apply(this, arguments);
};
//# sourceMappingURL=bundle.js.map
