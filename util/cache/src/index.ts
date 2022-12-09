import { JsonFormat } from "@better-rules-javascript/util-json";
import { getOrSetAync } from "@better-rules-javascript/util/collection";
import { ManagedResource } from "@better-rules-javascript/util/resource";
import * as fs from "node:fs";

interface Versioned<T> {
  _version: string;
  value: T;
}

namespace Versioned {
  export function json<T>(value: JsonFormat<T>): JsonFormat<Versioned<T>> {
    return JsonFormat.object({ _version: JsonFormat.string(), value });
  }
}

export class TrackingCache<K, V> {
  constructor(
    private readonly cache: Map<K, V>,
    private readonly newCache: Map<K, V>,
  ) {}

  async asyncGet(key: K, f: () => Promise<V>): Promise<V> {
    const result = await getOrSetAync(this.cache, key, f);
    this.newCache.set(key, result);
    return result;
  }
}

export function withFileCache<K, V>(
  path: string,
  version: string,
  keyFormat: JsonFormat<K>,
  valueFormat: JsonFormat<V>,
): ManagedResource<TrackingCache<K, V>> {
  const format = Versioned.json(JsonFormat.map(keyFormat, valueFormat));
  return async (f) => {
    let cacheContent: string | undefined;
    try {
      cacheContent = await fs.promises.readFile(path, "utf8");
    } catch {}
    if (
      cacheContent !== undefined &&
      !cacheContent.startsWith(`{"_version":${JSON.stringify(version)}`)
    ) {
      cacheContent = undefined;
    }
    const newCache = new Map<K, V>();
    const cache: Map<K, V> = cacheContent
      ? JsonFormat.parse(format, cacheContent).value
      : newCache;

    const result = await f(new TrackingCache(cache, newCache));

    await fs.promises.writeFile(
      path,
      JsonFormat.stringify(format, { _version: version, value: cache }),
    );

    return result;
  };
}
