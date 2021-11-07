import * as fs from "fs";
import { VfsEntry } from "@better_rules_javascript/commonjs-fs";
import { JsonFormat } from "@better_rules_javascript/commonjs-fs/json";
import { dir } from "console";

export interface Root {
  links: RootLink[];
  descriptor: string;
  id: string;
  label: string;
  name: string;
  path: string;
}

export namespace Root {
  export function json(): JsonFormat<Root> {
    return JsonFormat.object<Root>({
      descriptor: JsonFormat.string(),
      id: JsonFormat.string(),
      label: JsonFormat.string(),
      links: JsonFormat.array(RootLink.json()),
      name: JsonFormat.string(),
      path: JsonFormat.string(),
    });
  }
}

export interface RootLink {
  id: string;
  name: string;
}

export namespace RootLink {
  export function json(): JsonFormat<RootLink> {
    return JsonFormat.object({
      id: JsonFormat.string(),
      name: JsonFormat.string(),
    });
  }
}

export interface Entry {
  file: string;
  name: string;
  root: string;
  label: string;
}

export namespace Entry {
  export function json() {
    return JsonFormat.object({
      file: JsonFormat.string(),
      name: JsonFormat.string(),
      root: JsonFormat.string(),
      label: JsonFormat.string(),
    });
  }
}

export interface ExtraLink {
  root: string;
  dep: string;
}

export namespace ExtraLink {
  export function json(): JsonFormat<ExtraLink> {
    return JsonFormat.object({
      root: JsonFormat.string(),
      dep: JsonFormat.string(),
    });
  }
}

const root: VfsEntry.Directory = {
  type: VfsEntry.DIRECTORY,
  children: new Map(),
};

function mkdir(dir: VfsEntry.Directory, name: string): VfsEntry.Directory {
  let result = dir.children.get(name);
  if (!result) {
    result = { type: VfsEntry.DIRECTORY, children: new Map() };
    dir.children.set(name, result);
  } else if (result.type !== VfsEntry.DIRECTORY) {
    throw new Error();
  }
  return result;
}

function addDep(root: VfsEntry.Directory, name: string, path: string) {
  let dir = <VfsEntry.Directory>root.children.get("node_modules");
  const parts = name.split("/");
  for (const part of parts.slice(0, -1)) {
    dir = mkdir(dir, part);
  }
  dir.children.set(parts[parts.length - 1], {
    type: VfsEntry.LINK,
    path: [path],
  });
}

export interface GenArgs {
  globals: string;
  runfiles: boolean;
  mount: string;
  extraLinks: ExtraLink[];
  entries: Entry[];
  roots: Root[];
  outputPath: string;
}

export function gen(args: GenArgs): void {
  const paths = new Map<string, string>();
  for (const root_ of args.roots) {
    paths.set(root_.id, root_.path);
  }

  const names = new Map<string, string>();
  const targets = new Map<string, Set<string>>();

  // add roots
  for (const root_ of args.roots) {
    const packageRoot = mkdir(root, root_.path);
    const t = new Set<string>();

    packageRoot.children.set("package.json", {
      type: VfsEntry.PATH,
      path: root_.descriptor,
    });
    packageRoot.children.set("node_modules", {
      type: VfsEntry.DIRECTORY,
      children: new Map(),
    });

    for (const link of root_.links) {
      t.add(link.id);
      addDep(packageRoot, link.name, paths.get(link.id));
    }

    targets.set(root_.id, t);
    names.set(root_.id, root_.name);
    paths.set(root_.id, root_.path);
  }

  // add additional deps, if not already present
  for (const dep of args.extraLinks) {
    if (targets.get(dep.root).has(dep.dep)) {
      continue;
    }

    const packageRoot = <VfsEntry.Directory>(
      root.children.get(paths.get(dep.root))
    );
    addDep(packageRoot, names.get(dep.dep), paths.get(dep.dep));
  }

  // add entries
  for (const entry of args.entries) {
    const parts = entry.name.split("/");

    const packageRoot = root.children.get(paths.get(entry.root));

    if (!packageRoot) {
      throw new Error("No package root");
    }

    let dir = <VfsEntry.Directory>packageRoot;
    for (const part of parts.slice(0, -1)) {
      dir = mkdir(dir, part);
    }

    dir.children.set(parts[parts.length - 1], {
      type: VfsEntry.PATH,
      path: entry.file,
    });
  }

  // add globals
  mkdir(root, "node_modules");
  for (const global_ of args.globals) {
    addDep(root, names.get(global_)!, paths.get(global_)!);
  }

  const json = JSON.stringify(VfsEntry.json().toJson(root));
  const content = `global.linkFsMount(
  ${JSON.stringify(args.mount)},
  ${json},
  ${JSON.stringify(args.runfiles)},
);
`;

  fs.writeFileSync(args.outputPath, content, "utf8");
}
