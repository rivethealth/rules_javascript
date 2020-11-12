JsInfo = provider(
    doc = "JavaScript",
    fields = {
        "id": "ID",
        "name": "Default module prefix",
        "globals": "IDs of global packages",
        "transitive_files": "Depset of files",
        "transitive_packages": "Depset of packages",
        "transitive_source_maps": "Depset of source maps",
    },
)

def create_package(id, name, main, modules, deps):
    """
    Create package.

    :param Label id: ID
    :param str name: Name
    :param File manifest: Manifest of modules
    :param list deps: List of package deps
    """
    return struct(
        id = id,
        name = name,
        main = main,
        modules = modules,
        deps = deps,
    )

def create_module(name, file):
    return struct(name = name, file = file)

def create_package_dep(name, id):
    """
    Create package dependency definition

    :param str name: Module prefix, or empty if no prefix
    :param Label id: ID
    """
    return struct(name = name, id = id)

def merge_js(js_info, other):
    globals = depset(
        transitive = [js_info.globals] + [js_info.globals for js_info in other],
    )
    transitive_files = depset(
        transitive = [js_info.transitive_files] + [js_info.transitive_files for js_info in other],
    )
    transitive_packages = depset(
        transitive = [js_info.transitive_packages] + [js_info.transitive_packages for js_info in other],
    )
    transitive_source_maps = depset(
        transitive = [js_info.transitive_source_maps] + [js_info.transitive_source_maps for js_info in other],
    )

    return JsInfo(
        id = js_info.id,
        name = js_info.name,
        globals = globals,
        transitive_files = transitive_files,
        transitive_packages = transitive_packages,
        transitive_source_maps = transitive_source_maps,
    )

def add_globals(js_info, globals):
    return JsInfo(
        id = js_info.id,
        name = js_info.name,
        globals = depset(globals, transitive = [js_info.globals]),
        transitive_files = js_info.transitive_files,
        transitive_packages = js_info.transitive_packages,
        transitive_source_maps = js_info.transitive_source_maps,
    )
