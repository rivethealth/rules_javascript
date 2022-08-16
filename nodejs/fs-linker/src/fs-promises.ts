import { promises as fsPromises } from "node:fs";
import { Vfs } from "./vfs";
import { replaceArguments } from "./fs";

function access(
  vfs: Vfs,
  delegate: typeof fsPromises.access,
): typeof fsPromises.access {
  return replaceArguments(vfs, delegate, [0]);
}

function appendFile(
  vfs: Vfs,
  delegate: typeof fsPromises.appendFile,
): typeof fsPromises.appendFile {
  return replaceArguments(vfs, delegate, [0]);
}

function chmod(
  vfs: Vfs,
  delegate: typeof fsPromises.chmod,
): typeof fsPromises.chmod {
  return replaceArguments(vfs, delegate, [0]);
}

function chown(
  vfs: Vfs,
  delegate: typeof fsPromises.chown,
): typeof fsPromises.chown {
  return replaceArguments(vfs, delegate, [0]);
}

function copyFile(
  vfs: Vfs,
  delegate: typeof fsPromises.copyFile,
): typeof fsPromises.copyFile {
  return replaceArguments(vfs, delegate, [0, 1]);
}

function cp(vfs: Vfs, delegate: typeof fsPromises.cp): typeof fsPromises.cp {
  return replaceArguments(vfs, delegate, [0, 1]);
}

function lutimes(
  vfs: Vfs,
  delegate: typeof fsPromises.lutimes,
): typeof fsPromises.lutimes {
  return replaceArguments(vfs, delegate, [0]);
}

export function patchFsPromises(vfs: Vfs, delegate: typeof fsPromises) {
  delegate.access = access(vfs, fsPromises.access);
  delegate.appendFile = appendFile(vfs, fsPromises.appendFile);
  delegate.chmod = chmod(vfs, delegate.chmod);
  delegate.chown = chown(vfs, delegate.chown);
  delegate.copyFile = copyFile(vfs, delegate.copyFile);
  delegate.cp = cp(vfs, delegate.cp);
  // delegate.lchmod
  // delegate.lchown
  delegate.lutimes = lutimes(vfs, delegate.lutimes);
}
