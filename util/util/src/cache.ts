export function lazy<T>(f: () => T) {
  let result: T;
  return () => {
    if (f) {
      result = f();
      f = undefined!;
    }
    return result;
  };
}

export function memo<A, B>(f: (input: A) => B) {
  const cache = new Map<A, B>();
  return (input: A) => {
    if (cache.has(input)) {
      return cache.get(input)!;
    }
    const result = f(input);
    cache.set(input, result);
    return result;
  };
}
