export interface ManagedResource<T> {
  <R>(f: (resource: T) => Promise<R>): Promise<R>;
}
