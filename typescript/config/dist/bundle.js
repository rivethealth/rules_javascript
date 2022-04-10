'use strict';

var argparse = require('argparse');
var fs = require('fs');
var path = require('path');

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

var fs__namespace = /*#__PURE__*/_interopNamespace(fs);
var path__namespace = /*#__PURE__*/_interopNamespace(path);

var JsonFormat;
(function (JsonFormat) {
    function parse(format, string) {
        return format.fromJson(JSON.parse(string));
    }
    JsonFormat.parse = parse;
    function stringify(format, value) {
        return JSON.stringify(format.toJson(value));
    }
    JsonFormat.stringify = stringify;
})(JsonFormat || (JsonFormat = {}));
(function (JsonFormat) {
    function array(elementFormat) {
        return new ArrayJsonFormat(elementFormat);
    }
    JsonFormat.array = array;
    function map(keyFormat, valueFormat) {
        return new MapJsonFormat(keyFormat, valueFormat);
    }
    JsonFormat.map = map;
    function object(format) {
        return new ObjectJsonFormat(format);
    }
    JsonFormat.object = object;
    function defer(format) {
        return {
            fromJson(json) {
                return format().fromJson(json);
            },
            toJson(value) {
                return format().toJson(value);
            },
        };
    }
    JsonFormat.defer = defer;
    function any() {
        return new AnyJsonFormat();
    }
    JsonFormat.any = any;
    function identity() {
        return new IdentityJsonFormat();
    }
    JsonFormat.identity = identity;
    function nullable(format) {
        return new NullableJsonFormat(format);
    }
    JsonFormat.nullable = nullable;
    function number() {
        return new IdentityJsonFormat();
    }
    JsonFormat.number = number;
    function set(format) {
        return new SetJsonFormat(format);
    }
    JsonFormat.set = set;
    function string() {
        return new IdentityJsonFormat();
    }
    JsonFormat.string = string;
})(JsonFormat || (JsonFormat = {}));
class AnyJsonFormat {
    fromJson(json) {
        return json;
    }
    toJson(value) {
        if (typeof value !== "object" || value === null || value instanceof Array) {
            return value;
        }
        const json = {};
        for (const key of Object.keys(value).sort()) {
            json[key] = this.toJson(value[key]);
        }
        return json;
    }
}
class ArrayJsonFormat {
    constructor(elementFormat) {
        this.elementFormat = elementFormat;
    }
    fromJson(json) {
        return json.map((element) => this.elementFormat.fromJson(element));
    }
    toJson(json) {
        return json.map((element) => this.elementFormat.toJson(element));
    }
}
class IdentityJsonFormat {
    fromJson(json) {
        return json;
    }
    toJson(value) {
        return value;
    }
}
class ObjectJsonFormat {
    constructor(format) {
        this.properties = (Object.entries(format)).sort(([a], [b]) => (a < b ? -1 : b > a ? 1 : 0));
    }
    fromJson(json) {
        const result = {};
        for (const [key, format] of this.properties) {
            if (key in json) {
                result[key] = format.fromJson(json[key]);
            }
        }
        return result;
    }
    toJson(value) {
        const json = {};
        for (const [key, format] of this.properties) {
            if (key in value) {
                json[key] = format.toJson(value[key]);
            }
        }
        return json;
    }
}
class MapJsonFormat {
    constructor(keyFormat, valueFormat) {
        this.keyFormat = keyFormat;
        this.valueFormat = valueFormat;
    }
    fromJson(json) {
        return new Map(json.map(({ key, value }) => [
            this.keyFormat.fromJson(key),
            this.valueFormat.fromJson(value),
        ]));
    }
    toJson(value) {
        return [...value.entries()].map(([key, value]) => ({
            key: this.keyFormat.toJson(key),
            value: this.valueFormat.toJson(value),
        }));
    }
}
class NullableJsonFormat {
    constructor(format) {
        this.format = format;
    }
    fromJson(json) {
        if (json === null) {
            return null;
        }
        return this.format.fromJson(json);
    }
    toJson(value) {
        if (value === null) {
            return null;
        }
        return this.format.toJson(value);
    }
}
class SetJsonFormat {
    constructor(format) {
        this.format = format;
    }
    fromJson(json) {
        return new Set(json.map((element) => this.format.fromJson(element)));
    }
    toJson(value) {
        return [...value].map((element) => this.format.toJson(element));
    }
}

const parser = new argparse.ArgumentParser({
    prog: "typescript-config",
    description: "Generate tsconfig.",
});
parser.add_argument("--config");
parser.add_argument("--empty", {
    default: false,
    help: "Whether to have empty file list",
});
parser.add_argument("--declaration-dir", { dest: "declarationDir" });
parser.add_argument("--module");
parser.add_argument("--root-dir", { dest: "rootDir", required: true });
parser.add_argument("--source-map", { default: "false", dest: "sourceMap" });
parser.add_argument("--out-dir", { dest: "outDir" });
parser.add_argument("--target");
parser.add_argument("--type-root", {
    action: "append",
    dest: "typeRoots",
    default: [],
});
parser.add_argument("output");
(async () => {
    const args = parser.parse_args();
    const outDir = path__namespace.dirname(args.output);
    const relative = (path_) => {
        let result = path__namespace.relative(outDir, path_);
        const [first] = result.split("/", 1);
        if (first != "." && first != "..") {
            result = `./${result}`;
        }
        return result;
    };
    const tsconfig = {
        compilerOptions: {
            typeRoots: args.typeRoots.map(relative),
        },
    };
    tsconfig.compilerOptions.rootDir = relative(args.rootDir);
    if (args.empty) {
        tsconfig.files = [];
    }
    else {
        tsconfig.include = [`${tsconfig.compilerOptions.rootDir}/**/*`];
        tsconfig.exclude = [];
    }
    if (args.module) {
        tsconfig.compilerOptions.module = args.module;
    }
    if (args.declarationDir) {
        tsconfig.compilerOptions.declaration = true;
        tsconfig.compilerOptions.declarationDir = relative(args.declarationDir);
        if (!args.outDir) {
            tsconfig.compilerOptions.emitDeclarationOnly = true;
        }
    }
    if (args.outDir) {
        tsconfig.compilerOptions.outDir = relative(args.outDir);
    }
    if (args.config) {
        tsconfig.extends = relative(args.config);
    }
    tsconfig.compilerOptions.sourceMap = args.sourceMap === "true";
    tsconfig.compilerOptions.inlineSources = args.sourceMap === "true";
    if (args.target) {
        tsconfig.compilerOptions.target = args.target;
    }
    const content = JsonFormat.stringify(JsonFormat.any(), tsconfig);
    await fs__namespace.promises.writeFile(args.output, content, "utf8");
})().catch((e) => {
    console.error(e);
    process.exit(1);
});
//# sourceMappingURL=bundle.js.map
