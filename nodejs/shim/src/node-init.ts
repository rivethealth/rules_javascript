import { Vfs, VfsMount, VfsEntry } from "@better_rules_javascript/commonjs-fs";
import { patchFs } from "./fs";
import { traceFs } from "./trace-fs";

if (process.env.NODE_TRACE_FS === "true") {
  console.error("Shimming Node.js FS");
}

const linkFs = new Vfs();
// eslint-disable-next-line @typescript-eslint/no-var-requires
patchFs(linkFs, require("fs"));

if (process.env.NODE_TRACE_FS === "true") {
  // eslint-disable-next-line @typescript-eslint/no-var-requires
  traceFs(require("fs"));
}

(<any>global).linkFsMount = (
  name: string,
  config: any,
  isRunfiles: boolean,
) => {
  if (process.env.NODE_TRACE_FS === "true") {
    console.error(`Mounting FS ${name}`);
  }

  const entry = VfsEntry.json().fromJson(config);
  if (isRunfiles) {
    (function f(entry: VfsEntry) {
      switch (entry.type) {
        case VfsEntry.DIRECTORY:
          for (const child of entry.children.values()) {
            f(child);
          }
          break;
        case VfsEntry.LINK:
          break;
        case VfsEntry.PATH:
          entry.path = (<any>global).runfilePath(entry.path) || entry.path;
          break;
      }
    })(entry);
  }

  const mount = new VfsMount(entry);
  if (process.env.NODE_TRACE_FS === "true") {
    for (const line of mount.tree()) {
      console.error(`  ${line}`);
    }
  }
  linkFs.mount(name, mount);
};
