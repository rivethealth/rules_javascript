export type Json = any;

export interface JsonFormat<T> {
  fromJson(json: any): T;
  toJson(value: T): Json;
}

export namespace JsonFormat {
  export function array<T>(elementFormat: JsonFormat<T>): JsonFormat<T[]> {
    return new ArrayJsonFormat(elementFormat);
  }

  export function map<K, V>(
    keyFormat: JsonFormat<K>,
    valueFormat: JsonFormat<V>,
  ): JsonFormat<Map<K, V>> {
    return new MapJsonFormat(keyFormat, valueFormat);
  }

  export function object<V>(format: {
    [K in keyof V]: JsonFormat<V[K]>;
  }): JsonFormat<V> {
    return new ObjectJsonFormat(format);
  }

  export function defer<T>(format: () => JsonFormat<T>): JsonFormat<T> {
    return {
      fromJson(json: any) {
        return format().fromJson(json);
      },
      toJson(value: T) {
        return format().toJson(value);
      },
    };
  }

  export function string(): JsonFormat<string> {
    return new StringJsonFormat();
  }
}

class ArrayJsonFormat<T> implements JsonFormat<T[]> {
  constructor(private readonly elementFormat: JsonFormat<T>) {}

  fromJson(json: any) {
    return json.map((element) => this.elementFormat.fromJson(element));
  }

  toJson(json: any) {
    return json.map((element) => this.elementFormat.toJson(element));
  }
}

class ObjectJsonFormat<V> implements JsonFormat<V> {
  constructor(private readonly format: { [K in keyof V]: JsonFormat<V[K]> }) {}

  fromJson(json: any) {
    const result = <V>{};
    for (const key in this.format) {
      result[key] = this.format[key].fromJson(json[key]);
    }
    return result;
  }

  toJson(value: V) {
    const json = <Json>{};
    for (const key in this.format) {
      json[key] = this.format[key].toJson(value[key]);
    }
    return json;
  }
}

class MapJsonFormat<K, V> implements JsonFormat<Map<K, V>> {
  constructor(
    private readonly keyFormat: JsonFormat<K>,
    private readonly valueFormat: JsonFormat<V>,
  ) {}

  fromJson(json: any) {
    return new Map<K, V>(
      json.map(({ key, value }) => [
        this.keyFormat.fromJson(key),
        this.valueFormat.fromJson(value),
      ]),
    );
  }

  toJson(value: Map<K, V>) {
    return [...value.entries()].map(([key, value]) => ({
      key: this.keyFormat.toJson(key),
      value: this.valueFormat.toJson(value),
    }));
  }
}

class StringJsonFormat implements JsonFormat<string> {
  fromJson(json: any) {
    return json;
  }

  toJson(value: string) {
    return value;
  }
}
