import { StackSet } from "./collection";

export type Component<T> = Set<T>;

export type Graph<T> = Map<T, Set<T>>;

/**
 * @see https://en.wikipedia.org/wiki/Tarjan%27s_strongly_connected_components_algorithm
 */
export function* stronglyConnectedComponents<T>(
  graph: Graph<T>,
): IterableIterator<Component<T>> {
  let index = 0;
  const stack = new StackSet<T>();
  const minLinks = new Map<T, number>();
  const indices = new Map<T, number>();
  const visit = function* (node: T): IterableIterator<Component<T>> {
    indices.set(node, index);
    minLinks.set(node, index);
    index++;
    stack.push(node);

    for (const node2 of graph.get(node)!) {
      const index2 = indices.get(node2);
      if (index2 === undefined) {
        yield* visit(node2);
        minLinks.set(node, Math.min(minLinks.get(node)!, minLinks.get(node2)!));
      } else if (stack.has(node2)) {
        minLinks.set(node, Math.min(minLinks.get(node)!, index2));
      }
    }

    if (minLinks.get(node) === indices.get(node)) {
      const component = new Set<T>();
      while (true) {
        const n = stack.pop()!;
        component.add(n);
        if (node === n) {
          break;
        }
      }
      yield component;
    }
  };

  for (const node of graph.keys()) {
    if (!indices.has(node)) {
      yield* visit(node);
    }
  }
}
