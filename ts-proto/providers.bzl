TsProtobuf = provider(
    doc = "TypeScript Protobuf compiler",
    fields = {
        "bin": "Plugin",
        "compiler": "TypeScript compiler",
        "cjs_deps": "List of CjsInfo",
        "js_deps": "List of JsInfo",
        "ts_deps": "List of TsInfo",
    },
)

TsProtoInfo = provider(
    doc = "TS proto info",
    fields = {
        "transitive_libs": "Transitive library structs",
        "transitive_paths": "Paths of dependencies",
        "transitive_files": "Transitive declarations",
    },
)

def create_lib(label, path, deps, js, declarations):
    """
    Create library struct

    Args:
        declarations: List of declaration files
        deps: Labels of dependencies
        js: List of declaration files
        label: Label
        path: Directory path
    """
    return struct(
        declarations = tuple(declarations),
        deps = tuple(deps),
        js = tuple(js),
        label = label,
        path = path,
    )

TsProtosInfo = provider(
    doc = "",
    fields = {
        "cjs": "CjsInfo",
        "js": "Dict of JsInfo by label",
        "ts": "Dict of TsInfo by label",
        "default": "Dict of DefaultInfo by label",
    },
)
