import { PackageTree } from "@better-rules-javascript/commonjs-package";
import {
  IbazelNotification,
  IbazelStatus,
  readNotifications,
} from "@better-rules-javascript/ibazel-notification/index";
import { createVfs } from "@better-rules-javascript/nodejs-fs-linker/package";
import { WrapperVfs } from "@better-rules-javascript/nodejs-fs-linker/vfs";
import { JsonFormat } from "@better-rules-javascript/util-json";
import { readFileSync } from "node:fs";
import { readFile } from "node:fs/promises";
import { Subject } from "rxjs";

export function refreshPackageTree(
  vfs: WrapperVfs,
  webpackManifestPath: string,
  webpackRunfiles: string,
) {
  const packageTree = JsonFormat.parse(
    PackageTree.json(),
    readFileSync(webpackManifestPath, "utf8"),
  );
  const vfsImpl = createVfs(packageTree, webpackRunfiles);
  vfs.delegate = vfsImpl;
}

export function run(
  vfs: WrapperVfs,
  webpackManifestPath: string,
  webpackRunfiles: string,
  digestPath: string,
  refresh: Subject<void>,
): Promise<void> {
  process.stdin.setEncoding("ascii");

  refreshPackageTree(vfs, webpackManifestPath, webpackRunfiles);

  let digest: Buffer = readFileSync(digestPath);
  return (async () => {
    for await (const notification of readNotifications(<any>process.stdin)) {
      if (
        notification.type !== IbazelNotification.COMPLETED ||
        notification.status !== IbazelStatus.SUCCESS
      ) {
        continue;
      }

      const newDigest = await readFile(digestPath);
      if (digest.equals(newDigest)) {
        continue;
      }
      digest = newDigest;

      refreshPackageTree(vfs, webpackManifestPath, webpackRunfiles);
      refresh.next();
    }
  })();
}
