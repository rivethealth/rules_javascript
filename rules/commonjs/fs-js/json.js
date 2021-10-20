export var JsonFormat;
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
            }
        };
    }
    JsonFormat.defer = defer;
    function string() {
        return new StringJsonFormat();
    }
    JsonFormat.string = string;
})(JsonFormat || (JsonFormat = {}));
class ArrayJsonFormat {
    constructor(elementFormat) {
        this.elementFormat = elementFormat;
    }
    fromJson(json) {
        return json.map(element => this.elementFormat.fromJson(element));
    }
    toJson(json) {
        return json.map(element => this.elementFormat.toJson(element));
    }
}
class ObjectJsonFormat {
    constructor(format) {
        this.format = format;
    }
    fromJson(json) {
        const result = {};
        for (const key in this.format) {
            result[key] = this.format[key].fromJson(json[key]);
        }
        return result;
    }
    toJson(value) {
        const json = {};
        for (const key in this.format) {
            json[key] = this.format[key].toJson(value[key]);
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
        return new Map(json.map(({ key, value }) => [this.keyFormat.fromJson(key), this.valueFormat.fromJson(value)]));
    }
    toJson(value) {
        return [...value.entries()].map(([key, value]) => ({ key: this.keyFormat.toJson(key), value: this.valueFormat.toJson(value) }));
    }
}
class StringJsonFormat {
    fromJson(json) {
        return json;
    }
    toJson(value) {
        return value;
    }
}
