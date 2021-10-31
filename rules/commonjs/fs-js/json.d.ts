export declare type Json = any;
export interface JsonFormat<T> {
  fromJson(json: any): T;
  toJson(value: T): Json;
}
export declare namespace JsonFormat {
  function array<T>(elementFormat: JsonFormat<T>): JsonFormat<T[]>;
  function map<K, V>(
    keyFormat: JsonFormat<K>,
    valueFormat: JsonFormat<V>,
  ): JsonFormat<Map<K, V>>;
  function object<V>(
    format: {
      [K in keyof V]: JsonFormat<V[K]>;
    },
  ): JsonFormat<V>;
  function defer<T>(format: () => JsonFormat<T>): JsonFormat<T>;
  function string(): JsonFormat<string>;
}
