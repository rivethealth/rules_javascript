TsProtobuf = provider(
    fields = {
        "bin": "Plugin",
        "compiler": "TypeScript compiler",
        "js_deps": "Runtime JsInfo",
        "ts_deps": "Declarations",
    },
)

TsProtoInfo = provider(
    fields = {
        "transitive_libs": "Transitive library structs",
        "transitive_packages": "Transitive packages",
        "transitive_paths": "Paths of dependencies",
        "transitive_declarations": "Transitive declarations",
        "transitive_deps": "Transitive deps",
    },
)

def create_lib(label, path, deps, js, declarations, srcs, js_deps, ts_deps):
    """
    Create library struct

    Args:
        declarations: List of declaration files
        deps: Labels of dependencies
        js: List of declaration files
        label: Label
        path: Directory path
        srcs: List of source files
    """
    return struct(
        declarations = tuple(declarations),
        deps = tuple(deps),
        js = tuple(js),
        js_deps = tuple(js_deps),
        label = label,
        path = path,
        srcs = tuple(srcs),
        ts_deps = tuple(ts_deps),
    )

TsProtosInfo = provider(
    doc = "",
    fields = {
        "js": "Dict of JsInfo by label",
        "ts": "Dict of TsInfo by label",
    },
)
