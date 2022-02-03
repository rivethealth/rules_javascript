import {
  IbazelNotification,
  IbazelStatus,
  readNotifications,
} from "@better-rules-javascript/ibazel-notification";
import * as webpack from "webpack";
import * as WebpackDevServer from "webpack-dev-server";
import { JsonFormat } from "@better-rules-javascript/util-json";
import { PackageTree } from "@better-rules-javascript/commonjs-package";
import { createVfs } from "@better-rules-javascript/nodejs-fs-linker/package";
import * as fs from "fs";
import { WrapperVfs } from "@better-rules-javascript/nodejs-fs-linker/vfs";
import * as CachedInputFileSystem from "enhanced-resolve/lib/CachedInputFileSystem";
import { BazelWatchFileSystem } from "./watch";

function refreshPackageTree(vfs: WrapperVfs, webpackManifestPath: string) {
  const packageTree = JsonFormat.parse(
    PackageTree.json(),
    fs.readFileSync(webpackManifestPath, "utf8"),
  );
  const vfsImpl = createVfs(packageTree, true);
  vfs.delegate = vfsImpl;
}

export async function startServer(
  vfs: WrapperVfs,
  webpackManifestPath: string,
) {
  const { default: configPromise } = await eval(
    'import("@better-rules-javascript/webpack-load-config")',
  );
  const config = await configPromise;
  const compiler = webpack(config);

  refreshPackageTree(vfs, webpackManifestPath);

  // don't use graceful-fs
  compiler.inputFileSystem = new CachedInputFileSystem(fs);
  compiler.intermediateFileSystem = fs;
  compiler.outputFileSystem = fs;

  const watchFileSystem = new BazelWatchFileSystem(compiler.inputFileSystem);
  compiler.watchFileSystem = watchFileSystem;

  const server = new WebpackDevServer(config.devServer, compiler);

  await server.start();

  process.stdin.setEncoding("ascii");
  for await (const notification of readNotifications(<any>process.stdin)) {
    if (
      notification.type === IbazelNotification.COMPLETED &&
      notification.status === IbazelStatus.SUCCESS
    ) {
      refreshPackageTree(vfs, webpackManifestPath);
      watchFileSystem.refresh();
    }
  }
}
