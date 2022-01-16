load("//commonjs:providers.bzl", "create_dep", "create_global")

TsInfo = provider(
    doc = "TypeScript",
    fields = {
        "name": "Package name",
        "package": "CommonJS package",
        "transitive_deps": "Depset of extra links",
        "transitive_files": "Depset of files (descriptors, declarations)",
        "transitive_packages": "Depset of packages",
        "transitive_srcs": "Depset of sources",
    },
)

SimpleTsCompilerInfo = provider(
    doc = "TypeScript compiler",
    fields = {
        "bin": "Executable",
        "js_deps": "Js deps",
        "ts_deps": "TS deps",
    },
)

TsCompilerInfo = provider(
    doc = "TypeScript compiler",
    fields = {
        "bin": "Executable",
        "transpile_bin": "Executable",
        "js_deps": "JS deps",
        "ts_deps": "TS deps",
    },
)

TsconfigInfo = provider(
    doc = "TypeScript config file",
    fields = {
        "file": "Config file",
        "name": "Package name",
        "package": "Package",
        "transitive_deps": "Depset of extra links",
        "transitive_files": "Depset of files (descriptors, config files)",
        "transitive_packages": "Depset of packages",
    },
)

def target_deps(package, targets):
    return [
        create_dep(id = package.id, name = target[TsInfo].name, dep = target[TsInfo].package.id, label = target.label)
        for target in targets
        if TsInfo in target
    ]

def create_deps(package, label, ts_infos):
    return [
        create_dep(id = package.id, name = ts_info.name, dep = ts_info.package.id, label = label)
        for ts_info in ts_infos
    ]

def target_globals(targets):
    return [
        create_global(id = target[TsInfo].package.id, name = target[TsInfo].name)
        for target in targets
        if TsInfo in target
    ]

def create_extra_deps(package, label, extra_deps):
    return [
        create_dep(
            dep = id,
            id = package.id,
            label = label,
            name = name,
        )
        for name, id in extra_deps.items()
    ]

def is_declaration(path):
    return path.endswith(".d.ts") or path.endswith(".d.cts") or path.endswith(".d.mts")

def is_directory(path):
    return "." not in path.split("/")[-1]

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
        return path[:-len(".ts")] + ".d.ts"
    fail("%s does not have a recognized file extension" % path)

def js_path(path):
    if path.endswith(".cjs") or path.endswith(".js") or path.endswith(".mjs"):
        return path
    if path.endswith(".cts"):
        return path[:-len(".cts")] + ".cjs"
    if path.endswith(".jsx"):
        return path[:-len(".jsx")] + ".js"
    if path.endswith(".ts"):
        return path[:-len(".ts")] + ".js"
    if path.endswith(".tsx"):
        return path[:-len(".tsx")] + ".js"
    if path.endswith(".mts"):
        return path[:-len(".mts")] + ".mjs"
    if path.endswith(".json"):
        return path
    fail("%s does not have a recognized file extension" % path)

def map_path(path):
    return path + ".map"
