'use strict';

var Module = require('node:module');

function _interopNamespace(e) {
    if (e && e.__esModule) return e;
    var n = Object.create(null);
    if (e) {
        Object.keys(e).forEach(function (k) {
            if (k !== 'default') {
                var d = Object.getOwnPropertyDescriptor(e, k);
                Object.defineProperty(n, k, d.get ? d : {
                    enumerable: true,
                    get: function () { return e[k]; }
                });
            }
        });
    }
    n["default"] = e;
    return Object.freeze(n);
}

var Module__namespace = /*#__PURE__*/_interopNamespace(Module);

const { emit } = process;
// shim module.isBuiltin, added in v18.6.0
const moduleModule = require("node:module");
if (!moduleModule.isBuiltin) {
    const builtins = new Set(Module__namespace.builtinModules);
    moduleModule.isBuiltin = (name) => name.startsWith("node:") || builtins.has(name);
}
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
