load("//commonjs:providers.bzl", "create_dep", "create_global")

JsFile = provider(
    doc = "JavaScript file",
    fields = {
        "path": "Path",
    },
)

JsInfo = provider(
    doc = "JavaScript",
    fields = {
        "name": "CommonJS name",
        "package": "CommonJS package struct",
        "transitive_deps": "Depset of dependency structs",
        "transitive_files": "Depset of files (descriptors, JavaScript, data files)",
        "transitive_packages": "Depset of packages",
        "transitive_srcs": "Depset of sources",
    },
)

def create_deps(package, label, js_infos):
    return [
        create_dep(id = package.id, name = js_info.name, dep = js_info.package.id, label = label)
        for js_info in js_infos
    ]

def target_deps(package, targets):
    return [
        create_dep(id = package.id, name = target[JsInfo].name, dep = target[JsInfo].package.id, label = target.label)
        for target in targets
        if JsInfo in target
    ]

def target_globals(targets):
    return [
        create_global(id = target[JsInfo].package.id, name = target[JsInfo].name)
        for target in targets
        if JsInfo in target
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

def js_npm_label(repo):
    return "@%s//:lib" % repo
