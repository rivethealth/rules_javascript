TsProtobuf = provider(
    doc = "TypeScript Protobuf compiler",
    fields = {
        "bin": "Plugin",
        "tsc": "TypeScript compiler",
        "deps_cjs": "List of CjsInfo",
        "deps_js": "List of JsInfo",
        "deps_ts": "List of TsInfo",
        "options": "Options",
    },
)

TsProtoInfo = provider(
    doc = "TS proto info",
    fields = {
        "transitive_libs": "Transitive libraries",
    },
)

def create_lib(label, path, files, deps):
    """
    Create library struct

    Args:
        files: List of TypeScript files
        deps: Labels of dependencies
        label: Label
        path: Directory path
    """
    return struct(
        deps = tuple(deps),
        files = tuple(files),
        label = label,
        path = path,
    )

TsProtosInfo = provider(
    doc = "",
    fields = {
        "cjs": "Dict of CjsInfo by label",
        "js": "Dict of JsInfo by label",
        "ts": "Dict of TsInfo by label",
        "default": "Dict of DefaultInfo by label",
    },
)
