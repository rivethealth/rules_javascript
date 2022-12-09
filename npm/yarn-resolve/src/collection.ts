export class StackSet<T> {
  private readonly stack: T[] = [];
  private readonly set = new Set<T>();

  get size() {
    return this.stack.length;
  }

  has(value: T) {
    return this.set.has(value);
  }

  pop() {
    if (this.stack.length === 0) {
      return;
    }
    const result = this.stack.pop()!;
    this.set.delete(result);
    return result;
  }

  push(value: T) {
    this.stack.push(value);
    this.set.add(value);
  }
}
