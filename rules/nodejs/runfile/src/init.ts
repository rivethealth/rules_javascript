import * as fs from 'fs';

const BAZEL_WORKSPACE = process.env["BAZEL_WORKSPACE"];
const RUNFILES_DIR = process.env["RUNFILES_DIR"];
const RUNFILES_MANIFEST = process.env["RUNFILES_MANIFEST_FILE"];

function log(str: string) {
    if (process.env.BAZEL_TRACE_RUNFILES === 'true') {
        console.debug(str);
    }
}

/**
 * Bazel has symlinks
 */
class SymlinkRunfiles {
    constructor(private readonly runfilesDir, private readonly workspace: string) {
    }

    getPath(name) {
        if (name.startsWith("../")) {
            name = `${name.slice("../".length)}`;
        } else {
            name = `${this.workspace}/${name}`;
        }
        return `${this.runfilesDir}/${name}`;
    }
}

/**
 * Uses a manifest
 */
class ManifestRunfiles {
    constructor(private readonly workspace: string) {
    }

    private pathByName = new Map();

    addRunfile(name, path) {
        this.pathByName.set(name, path);
    }
    getPath(name): string | undefined {
        if (name.startsWith("../")) {
            name = `${name.slice("../".length)}`;
        } else {
            name = `${this.workspace}/${name}`;
        }
        return this.pathByName.get(name);
    }
    static readManifest(runfiles, path) {
        const items = fs
            .readFileSync(path, "utf8")
            .split("\n")
            .filter(Boolean)
            .map((line) => {
            const [name, path] = line.split(" ");
            return { name, path };
        });
        for (const { name, path } of items) {
            runfiles.addRunfile(name, path);
        }
    }
}

log(`Workspace: ${BAZEL_WORKSPACE}`);
let runfiles;
if (RUNFILES_MANIFEST) {
    log(`Runfiles manifest: ${RUNFILES_MANIFEST}`);
    runfiles = new ManifestRunfiles(BAZEL_WORKSPACE);
    ManifestRunfiles.readManifest(runfiles, RUNFILES_MANIFEST);
} else {
    log(`Runfiles directory: ${RUNFILES_DIR}`);
    runfiles = new SymlinkRunfiles(RUNFILES_DIR, BAZEL_WORKSPACE);
}
(<any>global).runfilePath = (name) => runfiles.getPath(name);
