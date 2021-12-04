export type VfsNode = VfsNode.Path | VfsNode.Link;

export namespace VfsNode {
  export const PATH = Symbol("PATH");
  export const SYMLINK = Symbol("SYMLINK");

  export interface Path {
    /** Real path */
    path: string | undefined;
    /** Synthentic child entries */
    extraChildren: Map<string, VfsNode>;
    /** Harden real symlinks under this path */
    hardenSymlinks: boolean;
    type: typeof PATH;
  }

  export interface Link {
    /** Target path */
    path: string;
    type: typeof SYMLINK;
  }
}

export interface RealpathResult {
  path: string;
  hardenSymlinks: boolean;
}

export class Vfs {
  constructor(private readonly root: VfsNode) {}

  entry(path: string): VfsNode | undefined {
    loop: while (true) {
      if (!path.startsWith("/")) {
        throw new Error("Path must be absolute");
      }
      const parts = path.split("/").slice(1);

      let node = this.root;
      let i: number;
      for (i = 0; i < parts.length; i++) {
        if (node.type === VfsNode.SYMLINK) {
          path = [node.path, ...parts.slice(i)].join("/");
          continue loop;
        }

        const newNode = node.extraChildren.get(parts[i]);
        if (!newNode) {
          break;
        }
        node = newNode;
      }

      if (i < parts.length) {
        if (node.path === undefined) {
          return undefined;
        }
        return {
          type: VfsNode.PATH,
          extraChildren: new Map(),
          hardenSymlinks: (<VfsNode.Path>node).hardenSymlinks,
          path: [node.path, ...parts.slice(i)].join("/"),
        };
      }
      return node;
    }
  }

  realpath(path: string): RealpathResult | undefined {
    loop: while (true) {
      if (!path.startsWith("/")) {
        throw new Error("Path must be absolute");
      }
      const parts = path.split("/").slice(1);

      let node = this.root;
      let i: number;
      for (i = 0; i < parts.length; i++) {
        if (node.type === VfsNode.SYMLINK) {
          path = [node.path, ...parts.slice(i)].join("/");
          continue loop;
        }

        const newNode = node.extraChildren.get(parts[i]);
        if (!newNode) {
          break;
        }
        node = newNode;
      }

      if (node.type === VfsNode.SYMLINK) {
        path = [node.path, ...parts.slice(i)].join("/");
        continue loop;
      }

      if (i < parts.length) {
        if (node.path === undefined) {
          return undefined;
        }
        return {
          hardenSymlinks: (<VfsNode.Path>node).hardenSymlinks,
          path: [node.path, ...parts.slice(i)].join("/"),
        };
      }
      return {
        hardenSymlinks: (<VfsNode.Path>node).hardenSymlinks,
        path: "/" + parts.join("/"),
      };
    }
  }

  /**
   * Return node representing file path
   */
  resolve(path: string): VfsNode.Path | undefined {
    loop: while (true) {
      if (!path.startsWith("/")) {
        throw new Error("Path must be absolute");
      }
      const parts = path.split("/").slice(1);

      let node = this.root;
      let i: number;
      for (i = 0; i < parts.length; i++) {
        if (node.type === VfsNode.SYMLINK) {
          path = [node.path, ...parts.slice(i)].join("/");
          continue loop;
        }

        const newNode = node.extraChildren.get(parts[i]);
        if (!newNode) {
          break;
        }
        node = newNode;
      }

      if (node.type === VfsNode.SYMLINK) {
        path = [node.path, ...parts.slice(i)].join("/");
        continue loop;
      }

      if (i < parts.length) {
        if (node.path === undefined) {
          return undefined;
        }
        return {
          type: VfsNode.PATH,
          extraChildren: new Map(),
          hardenSymlinks: (<VfsNode.Path>node).hardenSymlinks,
          path: [node.path, ...parts.slice(i)].join("/"),
        };
      }
      return node;
    }
  }

  print() {
    return (function print(name: string, node: VfsNode, prefix: string) {
      switch (node.type) {
        case VfsNode.PATH: {
          let result: string;
          if (node.path) {
            result = `${prefix}${name}/ (${node.path})\n`;
          } else {
            result = `${prefix}${name}/\n`;
          }
          for (const [name, child] of node.extraChildren.entries()) {
            result += print(name, child, prefix + "  ");
          }
          return result;
        }
        case VfsNode.SYMLINK:
          return `${prefix}${name} -> ${node.path}\n`;
      }
    })("", this.root, "");
  }
}
