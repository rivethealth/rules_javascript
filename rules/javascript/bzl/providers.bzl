JsPackage = provider(
    doc = """JavaScript package

A package is a set of modules that share a module prefix and dependencies.
""",
    fields = {
        "id": "ID",
        "name": "Default module prefix",
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

def merge_packages(package, files, source_maps, packages):
    transitive_files = depset(
        files,
        transitive = [js_package.transitive_files for js_package in packages],
    )
    transitive_packages = depset(
        [package],
        transitive = [js_package.transitive_packages for js_package in packages],
    )
    transitive_source_maps = depset(
        source_maps,
        transitive = [js_package.transitive_source_maps for js_package in packages],
    )

    return JsPackage(
        id = package.id,
        name = package.name,
        transitive_files = transitive_files,
        transitive_packages = transitive_packages,
        transitive_source_maps = transitive_source_maps,
    )
