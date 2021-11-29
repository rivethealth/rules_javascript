interface Data<K, V> {
  children: Map<K, Data<K, V>>;
  value?: V;
}

export class Trie<K, V> {
  private readonly data: Data<K, V> = { children: new Map() };

  getClosest(key: K[]): { rest: K[]; value: V | undefined } {
    let data = this.data;
    let i: number;
    for (i = 0; i < key.length && data; i++) {
      const k = key[i];
      let newData = data.children.get(k);
      if (!newData) {
        break;
      }
      data = newData;
    }
    return { rest: key.slice(i), value: data.value };
  }

  put(key: K[], value: V) {
    let data = this.data;
    for (const k of key) {
      let newData = data.children.get(k);
      if (!newData) {
        newData = { children: new Map() };
        data.children.set(k, newData);
      }
      data = newData;
    }
    data.value = value;
  }
}
