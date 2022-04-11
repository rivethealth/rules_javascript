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
  const vfsImpl = createVfs(packageTree, process.env.RUNFILES_DIR);
  vfs.delegate = vfsImpl;
}

function clearTimeout_(delegate: typeof clearTimeout): typeof clearTimeout {
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
  const watchpackPolling = +process.env.WATCHPACK_POLLING;

  return <any>function (callback, time) {
    if (time === watchpackPolling) {
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
// eslint-disable-next-line no-global-assign
(<any>setTimeout) = setTimeout_(setTimeout, refresh);
// eslint-disable-next-line no-global-assign
(<any>clearTimeout) = clearTimeout_(clearTimeout);

export async function startServer(
  vfs: WrapperVfs,
  webpackManifestPath: string,
  digestPath: string,
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

  const serverOptions = config.devServer || {};
  serverOptions.setupExitSignals = false;
  const server = new WebpackDevServer(serverOptions, compiler);

  await server.start();

  process.stdin.setEncoding("ascii");
  let digest: Buffer | undefined;
  for await (const notification of readNotifications(<any>process.stdin)) {
    if (
      notification.type !== IbazelNotification.COMPLETED ||
      notification.status !== IbazelStatus.SUCCESS
    ) {
      continue;
    }

    const newDigest = await fs.promises.readFile(digestPath);
    if (digest !== undefined && digest.equals(newDigest)) {
      continue;
    }
    digest = newDigest;

    refreshPackageTree(vfs, webpackManifestPath);
    refresh.next(undefined);
  }
}
