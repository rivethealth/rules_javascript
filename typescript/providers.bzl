"""
TypeScript helpers
"""

TsInfo = provider(
    doc = "TypeScript",
    fields = {
        "transitive_files": "Depset of files (descriptors, declarations)",
    },
)

TsCompilerInfo = provider(
    doc = "TypeScript compiler",
    fields = {
        "bin": "Compile executable.",
        "transpile_bin": "JS transpile executable.",
        "runtime_cjs": "List of runtime CjsInfo.",
        "runtime_js": "Runtime files.",
    },
)

TsCompileInfo = provider(
    doc = "TypeScript compilation info",
    fields = {
        "compiler": "Compiler",
        "config_path": "Configuration path",
        "configs": "Depset of config files",
        "declarations": "Depset of upstream declarations",
        "manifest": "Manifest file",
        "srcs": "Depset of sources",
        "runtime_js": "Runtime files",
    },
)

def is_declaration(path):
    return path.endswith(".d.ts") or path.endswith(".d.cts") or path.endswith(".d.mts")

def is_json(path):
    return path.endswith(".json")

def declaration_path(path):
    if path.endswith(".cjs"):
        return path[:-len(".cjs")] + ".d.cts"
    if path.endswith(".cts"):
        return path[:-len(".cts")] + ".d.cts"
    if path.endswith(".js"):
        return path[:-len(".js")] + ".d.ts"
    if path.endswith(".jsx"):
        return path[:-len(".jsx")] + ".d.ts"
    if path.endswith(".mjs"):
        return path[:-len(".mjs")] + ".d.mts"
    if path.endswith(".mts"):
        return path[:-len(".mts")] + ".d.mts"
    if path.endswith(".ts"):
        return path[:-len(".ts")] + ".d.ts"
    if path.endswith(".tsx"):
        return path[:-len(".tsx")] + ".d.ts"
    fail("%s does not have a recognized file extension" % path)

def js_path(path, jsx = "react"):
    if path.endswith(".cjs") or path.endswith(".js") or path.endswith(".mjs"):
        return path
    if path.endswith(".cts"):
        return path[:-len(".cts")] + ".cjs"
    if path.endswith(".jsx"):
        return path[:-len(".jsx")] + (".js" if jsx == "react" else ".jsx")
    if path.endswith(".ts"):
        return path[:-len(".ts")] + ".js"
    if path.endswith(".tsx"):
        return path[:-len(".tsx")] + (".js" if jsx == "react" else ".jsx")
    if path.endswith(".mts"):
        return path[:-len(".mts")] + ".mjs"
    if path.endswith(".json"):
        return path
    fail("%s does not have a recognized file extension" % path)

def map_path(path):
    return path + ".map"

def module(module):
    if module == "node":
        return "commonjs"
    return module

def target(language):
    return language

def create_ts_info(cjs_root, files = [], deps = []):
    return TsInfo(
        transitive_files = depset(files, transitive = [ts_info.transitive_files for ts_info in ([cjs_root] if cjs_root else []) + deps]),
    )
