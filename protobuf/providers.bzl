JsProtobuf = provider(
    fields = {
        "runtime": "Runtime dependencies",
    },
)

JsProtoInfo = provider(
    fields = {
        "transitive_libs": "Transitive library structs",
    },
)

def create_lib(label, path, deps, js, js_deps):
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
        deps = tuple(deps),
        js = tuple(js),
        js_deps = tuple(js_deps),
        label = label,
        path = path,
    )
