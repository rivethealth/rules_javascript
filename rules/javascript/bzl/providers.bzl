JsInfo = provider(
    doc = "JavaScript",
    fields = {
        "ids": "Package IDs",
        "name": "Default module prefix",
        "global_package_ids": "Global package ids",
        "transitive_files": "Depset of files",
        "transitive_packages": "Depset of packages",
        "transitive_source_maps": "Depset of source maps",
    },
)

def create_package(id, name, main = None, modules = (), deps = ()):
    """
    Create package.

    :param str id: ID
    :param str name: Name
    :param str main: Main module
    :param list: Modules
    :param list deps: Dependencies
    """
    return struct(
        id = id,
        name = name,
        main = main,
        modules = modules,
        deps = deps,
    )

def create_module(name, file):
    """
    Create module

    :param str name: Name
    :param str file: File
    """
    return struct(name = name, file = file)

def create_package_dep(name, id):
    """
    Create package dependency definition

    :param str name: Module prefix
    :param str id: ID
    """
    return struct(name = name, id = id)

def create_js(package, global_package_ids = [], files = [], source_maps = [], deps = []):
    """
    Create JsInfo

    :param struct package: Package
    :param list global_package_ids: Global package ids
    :param list files: Files
    :param list source_maps: Source maps
    :param list deps: Dependent JsInfo
    """
    global_package_ids = depset(
        global_package_ids,
        transitive = [js_info.global_package_ids for js_info in deps],
    )
    transitive_files = depset(
        files,
        transitive = [js_info.transitive_files for js_info in deps],
    )
    transitive_packages = depset(
        [package],
        transitive = [js_info.transitive_packages for js_info in deps],
    )
    transitive_source_maps = depset(
        source_maps,
        transitive = [js_info.transitive_source_maps for js_info in deps],
    )

    return JsInfo(
        ids = [package.id],
        name = package.name,
        global_package_ids = global_package_ids,
        transitive_files = transitive_files,
        transitive_packages = transitive_packages,
        transitive_source_maps = transitive_source_maps,
    )

def merge_js(name, deps = [], global_deps = []):
    """
    Combine JsInfo

    :param str name: Package name
    :param list deps: Collected JsInfos
    """
    ids = {id: None for js_info in deps for id in js_info.ids}.keys()
    global_package_ids = depset(
        [id for dep in global_deps for id in dep.ids],
        transitive = [js_info.global_package_ids for js_info in deps + global_deps],
    )
    transitive_files = depset(
        [],
        transitive = [js_info.transitive_files for js_info in deps + global_deps],
    )
    transitive_packages = depset(
        [],
        transitive = [js_info.transitive_packages for js_info in deps + global_deps],
    )
    transitive_source_maps = depset(
        [],
        transitive = [js_info.transitive_source_maps for js_info in deps + global_deps],
    )

    return JsInfo(
        ids = ids,
        name = name,
        global_package_ids = global_package_ids,
        transitive_files = transitive_files,
        transitive_packages = transitive_packages,
        transitive_source_maps = transitive_source_maps,
    )
