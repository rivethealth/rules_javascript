import * as fs from 'fs';

function toString(arg: any) {
    if (arg instanceof Error) {
        return arg.message;
    }
    if (typeof arg === 'object' && arg !== null) {
        return arg.constructor.name;
    }
    return String(arg).split('\n')[0];
}

function trace<F extends Function>(name: string, delegate: F): F {
    return <F><unknown>function(...args) {
        for (let i = 0; i < args.length; i++) {
            if (args[i] instanceof Function) {
                const f = args[i];
                args[i] = function(...args) {
                    console.log(name, 'callback', ...args.map(toString));
                    return f.apply(this, args);
                }
            }
        }
        try {
            const result = delegate.apply(this, args);
            console.log(name, ...args.map(toString), toString(result));
            return result;
        } catch (e) {
            console.log(name, ...args.map(toString), toString(e));
            throw e;
        }
    }
}

export function traceFs(delegate: typeof fs) {
    delegate.access = trace('access', delegate.access);
    delegate.accessSync = trace('accessSync', delegate.accessSync);
    delegate.appendFile = trace('appendFile', delegate.appendFile);
    delegate.appendFileSync = trace('appendFileSync', delegate.appendFileSync);
    delegate.chmod = trace('chmod', delegate.chmod);
    delegate.chmodSync = trace('chmodSync', delegate.chmodSync);
    delegate.chown = trace('chown', delegate.chown);
    delegate.chownSync = trace('chownSync', delegate.chownSync);
    delegate.copyFile = trace('copyFile', delegate.copyFile);
    delegate.copyFileSync = trace('copyFileSync', delegate.copyFileSync);
    delegate.createReadStream = trace(
      'createReadStream',
      delegate.createReadStream
    );
    delegate.createWriteStream = trace(
      'createWriteStream',
      delegate.createWriteStream
    );
    delegate.exists = trace('exists', delegate.exists);
    delegate.existsSync = trace('existsSync', delegate.existsSync);
    delegate.lchmod = trace('lchmod', delegate.lchmod);
    delegate.lchmodSync = trace('lchmodSync', delegate.lchmodSync);
    delegate.lchown = trace('lchown', delegate.lchown);
    delegate.lchownSync = trace('lchownSync', delegate.lchownSync);
    delegate.lutimes = trace('lutimes', delegate.lutimes);
    delegate.lutimesSync = trace('lutimesSync', delegate.lutimesSync);
    delegate.link = trace('link', delegate.link);
    delegate.linkSync = trace('linkSync', delegate.linkSync);
    delegate.lstat = trace('lstat', delegate.lstat);
    delegate.lstatSync = trace('lstatSync', delegate.lstatSync);
    delegate.mkdir = trace('mkdir', delegate.mkdir);
    delegate.mkdirSync = trace('mkdirSync', delegate.mkdirSync);
    delegate.mkdtemp = trace('mkdtemp', delegate.mkdtemp);
    delegate.mkdtempSync = trace('mkdtempSync', delegate.mkdtempSync);
    delegate.open = trace('open', delegate.open);
    delegate.openSync = trace('openSync', delegate.openSync);
    delegate.opendir = trace('opendir', delegate.opendir);
    delegate.opendirSync = trace('opendirSync', delegate.opendirSync);
    delegate.readdir = trace('readdir', delegate.readdir);
    delegate.readdirSync = trace('readdirSync', delegate.readdirSync);
    delegate.readFile = trace('readFile', delegate.readFile);
    delegate.readFileSync = trace('readFileSync', delegate.readFileSync);
    delegate.readlink = trace('readlink', delegate.readlink);
    delegate.readlinkSync = trace('readlinkSync', delegate.readlinkSync);
    delegate.realpath = trace('realpath', delegate.realpath);
    delegate.realpathSync = trace('realpathSync', delegate.realpathSync);
    delegate.rename = trace('rename', delegate.rename);
    delegate.renameSync = trace('renameSync', delegate.renameSync);
    delegate.rmdir = trace('rmdir', delegate.rmdir);
    delegate.rmdirSync = trace('rmdirSync`', delegate.rmdirSync);
    // delegate.rm;
    // delegate.rmSync;
    delegate.stat = trace('stat', delegate.stat);
    delegate.statSync = trace('statSync', delegate.statSync);
    delegate.symlink = trace('symlink', delegate.symlink);
    delegate.symlinkSync = trace('symlinkSync', delegate.symlinkSync);
    delegate.truncate = trace('truncate', delegate.truncate);
    delegate.truncateSync = trace('truncateSync', delegate.truncateSync);
    delegate.unlink = trace('unlink', delegate.unlink);
    delegate.unlinkSync = trace('unlinkSync', delegate.unlinkSync);
    delegate.utimes = trace('utimes', delegate.utimes);
    delegate.utimesSync = trace('utimesSync', delegate.unlinkSync);
    delegate.writeFile = trace('writeFile', delegate.writeFile);
    delegate.writeFileSync = trace('writeFileSync', delegate.writeFileSync);
  }
