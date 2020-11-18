/**
 * Resolve modules
 */
export declare class Resolver {
    #private;
    constructor(trace: any, variations: any);
    /**
     * Set package ID to be globally available.
     * Module must already be added.
     */
    addGlobal(id: any): void;
    /**
     * Add package
     */
    addPackage(id: any, package_: any): void;
    /**
     * Resolve path to module.
     */
    resolveById(id: any, request: any): any;
    /**
     * Resolve path to module.
     */
    resolve(request: any, parent: any): any;
    _resolveDeps(deps: any, request: any, attempts: any): any;
    _resolveDep(request: any, id: any, package_: any, name: any, attempts: any): any;
    /**
     * Read and add items from manifest
     */
    static readManifest(resolver: any, path: any, runfile: any): void;
}
