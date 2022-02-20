export function getOrSet<K, V>(map: Map<K, V>, key: K, valueFn: () => V): V {
  if (map.has(key)) {
    return map.get(key);
  }
  const value = valueFn();
  map.set(key, value);
  return value;
}
