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
import { Subject } from "rxjs";

function refreshPackageTree(vfs: WrapperVfs, webpackManifestPath: string) {
  const packageTree = JsonFormat.parse(
    PackageTree.json(),
    fs.readFileSync(webpackManifestPath, "utf8"),
  );
  const vfsImpl = createVfs(packageTree, true);
  vfs.delegate = vfsImpl;
}

function clearTimeout_(
  delegate: typeof clearTimeout,
  event: Subject<undefined>,
): typeof clearTimeout {
  return <any>function (handle) {
    if (handle?.unsubscribe) {
      handle.unsubscribe();
      return;
    }
    return delegate.apply(this, arguments);
  };
}

function setTimeout_(
  delegate: typeof setTimeout,
  event: Subject<undefined>,
): typeof setTimeout {
  return <any>function (callback, time) {
    if (time === 130929) {
      const subscription = event.subscribe(() => {
        subscription.unsubscribe();
        callback();
      });
      return subscription;
    }
    return delegate.apply(this, arguments);
  };
}

const refresh = new Subject<undefined>();
(<any>setTimeout) = setTimeout_(setTimeout, refresh);
(<any>clearTimeout) = clearTimeout_(clearTimeout, refresh);

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

  const devServer = config.devServer || {};
  devServer.setupExitSignals = false;

  const server = new WebpackDevServer(config.devServer, compiler);

  await server.start();

  process.stdin.setEncoding("ascii");
  for await (const notification of readNotifications(<any>process.stdin)) {
    if (
      notification.type === IbazelNotification.COMPLETED &&
      notification.status === IbazelStatus.SUCCESS
    ) {
      refreshPackageTree(vfs, webpackManifestPath);
      refresh.next(undefined);
    }
  }
}
