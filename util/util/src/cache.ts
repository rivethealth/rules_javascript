export function lazy<T>(f: () => T) {
  let result: T;
  return () => {
    if (f) {
      result = f();
      f = undefined;
    }
    return result;
  };
}
